import 'package:go_router/go_router.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/domain/models/user_empresa_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoadingViewModel {
  final AppState appState;
  final supabase = Supabase.instance.client;

  LoadingViewModel({required this.appState});

Future<void> initAndRoute(GoRouter router) async {
    // 1) carrega cache local
    await appState.carregar();

    // 2) precisa estar logado
    final session = supabase.auth.currentSession;
    final user = session?.user;
    if (user == null) {
      router.go('/login');
      return;
    }

    try {
      // 3) chama RPC com p_user_id
      final data = await supabase.rpc(
        'get_user_empresa',
        params: {'p_user_id': user.id},
      );

      // data = { user: {...}, empresa: {...}|null }
      final userMap = Map<String, dynamic>.from(data['user'] as Map);
      final empresaMap = data['empresa'] == null
          ? null
          : Map<String, dynamic>.from(data['empresa'] as Map);

      final uModel = UserModel.fromMap(userMap);
      final eModel = empresaMap == null ? null : EmpresaModel.fromMap(empresaMap);

      // 4) salva no cache e no estado
      await appState.salvarUsuarioEmpresa(usuario: uModel, empresa: eModel);

      // 5) decide rota pelo status
      final ativo = uModel.status ?? false;
      router.go(ativo ? '/' : '/verify');
    } catch (e) {
      // fallback: limpa e vai pro login
      await appState.limparUsuarioEmpresa();
      router.go('/login');
    }
  }
}
