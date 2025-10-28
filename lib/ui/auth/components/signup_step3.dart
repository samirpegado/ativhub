import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/auth/view_models/signup_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/themes/dimens.dart';
import 'package:repsys/ui/core/themes/theme.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/validators.dart';
import 'package:repsys/utils/constants.dart';

class SignupStep3 extends StatefulWidget {
  const SignupStep3({super.key, required this.viewModel});
  final SignUpViewModel viewModel;

  @override
  State<SignupStep3> createState() => _SignupStep3State();
}

class _SignupStep3State extends State<SignupStep3> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cepController;
  late final TextEditingController _enderecoController;
  late final TextEditingController _cidadeController;
  late final TextEditingController _numeroController;
  late final TextEditingController _complementoController;
  String? selectedUf;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final data = context.read<AppState>().registerData;

    _cepController = TextEditingController(text: data?.cep ?? '');
    _enderecoController = TextEditingController(text: data?.endereco ?? '');
    _cidadeController = TextEditingController(text: data?.cidade ?? '');
    _numeroController = TextEditingController(text: data?.numero ?? '');
    _complementoController = TextEditingController(text: data?.complemento ?? '');
    selectedUf = estados.contains(data?.uf) ? data?.uf : null;

  }

  @override
  void dispose() {
    _cepController.dispose();
    _enderecoController.dispose();
    _cidadeController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onCepChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      final endereco = await widget.viewModel.buscarEndereco(value);
      if (endereco != null) {
        setState(() {
          _enderecoController.text = endereco['logradouro'] ?? '';
          _cidadeController.text = endereco['localidade'] ?? '';
          selectedUf = endereco['uf'] ?? '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
          'Endereço da empresa',
          style: AppTheme.lightTheme.textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cepController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CepInputFormatter(),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: AppInputDecorations.normal(
                    label: 'CEP',
                    icon: Icons.location_on_outlined,
                  ),
                  validator: AppValidators.nome(),
                  onChanged: _onCepChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField2<String?>(
                  value: selectedUf,
                  style: TextStyle(color: AppColors.primaryText),
                  dropdownStyleData: DropdownStyleData(maxHeight: 300),
                  decoration: AppInputDecorations.normal(
                    label: 'UF',
                    icon: Icons.map_outlined,
                  ),
                  isExpanded: true,
                  items: estados
                      .map((estado) => DropdownMenuItem<String?>(
                            value: estado,
                            child: Text(
                              estado,
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 18,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedUf = value;
                      });
                    }
                  },
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Selecione uma UF' : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          TextFormField(
            controller: _cidadeController,
            textCapitalization: TextCapitalization.words,
            decoration: AppInputDecorations.normal(
              label: 'Cidade',
              icon: Icons.location_city_outlined,
            ),
            validator: AppValidators.nome(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _enderecoController,
            textCapitalization: TextCapitalization.words,
            decoration: AppInputDecorations.normal(
              label: 'Endereço',
              icon: Icons.home_outlined,
            ),
            validator: AppValidators.nome(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _numeroController,
                  keyboardType: TextInputType.number,
                  decoration: AppInputDecorations.normal(
                    label: 'Número',
                    icon: Icons.pin_outlined,
                  ),
                  validator: AppValidators.nome(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _complementoController,
                  decoration: AppInputDecorations.normal(
                    label: 'Complemento',
                    icon: Icons.edit_location_outlined,
                  ),
                ),
              ),
            ],
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
                appState.salvarStep3(
                  cep: _cepController.text,
                  endereco: _enderecoController.text,
                  numero: _numeroController.text,
                  bairro: '',
                  cidade: _cidadeController.text,
                  uf: selectedUf ?? '',
                  complemento: _complementoController.text,
                );
                appState.setPageViewIndex(3);
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
          )
        ],
      ),
    );
  }
}