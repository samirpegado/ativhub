import 'package:repsys/domain/models/core_at_categorias_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoreAtCategoriasRepository {
  final SupabaseClient _supabase;

  CoreAtCategoriasRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Busca todas as categorias de uma empresa
  Future<List<CoreAtCategoriasModel>> buscarPorEmpresa({
    required String empresaId,
  }) async {
    try {
      final response = await _supabase
          .from('core_at_categorias')
          .select()
          .eq('empresa_id', empresaId)
          .order('nome', ascending: true);

      final List<CoreAtCategoriasModel> categorias = [];
      for (var item in response) {
        categorias.add(CoreAtCategoriasModel.fromJson(item));
      }

      return categorias;
    } catch (e) {
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  /// Busca uma categoria específica por ID
  Future<CoreAtCategoriasModel?> buscarPorId({
    required String id,
  }) async {
    try {
      final response = await _supabase
          .from('core_at_categorias')
          .select()
          .eq('id', id)
          .single();

      return CoreAtCategoriasModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}

