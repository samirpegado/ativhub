class CoreClientesModel {
  final String id;
  final String? empresaId;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? ativo;
  final String? tipo;
  final String? nome;
  final String? email;
  final String? documento;
  final String? telefone;
  final String? tipoContrato;
  final double? valorContrato;
  final int? diaPagamento;
  final DateTime? dataAssinatura;
  final String? endCep;
  final String? endRua;
  final String? endNumero;
  final String? endBairro;
  final String? endCidade;
  final String? endUf;
  final String? endComplemento;
  final String? observacoes;
  final Map<String, dynamic>? metadata;

  CoreClientesModel({
    required this.id,
    this.empresaId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.ativo,
    this.tipo,
    this.nome,
    this.email,
    this.documento,
    this.telefone,
    this.tipoContrato,
    this.valorContrato,
    this.diaPagamento,
    this.dataAssinatura,
    this.endCep,
    this.endRua,
    this.endNumero,
    this.endBairro,
    this.endCidade,
    this.endUf,
    this.endComplemento,
    this.observacoes,
    this.metadata,
  });

  factory CoreClientesModel.fromJson(Map<String, dynamic> json) {
    return CoreClientesModel(
      id: json['id'] as String,
      empresaId: json['empresa_id'] as String?,
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      ativo: json['ativo'] as bool?,
      tipo: json['tipo'] as String?,
      nome: json['nome'] as String?,
      email: json['email'] as String?,
      documento: json['documento'] as String?,
      telefone: json['telefone'] as String?,
      tipoContrato: json['tipo_contrato'] as String?,
      valorContrato: _parseValorContrato(json['valor_contrato']),
      diaPagamento: json['dia_pagamento'] as int?,
      dataAssinatura: json['data_assinatura'] != null
          ? DateTime.parse(json['data_assinatura'] as String)
          : null,
      endCep: json['end_cep'] as String?,
      endRua: json['end_rua'] as String?,
      endNumero: json['end_numero'] as String?,
      endBairro: json['end_bairro'] as String?,
      endCidade: json['end_cidade'] as String?,
      endUf: json['end_uf'] as String?,
      endComplemento: json['end_complemento'] as String?,
      observacoes: json['observacoes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empresa_id': empresaId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'ativo': ativo,
      'tipo': tipo,
      'nome': nome,
      'email': email,
      'documento': documento,
      'telefone': telefone,
      'tipo_contrato': tipoContrato,
      'valor_contrato': valorContrato,
      'dia_pagamento': diaPagamento,
      'data_assinatura': dataAssinatura?.toIso8601String(),
      'end_cep': endCep,
      'end_rua': endRua,
      'end_numero': endNumero,
      'end_bairro': endBairro,
      'end_cidade': endCidade,
      'end_uf': endUf,
      'end_complemento': endComplemento,
      'observacoes': observacoes,
      'metadata': metadata,
    };
  }

  CoreClientesModel copyWith({
    String? id,
    String? empresaId,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? ativo,
    String? tipo,
    String? nome,
    String? email,
    String? documento,
    String? telefone,
    String? tipoContrato,
    double? valorContrato,
    int? diaPagamento,
    DateTime? dataAssinatura,
    String? endCep,
    String? endRua,
    String? endNumero,
    String? endBairro,
    String? endCidade,
    String? endUf,
    String? endComplemento,
    String? observacoes,
    Map<String, dynamic>? metadata,
  }) {
    return CoreClientesModel(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ativo: ativo ?? this.ativo,
      tipo: tipo ?? this.tipo,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      documento: documento ?? this.documento,
      telefone: telefone ?? this.telefone,
      tipoContrato: tipoContrato ?? this.tipoContrato,
      valorContrato: valorContrato ?? this.valorContrato,
      diaPagamento: diaPagamento ?? this.diaPagamento,
      dataAssinatura: dataAssinatura ?? this.dataAssinatura,
      endCep: endCep ?? this.endCep,
      endRua: endRua ?? this.endRua,
      endNumero: endNumero ?? this.endNumero,
      endBairro: endBairro ?? this.endBairro,
      endCidade: endCidade ?? this.endCidade,
      endUf: endUf ?? this.endUf,
      endComplemento: endComplemento ?? this.endComplemento,
      observacoes: observacoes ?? this.observacoes,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper para parse seguro do valor_contrato
  static double? _parseValorContrato(dynamic value) {
    if (value == null) return null;
    
    if (value is num) {
      return value.toDouble();
    }
    
    if (value is String) {
      return double.tryParse(value);
    }
    
    return null;
  }
}

