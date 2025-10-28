// lib/data/services/profile_service.dart
import 'dart:convert';
import 'package:repsys/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final _supabase = Supabase.instance.client;

  /// Busca do servidor (RPC) e salva no SharedPreferences
  Future<Map<String, dynamic>> fetchAndCacheProfile() async {
    final data = await _supabase.rpc('get_user_empresa');
    // `data` deve ser um Map<String, dynamic> com { user: {...}, empresa: {...} }
    if (data == null || data is! Map) {
      throw Exception('Perfil não encontrado');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefsKeys.profile, jsonEncode(data));

    return Map<String, dynamic>.from(data);
  }

  /// Lê do cache (se existir)
  Future<Map<String, dynamic>?> readCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(PrefsKeys.profile);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PrefsKeys.profile);
  }
}
