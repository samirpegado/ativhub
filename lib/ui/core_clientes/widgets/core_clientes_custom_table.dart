import 'dart:async';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/core_clientes_repository.dart';
import 'package:repsys/domain/models/core_clientes_filtro_model.dart';
import 'package:repsys/domain/models/core_clientes_model.dart';
import 'package:repsys/domain/models/paginacao_model.dart';
import 'package:repsys/domain/models/core_clientes_page_model.dart';

import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';

class CoreClientesCustomTable extends StatefulWidget {
  final String empresaId;
  final int initialLimit;

  /// Você pode injetar o repo (para testes) ou deixar nulo que cria sozinho.
  final CoreClientesRepository? repository;

  /// Callback que retorna a função reload para ser chamada externamente
  final Function(VoidCallback reloadCallback)? onInit;

  const CoreClientesCustomTable({
    super.key,
    required this.empresaId,
    this.initialLimit = 20,
    this.repository,
    this.onInit,
  });

  @override
  State<CoreClientesCustomTable> createState() =>
      _CoreClientesCustomTableState();
}

class _CoreClientesCustomTableState extends State<CoreClientesCustomTable> {
  late final CoreClientesRepository _repo;

  // filtros que vêm do AppState
  String? _tipoContrato;
  bool? _ativo;
  String? _busca;
  String? _dataCriacaoInicial;
  String? _dataCriacaoFinal;

  int _limit = 20;
  int _pagina = 1;

  late AppState _appState;
  CoreClientesFiltroModel? _lastFiltro;

  // Future atual (para o FutureBuilder)
  Future<CoreClientesPageModel>? _future;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? CoreClientesRepository();

    // AppState + listener
    _appState = context.read<AppState>();
    _lastFiltro = _appState.coreClientesFiltro;

    _limit = widget.initialLimit;
    _tipoContrato = _lastFiltro?.tipoContrato;
    _ativo = _lastFiltro?.ativo;
    _busca = _lastFiltro?.busca;
    _dataCriacaoInicial = _lastFiltro?.dataCriacaoInicial;
    _dataCriacaoFinal = _lastFiltro?.dataCriacaoFinal;

    _appState.addListener(_onAppStateChanged);

    _reload();

    // Passa o callback de reload para o widget pai
    if (widget.onInit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onInit!(_reload);
      });
    }
  }

  void _onAppStateChanged() {
    final f = _appState.coreClientesFiltro;
    final mudouTipoContrato = f?.tipoContrato != _tipoContrato;
    final mudouAtivo = f?.ativo != _ativo;
    final mudouBusca = f?.busca != _busca;
    final mudouDataInicial = f?.dataCriacaoInicial != _dataCriacaoInicial;
    final mudouDataFinal = f?.dataCriacaoFinal != _dataCriacaoFinal;
    if (!mudouTipoContrato &&
        !mudouAtivo &&
        !mudouBusca &&
        !mudouDataInicial &&
        !mudouDataFinal) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _tipoContrato = f?.tipoContrato;
        _ativo = f?.ativo;
        _busca = f?.busca;
        _dataCriacaoInicial = f?.dataCriacaoInicial;
        _dataCriacaoFinal = f?.dataCriacaoFinal;
        _pagina = 1;
      });
      _reload();
    });
  }

  @override
  void dispose() {
    _appState.removeListener(_onAppStateChanged);
    super.dispose();
  }

  Future<CoreClientesPageModel> _fetchPage() {
    return _repo.buscarCoreClientesPage(
      empresaId: widget.empresaId,
      busca: _busca,
      tipoContrato: _tipoContrato,
      ativo: _ativo,
      dataCriacaoInicial: _dataCriacaoInicial,
      dataCriacaoFinal: _dataCriacaoFinal,
      limit: _limit,
      pagina: _pagina,
    );
  }

  void _reload() {
    final next = _fetchPage(); // faz o async fora
    if (!mounted) return;
    setState(() {
      // atualiza estado de forma síncrona
      _future = next;
    });
  }

  Widget _headerCell(String label) => Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF525251),
          fontSize: 12,
        ),
      );

  Widget _dataCell(String text,
      {TextAlign align = TextAlign.left, bool secondary = false}) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: const Color(0xFF333233),
        fontSize: 14,
        fontWeight: secondary ? FontWeight.w400 : FontWeight.w500,
      ),
    );
  }

  String _formatarTelefone(String? telefone) {
    if (telefone == null || telefone.isEmpty) return '-';
    final digitsOnly = telefone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) return '-';
    return UtilBrasilFields.obterTelefone(digitsOnly);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return FutureBuilder<CoreClientesPageModel>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(
            child: Text('Erro ao carregar: ${snap.error}',
                style: const TextStyle(color: Colors.red)),
          );
        }
        final page = snap.data;
        if (page == null) return const SizedBox.shrink();

        final List<CoreClientesModel> itens = page.itens;
        final PaginacaoModel pag = page.paginacao;

        final int paginaAtual = pag.paginaAtual ?? _pagina;
        final int totalPaginas = pag.qtdPaginas ?? 1;

        return Column(
          children: [
            // Header (apenas em telas largas)
            if (isWide)
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E1E1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _headerCell('Nome')),
                    const SizedBox(width: 8),
                    Expanded(flex: 3, child: _headerCell('Contato')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _headerCell('Documento')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _headerCell('Tipo Contrato')),
                    const SizedBox(width: 8),
                    Expanded(flex: 1, child: _headerCell('Ativo')),
                  ],
                ),
              ),
            const SizedBox(height: 8),

            // Linhas
            Expanded(
              child: itens.isEmpty
                  ? const Center(child: Text('Nenhum cliente a ser listado'))
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: itens.length,
                      itemBuilder: (context, index) {
                        final e = itens[index];

                        if (isWide) {
                          // layout em colunas (tela larga)
                          return InkWell(
                            onTap: () {
                              _repo.buscarClientePorId(e.id).then((cliente) {
                                _appState.updateCoreClientesModel(
                                    coreClientesModel: CoreClientesModel.fromJson(cliente.toJson()));
                                context.push('/clientes/detalhes');
                              });
                            },
                            child: Container(
                              height: 72,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFCFCFC),
                                border: Border(
                                    bottom:
                                        BorderSide(color: Color(0xFFE1E1E1))),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 3, child: _dataCell(e.nome ?? '-')),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _dataCell(e.email ?? '-'),
                                        const SizedBox(height: 4),
                                        _dataCell(_formatarTelefone(e.telefone),
                                            secondary: true),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 2,
                                      child: _dataCell(e.documento ?? '-')),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 2,
                                      child: _dataCell(e.tipoContrato ?? '-')),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 1,
                                      child: _dataCell(
                                          e.ativo == true ? 'Sim' : 'Não')),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // layout "card" (mobile)
                          return InkWell(
                            onTap: () {
                                  _repo.buscarClientePorId(e.id).then((cliente) {
                                _appState.updateCoreClientesModel(
                                    coreClientesModel: CoreClientesModel.fromJson(cliente.toJson()));
                                context.push('/clientes/detalhes');
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCFCFC),
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: const Color(0xFFE1E1E1)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _dataCell(e.nome ?? '-'),
                                  const SizedBox(height: 6),
                                  _dataCell(e.email ?? '-', secondary: true),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _dataCell(
                                          'Tel: ${_formatarTelefone(e.telefone)}',
                                          secondary: true),
                                      _dataCell('Doc: ${e.documento ?? '-'}',
                                          secondary: true),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _dataCell(
                                          'Tipo: ${e.tipoContrato ?? '-'}',
                                          secondary: true),
                                      _dataCell(
                                          e.ativo == true ? 'Ativo' : 'Inativo',
                                          secondary: true),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
            ),

            const SizedBox(height: 8),

            // Footer: paginação
            Container(
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFFFCFCFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE1E1E1)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // limit por página
                  IntrinsicWidth(
                    child: DropdownButtonFormField<int>(
                      isDense: true,
                      value: _limit,
                      items: const [10, 20, 50]
                          .map((v) => DropdownMenuItem<int>(
                                value: v,
                                child: Text('$v itens',
                                    style: TextStyle(fontSize: 12)),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _limit = v;
                          _pagina = 1;
                        });
                        _reload();
                      },
                      decoration: AppInputDecorations.dropdownNoLabel(),
                    ),
                  ),
                  // paginação
                  Row(
                    children: [
                      Text(
                        '$paginaAtual de $totalPaginas',
                        style: const TextStyle(
                            color: Color(0xFF525251), fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        color: AppColors.primaryText,
                        onPressed: paginaAtual <= 1
                            ? null
                            : () {
                                setState(() {
                                  _pagina = _pagina - 1;
                                });
                                _reload();
                              },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 18),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        color: AppColors.primaryText,
                        onPressed: paginaAtual >= totalPaginas
                            ? null
                            : () {
                                setState(() {
                                  _pagina = _pagina + 1;
                                });
                                _reload();
                              },
                        icon: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
