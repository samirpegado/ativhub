class PaginacaoModel {
  final int? limit;
  final int? qtdPaginas;
  final int? paginaAtual;
  final int? qtdItensTotal;
  final int? qtdItensFiltrados;

  PaginacaoModel({
    this.limit,
    this.qtdPaginas,
    this.paginaAtual,
    this.qtdItensTotal,
    this.qtdItensFiltrados,
  });

  factory PaginacaoModel.fromJson(Map<String, dynamic> json) {
    return PaginacaoModel(
      limit: json['limit'] as int?,
      paginaAtual: json['pagina_atual'] as int?,
      qtdItensFiltrados: json['qtd_itens_filtrados'] as int?,
      qtdItensTotal: json['qtd_itens_total'] as int?,
      qtdPaginas: json['qtd_paginas'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'pagina_atual': paginaAtual,
      'qtd_itens_filtrados': qtdItensFiltrados,
      'qtd_itens_total': qtdItensTotal,
      'qtd_paginas': qtdPaginas,
    };
  }
}
