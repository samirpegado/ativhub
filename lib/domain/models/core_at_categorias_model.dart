class CoreAtCategoriasModel {
  final String? id;
  final String? empresaId;
  final DateTime? createdAt;
  final String? nome;
  final String? descricao;

  CoreAtCategoriasModel({
    this.id,
    this.empresaId,
    this.createdAt,
    this.nome,
    this.descricao,
  });

  factory CoreAtCategoriasModel.fromJson(Map<String, dynamic> json) {
    return CoreAtCategoriasModel(
      id: json['id'],
      empresaId: json['empresa_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      nome: json['nome'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'empresa_id': empresaId,
      'created_at': createdAt?.toIso8601String(),
      'nome': nome,
      'descricao': descricao,
    };
  }
}

