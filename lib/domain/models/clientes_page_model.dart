// lib/domain/models/catalogo_page_model.dart
import 'package:repsys/domain/models/clientes_model.dart';
import 'paginacao_model.dart';

class ClientesPageModel {
  final List<ClientesModel> itens;
  final PaginacaoModel paginacao;

  const ClientesPageModel({
    required this.itens,
    required this.paginacao,
  });

  factory ClientesPageModel.fromRpc(dynamic rpc) {
    final map = (rpc as Map).cast<String, dynamic>();

    final itensRaw = (map['itens'] as List? ?? const [])
        .map((e) => ClientesModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList(growable: false);

    final pag = PaginacaoModel.fromJson(
      ((map['paginacao'] as Map?) ?? const {}).cast<String, dynamic>(),
    );

    return ClientesPageModel(itens: itensRaw, paginacao: pag);
  }

  Map<String, dynamic> toJson() => {
        'itens': itens.map((e) => e.toJson()).toList(),
        'paginacao': paginacao.toJson(),
      };
}
