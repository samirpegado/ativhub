class CoreAtivosModel {
  final String? id;
  final String? empresaId;
  final String? clienteId;
  final String? nome;
  final String? localInstalacao;
  final String? tag;
  final String? categoria;
  final String? status;
  final String? imagemUrl;
  final DateTime? dataInstalacao;
  final DateTime? dataInicioOperacao;
  final String? numeroSerie;
  final DateTime? garantiaFim;
  final String? notaFiscal;
  final String? fornecedor;
  final String? planoManutencaoId;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  CoreAtivosModel({
    this.id,
    this.empresaId,
    this.clienteId,
    this.nome,
    this.localInstalacao,
    this.tag,
    this.categoria,
    this.status,
    this.imagemUrl,
    this.dataInstalacao,
    this.dataInicioOperacao,
    this.numeroSerie,
    this.garantiaFim,
    this.notaFiscal,
    this.fornecedor,
    this.planoManutencaoId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory CoreAtivosModel.fromJson(Map<String, dynamic> json) {
    return CoreAtivosModel(
      id: json['id'],
      empresaId: json['empresa_id'],
      clienteId: json['cliente_id'],
      nome: json['nome'],
      localInstalacao: json['local_instalacao'],
      tag: json['tag'],
      categoria: json['categoria'],
      status: json['status'],
      imagemUrl: json['imagem_url'],
      dataInstalacao: json['data_instalacao'] != null
          ? DateTime.parse(json['data_instalacao'])
          : null,
      dataInicioOperacao: json['data_inicio_operacao'] != null
          ? DateTime.parse(json['data_inicio_operacao'])
          : null,
      numeroSerie: json['numero_serie'],
      garantiaFim: json['garantia_fim'] != null
          ? DateTime.parse(json['garantia_fim'])
          : null,
      notaFiscal: json['nota_fiscal'],
      fornecedor: json['fornecedor'],
      planoManutencaoId: json['plano_manutencao_id'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      'empresa_id': empresaId,
      'cliente_id': clienteId,
      'nome': nome,
      'local_instalacao': localInstalacao,
      // 'tag' não é enviado - será gerado automaticamente pelo banco
      'categoria': categoria,
      'status': status ?? 'ativo',
      'imagem_url': imagemUrl,
      'data_instalacao': dataInstalacao?.toIso8601String(),
      'data_inicio_operacao': dataInicioOperacao?.toIso8601String(),
      'numero_serie': numeroSerie,
      'garantia_fim': garantiaFim?.toIso8601String(),
      'nota_fiscal': notaFiscal,
      'fornecedor': fornecedor,
      'plano_manutencao_id': planoManutencaoId,
      'created_by': createdBy,
      'metadata': metadata ?? {},
    };
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      'nome': nome,
      'local_instalacao': localInstalacao,
      // 'tag' não pode ser editado
      'categoria': categoria,
      'status': status,
      'imagem_url': imagemUrl,
      'data_instalacao': dataInstalacao?.toIso8601String(),
      'data_inicio_operacao': dataInicioOperacao?.toIso8601String(),
      'numero_serie': numeroSerie,
      'garantia_fim': garantiaFim?.toIso8601String(),
      'nota_fiscal': notaFiscal,
      'fornecedor': fornecedor,
      'plano_manutencao_id': planoManutencaoId,
      'updated_by': updatedBy,
    };
  }

  String getStatusLabel() {
    switch (status) {
      case 'ativo':
        return 'Ativo';
      case 'inativo':
        return 'Inativo';
      case 'em_manutencao':
        return 'Em Manutenção';
      case 'baixado':
        return 'Baixado';
      default:
        return status ?? 'Desconhecido';
    }
  }

  CoreAtivosModel copyWith({
    String? id,
    String? empresaId,
    String? clienteId,
    String? nome,
    String? localInstalacao,
    String? tag,
    String? categoria,
    String? status,
    String? imagemUrl,
    DateTime? dataInstalacao,
    DateTime? dataInicioOperacao,
    String? numeroSerie,
    DateTime? garantiaFim,
    String? notaFiscal,
    String? fornecedor,
    String? planoManutencaoId,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return CoreAtivosModel(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      clienteId: clienteId ?? this.clienteId,
      nome: nome ?? this.nome,
      localInstalacao: localInstalacao ?? this.localInstalacao,
      tag: tag ?? this.tag,
      categoria: categoria ?? this.categoria,
      status: status ?? this.status,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      dataInstalacao: dataInstalacao ?? this.dataInstalacao,
      dataInicioOperacao: dataInicioOperacao ?? this.dataInicioOperacao,
      numeroSerie: numeroSerie ?? this.numeroSerie,
      garantiaFim: garantiaFim ?? this.garantiaFim,
      notaFiscal: notaFiscal ?? this.notaFiscal,
      fornecedor: fornecedor ?? this.fornecedor,
      planoManutencaoId: planoManutencaoId ?? this.planoManutencaoId,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

