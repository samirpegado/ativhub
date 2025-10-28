import 'package:repsys/domain/models/core_planos_manutencao_model.dart';
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
}

