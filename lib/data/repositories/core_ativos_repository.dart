import 'dart:typed_data';
import 'package:repsys/domain/models/core_ativos_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoreAtivosRepository {
  final SupabaseClient _supabase;

  CoreAtivosRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Busca todos os ativos de um cliente específico
  Future<List<CoreAtivosModel>> buscarPorCliente({
    required String empresaId,
    required String clienteId,
  }) async {
    try {
      final response = await _supabase
          .from('core_ativos')
          .select()
          .eq('empresa_id', empresaId)
          .eq('cliente_id', clienteId)
          .order('created_at', ascending: false);

      final List<CoreAtivosModel> ativos = [];
      for (var item in response) {
        ativos.add(CoreAtivosModel.fromJson(item));
      }

      return ativos;
    } catch (e) {
      throw Exception('Erro ao buscar ativos: $e');
    }
  }

  /// Busca um ativo específico por ID
  Future<CoreAtivosModel?> buscarPorId({
    required String id,
  }) async {
    try {
      final response = await _supabase
          .from('core_ativos')
          .select()
          .eq('id', id)
          .single();

      return CoreAtivosModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Insere um novo ativo
  Future<String?> inserir({
    required CoreAtivosModel ativo,
  }) async {
    try {
      final response = await _supabase
          .from('core_ativos')
          .insert(ativo.toJsonCreate())
          .select('id')
          .single();

      return response['id'];
    } catch (e) {
      throw Exception('Erro ao inserir ativo: $e');
    }
  }

  /// Atualiza um ativo existente
  Future<bool> atualizar({
    required String id,
    required CoreAtivosModel ativo,
  }) async {
    try {
      await _supabase
          .from('core_ativos')
          .update(ativo.toJsonUpdate())
          .eq('id', id);

      return true;
    } catch (e) {
      throw Exception('Erro ao atualizar ativo: $e');
    }
  }

  /// Deleta um ativo
  Future<bool> deletar({
    required String id,
  }) async {
    try {
      await _supabase
          .from('core_ativos')
          .delete()
          .eq('id', id);

      return true;
    } catch (e) {
      throw Exception('Erro ao deletar ativo: $e');
    }
  }

  /// Conta quantos ativos um cliente tem
  Future<int> contarPorCliente({
    required String empresaId,
    required String clienteId,
  }) async {
    try {
      final response = await _supabase
          .from('core_ativos')
          .select()
          .eq('empresa_id', empresaId)
          .eq('cliente_id', clienteId);

      return response.length;
    } catch (e) {
      return 0;
    }
  }

  /// Upload de imagem do ativo para o bucket
  Future<String?> uploadImagem({
    required String empresaId,
    required String ativoId,
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    try {
      final path = '$empresaId/$ativoId/$fileName';
      
      await _supabase.storage
          .from('ativos')
          .uploadBinary(
            path,
            imageBytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      final url = _supabase.storage
          .from('ativos')
          .getPublicUrl(path);

      return url;
    } catch (e) {
      throw Exception('Erro ao fazer upload da imagem: $e');
    }
  }

  /// Remove imagem do ativo do bucket
  Future<bool> removerImagem({
    required String imagemUrl,
  }) async {
    try {
      // Extrai o path da URL
      final uri = Uri.parse(imagemUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf('ativos');
      
      if (bucketIndex == -1 || bucketIndex == pathSegments.length - 1) {
        return false;
      }

      final path = pathSegments.sublist(bucketIndex + 1).join('/');
      
      await _supabase.storage
          .from('ativos')
          .remove([path]);

      return true;
    } catch (e) {
      return false;
    }
  }
}

