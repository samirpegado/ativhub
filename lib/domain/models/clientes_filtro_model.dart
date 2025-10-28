// lib/domain/models/catalogo_filtro_model.dart
class ClientesFiltroModel {
  final String? busca;
  final String? tipo;
  final String? comoConheceu;

  const ClientesFiltroModel({this.busca, this.tipo, this.comoConheceu});

  // sentinela público p/ defaults de parâmetro (precisa ser const)
  static const Object kUnset = Object();

  ClientesFiltroModel copyWith({
    Object? busca = kUnset,  // Object? para diferenciar omitido vs null
    Object? tipo  = kUnset,
    Object? comoConheceu = kUnset,
  }) {
    return ClientesFiltroModel(
      busca: identical(busca, kUnset) ? this.busca : busca as String?,
      tipo:  identical(tipo,  kUnset) ? this.tipo  : tipo  as String?,
      comoConheceu: identical(comoConheceu, kUnset) ? this.comoConheceu : comoConheceu as String?,
    );
  }
}
