import 'package:repsys/data/services/auth_service.dart';
import 'package:repsys/domain/models/response_model.dart';
import '../../../../utils/command.dart';
import '../../../../utils/result.dart';

class RecoveryViewModel {
  final AuthService authService;
  late final Command1<ResponseModel, String> recovery;

  RecoveryViewModel({required this.authService}) {
    recovery = Command1<ResponseModel, String>(_recovery);
  }

  Future<Result<ResponseModel>> _recovery(String email) async {
    try {
      final result = await authService.recoveryPasswordMobile(
        email: email.trim().toLowerCase(),
      );
      return Result.ok(result);
    } catch (e) {
      return Result.error(Exception('Erro ao processar requisição: $e'));
    }
  }
}
