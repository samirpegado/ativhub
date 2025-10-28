class DespesaModel {
  final String tipo;
  final double valor;
  final String titulo;
  final int? parcelas;
  final String descricao;
  final bool liquidada;
  final int despesaId;
  final String? parcelaId;
  final String vencimento;
  final int? parcelaAtual;
  final String categoriaTitulo;

  DespesaModel({
    required this.tipo,
    required this.valor,
    required this.titulo,
    this.parcelas,
    required this.descricao,
    required this.liquidada,
    required this.despesaId,
    this.parcelaId,
    required this.vencimento,
    this.parcelaAtual,
    required this.categoriaTitulo,
  });

  factory DespesaModel.fromJson(Map<String, dynamic> json) {
    return DespesaModel(
      tipo: json['tipo'],
      valor: (json['valor'] as num).toDouble(),
      titulo: json['titulo'],
      parcelas: json['parcelas'],
      descricao: json['descricao'],
      liquidada: json['liquidada'],
      despesaId: json['despesa_id'],
      parcelaId: json['parcela_id'],
      vencimento: json['vencimento'],
      parcelaAtual: json['parcela_atual'],
      categoriaTitulo: json['categoria_titulo'],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'valor': valor,
      'titulo': titulo,
      'parcelas': parcelas,
      'descricao': descricao,
      'liquidada': liquidada,
      'despesa_id': despesaId,
      'parcela_id': parcelaId,
      'vencimento': vencimento,
      'parcela_atual': parcelaAtual,
      'categoria_titulo': categoriaTitulo,
    };
  }
}
