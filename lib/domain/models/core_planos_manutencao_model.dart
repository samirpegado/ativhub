class CorePlanosManutencaoModel {
  final String? id;
  final DateTime? createdAt;
  final String? empresaId;
  final String? nome;
  final String? descricao;
  final String? tipo;
  final String? frequencia;
  final List<Map<String, dynamic>>? checklist;

  CorePlanosManutencaoModel({
    this.id,
    this.createdAt,
    this.empresaId,
    this.nome,
    this.descricao,
    this.tipo,
    this.frequencia,
    this.checklist,
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
      tipo: json['tipo'],
      frequencia: json['frequencia'],
      checklist: json['checklist'] != null
          ? List<Map<String, dynamic>>.from(json['checklist'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'empresa_id': empresaId,
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo,
      'frequencia': frequencia,
      'checklist': checklist,
    };
  }
}

