import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/endereco_repository.dart';
import 'package:repsys/ui/clientes/view_models/clientes_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/validators.dart';

// ---- Formatter que alterna entre CPF e CNPJ automaticamente ----
class DocumentoInputFormatter extends TextInputFormatter {
  final _cpf = CpfInputFormatter();
  final _cnpj = CnpjInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 11) {
      return _cpf.formatEditUpdate(oldValue, newValue);
    }
    return _cnpj.formatEditUpdate(oldValue, newValue);
  }
}

class ClientesNovoItem extends StatefulWidget {
  const ClientesNovoItem({super.key});

  @override
  State<ClientesNovoItem> createState() => _ClientesNovoItemState();
}

class _ClientesNovoItemState extends State<ClientesNovoItem> {
  final _formKey = GlobalKey<FormState>();

  // Campos
  String _tipo = 'pf'; // pf | pj
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _contatoAltController = TextEditingController();
  String? _comoConheceu; // dropdown

  // Endereço
  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();
  final _bairroController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();

  final _endRepo = EnderecoRepository();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _documentoController.dispose();
    _telefoneController.dispose();
    _dataNascimentoController.dispose();
    _contatoAltController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _cidadeController.dispose();
    _ufController.dispose();
    _bairroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    super.dispose();
  }

  Future<void> _buscarCep() async {
    final cepDigits = _cepController.text.replaceAll(RegExp(r'\D'), '');
    if (cepDigits.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CEP inválido. Digite 8 dígitos.')),
      );
      return;
    }

    try {
      final data = await _endRepo.buscarEnderecoPorCep(cepDigits);
      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CEP não encontrado.')),
        );
        return;
      }
      _ruaController.text = (data['logradouro'] ?? '').toString();
      _bairroController.text = (data['bairro'] ?? '').toString();
      _cidadeController.text = (data['localidade'] ?? '').toString();
      _ufController.text = (data['uf'] ?? '').toString();
    } finally {}
  }

  // Lista padrão para "Como conheceu" (ajuste conforme sua necessidade)
  static const _comoConheceuOpcoes = <String>[
    'Redes sociais',
    'Indicação de amigo',
    'Pesquisa Google',
    'Anúncio',
    'Outro',
  ];

  String? ajustarDataAniversario(String? data) {
    if (data == null || data.isEmpty) return null;

    return '$data/1990';
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return Dialog(
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1024),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Novo cliente',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded,
                          color: AppColors.primaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(height: 1, color: AppColors.borderColor),

                /// Form
                const SizedBox(height: 16),
                Flexible(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tipo PF/PJ
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _tipo,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'pf',
                                        child: Text('Pessoa física')),
                                    DropdownMenuItem(
                                        value: 'pj',
                                        child: Text('Pessoa jurídica')),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _tipo = v ?? 'pf'),
                                  style: TextStyle(
                                    height: 1.6,
                                    color: AppColors.primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: AppInputDecorations.normal(
                                    label: 'Tipo',
                                    icon: Icons.person_outline,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              // Como conheceu
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _comoConheceu,
                                  items: _comoConheceuOpcoes
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text(e)))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _comoConheceu = v),
                                  style: TextStyle(
                                    height: 1.6,
                                    color: AppColors.primaryText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: AppInputDecorations.normal(
                                    label: 'Como conheceu',
                                    icon: Icons.travel_explore_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Nome
                          TextFormField(
                            controller: _nomeController,
                            textCapitalization: TextCapitalization.words,
                            validator: AppValidators.nome(),
                            decoration: AppInputDecorations.normal(
                              label: 'Nome *',
                              icon: Icons.badge_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              // Telefone
                              Expanded(
                                child: TextFormField(
                                  controller: _telefoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    TelefoneInputFormatter(),
                                  ],
                                  validator:
                                      AppValidators.nome(label: 'Telefone'),
                                  decoration: AppInputDecorations.normal(
                                    label: 'Telefone *',
                                    icon: Icons.call_outlined,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),
                              // Email
                              Expanded(
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: AppValidators.email(),
                                  decoration: AppInputDecorations.normal(
                                    label: 'E-mail *',
                                    icon: Icons.alternate_email,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              // Documento (CPF/CNPJ auto)
                              Expanded(
                                child: TextFormField(
                                  controller: _documentoController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    DocumentoInputFormatter(),
                                  ],
                                  decoration: AppInputDecorations.normal(
                                    label: 'CPF/CNPJ',
                                    icon: Icons.assignment_ind_outlined,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              // Data de nascimento
                              Expanded(
                                child: TextFormField(
                                  controller: _dataNascimentoController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    DiaMesInputFormatter(),
                                  ],
                                  decoration: AppInputDecorations.normal(
                                    label: 'Aniversário',
                                    icon: Icons.event_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Contato alternativo
                          TextFormField(
                            controller: _contatoAltController,
                            decoration: AppInputDecorations.normal(
                              label: 'Contato alternativo',
                              icon: Icons.person_add_alt_1_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Endereço - CEP + botão
                          TextFormField(
                            controller: _cepController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CepInputFormatter(ponto: false),
                            ],
                            onChanged: (v) {
                              final digits = v.replaceAll(RegExp(r'\D'), '');
                              if (digits.length == 8) {
                                _buscarCep();
                              }
                            },
                            decoration: AppInputDecorations.normal(
                              label: 'CEP',
                              icon: Icons.location_on_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Rua / Número
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _ruaController,
                                  decoration: AppInputDecorations.normal(
                                    label: 'Rua',
                                    icon: Icons.map_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _numeroController,
                                  keyboardType: TextInputType.number,
                                  decoration: AppInputDecorations.normal(
                                    label: 'Número',
                                    icon: Icons.numbers_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Bairro / Cidade
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _bairroController,
                                  decoration: AppInputDecorations.normal(
                                    label: 'Bairro',
                                    icon: Icons.location_city_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _cidadeController,
                                  decoration: AppInputDecorations.normal(
                                    label: 'Cidade',
                                    icon: Icons.apartment_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // UF / Complemento
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: _ufController,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[A-Za-z]')),
                                    UpperCaseTextFormatter(),
                                    LengthLimitingTextInputFormatter(2),
                                  ],
                                  decoration: AppInputDecorations.normal(
                                    label: 'UF',
                                    icon: Icons.flag_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _complementoController,
                                  decoration: AppInputDecorations.normal(
                                    label: 'Complemento',
                                    icon: Icons.add_location_alt_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(height: 1, color: AppColors.borderColor),

                /// Ações
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8.0),
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ButtonStyle(
                          minimumSize:
                              const WidgetStatePropertyAll(Size(0, 50)),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Cancelar',
                              style: TextStyle(
                                  color: AppColors.primaryText, fontSize: 14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Consumer<ClientesViewmodel>(
                      builder: (_, vm, __) => Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8.0),
                        child: TextButton(
                          onPressed: vm.isSaving
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  final erro = await vm.inserirClientes(
                                    empresaId: appState.empresa!.id,
                                    tipo: _tipo,
                                    nome: _nomeController.text.trim(),
                                    email: _emailController.text.trim(),
                                    documento: _documentoController.text.trim(),
                                    telefone: _telefoneController.text.trim(),
                                    dataNascimento: ajustarDataAniversario(
                                      _dataNascimentoController.text,
                                    ),
                                    contatoAlternativo:
                                        _contatoAltController.text.trim(),
                                    comoConheceu: _comoConheceu,
                                    endCep: _cepController.text.trim(),
                                    endRua: _ruaController.text.trim(),
                                    endCidade: _cidadeController.text.trim(),
                                    endUf: _ufController.text.trim(),
                                    endBairro: _bairroController.text.trim(),
                                    endNumero: _numeroController.text.trim(),
                                    endComplemento:
                                        _complementoController.text.trim(),
                                  );

                                  if (!mounted) return;

                                  if (erro == null) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Cliente cadastrado com sucesso!')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(erro)),
                                    );
                                  }
                                },
                          style: ButtonStyle(
                            minimumSize:
                                const WidgetStatePropertyAll(Size(0, 50)),
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.primary),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: vm.isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        color: AppColors.secondary))
                                : Text('Salvar',
                                    style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 14)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Helpers opcionais ----

// Deixa o texto sempre em maiúsculo (para UF)
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
