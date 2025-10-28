import 'package:flutter/foundation.dart';
import 'package:repsys/data/repositories/core_clientes_repository.dart';
import 'package:repsys/utils/helpers.dart';

class CoreClientesViewModel with ChangeNotifier {
  final CoreClientesRepository _repo = CoreClientesRepository();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  Future<String?> inserir({
    required String empresaId,
    required String userId,
    required String nome,
    String? tipo,
    String? email,
    String? documento,
    String? telefone,
    String? tipoContrato,
    String? valorContratoTxt,
    String? diaPagamentoTxt,
    String? dataAssinaturaTxt,
    String? endCep,
    String? endRua,
    String? endNumero,
    String? endBairro,
    String? endCidade,
    String? endUf,
    String? endComplemento,
    String? observacoes,
  }) async {
    // Converte valores
    final valorContrato = _parseValorContrato(valorContratoTxt);
    final diaPagamento = int.tryParse((diaPagamentoTxt ?? '').trim());
    final dataAssinatura = _parseDataAssinatura(dataAssinaturaTxt);

    // Validações mínimas
    if (nome.trim().isEmpty) return 'Informe o nome';

    _isSaving = true;
    notifyListeners();

    try {
      final payload = <String, dynamic>{
        'empresa_id': empresaId,
        'created_by': userId,
        'updated_by': userId,
        'nome': nome.trim(),  
        'tipo': emptyToNull(tipo),
        'email': emptyToNull(email),
        'documento': emptyToNull(documento),
        'telefone': emptyToNull(telefone),
        'tipo_contrato': emptyToNull(tipoContrato),
        'valor_contrato': valorContrato,
        'dia_pagamento': diaPagamento,
        'data_assinatura': dataAssinatura?.toIso8601String(),
        'end_cep': emptyToNull(endCep),
        'end_rua': emptyToNull(endRua),
        'end_numero': emptyToNull(endNumero),
        'end_bairro': emptyToNull(endBairro),
        'end_cidade': emptyToNull(endCidade),
        'end_uf': emptyToNull(endUf),
        'end_complemento': emptyToNull(endComplemento),
        'observacoes': emptyToNull(observacoes),
        'ativo': true,
      };

      await _repo.inserir(payload);
      return null; // sucesso (sem mensagem de erro)
    } catch (e) {
      return 'Erro ao salvar: $e';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<String?> editar({
    required String itemId,
    required String empresaId,
    required String userId,
    required String nome,
    String? tipo,
    String? email,
    String? documento,
    String? telefone,
    String? tipoContrato,
    String? valorContratoTxt,
    String? diaPagamentoTxt,
    String? dataAssinaturaTxt,
    String? endCep,
    String? endRua,
    String? endNumero,
    String? endBairro,
    String? endCidade,
    String? endUf,
    String? endComplemento,
    String? observacoes,
    bool? ativo,
  }) async {
    // Converte valores
    final valorContrato = _parseValorContrato(valorContratoTxt);
    final diaPagamento = int.tryParse((diaPagamentoTxt ?? '').trim());
    final dataAssinatura = _parseDataAssinatura(dataAssinaturaTxt);

    // Validações mínimas
    if (nome.trim().isEmpty) return 'Informe o nome';

    _isSaving = true;
    notifyListeners();

    try {
      final payload = <String, dynamic>{
        'id': itemId,
        'empresa_id': empresaId, 
        'updated_by': userId,
        'nome': nome.trim(),
        'tipo': emptyToNull(tipo),
        'email': emptyToNull(email),
        'documento': emptyToNull(documento),
        'telefone': emptyToNull(telefone),
        'tipo_contrato': emptyToNull(tipoContrato),
        'valor_contrato': valorContrato,
        'dia_pagamento': diaPagamento,
        'data_assinatura': dataAssinatura?.toIso8601String(),
        'end_cep': emptyToNull(endCep),
        'end_rua': emptyToNull(endRua),
        'end_numero': emptyToNull(endNumero),
        'end_bairro': emptyToNull(endBairro),
        'end_cidade': emptyToNull(endCidade),
        'end_uf': emptyToNull(endUf),
        'end_complemento': emptyToNull(endComplemento),
        'observacoes': emptyToNull(observacoes),
        'ativo': ativo,
      };

      await _repo.editar(payload);
      return null; // sucesso (sem mensagem de erro)
    } catch (e) {
      return 'Erro ao salvar: $e';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<String?> deletar({
    required String itemId,
    required String empresaId,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      final payload = <String, dynamic>{
        'id': itemId,
        'empresa_id': empresaId,
      };

      await _repo.deletar(payload);
      return null; // sucesso (sem mensagem de erro)
    } catch (e) {
      return 'Erro ao deletar: $e';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Helpers de conversão
  double? _parseValorContrato(String? valor) {
    if (valor == null || valor.trim().isEmpty) return null;
    
    // Remove tudo exceto dígitos e vírgula
    final cleaned = valor.replaceAll(RegExp(r'[^\d,]'), '');
    // Substitui vírgula por ponto
    final withDot = cleaned.replaceAll(',', '.');
    
    return double.tryParse(withDot);
  }

  DateTime? _parseDataAssinatura(String? data) {
    if (data == null || data.trim().isEmpty) return null;
    
    // Formato esperado: dd/mm/yyyy
    final parts = data.split('/');
    if (parts.length != 3) return null;
    
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    
    if (day == null || month == null || year == null) return null;
    
    try {
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}

