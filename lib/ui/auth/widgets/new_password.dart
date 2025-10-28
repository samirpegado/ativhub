import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:repsys/domain/models/response_model.dart';
import 'package:repsys/ui/auth/components/active_logo.dart';
import 'package:repsys/ui/auth/view_models/new_password_viewmodel.dart';
import 'package:repsys/ui/core/themes/dimens.dart';
import 'package:repsys/ui/core/themes/theme.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/validators.dart';
import 'package:repsys/utils/result.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key, required this.viewModel, this.email});
  final NewPasswordViewModel viewModel;
  final String? email;

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();
  final _senhaController = TextEditingController();
  final _senha2Controller = TextEditingController();
  bool _showPassword = false;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: (widget.email != null && widget.email!.trim().isNotEmpty)
          ? widget.email
          : '',
    );
  }

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
                    Text('Criar nova senha',
                        style: AppTheme.lightTheme.textTheme.headlineLarge),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: AppInputDecorations.normal(
                        label: 'E-mail',
                        icon: Icons.mail_outline,
                      ),
                      validator: AppValidators.email(),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _otpController,
                      decoration: AppInputDecorations.normal(
                        label: 'Código de segurança',
                        icon: Icons.code,
                      ),
                      validator: AppValidators.nome(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: !_showPassword,
                      decoration: AppInputDecorations.password(
                        label: 'Senha',
                        isVisible: _showPassword,
                        onToggleVisibility: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                      ),
                      validator: AppValidators.senha(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senha2Controller,
                      obscureText: !_showPassword,
                      decoration: AppInputDecorations.password(
                        label: 'Confirmação de senha',
                        isVisible: _showPassword,
                        onToggleVisibility: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                      ),
                      validator: AppValidators.senha(),
                    ),
                    const SizedBox(height: 32),
                    AnimatedBuilder(
                      animation: widget.viewModel.newPassword,
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
                              await widget.viewModel.newPassword.execute(
                                  (NewPasswordParams(
                                      email: _emailController.text,
                                      otpCode: _otpController.text,
                                      password: _senhaController.text,
                                      confirmPassword: _senha2Controller.text)));
                
                              final result = widget.viewModel.newPassword.result;
                
                              if (result is Ok<ResponseModel>) {
                                if (result.value.success) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(SnackBar(
                                        content: Text(result.value.message)));
                                    context.go('/login');
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
                          child: widget.viewModel.newPassword.running
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Confirmar'),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => context.go('/recovery'),
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
