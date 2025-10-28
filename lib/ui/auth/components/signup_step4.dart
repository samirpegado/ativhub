import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/domain/models/response_model.dart';
import 'package:repsys/ui/auth/view_models/signup_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/themes/dimens.dart';
import 'package:repsys/ui/core/themes/theme.dart';
import 'package:repsys/utils/result.dart';

class SignupStep4 extends StatefulWidget {
  const SignupStep4({super.key, required this.viewModel});
  final SignUpViewModel viewModel;

  @override
  State<SignupStep4> createState() => _SignupStep4State();
}

class _SignupStep4State extends State<SignupStep4> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Tudo pronto!',
          style: AppTheme.lightTheme.textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        Text(
          '''
Estamos muito felizes em tê-lo conosco! Você está prestes a embarcar em uma experiência incrível com a nossa plataforma. Para começar a explorar todas as funcionalidades e recursos que oferecemos, basta clicar em "Testar Grátis".

Ao iniciar seu teste gratuito, você terá acesso a ferramentas que facilitarão a gestão e otimização dos seus processos. Nossa equipe está aqui para garantir que você aproveite ao máximo essa experiência. Se tiver alguma dúvida, não hesite em entrar em contato conosco.

Aproveite sua jornada no Repsys e descubra como podemos ajudá-lo a alcançar seus objetivos!
''',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        InkWell(
            onTap: () => context.go('/policy'),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text:
                          'Ao clicar em "Testar grátis" você cria sua conta você concorda com nossos ',
                      style: AppTheme.lightTheme.textTheme.displayMedium),
                  TextSpan(
                      text: 'Termos de Uso e Política de Privacidade',
                      style: AppTheme.lightTheme.textTheme.labelMedium),
                ],
              ),
            )),
        const SizedBox(height: 32),
        AnimatedBuilder(
          animation: widget.viewModel.criarContaCommand,
          builder: (context, _) {
            final cmd = widget.viewModel.criarContaCommand;

            // Reagir ao resultado final
            if (cmd.result != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (cmd.result is Ok<ResponseModel>) {
                  final result = (cmd.result as Ok<ResponseModel>).value;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result.message)),
                  );
                  if (result.success) {
                    appState.limparDadosRegistro();
                    context.go('/home');
                  }
                } else if (cmd.result is Error) {
                  final error = (cmd.result as Error).error;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error.toString())),
                  );
                }
                cmd.clearResult(); // limpa para não repetir
              });
            }

            return FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.success),
                minimumSize: WidgetStateProperty.all(
                  const Size.fromHeight(60),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: Dimens.borderRadius,
                  ),
                ),
                elevation: WidgetStateProperty.all(2),
              ),
              onPressed: cmd.running ? null : () => cmd.execute(),
              child: cmd.running
                  ? const CircularProgressIndicator(color: Colors.white,)
                  : const Text('Testar grátis'),
            );
          },
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => appState.backPageView(),
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(
              const Size.fromHeight(60),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: Dimens.borderRadius,
              ),
            ),
            elevation: WidgetStateProperty.all(2),
          ),
          child: Text('Voltar'),
        )
      ],
    );
  }
}
