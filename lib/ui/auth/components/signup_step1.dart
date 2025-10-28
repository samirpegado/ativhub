import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/auth/view_models/signup_viewmodel.dart';
import 'package:repsys/ui/core/themes/dimens.dart';
import 'package:repsys/ui/core/themes/theme.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/mask_formaters.dart';
import 'package:repsys/ui/core/ui/validators.dart';

class SignupStep1 extends StatefulWidget {
  const SignupStep1({super.key, required this.viewModel});
  final SignUpViewModel viewModel;

  @override
  State<SignupStep1> createState() => _SignupStep1State();
}

class _SignupStep1State extends State<SignupStep1> {
  final _formKey = GlobalKey<FormState>();
  late AppState appState;
  late final _nomeController = TextEditingController();
  late final _celularController = TextEditingController();
  late final _cpfController = TextEditingController();
  late final _emailController = TextEditingController();
  late final _senhaController = TextEditingController();
  late final _senha2Controller = TextEditingController();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();

    appState = context.read<AppState>();

    final data = appState.registerData;

    _nomeController.text = data?.nome ?? '';
    _emailController.text = data?.email ?? '';
    _celularController.text = data?.celular ?? '';
    _cpfController.text = data?.cpf ?? '';
    _senhaController.text = data?.senha ?? '';
    _senha2Controller.text = data?.senha ?? '';
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _celularController.dispose();
    _cpfController.dispose();
    _senhaController.dispose();
    _senha2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
          'Dados pessoais',
          style: AppTheme.lightTheme.textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
          TextFormField(
            controller: _nomeController,
            textCapitalization: TextCapitalization.words,
            decoration: AppInputDecorations.normal(
              label: 'Nome',
              icon: Icons.person_outlined,
            ),
            validator: AppValidators.nome(),
          ),
          const SizedBox(height: 16),
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
            controller: _celularController,
            inputFormatters: [  FilteringTextInputFormatter.digitsOnly,
              TelefoneInputFormatter()],
            keyboardType: TextInputType.number,
            decoration: AppInputDecorations.normal(
              label: 'Celular',
              icon: Icons.phone_android_outlined,
            ),
            validator: AppValidators.celular(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cpfController,
            inputFormatters: [cpfFomatter],
            keyboardType: TextInputType.number,
            decoration: AppInputDecorations.normal(
              label: 'CPF',
              icon: Icons.badge_outlined,
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
          SizedBox(height: 16),
          TextFormField(
            controller: _senha2Controller,
            obscureText: !_showPassword,
            decoration: AppInputDecorations.password(
              label: 'Confirmar senha',
              isVisible: _showPassword,
              onToggleVisibility: () {
                setState(() => _showPassword = !_showPassword);
              },
            ),
            validator: AppValidators.senha(),
          ),
          const SizedBox(height: 32),
          FilledButton(
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
              onPressed: () {
                if (_senhaController.text != _senha2Controller.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('As senhas não coincidem'),
                    ),
                  );
                  return;
                }
                if (_formKey.currentState!.validate()) {
                  appState.salvarStep1(
                    nome: _nomeController.text,
                    email: _emailController.text,
                    celular: _celularController.text,
                    cpf: _cpfController.text,
                    senha: _senhaController.text,
                  );
                  appState.setPageViewIndex(1);
                }
              },
              child: const Text('Avançar')),
              const SizedBox(height: 16),
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
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
