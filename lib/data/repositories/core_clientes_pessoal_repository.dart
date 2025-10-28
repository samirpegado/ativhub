import 'package:repsys/domain/models/core_clientes_pessoal_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoreClientesPessoalRepository {
  final SupabaseClient _supabase;

  CoreClientesPessoalRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Busca todos os responsáveis de um cliente específico
  Future<List<CoreClientesPessoalModel>> buscarPorCliente({
    required String empresaId,
    required String clienteId,
  }) async {
    try {
      final response = await _supabase
          .from('core_clientes_responsaveis')
          .select()
          .eq('empresa_id', empresaId)
          .eq('cliente_id', clienteId)
          .order('created_at', ascending: false);

      final List<CoreClientesPessoalModel> responsaveis = [];
      for (var item in response) {
        responsaveis.add(CoreClientesPessoalModel.fromJson(item));
      }

      return responsaveis;
    } catch (e) {
      throw Exception('Erro ao buscar responsáveis: $e');
    }
  }

  /// Busca um responsável específico por ID
  Future<CoreClientesPessoalModel?> buscarPorId({
    required String id,
  }) async {
    try {
      final response = await _supabase
          .from('core_clientes_responsaveis')
          .select()
          .eq('id', id)
          .single();

      return CoreClientesPessoalModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Insere um novo responsável
  /// Retorna o ID do responsável criado ou null em caso de erro
  Future<String?> inserir({
    required CoreClientesPessoalModel responsavel,
  }) async {
    try {
      final response = await _supabase
          .from('core_clientes_responsaveis')
          .insert(responsavel.toJsonCreate())
          .select('id')
          .single();

      return response['id'];
    } catch (e) {
      throw Exception('Erro ao inserir responsável: $e');
    }
  }

  /// Atualiza um responsável existente
  /// Retorna true em caso de sucesso, false em caso de erro
  Future<bool> atualizar({
    required String id,
    required CoreClientesPessoalModel responsavel,
  }) async {
    try {
      await _supabase
          .from('core_clientes_responsaveis')
          .update(responsavel.toJsonUpdate())
          .eq('id', id);

      return true;
    } catch (e) {
      throw Exception('Erro ao atualizar responsável: $e');
    }
  }

  /// Deleta um responsável
  /// Retorna true em caso de sucesso, false em caso de erro
  Future<bool> deletar({
    required String id,
  }) async {
    try {
      await _supabase
          .from('core_clientes_responsaveis')
          .delete()
          .eq('id', id);

      return true;
    } catch (e) {
      throw Exception('Erro ao deletar responsável: $e');
    }
  }

  /// Conta quantos responsáveis um cliente tem
  Future<int> contarPorCliente({
    required String empresaId,
    required String clienteId,
  }) async {
    try {
      final response = await _supabase
          .from('core_clientes_responsaveis')
          .select()
          .eq('empresa_id', empresaId)
          .eq('cliente_id', clienteId);

      return response.length;
    } catch (e) {
      return 0;
    }
  }
}

