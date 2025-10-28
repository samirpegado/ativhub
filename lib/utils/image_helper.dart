import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageHelper {
  /// Redimensiona uma imagem para no máximo 512px de largura mantendo a proporção
  /// E aplica compressão de 70% de qualidade
  static Future<Uint8List> redimensionarImagem(Uint8List imageBytes) async {
    // Decodifica a imagem
    final image = img.decodeImage(imageBytes);
    
    if (image == null) {
      throw Exception('Não foi possível processar a imagem');
    }

    // Redimensiona se necessário
    img.Image resized;
    if (image.width > 512) {
      resized = img.copyResize(
        image,
        width: 512,
        interpolation: img.Interpolation.linear,
      );
    } else {
      resized = image;
    }

    // Codifica com qualidade 70%
    final jpg = img.encodeJpg(resized, quality: 70);
    
    return Uint8List.fromList(jpg);
  }

  /// Valida se o arquivo é uma imagem válida
  static bool isImageValid(String? mimeType) {
    if (mimeType == null) return false;
    return mimeType.startsWith('image/');
  }

  /// Retorna a extensão do arquivo baseado no mimeType
  static String getExtension(String? mimeType) {
    if (mimeType == null) return 'jpg';
    
    if (mimeType.contains('jpeg') || mimeType.contains('jpg')) {
      return 'jpg';
    } else if (mimeType.contains('png')) {
      return 'png';
    } else if (mimeType.contains('gif')) {
      return 'gif';
    } else if (mimeType.contains('webp')) {
      return 'webp';
    }
    
    return 'jpg';
  }
}

