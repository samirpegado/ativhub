import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:repsys/data/repositories/auth_repository.dart';
import 'package:repsys/domain/models/response_model.dart';
import 'package:repsys/ui/auth/components/active_logo.dart';
import 'package:repsys/ui/auth/view_models/verify_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/themes/dimens.dart';
import 'package:repsys/utils/result.dart';
import 'package:provider/provider.dart';

class Verify extends StatefulWidget {
  const Verify({super.key, required this.viewModel});
  final VerifyViewModel viewModel;

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;

  bool _loading = false;
  bool _canResend = false;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();

    _sendInitialOtp();
  }

  void _sendInitialOtp() async {
    await widget.viewModel.sendOtp.execute();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() => _canResend = false);
    _resendTimer?.cancel();
    _resendTimer = Timer(const Duration(minutes: 1), () {
      setState(() => _canResend = true);
    });
  }

  void _resendOtp() async {
    if (!_canResend) return;
    await widget.viewModel.sendOtp.execute();
    _startResendTimer();
  }

  void _verifyOtp() async {
    final otp = pinController.text.trim();
    if (otp.length < 4) return;

    setState(() {
      _loading = true;
    });

    await widget.viewModel.verifyOtp.execute(otp);
    final result = widget.viewModel.verifyOtp.result;

    if (result is Error) {
      setState(() {
        _loading = false;
      });
      return;
    }
    if (result is Ok<ResponseModel>) {
      final response = result.value;
      if (response.success) {
      /*
        final appState = context.read<AppState>();
        final user = appState.usuario;
      
        if (user != null) {
          final updatedUser = UserModel(
            id: user.id,
            email: user.email ?? '',
            nome: user.nome,
         
            celular: user.celular,
            cpf: user.cpf,
            status: true,
          );
          await appState.salvarUsuario(updatedUser);
        }
      */
        if (mounted) context.go('/loading');
      } else {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Verificação de e-mail',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.primary,
        ),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(children: [
                  ActiveLogo(),
                  const Text(
                    '''Quase lá! \n\nDigite o código que te mandamos por e-mail pra confirmar sua conta.''',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Pinput(
                    controller: pinController,
                    focusNode: focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _loading ? null : _verifyOtp,
                    style: ButtonStyle(
                      minimumSize:
                          WidgetStateProperty.all(const Size.fromHeight(60)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: Dimens.borderRadius),
                      ),
                      elevation: WidgetStateProperty.all(2),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Verificar'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      context.read<AuthRepository>().logout();
                    },
                    style: ButtonStyle(
                      minimumSize:
                          WidgetStateProperty.all(const Size.fromHeight(60)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: Dimens.borderRadius),
                      ),
                      elevation: WidgetStateProperty.all(2),
                    ),
                    child: const Text('Voltar'),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _canResend ? _resendOtp : null,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text:
                                'Não recebeu o código? Verifique a caixa de spam ou clique em ',
                            style: TextStyle(
                                color: AppColors.secondaryText, fontSize: 12.0),
                          ),
                          TextSpan(
                            text: _canResend ? 'Reenviar' : 'Aguarde...',
                            style: TextStyle(
                              color: _canResend
                                  ? AppColors.secondaryText
                                  : Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
