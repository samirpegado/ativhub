class ClientesModel {
  final int id;
  final String? empresaId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  final String? tipo;
  final String? nome;
  final String? email;
  final String? documento;
  final String? telefone;
  final DateTime? dataNascimento;
  final String? contatoAlternativo;
  final String? comoConheceu;

  final String? endCep;
  final String? endRua;
  final String? endCidade;
  final String? endUf;
  final String? endBairro;
  final String? endNumero;
  final String? endComplemento;

  ClientesModel({
    required this.id,
    this.empresaId,
    required this.createdAt,
    this.updatedAt,
    this.tipo,
    this.nome,
    this.email,
    this.documento,
    this.telefone,
    this.dataNascimento,
    this.contatoAlternativo,
    this.comoConheceu,
    this.endCep,
    this.endRua,
    this.endCidade,
    this.endUf,
    this.endBairro,
    this.endNumero,
    this.endComplemento,
  });

  factory ClientesModel.fromJson(Map<String, dynamic> json) {
    return ClientesModel(
      id: (json['id'] as num).toInt(),
      empresaId: json['empresa_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      tipo: json['tipo'] as String?,
      nome: json['nome'] as String?,
      email: json['email'] as String?,
      documento: json['documento'] as String?,
      telefone: json['telefone'] as String?,
      dataNascimento: json['data_nascimento'] != null
          ? DateTime.parse(json['data_nascimento'] as String)
          : null,
      contatoAlternativo: json['contato_alternativo'] as String?,
      comoConheceu: json['como_conheceu'] as String?,
      endCep: json['end_cep'] as String?,
      endRua: json['end_rua'] as String?,
      endCidade: json['end_cidade'] as String?,
      endUf: json['end_uf'] as String?,
      endBairro: json['end_bairro'] as String?,
      endNumero: json['end_numero'] as String?,
      endComplemento: json['end_complemento'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    String? dateOnly(DateTime? d) => d?.toIso8601String().split('T').first;

    return {
      'id': id,
      'empresa_id': empresaId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'tipo': tipo,
      'nome': nome,
      'email': email,
      'documento': documento,
      'telefone': telefone,
      'data_nascimento': dateOnly(dataNascimento), // date (YYYY-MM-DD)
      'contato_alternativo': contatoAlternativo,
      'como_conheceu': comoConheceu,
      'end_cep': endCep,
      'end_rua': endRua,
      'end_cidade': endCidade,
      'end_uf': endUf,
      'end_bairro': endBairro,
      'end_numero': endNumero,
      'end_complemento': endComplemento,
    };
  }
}
