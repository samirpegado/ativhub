import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../utils/result.dart';
import 'auth_repository.dart';

class SupabaseAuthRepository extends ChangeNotifier implements AuthRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  SupabaseAuthRepository() {
    // Notifica o GoRouter sempre que o estado de autenticação mudar
    supabase.auth.onAuthStateChange.listen((event) {
      notifyListeners();
    });
  }

  @override
  Future<Result<void>> login({required String email, required String password}) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      return Result.ok(null);
    } on AuthException catch (e) {
      return Result.error(Exception(e.message));
    } catch (_) {
      return Result.error(Exception('Erro inesperado ao fazer login.'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await supabase.auth.signOut();
      return Result.ok(null);
    } catch (_) {
      return Result.error(Exception('Erro ao fazer logout.'));
    }
  }

  @override
  Future<bool> get isAuthenticated async {
    final session = supabase.auth.currentSession;
    return session != null;
  }
}
