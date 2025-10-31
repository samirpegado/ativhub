class CorePlanosManutencaoFiltroModel {
  final String? busca;
  final String? tipo;

  const CorePlanosManutencaoFiltroModel({
    this.busca,
    this.tipo,
  });

  // sentinela público p/ defaults de parâmetro (precisa ser const)
  static const Object kUnset = Object();

  CorePlanosManutencaoFiltroModel copyWith({
    Object? busca = kUnset,
    Object? tipo = kUnset,
  }) {
    return CorePlanosManutencaoFiltroModel(
      busca: identical(busca, kUnset) ? this.busca : busca as String?,
      tipo: identical(tipo, kUnset) ? this.tipo : tipo as String?,
    );
  }
}
