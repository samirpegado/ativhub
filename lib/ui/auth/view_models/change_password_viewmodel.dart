import 'package:repsys/data/services/auth_service.dart';
import 'package:repsys/domain/models/response_model.dart';
import 'package:repsys/utils/command.dart';
import 'package:repsys/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordViewModel {
  final AuthService authService;
  late final Command1<ResponseModel, PasswordParams> changePassword;

  ChangePasswordViewModel({required this.authService}) {
    changePassword = Command1<ResponseModel, PasswordParams>(_changePassword);
  }

  Future<Result<ResponseModel>> _changePassword(PasswordParams params) async {
    try {
      final cliente = Supabase.instance.client;

      if (params.password != params.confirmPassword) {
        return Result.error(Exception('As senhas não coincidem.'));
      }

      final response = await cliente.auth.updateUser(
        UserAttributes(password: params.password),
      );

      if (response.user != null) {
        return Result.ok(
          ResponseModel(success: true, message: 'Senha alterada com sucesso!'),
        );
      }

      return Result.error(Exception('Erro desconhecido ao alterar senha.'));
    } catch (e) {
      return Result.error(Exception('Erro ao alterar senha: $e'));
    }
  }
}

class PasswordParams {
  final String password;
  final String confirmPassword;

  PasswordParams({
    required this.password,
    required this.confirmPassword,
  });
}
