import 'package:flutter/foundation.dart';
import 'package:repsys/data/repositories/core_planos_manutencao_repository.dart';
import 'package:repsys/domain/models/core_planos_checklist_model.dart';

class PlanosViewModel with ChangeNotifier {
  final CorePlanosManutencaoRepository _repo = CorePlanosManutencaoRepository();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  void setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  Future<String?> inserir({
    required String empresaId,
    required String userId,
    required String nome,
    String? descricao,
    required String tipoPlano,
    required List<CorePlanosChecklistModel> checklists,
  }) async {
    // Validações mínimas
    if (nome.trim().isEmpty) return 'Informe o nome do plano';
    if (tipoPlano.trim().isEmpty) return 'Selecione o tipo de plano';

    _isSaving = true;
    notifyListeners();

    try {
      // Insere o plano primeiro
      final planoId = await _repo.inserir(
        empresaId: empresaId,
        userId: userId,
        nome: nome,
        descricao: descricao,
        tipoPlano: tipoPlano,
      );

      // Se houver checklists, insere eles
      if (planoId != null && checklists.isNotEmpty) {
        await _repo.inserirChecklists(
          planoManutencaoId: planoId,
          checklists: checklists,
        );
      }

      return null; // sucesso (sem mensagem de erro)
    } catch (e) {
      return 'Erro ao salvar: $e';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<String?> editar({
    required String planoId,
    required String userId,
    required String nome,
    String? descricao,
    required String tipoPlano,
    required List<CorePlanosChecklistModel> checklists,
  }) async {
    // Validações mínimas
    if (nome.trim().isEmpty) return 'Informe o nome do plano';
    if (tipoPlano.trim().isEmpty) return 'Selecione o tipo de plano';

    _isSaving = true;
    notifyListeners();

    try {
      // Atualiza o plano
      await _repo.atualizar(
        id: planoId,
        userId: userId,
        nome: nome,
        descricao: descricao,
        tipoPlano: tipoPlano,
      );

      // Atualiza os checklists (remove os antigos e insere os novos)
      await _repo.atualizarChecklists(
        planoManutencaoId: planoId,
        checklists: checklists,
      );

      return null; // sucesso (sem mensagem de erro)
    } catch (e) {
      return 'Erro ao atualizar: $e';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<String?> deletar({
    required String planoId,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _repo.deletar(id: planoId);
      return null; // sucesso (sem mensagem de erro)
    } catch (e) {
      return 'Erro ao deletar: $e';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
