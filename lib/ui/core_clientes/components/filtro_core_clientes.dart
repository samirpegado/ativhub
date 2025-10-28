import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/core_clientes/view_models/core_clientes_viewmodel.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';

class FiltroCoreClientes extends StatefulWidget {
  const FiltroCoreClientes({super.key});

  @override
  State<FiltroCoreClientes> createState() => _FiltroCoreClientesState();
}

class _FiltroCoreClientesState extends State<FiltroCoreClientes> {
  String? _tipoContrato;
  bool? _ativo;
  DateTime? _dataInicial;
  DateTime? _dataFinal;
  late AppState _appState;

  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _appState = context.read<AppState>();
    // Inicializar com valores atuais do filtro, se houver
    _tipoContrato = _appState.coreClientesFiltro?.tipoContrato;
    _ativo = _appState.coreClientesFiltro?.ativo;
    
    // Converter strings de data para DateTime
    if (_appState.coreClientesFiltro?.dataCriacaoInicial != null) {
      try {
        _dataInicial = DateTime.parse(_appState.coreClientesFiltro!.dataCriacaoInicial!);
      } catch (_) {}
    }
    if (_appState.coreClientesFiltro?.dataCriacaoFinal != null) {
      try {
        _dataFinal = DateTime.parse(_appState.coreClientesFiltro!.dataCriacaoFinal!);
      } catch (_) {}
    }
  }

  Future<void> _selecionarDataInicial() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataInicial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null) {
      setState(() => _dataInicial = picked);
    }
  }

  Future<void> _selecionarDataFinal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataFinal ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null) {
      setState(() => _dataFinal = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
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
                      'Filtros',
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

                const SizedBox(height: 16),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tipo de Contrato
                      DropdownButtonFormField<String>(
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
                      const SizedBox(height: 16),

                      // Ativo
                      DropdownButtonFormField<bool>(
                        value: _ativo,
                        items: const [
                          DropdownMenuItem<bool>(
                            value: true,
                            child: Text('Ativo'),
                          ),
                          DropdownMenuItem<bool>(
                            value: false,
                            child: Text('Inativo'),
                          ),
                        ],
                        onChanged: (value) => setState(() => _ativo = value),
                        style: TextStyle(
                          height: 1.6,
                          color: AppColors.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: AppInputDecorations.normal(
                          label: 'Status',
                          icon: Icons.toggle_on,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Data de Criação Inicial
                      InkWell(
                        onTap: _selecionarDataInicial,
                        child: InputDecorator(
                          decoration: AppInputDecorations.normal(
                            label: 'Data Inicial',
                            icon: Icons.calendar_today,
                          ),
                          child: Text(
                            _dataInicial != null
                                ? _dateFormat.format(_dataInicial!)
                                : 'Selecione a data',
                            style: TextStyle(
                              color: _dataInicial != null
                                  ? AppColors.primaryText
                                  : AppColors.secondaryText,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Data de Criação Final
                      InkWell(
                        onTap: _selecionarDataFinal,
                        child: InputDecorator(
                          decoration: AppInputDecorations.normal(
                            label: 'Data Final',
                            icon: Icons.calendar_today,
                          ),
                          child: Text(
                            _dataFinal != null
                                ? _dateFormat.format(_dataFinal!)
                                : 'Selecione a data',
                            style: TextStyle(
                              color: _dataFinal != null
                                  ? AppColors.primaryText
                                  : AppColors.secondaryText,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                        onPressed: () {
                          _appState.updateCoreClientesFiltro(
                              tipoContrato: null,
                              ativo: null,
                              dataCriacaoInicial: null,
                              dataCriacaoFinal: null,
                              busca: null,
                              replaceAll: true);
                          Navigator.of(context).pop();
                        },
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
                          child: Text('Limpar',
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
                                  // Converter DateTime para string no formato YYYY-MM-DD
                                  String? dataInicialStr;
                                  String? dataFinalStr;
                                  
                                  if (_dataInicial != null) {
                                    dataInicialStr = DateFormat('yyyy-MM-dd').format(_dataInicial!);
                                  }
                                  if (_dataFinal != null) {
                                    dataFinalStr = DateFormat('yyyy-MM-dd').format(_dataFinal!);
                                  }

                                  _appState.updateCoreClientesFiltro(
                                    tipoContrato: _tipoContrato,
                                    ativo: _ativo,
                                    dataCriacaoInicial: dataInicialStr,
                                    dataCriacaoFinal: dataFinalStr,
                                  );
                                  Navigator.of(context).pop();
                                },
                          style: ButtonStyle(
                            minimumSize:
                                const WidgetStatePropertyAll(Size(0, 50)),
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.primary),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
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
                                      color: AppColors.secondary,
                                    ),
                                  )
                                : Text('Aplicar',
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

