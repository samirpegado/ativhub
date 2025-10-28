// lib/domain/models/catalogo_page_model.dart
import 'catalogo_model.dart';
import 'paginacao_model.dart';

class CatalogoPageModel {
  final List<CatalogoModel> itens;
  final PaginacaoModel paginacao;

  const CatalogoPageModel({
    required this.itens,
    required this.paginacao,
  });

  factory CatalogoPageModel.fromRpc(dynamic rpc) {
    final map = (rpc as Map).cast<String, dynamic>();

    final itensRaw = (map['itens'] as List? ?? const [])
        .map((e) => CatalogoModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList(growable: false);

    final pag = PaginacaoModel.fromJson(
      ((map['paginacao'] as Map?) ?? const {}).cast<String, dynamic>(),
    );

    return CatalogoPageModel(itens: itensRaw, paginacao: pag);
  }

  Map<String, dynamic> toJson() => {
        'itens': itens.map((e) => e.toJson()).toList(),
        'paginacao': paginacao.toJson(),
      };
}
