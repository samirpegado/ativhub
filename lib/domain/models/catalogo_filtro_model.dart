// lib/domain/models/catalogo_filtro_model.dart
class CatalogoFiltroModel {
  final String? busca;
  final String? tipo;
  final String? marca;

  const CatalogoFiltroModel({this.busca, this.tipo, this.marca});

  // sentinela público p/ defaults de parâmetro (precisa ser const)
  static const Object kUnset = Object();

  CatalogoFiltroModel copyWith({
    Object? busca = kUnset,  // Object? para diferenciar omitido vs null
    Object? tipo  = kUnset,
    Object? marca = kUnset,
  }) {
    return CatalogoFiltroModel(
      busca: identical(busca, kUnset) ? this.busca : busca as String?,
      tipo:  identical(tipo,  kUnset) ? this.tipo  : tipo  as String?,
      marca: identical(marca, kUnset) ? this.marca : marca as String?,
    );
  }
}
