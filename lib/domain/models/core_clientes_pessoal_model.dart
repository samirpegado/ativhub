class CoreClientesPessoalModel {
  final String? id;
  final DateTime? createdAt;
  final String? empresaId;
  final String? clienteId;
  final String? nome;
  final String? email;
  final String? telefone;
  final String? cargo;

  CoreClientesPessoalModel({
    this.id,
    this.createdAt,
    this.empresaId,
    this.clienteId,
    this.nome,
    this.email,
    this.telefone,
    this.cargo,
  });

  factory CoreClientesPessoalModel.fromJson(Map<String, dynamic> json) {
    return CoreClientesPessoalModel(
      id: json['id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      empresaId: json['empresa_id'],
      clienteId: json['cliente_id'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      cargo: json['cargo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'empresa_id': empresaId,
      'cliente_id': clienteId,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cargo': cargo,
    };
  }

  /// Para criar novo responsável (sem id e created_at)
  Map<String, dynamic> toJsonCreate() {
    return {
      'empresa_id': empresaId,
      'cliente_id': clienteId,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cargo': cargo,
    };
  }

  /// Para atualizar responsável existente
  Map<String, dynamic> toJsonUpdate() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cargo': cargo,
    };
  }

  CoreClientesPessoalModel copyWith({
    String? id,
    DateTime? createdAt,
    String? empresaId,
    String? clienteId,
    String? nome,
    String? email,
    String? telefone,
    String? cargo,
  }) {
    return CoreClientesPessoalModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      empresaId: empresaId ?? this.empresaId,
      clienteId: clienteId ?? this.clienteId,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cargo: cargo ?? this.cargo,
    );
  }
}

