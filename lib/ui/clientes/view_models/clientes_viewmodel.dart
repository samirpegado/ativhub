import 'package:flutter/foundation.dart';
import 'package:repsys/data/repositories/clientes_repository.dart';
import 'package:repsys/utils/helpers.dart';

class ClientesViewmodel with ChangeNotifier {
  final _repo = ClientesRepository();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  Future<String?> inserirClientes({
  required String empresaId,
  required String tipo, // 'pf' | 'pj'
  required String nome,
  required String email,
  required String telefone,
  String? documento,
  String? dataNascimento, // aceita DD/MM/AAAA; se vier só DD/MM, não envia
  String? contatoAlternativo,
  String? comoConheceu,
  String? endCep,
  String? endRua,
  String? endCidade,
  String? endUf,
  String? endBairro,
  String? endNumero,
  String? endComplemento,
}) async {
  String trimOrEmpty(String? v) => (v ?? '').trim();
  String? emptyToNull(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }



  bool isValidEmail(String v) {
    final t = v.trim();
    // simples e eficaz p/ maioria dos casos
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(t);
  }

  /// Converte "DD/MM/AAAA" -> "yyyy-MM-dd". Retorna null se inválida.
  String? parseDateBrToIso(String? v) {
    if (v == null) return null;
    final t = v.trim();
    final full = RegExp(r'^(\d{2})\/(\d{2})\/(\d{4})$');
    final m = full.firstMatch(t);
    if (m == null) return null; // não converte DD/MM (sem ano)
    final dd = int.parse(m.group(1)!);
    final mm = int.parse(m.group(2)!);
    final yyyy = int.parse(m.group(3)!);
    // validação rápida de faixa
    if (mm < 1 || mm > 12 || dd < 1 || dd > 31) return null;
    try {
      final dt = DateTime(yyyy, mm, dd);
      // garante que o mês/dia não “rolou” (ex.: 31/02 vira 03/03)
      if (dt.day != dd || dt.month != mm || dt.year != yyyy) return null;
      final mmStr = mm.toString().padLeft(2, '0');
      final ddStr = dd.toString().padLeft(2, '0');
      return '${dt.year}-$mmStr-$ddStr';
    } catch (_) {
      return null;
    }
  }

  // --- Saneamento ---
  final nomeT = trimOrEmpty(nome);
  final emailT = trimOrEmpty(email);

  final ufT = trimOrEmpty(endUf).toUpperCase();

  // --- Validações obrigatórias ---
  if (nomeT.isEmpty) return 'Informe o nome';
  if (emailT.isEmpty || !isValidEmail(emailT)) return 'Informe um e-mail válido';


  // tipo
  final tipoNorm = (tipo.trim().toLowerCase() == 'pj') ? 'pj' : 'pf';

  // data de nascimento (opcional)
  final dataNascIso = parseDateBrToIso(dataNascimento);

  _isSaving = true;
  notifyListeners();

  try {
    final payload = <String, dynamic>{
      'empresa_id': empresaId,
      'tipo': tipoNorm, // 'pf' | 'pj'
      'nome': nomeT,
      'email': emailT,
      'documento': emptyToNull(documento),
      'telefone': telefone, // salvo apenas dígitos
      'data_nascimento': dataNascIso, // null se não veio AAAA
      'contato_alternativo': emptyToNull(contatoAlternativo),
      'como_conheceu': emptyToNull(comoConheceu),
      'end_cep': emptyToNull(endCep),
      'end_rua': emptyToNull(endRua),
      'end_cidade': emptyToNull(endCidade),
      'end_uf': emptyToNull(ufT.isEmpty ? null : ufT),
      'end_bairro': emptyToNull(endBairro),
      'end_numero': emptyToNull(endNumero),
      'end_complemento': emptyToNull(endComplemento),
    };

    await _repo.inserir(payload); 
    return null;
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
