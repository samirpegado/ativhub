import 'dart:convert';

import 'package:http/http.dart' as http;

class EnderecoRepository {
  Future<Map<String, dynamic>?> buscarEnderecoPorCep(String cep) async {
    try {
      final cleanedCep = cep.replaceAll(RegExp(r'\D'), '');
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cleanedCep/json/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['erro'] == true) return null;
        return data;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}