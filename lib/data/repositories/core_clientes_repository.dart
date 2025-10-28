import 'package:repsys/domain/models/core_clientes_model.dart';
import 'package:repsys/domain/models/core_clientes_page_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoreClientesRepository {
  final _supabase = Supabase.instance.client;

  /// Insere um cliente na tabela core_clientes.
  Future<void> inserir(Map<String, dynamic> data) async {
    // Remover nulos para não enviar colunas desnecessárias
    data.removeWhere((k, v) => v == null);
    await _supabase.from('core_clientes').insert(data);
  }

  /// Edita um cliente na tabela core_clientes.
  Future<void> editar(Map<String, dynamic> data) async {
    // Remover nulos para não enviar colunas desnecessárias
    data.removeWhere((k, v) => v == null);
    await _supabase.from('core_clientes').update(data).eq('id', data['id']);
  }

  /// Deleta um cliente da tabela core_clientes.
  Future<void> deletar(Map<String, dynamic> data) async {
    await _supabase.from('core_clientes').delete().eq('id', data['id']);
  }

  /// Busca paginada via RPC `buscar_core_clientes_json`, já convertendo para modelos.
  Future<CoreClientesPageModel> buscarCoreClientesPage({
    required String empresaId,
    int limit = 20,
    int pagina = 1,
    String? dataCriacaoInicial,
    String? dataCriacaoFinal,
    String? busca,
    String? tipoContrato,
    bool? ativo,
  }) async {
    final resp = await _supabase.rpc('buscar_core_clientes_json', params: {
      'p_empresa_id': empresaId,
      'p_limit': limit,
      'p_pagina': pagina,
      'f_data_criacao_inicial': _nullIfEmpty(dataCriacaoInicial),
      'f_data_criacao_final': _nullIfEmpty(dataCriacaoFinal),
      'p_busca': _nullIfEmpty(busca),
      'f_tipo_contrato': _nullIfEmpty(tipoContrato),
      'f_ativo': ativo,
    });

    // Usa o factory que une as duas partes (itens + paginação)
    return CoreClientesPageModel.fromRpc(resp);
  }

  // Helper
  String? _nullIfEmpty(String? s) {
    if (s == null) return null;
    final t = s.trim();
    return t.isEmpty ? null : t;
  }

    Future<CoreClientesModel> buscarClientePorId(String id) async {
    final resp = await _supabase.from('core_clientes').select('*').eq('id', id).single();
    return CoreClientesModel.fromJson(resp);
  }
}

