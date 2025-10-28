import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:repsys/domain/models/response_model.dart';
import 'package:repsys/ui/auth/components/active_logo.dart';
import 'package:repsys/ui/auth/view_models/recovery_viewmodel.dart';
import 'package:repsys/ui/core/themes/dimens.dart';
import 'package:repsys/ui/core/themes/theme.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/validators.dart';
import 'package:repsys/utils/result.dart';

class Recovery extends StatefulWidget {
  const Recovery({super.key, required this.viewModel});
  final RecoveryViewModel viewModel;

  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Dimens.of(context).edgeInsetsScreen,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Container(constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ActiveLogo(),
                    Text('Esqueceu sua senha?',
                        style: AppTheme.lightTheme.textTheme.headlineLarge),
                    SizedBox(height: 16),
                    SelectableText(
                      '''Sem problemas! Informe o e-mail cadastrado e enviaremos um código de segurança para você criar uma nova senha.''',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: AppInputDecorations.normal(
                        label: 'E-mail',
                        icon: Icons.mail_outline,
                      ),
                      validator: AppValidators.email(),
                    ),
                    const SizedBox(height: 32),
                    AnimatedBuilder(
                      animation: widget.viewModel.recovery,
                      builder: (context, _) {
                        return FilledButton(
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await widget.viewModel.recovery
                                  .execute((_emailController.text));
                
                              final result = widget.viewModel.recovery.result;
                
                              if (result is Ok<ResponseModel>) {
                                if (result.value.success == true) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(SnackBar(
                                        content: Text(result.value.message)));
                
                                    context.push(
                                        '/new-password?email=${_emailController.text}');
                                  }
                                } else {
                                  if (mounted) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(SnackBar(
                                        content: Text(result.value.message)));
                                  }
                                }
                              } else if (result is Error) {
                                final message = result.error.toString();
                                if (mounted) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text(message)));
                                }
                              }
                            }
                          },
                          child: widget.viewModel.recovery.running
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Enviar'),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => context.go('/login'),
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
