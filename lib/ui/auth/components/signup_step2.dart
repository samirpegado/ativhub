import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/auth/view_models/signup_viewmodel.dart';
import 'package:repsys/ui/core/themes/dimens.dart';
import 'package:repsys/ui/core/themes/theme.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/mask_formaters.dart';
import 'package:repsys/ui/core/ui/validators.dart';

class SignupStep2 extends StatefulWidget {
  const SignupStep2({super.key, required this.viewModel});
  final SignUpViewModel viewModel;

  @override
  State<SignupStep2> createState() => _SignupStep2State();
}

class _SignupStep2State extends State<SignupStep2> {
  final _formKey = GlobalKey<FormState>();
  late final AppState appState;
  late final _nomeFantasiaController = TextEditingController();
  late final _razaoSocialController = TextEditingController();
  late final _cnpjController = TextEditingController();
  late final _siteController = TextEditingController();
  late final _telefoneController = TextEditingController();
  late final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    appState = context.read<AppState>();

    final data = appState.registerData;
    _nomeFantasiaController.text = data?.nomeFantasia ?? '';
    _razaoSocialController.text = data?.razaoSocial ?? '';
    _cnpjController.text = data?.cnpj ?? '';
    _siteController.text = data?.site ?? '';
    _telefoneController.text = data?.telefone ?? '';
    _emailController.text = data?.empresaEmail ?? '';
  }

  @override
  void dispose() {
    _nomeFantasiaController.dispose();
    _razaoSocialController.dispose();
    _cnpjController.dispose();
    _siteController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
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
            'Dados da empresa',
            style: AppTheme.lightTheme.textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nomeFantasiaController,
            textCapitalization: TextCapitalization.words,
            decoration: AppInputDecorations.normal(
              label: 'Nome fantasia',
              icon: Icons.business_center_outlined,
            ),
            validator: AppValidators.nome(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _razaoSocialController,
            textCapitalization: TextCapitalization.words,
            decoration: AppInputDecorations.normal(
              label: 'Razão social',
              icon: Icons.apartment_outlined,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cnpjController,
            inputFormatters: [cnpjFormatter],
            keyboardType: TextInputType.number,
            decoration: AppInputDecorations.normal(
              label: 'CNPJ',
              icon: Icons.badge_outlined,
            ),
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
            controller: _telefoneController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TelefoneInputFormatter()
            ],
            keyboardType: TextInputType.number,
            decoration: AppInputDecorations.normal(
              label: 'Telefone',
              icon: Icons.phone_android_outlined,
            ),
            validator: AppValidators.celular(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _siteController,
            decoration: AppInputDecorations.normal(
              label: 'Site',
              icon: Icons.public_outlined,
            ),
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
              if (_formKey.currentState!.validate()) {
                appState.salvarStep2(
                  nomeFantasia: _nomeFantasiaController.text,
                  razaoSocial: _razaoSocialController.text,
                  cnpj: _cnpjController.text,
                  site: _siteController.text,
                  empresaEmail: _emailController.text,
                  telefone: _telefoneController.text,
                );
                appState.setPageViewIndex(2);
              }
            },
            child: const Text('Avançar'),
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
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
