import 'package:repsys/domain/models/core_planos_checklist_model.dart';
import 'package:repsys/domain/models/core_planos_manutencao_model.dart';
import 'package:repsys/domain/models/core_planos_manutencao_page_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CorePlanosManutencaoRepository {
  final SupabaseClient _supabase;

  CorePlanosManutencaoRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Busca todos os planos de manutenção de uma empresa
  Future<List<CorePlanosManutencaoModel>> buscarPorEmpresa({
    required String empresaId,
  }) async {
    try {
      final response = await _supabase
          .from('core_planos_manutencao')
          .select()
          .eq('empresa_id', empresaId)
          .order('nome', ascending: true);

      final List<CorePlanosManutencaoModel> planos = [];
      for (var item in response) {
        planos.add(CorePlanosManutencaoModel.fromJson(item));
      }

      return planos;
    } catch (e) {
      throw Exception('Erro ao buscar planos de manutenção: $e');
    }
  }

  /// Busca um plano específico por ID
  Future<CorePlanosManutencaoModel?> buscarPorId({
    required String id,
  }) async {
    try {
      final response = await _supabase
          .from('core_planos_manutencao')
          .select()
          .eq('id', id)
          .single();

      return CorePlanosManutencaoModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Busca paginada via RPC `buscar_planos`, já convertendo para modelos.
  Future<CorePlanosManutencaoPageModel> buscarPlanosPage({
    required String empresaId,
    String? busca,
    String? tipo,
    int limit = 20,
    int pagina = 1,
  }) async {
    try {
      final resp = await _supabase.rpc('buscar_planos', params: {
        'p_empresa_id': empresaId,
        'p_limit': limit,
        'p_pagina': pagina,
        'p_busca': _nullIfEmpty(busca),
        'f_tipo': _nullIfEmpty(tipo),
      });

      // Usa o factory que une as duas partes (itens + paginação)
      return CorePlanosManutencaoPageModel.fromRpc(resp);
    } catch (e) {
      throw Exception('Erro ao buscar planos de manutenção: $e');
    }
  }

  // Helper
  String? _nullIfEmpty(String? s) {
    if (s == null) return null;
    final t = s.trim();
    return t.isEmpty ? null : t;
  }

  /// Insere um novo plano de manutenção
  Future<String?> inserir({
    required String empresaId,
    required String userId,
    required String nome,
    String? descricao,
    String? tipoPlano,
  }) async {
    try {
      final payload = <String, dynamic>{
        'empresa_id': empresaId,
        'created_by': userId,
        'updated_by': userId,
        'nome': nome.trim(),
        'descricao': descricao?.trim().isEmpty == true ? null : descricao?.trim(),
        'tipo_plano': tipoPlano,
      };

      final response = await _supabase
          .from('core_planos_manutencao')
          .insert(payload)
          .select('id')
          .single();

      return response['id'] as String;
    } catch (e) {
      throw Exception('Erro ao inserir plano de manutenção: $e');
    }
  }

  /// Busca todos os checklists de um plano
  Future<List<CorePlanosChecklistModel>> buscarChecklistsPorPlano({
    required String planoManutencaoId,
  }) async {
    try {
      final response = await _supabase
          .from('core_planos_checklist')
          .select()
          .eq('plano_manutencao_id', planoManutencaoId);

      final List<CorePlanosChecklistModel> checklists = [];
      for (var item in response) {
        checklists.add(CorePlanosChecklistModel.fromJson(item));
      }

      return checklists;
    } catch (e) {
      throw Exception('Erro ao buscar checklists: $e');
    }
  }

  /// Insere múltiplos itens de checklist (um por recorrência, com array de títulos)
  Future<void> inserirChecklists({
    required String planoManutencaoId,
    required List<CorePlanosChecklistModel> checklists,
  }) async {
    try {
      if (checklists.isEmpty) return;

      // Agrupa por recorrência e cria payloads (cada recorrência = uma linha com array de títulos)
      final payloads = checklists.map((checklist) => {
        'plano_manutencao_id': planoManutencaoId,
        'recorrencia': checklist.recorrencia,
        'titulo_checklist': checklist.tituloChecklist,
      }).toList();

      await _supabase.from('core_planos_checklist').insert(payloads);
    } catch (e) {
      throw Exception('Erro ao inserir checklists: $e');
    }
  }

  /// Atualiza os checklists de um plano (remove os antigos e insere os novos)
  Future<void> atualizarChecklists({
    required String planoManutencaoId,
    required List<CorePlanosChecklistModel> checklists,
  }) async {
    try {
      // Remove todos os checklists existentes do plano
      await _supabase
          .from('core_planos_checklist')
          .delete()
          .eq('plano_manutencao_id', planoManutencaoId);

      // Insere os novos checklists
      if (checklists.isNotEmpty) {
        await inserirChecklists(
          planoManutencaoId: planoManutencaoId,
          checklists: checklists,
        );
      }
    } catch (e) {
      throw Exception('Erro ao atualizar checklists: $e');
    }
  }

  /// Atualiza um plano de manutenção
  Future<void> atualizar({
    required String id,
    required String userId,
    required String nome,
    String? descricao,
    String? tipoPlano,
  }) async {
    try {
      final payload = <String, dynamic>{
        'updated_by': userId,
        'nome': nome.trim(),
        'descricao': descricao?.trim().isEmpty == true ? null : descricao?.trim(),
        'tipo_plano': tipoPlano,
      };

      await _supabase
          .from('core_planos_manutencao')
          .update(payload)
          .eq('id', id);
    } catch (e) {
      throw Exception('Erro ao atualizar plano de manutenção: $e');
    }
  }

  /// Deleta um plano de manutenção (os checklists são deletados automaticamente por CASCADE)
  Future<void> deletar({
    required String id,
  }) async {
    try {
      await _supabase
          .from('core_planos_manutencao')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Erro ao deletar plano de manutenção: $e');
    }
  }
}

