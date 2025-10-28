import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
  return null;
}

String? _dateToIso(DateTime? dt) => dt?.toIso8601String();

/// =======================
/// =      UserModel     =
/// =======================
class UserModel {
  static const _prefsKey = 'usuario_json';

  final String id;
  final String? empresaId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? role;
  final String? nome;
  final String? email;
  final String? cpf;
  final String? celular;
  final bool? status;

  const UserModel({
    required this.id,
    this.empresaId,
    required this.createdAt,
    this.updatedAt,
    this.role,
    this.nome,
    this.email,
    this.cpf,
    this.celular,
    this.status,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      empresaId: map['empresa_id'] as String?,
      createdAt: _parseDate(map['created_at']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: _parseDate(map['updated_at']),
      role: map['role'] as String?,
      nome: map['nome'] as String?,
      email: map['email'] as String?,
      cpf: map['cpf'] as String?,
      celular: map['celular'] as String?,
      status: map['status'] as bool?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'empresa_id': empresaId,
        'created_at': _dateToIso(createdAt),
        'updated_at': _dateToIso(updatedAt),
        'role': role,
        'nome': nome,
        'email': email,
        'cpf': cpf,
        'celular': celular,
        'status': status,
      };

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  String toJson() => jsonEncode(toMap());

  UserModel copyWith({
    String? id,
    String? empresaId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? role,
    String? nome,
    String? email,
    String? cpf,
    String? celular,
    bool? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      celular: celular ?? this.celular,
      status: status ?? this.status,
    );
  }

  // ---------- SharedPreferences ----------
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, toJson());
  }

  static Future<UserModel?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return null;
    return UserModel.fromJson(raw);
  }

  static Future<void> clearFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}

/// =======================
/// =    EmpresaModel     =
/// =======================
class EmpresaModel {
  static const _prefsKey = 'empresa_json';

  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? superUser; // uuid
  final String? nomeFantasia;
  final String? razaoSocial;
  final String? cnpj;
  final String? emailEmpresa;
  final String? telefone;
  final String? website;
  final String? enderecoCep;
  final String? enderecoUf;
  final String? enderecoCidade;
  final String? enderecoRua;
  final String? enderecoNumero;
  final String? enderecoComplemento;
  final String? logoUrl;
  final int? osInicial;     // smallint
  final DateTime? fimTeste;
  final String? termosServico;
  final int? garantiaDias;  // smallint

  const EmpresaModel({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.superUser,
    this.nomeFantasia,
    this.razaoSocial,
    this.cnpj,
    this.emailEmpresa,
    this.telefone,
    this.website,
    this.enderecoCep,
    this.enderecoUf,
    this.enderecoCidade,
    this.enderecoRua,
    this.enderecoNumero,
    this.enderecoComplemento,
    this.logoUrl,
    this.osInicial,
    this.fimTeste,
    this.termosServico,
    this.garantiaDias,
  });

  factory EmpresaModel.fromMap(Map<String, dynamic> map) {
    return EmpresaModel(
      id: map['id'] as String,
      createdAt: _parseDate(map['created_at']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: _parseDate(map['updated_at']),
      superUser: map['super_user'] as String?,
      nomeFantasia: map['nome_fantasia'] as String?,
      razaoSocial: map['razao_social'] as String?,
      cnpj: map['cnpj'] as String?,
      emailEmpresa: map['email_empresa'] as String?,
      telefone: map['telefone'] as String?,
      website: map['website'] as String?,
      enderecoCep: map['endereco_cep'] as String?,
      enderecoUf: map['endereco_uf'] as String?,
      enderecoCidade: map['endereco_cidade'] as String?,
      enderecoRua: map['endereco_rua'] as String?,
      enderecoNumero: map['endereco_numero'] as String?,
      enderecoComplemento: map['endereco_complemento'] as String?,
      logoUrl: map['logo_url'] as String?,
      osInicial: (map['os_inicial'] as num?)?.toInt(),
      fimTeste: _parseDate(map['fim_teste']),
      termosServico: map['termos_servico'] as String?,
      garantiaDias: (map['garantia_dias'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'created_at': _dateToIso(createdAt),
        'updated_at': _dateToIso(updatedAt),
        'super_user': superUser,
        'nome_fantasia': nomeFantasia,
        'razao_social': razaoSocial,
        'cnpj': cnpj,
        'email_empresa': emailEmpresa,
        'telefone': telefone,
        'website': website,
        'endereco_cep': enderecoCep,
        'endereco_uf': enderecoUf,
        'endereco_cidade': enderecoCidade,
        'endereco_rua': enderecoRua,
        'endereco_numero': enderecoNumero,
        'endereco_complemento': enderecoComplemento,
        'logo_url': logoUrl,
        'os_inicial': osInicial,
        'fim_teste': _dateToIso(fimTeste),
        'termos_servico': termosServico,
        'garantia_dias': garantiaDias,
      };

  factory EmpresaModel.fromJson(String source) =>
      EmpresaModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  String toJson() => jsonEncode(toMap());

  EmpresaModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? superUser,
    String? nomeFantasia,
    String? razaoSocial,
    String? cnpj,
    String? emailEmpresa,
    String? telefone,
    String? website,
    String? enderecoCep,
    String? enderecoUf,
    String? enderecoCidade,
    String? enderecoRua,
    String? enderecoNumero,
    String? enderecoComplemento,
    String? logoUrl,
    int? osInicial,
    DateTime? fimTeste,
    String? termosServico,
    int? garantiaDias,
  }) {
    return EmpresaModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      superUser: superUser ?? this.superUser,
      nomeFantasia: nomeFantasia ?? this.nomeFantasia,
      razaoSocial: razaoSocial ?? this.razaoSocial,
      cnpj: cnpj ?? this.cnpj,
      emailEmpresa: emailEmpresa ?? this.emailEmpresa,
      telefone: telefone ?? this.telefone,
      website: website ?? this.website,
      enderecoCep: enderecoCep ?? this.enderecoCep,
      enderecoUf: enderecoUf ?? this.enderecoUf,
      enderecoCidade: enderecoCidade ?? this.enderecoCidade,
      enderecoRua: enderecoRua ?? this.enderecoRua,
      enderecoNumero: enderecoNumero ?? this.enderecoNumero,
      enderecoComplemento: enderecoComplemento ?? this.enderecoComplemento,
      logoUrl: logoUrl ?? this.logoUrl,
      osInicial: osInicial ?? this.osInicial,
      fimTeste: fimTeste ?? this.fimTeste,
      termosServico: termosServico ?? this.termosServico,
      garantiaDias: garantiaDias ?? this.garantiaDias,
    );
  }

  // ---------- SharedPreferences ----------
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, toJson());
  }

  static Future<EmpresaModel?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return null;
    return EmpresaModel.fromJson(raw);
  }

  static Future<void> clearFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }
}
