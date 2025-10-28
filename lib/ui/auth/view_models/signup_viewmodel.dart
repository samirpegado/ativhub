import 'package:flutter/material.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/data/repositories/endereco_repository.dart';
import 'package:repsys/data/services/auth_service.dart';
import 'package:repsys/domain/models/response_model.dart';
import 'package:repsys/utils/command.dart';
import 'package:repsys/utils/result.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService authService;
  final AppState appState;
  final EnderecoRepository enderecoRepository;

  late final Command0<ResponseModel> criarContaCommand;

  SignUpViewModel({
    required this.authService,
    required this.appState,
    required this.enderecoRepository,
  }) {
    criarContaCommand = Command0(_criarConta);
  }

  Future<Map<String, dynamic>?> buscarEndereco(String cep) {
    return enderecoRepository.buscarEnderecoPorCep(cep);
  }

  // A função interna usada pelo comando
  Future<Result<ResponseModel>> _criarConta() async {
    try {
      final data = appState.registerData!;
      final response = await authService.createAccount(
        nome: data.nome,
        email: data.email,
        password: data.senha,
        cpf: data.cpf,
        celular: data.celular,
        nomeFantasia: data.nomeFantasia,
        razaoSocial: data.razaoSocial,
        cnpj: data.cnpj,
        emailEmpresa: data.empresaEmail,
        telefone: data.telefone,
        website: data.site,
        enderecoCep: data.cep,
        enderecoUf: data.uf,
        enderecoCidade: data.cidade,
        enderecoRua: data.endereco,
        enderecoNumero: data.numero,
        enderecoComplemento: data.complemento,
      );
      
   

      return Result.ok(response);
    } catch (e) {
      return Result.error(Exception('Erro ao criar conta: $e'));
    }
  }
}
