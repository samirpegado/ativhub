import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/auth/components/active_logo.dart';
import 'package:repsys/ui/auth/view_models/login_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/themes/dimens.dart';
import 'package:repsys/ui/core/themes/theme.dart';

import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/validators.dart';
import 'package:repsys/utils/result.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.viewModel});
  final LoginViewModel viewModel;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late AppState appState;
  late final _emailController = TextEditingController();
  late final _senhaController = TextEditingController();
  bool _showPassword = false;
  bool check = false;

  @override
  void initState() {
    super.initState();
    appState = context.read<AppState>();
    _emailController.text = appState.savedEmail ?? '';
    _senhaController.text = appState.savedPassword ?? '';
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
              child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    
                    ActiveLogo(),
                    Text('Sistema de Gestão de Ativos de Manutenção',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.secondaryText,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 400),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(
                              0xFFE5E7EB), // tom cinza bem claro (borda sutil)
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.04), // sombra leve
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4), // deslocamento vertical
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bem-vindo',
                              style:
                                  AppTheme.lightTheme.textTheme.headlineLarge),
                          Text(
                            'Preencha os dados abaixo para acessar sua conta',
                            style: TextStyle(color: AppColors.secondaryText),
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
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: check,
                                      onChanged: (value) {
                                        setState(() {
                                          check = !check;
                                        });
                                      }),
                                  SizedBox(width: 8),
                                  Text(
                                    'Lembrar-me',
                                    style: TextStyle(
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () => context.push('/recovery'),
                                child: Text(
                                  'Esqueci minha senha',
                                  style: TextStyle(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              context.go('/signup');
                            },
                            child: RichText(
                                text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Ainda não tem registro? ',
                                    style: TextStyle(
                                        color: AppColors.secondaryText,
                                        fontSize: 16)),
                                TextSpan(
                                    text: 'Teste grátis',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.success,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )),
                          ),
                          const SizedBox(height: 32),
                          AnimatedBuilder(
                            animation: widget.viewModel.login,
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
                                    if (check) {
                                      appState.saveLoginData(
                                        _emailController.text,
                                        _senhaController.text,
                                      );
                                    }
                                    await widget.viewModel.login.execute((
                                      _emailController.text,
                                      _senhaController.text,
                                    ));

                                    final result =
                                        widget.viewModel.login.result;

                                    if (result is Ok) {
                                      if (mounted) {
                                        context.go('/loading');
                                      }
                                    } else if (result is Error) {
                                      final message = result.error.toString();
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                            SnackBar(content: Text(message)));
                                      }
                                    }
                                  }
                                },
                                child: widget.viewModel.login.running
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Entrar'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
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
