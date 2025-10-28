import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/services/auth_service.dart';
import 'package:repsys/domain/models/response_model.dart';
import 'package:repsys/utils/command.dart';
import 'package:repsys/utils/result.dart';

class VerifyViewModel {
  final AuthService authService;
  final AppState appState;

  late final Command0<ResponseModel> sendOtp;
  late final Command1<ResponseModel, String> verifyOtp;

  VerifyViewModel({
    required this.authService,
    required this.appState,
  }) {
    sendOtp = Command0<ResponseModel>(_sendOtp);
    verifyOtp = Command1<ResponseModel, String>(_verifyOtp);
  }

  Future<Result<ResponseModel>> _sendOtp() async {
    try {
      final result = await authService.sendOtp(userId: appState.usuario?.id ?? '');
      return Result.ok(result);
    } catch (e) {
      return Result.error(Exception('Erro ao enviar código OTP: $e'));
    }
  }

  Future<Result<ResponseModel>> _verifyOtp(String otpCode) async {
    try {
      final result = await authService.verifyOtp(
          otpCode: otpCode, userId: appState.usuario?.id ?? '');
      return Result.ok(result);
    } catch (e) {
      return Result.error(Exception('Erro ao verificar código OTP: $e'));
    }
  }
}
