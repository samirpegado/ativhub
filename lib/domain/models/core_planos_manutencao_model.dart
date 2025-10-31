class CorePlanosManutencaoModel {
  final String? id;
  final DateTime? createdAt;
  final String? empresaId;
  final String? nome;
  final String? descricao;
  final String? tipoPlano;

  CorePlanosManutencaoModel({
    this.id,
    this.createdAt,
    this.empresaId,
    this.nome,
    this.descricao,
    this.tipoPlano,
  });

  factory CorePlanosManutencaoModel.fromJson(Map<String, dynamic> json) {
    return CorePlanosManutencaoModel(
      id: json['id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      empresaId: json['empresa_id'],
      nome: json['nome'],
      descricao: json['descricao'],
      tipoPlano: json['tipo_plano'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'empresa_id': empresaId,
      'nome': nome,
      'descricao': descricao,
      'tipo_plano': tipoPlano,
    };
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      'empresa_id': empresaId,
      'nome': nome,
      'descricao': descricao,
      'tipo_plano': tipoPlano,
    };
  }
}

