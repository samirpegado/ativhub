import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:repsys/domain/models/user_model.dart';

class StorageRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserModel> uploadProfilePic({
    required String userId,
    required XFile imagem,
  }) async {
    final fileName = 'profile_$userId.jpg';
    final bucket = _client.storage.from('profile');   

    // 1. Upload da imagem
    final bytes = await imagem.readAsBytes();
    final uploadResponse = await bucket.uploadBinary(
      fileName,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

    if (uploadResponse.isEmpty) {
      throw Exception('Erro ao fazer upload da imagem');
    }

    // 2. Obter URL pública
    final imageUrl = bucket.getPublicUrl(fileName);

    // 3. Atualizar o campo profile_pic do usuário
    final updateResponse = await _client
        .from('users')
        .update({'profile_pic': imageUrl}).eq('id', userId);

    if (updateResponse != null) {
      throw Exception('Erro ao atualizar o usuário');
    }

    // 4. Buscar e retornar o usuário atualizado
    final userResponse =
        await _client.from('users').select().eq('id', userId).single();

    return UserModel.fromMap(userResponse);
  }
}
