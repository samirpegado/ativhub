import 'package:flutter/foundation.dart';
import 'package:repsys/data/repositories/catalogo_repository.dart';
import 'package:repsys/utils/helpers.dart';

class CatalogoViewModel with ChangeNotifier {
  final CatalogoRepository _repo = CatalogoRepository();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  Future<String?> inserir({
    required String empresaId,
    required String tipo,
    required String nome,
    String? descricao,
    String? codigo,
    String? marca,
    String? quantidadeTxt,
    String? valorCompraTxt,
    String? valorVendaTxt,
    String? imagemUrl,
    String? numeroSerie,
    String? imei,
  }) async {
    // Regras simples por tipo
    final isServico = tipo == 'Serviço';
    final isEquip = tipo == 'Equipamento';

    // Converte valores
    final quantidade =
        isServico ? null : int.tryParse((quantidadeTxt ?? '').trim());
    final valorCompra = parseMoedaBr(valorCompraTxt);
    final valorVenda = parseMoedaBr(valorVendaTxt);

    // Validações mínimas
    if (nome.trim().isEmpty) return 'Informe o nome';
    if (tipo.trim().isEmpty) return 'Selecione o tipo';
    if (valorVenda == null) return 'Informe o valor de venda';

    _isSaving = true;
    notifyListeners();

    try {
      final payload = <String, dynamic>{
        'empresa_id': empresaId,
        'tipo': tipo,
        'nome': nome.trim(),
        'descricao': emptyToNull(descricao),
        'codigo': emptyToNull(codigo),
        'marca': isServico ? null : emptyToNull(marca),
        'quantidade': quantidade,
        'valor_venda': valorVenda,
        'valor_compra': valorCompra,
        'imagem_url': emptyToNull(imagemUrl),
        'numero_serie': isEquip ? emptyToNull(numeroSerie) : null,
        'imei': isEquip ? emptyToNull(imei) : null,
        // NÃO envie id/created_at/updated_at
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
    required String tipo,
    required String nome,
    String? descricao,
    String? codigo,
    String? marca,
    String? quantidadeTxt,
    String? valorCompraTxt,
    String? valorVendaTxt,
    String? imagemUrl,
    String? numeroSerie,
    String? imei,
  }) async {
    // Regras simples por tipo
    final isServico = tipo == 'Serviço';
    final isEquip = tipo == 'Equipamento';

    // Converte valores
    final quantidade =
        isServico ? null : int.tryParse((quantidadeTxt ?? '').trim());
    final valorCompra = parseMoedaBr(valorCompraTxt);
    final valorVenda = parseMoedaBr(valorVendaTxt);

    // Validações mínimas
    if (nome.trim().isEmpty) return 'Informe o nome';
    if (tipo.trim().isEmpty) return 'Selecione o tipo';
    if (valorVenda == null) return 'Informe o valor de venda';

    _isSaving = true;
    notifyListeners();

    try {
      final payload = <String, dynamic>{
        'id': itemId,
        'empresa_id': empresaId,
        'tipo': tipo,
        'nome': nome.trim(),
        'descricao': emptyToNull(descricao),
        'codigo': emptyToNull(codigo),
        'marca': isServico ? null : emptyToNull(marca),
        'quantidade': quantidade,
        'valor_venda': valorVenda,
        'valor_compra': valorCompra,
        'imagem_url': emptyToNull(imagemUrl),
        'numero_serie': isEquip ? emptyToNull(numeroSerie) : null,
        'imei': isEquip ? emptyToNull(imei) : null,
        // NÃO envie id/created_at/updated_at
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
      return 'Erro ao salvar: $e';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
