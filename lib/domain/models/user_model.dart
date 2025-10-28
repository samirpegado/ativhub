import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String id;
  final String email;
  final String? nome;
  final String? profilePic;
  final String? celular;
  final String? cpf;
  final bool status;

  UserModel({
    required this.id,
    required this.email,
    this.nome,
    this.profilePic,
    this.celular,
    this.cpf,
    this.status = false,
  });

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] ?? '',
      nome: map['nome'],
      profilePic: map['profile_pic'],
      celular: map['celular'],
      cpf: map['cpf'],
      status: map['status'] ?? false,
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nome': nome,
      'profile_pic': profilePic,
      'celular': celular,
      'cpf': cpf,
      'status': status,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? nome,
    String? profilePic,
    String? celular,
    String? cpf,
    bool? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      profilePic: profilePic ?? this.profilePic,
      celular: celular ?? this.celular,
      cpf: cpf ?? this.cpf,
      status: status ?? this.status,
    );
  }

  String toJson() => jsonEncode(toMap());
}
