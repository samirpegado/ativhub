class CatalogoModel {
  final String id;
  final String? empresaId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String tipo;
  final String nome;
  final String? descricao;
  final String? codigo;
  final String? marca;
  final int? quantidade;
  final double? valorVenda;
  final double? valorCompra;
  final String? imagemUrl;
  final String? numeroSerie;
  final String? imei;

  CatalogoModel({
    required this.id,
    this.empresaId,
    required this.createdAt,
    this.updatedAt,
    required this.tipo,
    required this.nome,
    this.descricao,
    this.codigo,
    this.marca,
    this.quantidade,
    this.valorVenda,
    this.valorCompra,
    this.imagemUrl,
    this.numeroSerie,
    this.imei,
  });

  factory CatalogoModel.fromJson(Map<String, dynamic> json) {
    return CatalogoModel(
      id: json['id'] as String,
      empresaId: json['empresa_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      tipo: json['tipo'] as String,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String?,
      codigo: json['codigo'] as String?,
      marca: json['marca'] as String?,
      quantidade: json['quantidade'] as int?,
      valorVenda: (json['valor_venda'] as num?)?.toDouble(),
      valorCompra: (json['valor_compra'] as num?)?.toDouble(),
      imagemUrl: json['imagem_url'] as String?,
      numeroSerie: json['numero_serie'] as String?,
      imei: json['imei'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empresa_id': empresaId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'tipo': tipo,
      'nome': nome,
      'descricao': descricao,
      'codigo': codigo,
      'marca': marca,
      'quantidade': quantidade,
      'valor_venda': valorVenda,
      'valor_compra': valorCompra,
      'imagem_url': imagemUrl,
      'numero_serie': numeroSerie,
      'imei': imei,
    };
  }
}