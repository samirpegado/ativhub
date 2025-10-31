import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/core_planos_manutencao_repository.dart';
import 'package:repsys/domain/models/core_planos_manutencao_filtro_model.dart';
import 'package:repsys/domain/models/core_planos_manutencao_model.dart';
import 'package:repsys/domain/models/core_planos_manutencao_page_model.dart';
import 'package:repsys/domain/models/paginacao_model.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';
import 'package:repsys/ui/planos/components/editar_plano.dart';
import 'package:repsys/ui/planos/view_models/planos_viewmodel.dart';

class PlanosCustomTable extends StatefulWidget {
  final String empresaId;
  final int initialLimit;
  final CorePlanosManutencaoRepository? repository;
  final Function(VoidCallback reloadCallback)? onInit;

  const PlanosCustomTable({
    super.key,
    required this.empresaId,
    this.initialLimit = 20,
    this.repository,
    this.onInit,
  });

  @override
  State<PlanosCustomTable> createState() => _PlanosCustomTableState();
}

class _PlanosCustomTableState extends State<PlanosCustomTable> {
  late final CorePlanosManutencaoRepository _repo;

  // filtros que vêm do AppState
  String? _tipo;
  String? _busca;

  int _limit = 20;
  int _pagina = 1;

  late AppState _appState;
  CorePlanosManutencaoFiltroModel? _lastFiltro;

  // Future atual (para o FutureBuilder)
  Future<CorePlanosManutencaoPageModel>? _future;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? CorePlanosManutencaoRepository();

    // AppState + listener
    _appState = context.read<AppState>();
    _lastFiltro = _appState.planosManutencaoFiltro;

    _limit = widget.initialLimit;
    _tipo = _lastFiltro?.tipo;
    _busca = _lastFiltro?.busca;

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
    final f = _appState.planosManutencaoFiltro;
    final mudouTipo = f?.tipo != _tipo;
    final mudouBusca = f?.busca != _busca;

    if (!mudouTipo && !mudouBusca) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _tipo = f?.tipo;
        _busca = f?.busca;
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

  Future<CorePlanosManutencaoPageModel> _fetchPage() {
    return _repo.buscarPlanosPage(
      empresaId: widget.empresaId,
      busca: _busca,
      tipo: _tipo,
      limit: _limit,
      pagina: _pagina,
    );
  }

  void _reload() {
    final next = _fetchPage();
    if (!mounted) return;
    setState(() {
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

  String _getTipoLabel(String? tipo) {
    if (tipo == null) return '-';
    switch (tipo) {
      case 'preventivo':
        return 'Preventivo';
      case 'corretivo':
        return 'Corretivo';
      case 'preditivo':
        return 'Preditivo';
      default:
        return tipo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return FutureBuilder<CorePlanosManutencaoPageModel>(
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

        final List<CorePlanosManutencaoModel> itens = page.itens;
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
                    Expanded(flex: 2, child: _headerCell('Nome')),
                    const SizedBox(width: 8),
                    Expanded(child: _headerCell('Tipo')),
                    const SizedBox(width: 8),
                    Expanded(flex: 3, child: _headerCell('Descrição')),
                  ],
                ),
              ),
            const SizedBox(height: 8),

            // Linhas
            Expanded(
              child: itens.isEmpty
                  ? const Center(child: Text('Nenhum plano a ser listado'))
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: itens.length,
                      itemBuilder: (context, index) {
                        final e = itens[index];

                        if (isWide) {
                          // layout em colunas (tela larga)
                          return InkWell(
                            onTap: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => PlanosViewModel(),
                                  child: EditarPlano(plano: e),
                                ),
                              );
                              if (result == true) {
                                _reload();
                              }
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
                                      flex: 2, child: _dataCell(e.nome ?? '-')),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: _dataCell(
                                          _getTipoLabel(e.tipoPlano))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _dataCell(e.descricao ?? '-',
                                          secondary: true)),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // layout "card" (mobile)
                          return InkWell(
                            onTap: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => PlanosViewModel(),
                                  child: EditarPlano(plano: e),
                                ),
                              );
                              if (result == true) {
                                _reload();
                              }
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
                                  _dataCell(
                                      'Tipo: ${_getTipoLabel(e.tipoPlano)}',
                                      secondary: true),
                                  const SizedBox(height: 6),
                                  _dataCell(e.nome ?? '-'),
                                  const SizedBox(height: 6),
                                  if (e.descricao != null &&
                                      e.descricao!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    _dataCell(e.descricao!, secondary: true),
                                  ],
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
