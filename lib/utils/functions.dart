import 'package:intl/intl.dart';
import 'package:repsys/domain/models/despesa.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

final NumberFormat currencyFormat =
    NumberFormat.simpleCurrency(locale: 'pt_BR');

List<DespesaModel> filtroDespesas(
  List<DespesaModel> lista,
  String? categoria,
) {
  // Se a lista for vazia ou ambos os filtros forem nulos/vazios, retorna a lista original
  if (lista.isEmpty ||
      (categoria == null || categoria.isEmpty || categoria == 'Todas')) {
    return lista;
  }

  return lista.where((despesa) {
    // Comparação de categoria
    final matchCategoria = (categoria.isEmpty)
        ? true
        : (despesa.categoriaTitulo.toLowerCase() == categoria.toLowerCase());

    return matchCategoria;
  }).toList();
}

Color? getColor(int index) {
  final hue = ((index + 1) * 40) % 360;
  return HSVColor.fromAHSV(1.0, hue.toDouble(), 1.0, 0.9).toColor();
}

String getFirstAndLastName(String? name) {
  if (name == null) return '';
  final parts = name.split(' ');
  return '${parts[0]} ${parts[parts.length - 1]}';
}

Future<XFile?> selecionarImagem(BuildContext context, String userId) async {
  if (kIsWeb) {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final nome = result.files.single.name;

      debugPrint('Imagem selecionada na web: $nome (${bytes.length} bytes)');
      // Se quiser retornar como XFile, pode criar manualmente:
      return XFile.fromData(bytes, name: nome);
    } else {
      debugPrint('Nenhuma imagem selecionada na web');
      return null;
    }
  } else {
    final XFile? imagem = await showModalBottomSheet<XFile?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () async {
                  final img =
                      await _pickImageMobile(ImageSource.camera, userId);
                  Navigator.of(context).pop(img);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () async {
                  final img =
                      await _pickImageMobile(ImageSource.gallery, userId);
                  Navigator.of(context).pop(img);
                },
              ),
            ],
          ),
        );
      },
    );

    return imagem;
  }
}

Future<XFile?> _pickImageMobile(ImageSource source, String userId) async {
  final picker = ImagePicker();
  final XFile? imagem = await picker.pickImage(source: source);

  if (imagem != null) {
    debugPrint('Imagem selecionada no mobile: ${imagem.path}');
    final comprimida = await compressAndResizeImage(imagem);
    return comprimida; // retorna XFile novamente
  } else {
    debugPrint('Nenhuma imagem selecionada no mobile');
    return null;
  }
}


Future<XFile?> compressAndResizeImage(XFile imageFile) async {
  final dir = await getTemporaryDirectory();
  final targetPath = p.join(
      dir.path, 'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');

  final result = await FlutterImageCompress.compressAndGetFile(
    imageFile.path,
    targetPath,
    minWidth: 512,
    minHeight: 512,
    quality: 75, // valor de 0 a 100, você pode ajustar
    format: CompressFormat.jpeg,
  );

  if (result == null) throw Exception('Erro ao comprimir imagem');

  return result;
}
