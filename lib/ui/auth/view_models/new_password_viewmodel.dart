import 'package:repsys/data/services/auth_service.dart';
import 'package:repsys/domain/models/response_model.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class NewPasswordViewModel {
  final AuthService authService;
  late final Command1<ResponseModel, NewPasswordParams> newPassword;

  NewPasswordViewModel({required this.authService}) {
    newPassword = Command1<ResponseModel, NewPasswordParams>(_newPassword);
  }

  Future<Result<ResponseModel>> _newPassword(NewPasswordParams params) async {
    try {
      final result = await authService.resetPasswordMobile(
        email: params.email.trim().toLowerCase(),
        otpCode: params.otpCode.trim(),
        password: params.password,
        confirmPassword: params.confirmPassword,
      );
      return Result.ok(result);
    } catch (e) {
      return Result.error(Exception('Erro ao processar requisição: $e'));
    }
  }
}

class NewPasswordParams {
  final String email;
  final String otpCode;
  final String password;
  final String confirmPassword;

  NewPasswordParams({
    required this.email,
    required this.otpCode,
    required this.password,
    required this.confirmPassword,
  });
}
