import 'package:repsys/domain/models/core_clientes_model.dart';
import 'package:repsys/domain/models/paginacao_model.dart';

class CoreClientesPageModel {
  final List<CoreClientesModel> itens;
  final PaginacaoModel paginacao;

  const CoreClientesPageModel({
    required this.itens,
    required this.paginacao,
  });

  factory CoreClientesPageModel.fromRpc(dynamic rpc) {
    final map = (rpc as Map).cast<String, dynamic>();

    final itensRaw = (map['itens'] as List? ?? const [])
        .map((e) => CoreClientesModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList(growable: false);

    final pag = PaginacaoModel.fromJson(
      ((map['paginacao'] as Map?) ?? const {}).cast<String, dynamic>(),
    );

    return CoreClientesPageModel(itens: itensRaw, paginacao: pag);
  }

  Map<String, dynamic> toJson() => {
        'itens': itens.map((e) => e.toJson()).toList(),
        'paginacao': paginacao.toJson(),
      };
}

