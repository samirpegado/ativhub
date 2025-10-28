import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerDataTable extends StatelessWidget {
  const ShimmerDataTable({
    super.key,
    required this.columnFlex,
    this.rows = 8,
    this.headerHeight = 40,
    this.rowHeight = 72,
    this.gap = 8,
    this.showHeader = true,
    this.showFooter = true,
    this.multiLineColumns = const {},
    this.alignRightColumns = const {},
    this.baseColor = const Color(0xFFE7E7E7),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  /// Largura relativa de cada coluna (usa Expanded com flex)
  final List<int> columnFlex;

  /// Quantas linhas “fantasma” mostrar
  final int rows;

  /// Alturas e espaçamentos
  final double headerHeight;
  final double rowHeight;
  final double gap;

  /// Exibir header/footer skeleton
  final bool showHeader;
  final bool showFooter;

  /// Colunas que terão 2 linhas de skeleton (ex.: “Identificador”)
  final Set<int> multiLineColumns;

  /// Colunas alinhadas à direita (ex.: quantidade, valor)
  final Set<int> alignRightColumns;

  /// Cores do shimmer
  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showHeader) _buildHeader(context),
        SizedBox(height: gap),
        Expanded(child: _buildRows(context)),
        if (showFooter) ...[
          SizedBox(height: gap),
          _buildFooter(context),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFE1E1E1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (int i = 0; i < columnFlex.length; i++) ...[
            Expanded(flex: columnFlex[i], child: const SizedBox()),
            if (i != columnFlex.length - 1) SizedBox(width: gap),
          ],
        ],
      ),
    );
  }

  Widget _buildRows(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: rows,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          height: rowHeight,
          decoration: const BoxDecoration(
            color: Color(0xFFFCFCFC),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE1E1E1)),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < columnFlex.length; i++) ...[
                Expanded(
                  flex: columnFlex[i],
                  child: _ShimmerCell(
                    lines: multiLineColumns.contains(i) ? 2 : 1,
                    alignRight: alignRightColumns.contains(i),
                    // você pode ajustar larguras por coluna aqui se quiser
                  ),
                ),
                if (i != columnFlex.length - 1) SizedBox(width: gap),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFFFCFCFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE1E1E1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _FooterBox(width: 100, height: 40), // “dropdown” fake do limit
            Row(
              children: [
                _FooterBox(width: 80, height: 14), // “X de Y”
                SizedBox(width: 8),
                _FooterBox(width: 40, height: 40), // prev
                SizedBox(width: 8),
                _FooterBox(width: 40, height: 40), // next
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCell extends StatelessWidget {
  const _ShimmerCell({
    this.lines = 1,
    // ignore: unused_element_parameter
    this.alignRight = false, this.width,
  });

  final int lines;
  final bool alignRight;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < lines; i++) {
      children.add(_skelBar(width: width));
      if (i < lines - 1) children.add(const SizedBox(height: 6));
    }
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class _FooterBox extends StatelessWidget {
  const _FooterBox({required this.width, required this.height});
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) => _skelBar(width: width, height: height);
}

Widget _skelBar({double height = 12, double? width}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
    ),
  );
}
