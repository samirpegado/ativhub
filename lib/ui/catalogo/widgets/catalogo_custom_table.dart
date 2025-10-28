// lib/ui/catalogo/widgets/catalogo_custom_table.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/catalogo_repository.dart';
import 'package:repsys/domain/models/catalogo_filtro_model.dart';
import 'package:repsys/domain/models/catalogo_model.dart';
import 'package:repsys/domain/models/paginacao_model.dart';
import 'package:repsys/domain/models/catalogo_page_model.dart';
import 'package:repsys/ui/catalogo/components/editar_item.dart';
import 'package:repsys/ui/catalogo/view_models/catalogo_viewmodel.dart';

import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/ui/input_decorations.dart';

class CatalogoCustomTable extends StatefulWidget {
  final String empresaId;
  final int initialLimit;

  /// Você pode injetar o repo (para testes) ou deixar nulo que cria sozinho.
  final CatalogoRepository? repository;

  const CatalogoCustomTable({
    super.key,
    required this.empresaId,
    this.initialLimit = 20,
    this.repository,
  });

  @override
  State<CatalogoCustomTable> createState() => _CatalogoCustomTableState();
}

class _CatalogoCustomTableState extends State<CatalogoCustomTable> {
  late final CatalogoRepository _repo;

  // filtros que vêm do AppState.catalogoFiltro
  String? _tipo;
  String? _marca;
  String? _busca;

  int _limit = 20;
  int _pagina = 1;

  late AppState _appState;
  CatalogoFiltroModel? _lastFiltro;

  // Future atual (para o FutureBuilder)
  Future<CatalogoPageModel>? _future;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? CatalogoRepository();

    // AppState + listener
    _appState = context.read<AppState>();
    _lastFiltro = _appState.catalogoFiltro;

    _limit = widget.initialLimit;
    _tipo = _lastFiltro?.tipo;
    _marca = _lastFiltro?.marca;
    _busca = _lastFiltro?.busca;

    _appState.addListener(_onAppStateChanged);

    _reload();
  }

  void _onAppStateChanged() {
    final f = _appState.catalogoFiltro;
    final mudouTipo = f?.tipo != _tipo;
    final mudouMarca = f?.marca != _marca;
    final mudouBusca = f?.busca != _busca;
    if (!mudouTipo && !mudouMarca && !mudouBusca) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _tipo = f?.tipo;
        _marca = f?.marca;
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

  Future<CatalogoPageModel> _fetchPage() {
    return _repo.buscarCatalogoPage(
      empresaId: widget.empresaId,
      busca: _busca,
      tipo: _tipo,
      marca: _marca,
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

  Future<void> _editaritem(CatalogoModel item) async {
    await showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => CatalogoViewModel(), // já instancia com o repo dentro
        child: EditarItem(
          item: item,
        ),
      ),
    );
    _reload();
  }

  String _fmtBRL(num? v) {
    if (v == null) return '-';
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(v);
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

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return FutureBuilder<CatalogoPageModel>(
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

        final List<CatalogoModel> itens = page.itens;
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
                    Expanded(flex: 3, child: _headerCell('Descrição')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _headerCell('Tipo')),
                    const SizedBox(width: 8),
                    Expanded(flex: 3, child: _headerCell('Código')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _headerCell('Marca')),
                    const SizedBox(width: 8),
                    Expanded(flex: 1, child: _headerCell('Qtd')),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: _headerCell('Valor de venda')),
                  ],
                ),
              ),
            const SizedBox(height: 8),

            // Linhas
            Expanded(
              child: itens.isEmpty
                  ? Center(child: Text('Nenhum item a ser listado'))
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: itens.length,
                      itemBuilder: (context, index) {
                        final e = itens[index];

                        if (isWide) {
                          // layout em colunas (tela larga)
                          return InkWell(
                            onTap: () => _editaritem(e),
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
                                  Expanded(flex: 2, child: _dataCell(e.nome)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _dataCell(e.descricao ?? '-')),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _dataCell(e.tipo)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _dataCell(e.codigo ?? '-')),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 2,
                                      child: _dataCell(e.marca ?? '-')),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 1,
                                      child: _dataCell('${e.quantidade ?? 0}')),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 2,
                                      child: _dataCell(_fmtBRL(e.valorVenda))),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // layout "card" (mobile)
                          return InkWell(
                            onTap: () => _editaritem(e),
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
                                  _dataCell(e.nome),
                                  const SizedBox(height: 6),
                                  _dataCell(e.descricao ?? '-',
                                      secondary: true),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _dataCell('Tipo: ${e.tipo}',
                                          secondary: true),
                                      _dataCell('Qtd: ${e.quantidade ?? 0}',
                                          secondary: true),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _dataCell('Marca: ${e.marca ?? '-'}',
                                          secondary: true),
                                      _dataCell(_fmtBRL(e.valorVenda),
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
