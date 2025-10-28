import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/endereco_repository.dart';
import 'package:repsys/ui/core_clientes/view_models/core_clientes_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/core/ui/validators.dart';

class NovoCliente extends StatefulWidget {
  const NovoCliente({super.key});

  @override
  State<NovoCliente> createState() => _NovoClienteState();
}

class _NovoClienteState extends State<NovoCliente> {
  final _formKey = GlobalKey<FormState>();
  String? _tipo;
  String? _tipoContrato;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _valorContratoController = TextEditingController();
  final _diaPagamentoController = TextEditingController();
  final _dataAssinaturaController = TextEditingController();
  final _endCepController = TextEditingController();
  final _endRuaController = TextEditingController();
  final _endNumeroController = TextEditingController();
  final _endBairroController = TextEditingController();
  final _endCidadeController = TextEditingController();
  final _endUfController = TextEditingController();
  final _endComplementoController = TextEditingController();
  final _observacoesController = TextEditingController();

  final _enderecoRepository = EnderecoRepository();
  bool _buscandoCep = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _documentoController.dispose();
    _telefoneController.dispose();
    _valorContratoController.dispose();
    _diaPagamentoController.dispose();
    _dataAssinaturaController.dispose();
    _endCepController.dispose();
    _endRuaController.dispose();
    _endNumeroController.dispose();
    _endBairroController.dispose();
    _endCidadeController.dispose();
    _endUfController.dispose();
    _endComplementoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _buscarEnderecoPorCep(String cep) async {
    final cleanedCep = cep.replaceAll(RegExp(r'\D'), '');
    if (cleanedCep.length != 8) return;

    setState(() => _buscandoCep = true);

    try {
      final endereco = await _enderecoRepository.buscarEnderecoPorCep(cep);
      
      if (endereco != null && mounted) {
        setState(() {
          _endRuaController.text = endereco['logradouro'] ?? '';
          _endBairroController.text = endereco['bairro'] ?? '';
          _endCidadeController.text = endereco['localidade'] ?? '';
          _endUfController.text = endereco['uf'] ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar CEP: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _buscandoCep = false);
      }
    }
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
                /// header do modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Novo Cliente',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded, color: AppColors.primaryText),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(height: 1, color: AppColors.borderColor),

                /// Formulário para adicionar novo cliente
                const SizedBox(height: 16),
                Flexible(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        // === DADOS BÁSICOS ===
                        Text(
                          'Dados Básicos',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Linha 1: Tipo e Nome
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _tipo,
                                items: ['Pessoa Física', 'Pessoa Jurídica']
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(() => _tipo = value),
                                style: TextStyle(
                                  height: 1.6,
                                  color: AppColors.primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: AppInputDecorations.normal(
                                  label: 'Tipo',
                                  icon: Icons.person,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _nomeController,
                                textCapitalization: TextCapitalization.words,
                                validator: AppValidators.nome(),
                                decoration: AppInputDecorations.normal(
                                  label: 'Nome',
                                  icon: Icons.badge,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Linha 2: Email e Documento
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: AppInputDecorations.normal(
                                  label: 'E-mail',
                                  icon: Icons.email,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _documentoController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  _tipo == 'Pessoa Física'
                                      ? CpfInputFormatter()
                                      : CnpjInputFormatter(),
                                ],
                                decoration: AppInputDecorations.normal(
                                  label: _tipo == 'Pessoa Física' ? 'CPF' : 'CNPJ',
                                  icon: Icons.description,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Linha 3: Telefone
                        TextFormField(
                          controller: _telefoneController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                          decoration: AppInputDecorations.normal(
                            label: 'Telefone',
                            icon: Icons.phone,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // === DADOS DO CONTRATO ===
                        Divider(height: 1, color: AppColors.borderColor),
                        const SizedBox(height: 16),
                        Text(
                          'Dados do Contrato',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Linha 4: Tipo Contrato e Valor do Contrato
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _tipoContrato,
                                items: ['Recorrente', 'Avulso', 'Outro']
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(() => _tipoContrato = value),
                                style: TextStyle(
                                  height: 1.6,
                                  color: AppColors.primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: AppInputDecorations.normal(
                                  label: 'Tipo de Contrato',
                                  icon: Icons.assignment,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _valorContratoController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CentavosInputFormatter(moeda: true),
                                ],
                                decoration: AppInputDecorations.normal(
                                  label: 'Valor do Contrato',
                                  icon: Icons.attach_money,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Linha 5: Dia Pagamento e Data de Assinatura
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _diaPagamentoController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                decoration: AppInputDecorations.normal(
                                  label: 'Dia de Pagamento',
                                  icon: Icons.calendar_today,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _dataAssinaturaController,
                                keyboardType: TextInputType.datetime,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  DataInputFormatter(),
                                ],
                                decoration: AppInputDecorations.normal(
                                  label: 'Data de Assinatura',
                                  icon: Icons.event,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Observações
                        TextFormField(
                          controller: _observacoesController,
                          maxLines: 3,
                          decoration: AppInputDecorations.normal(
                            label: 'Observações',
                            icon: Icons.note,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // === ENDEREÇO ===
                        Divider(height: 1, color: AppColors.borderColor),
                        const SizedBox(height: 16),
                        Text(
                          'Endereço',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Linha 4: CEP e Rua
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _endCepController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CepInputFormatter(),
                                ],
                                decoration: AppInputDecorations.normal(
                                  label: 'CEP',
                                  icon: _buscandoCep ? null : Icons.location_on,
                                  suffix: _buscandoCep
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                onChanged: (value) => _buscarEnderecoPorCep(value),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _endRuaController,
                                textCapitalization: TextCapitalization.words,
                                decoration: AppInputDecorations.normal(
                                  label: 'Rua',
                                  icon: Icons.home,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Linha 5: Número, Bairro
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _endNumeroController,
                                decoration: AppInputDecorations.normal(
                                  label: 'Número',
                                  icon: Icons.tag,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _endBairroController,
                                textCapitalization: TextCapitalization.words,
                                decoration: AppInputDecorations.normal(
                                  label: 'Bairro',
                                  icon: Icons.location_city,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Linha 6: Cidade, UF e Complemento
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _endCidadeController,
                                textCapitalization: TextCapitalization.words,
                                decoration: AppInputDecorations.normal(
                                  label: 'Cidade',
                                  icon: Icons.location_city,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _endUfController.text.isNotEmpty
                                    ? _endUfController.text
                                    : null,
                                items: Estados.listaEstadosSigla
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() => _endUfController.text = value ?? '');
                                },
                                style: TextStyle(
                                  height: 1.6,
                                  color: AppColors.primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: AppInputDecorations.normal(
                                  label: 'UF',
                                  icon: Icons.map,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _endComplementoController,
                                textCapitalization: TextCapitalization.words,
                                decoration: AppInputDecorations.normal(
                                  label: 'Complemento',
                                  icon: Icons.comment,
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

                /// Ações do modal
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
                          minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
                    Consumer<CoreClientesViewModel>(
                      builder: (_, vm, __) => Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8.0),
                        child: TextButton(
                          onPressed: vm.isSaving
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) return;

                                  final erro = await vm.inserir(
                                    empresaId: appState.empresa!.id,
                                    userId: appState.usuario!.id,
                                    nome: _nomeController.text,
                                    tipo: _tipo,
                                    email: _emailController.text,
                                    documento: _documentoController.text,
                                    telefone: _telefoneController.text,
                                    tipoContrato: _tipoContrato,
                                    valorContratoTxt: _valorContratoController.text,
                                    diaPagamentoTxt: _diaPagamentoController.text,
                                    dataAssinaturaTxt: _dataAssinaturaController.text,
                                    endCep: _endCepController.text,
                                    endRua: _endRuaController.text,
                                    endNumero: _endNumeroController.text,
                                    endBairro: _endBairroController.text,
                                    endCidade: _endCidadeController.text,
                                    endUf: _endUfController.text,
                                    endComplemento: _endComplementoController.text,
                                    observacoes: _observacoesController.text,
                                  );

                                  if (!mounted) return;

                                  if (erro == null) {
                                    Navigator.of(context).pop(true); // Retorna true para atualizar tabela
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cliente inserido com sucesso!'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(erro)),
                                    );
                                  }
                                },
                          style: ButtonStyle(
                            minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                            backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: vm.isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: AppColors.secondary,
                                    ),
                                  )
                                : Text('Salvar',
                                    style: TextStyle(
                                        color: AppColors.secondary, fontSize: 14)),
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

