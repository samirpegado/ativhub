import 'package:repsys/domain/models/core_planos_manutencao_model.dart';
import 'package:repsys/domain/models/paginacao_model.dart';

class CorePlanosManutencaoPageModel {
  final List<CorePlanosManutencaoModel> itens;
  final PaginacaoModel paginacao;

  const CorePlanosManutencaoPageModel({
    required this.itens,
    required this.paginacao,
  });

  factory CorePlanosManutencaoPageModel.fromRpc(dynamic rpc) {
    final map = (rpc as Map).cast<String, dynamic>();

    final itensRaw = (map['itens'] as List? ?? const [])
        .map((e) =>
            CorePlanosManutencaoModel.fromJson((e as Map).cast<String, dynamic>()))
        .toList(growable: false);

    final pag = PaginacaoModel.fromJson(
      ((map['paginacao'] as Map?) ?? const {}).cast<String, dynamic>(),
    );

    return CorePlanosManutencaoPageModel(itens: itensRaw, paginacao: pag);
  }

  Map<String, dynamic> toJson() => {
        'itens': itens.map((e) => e.toJson()).toList(),
        'paginacao': paginacao.toJson(),
      };
}
