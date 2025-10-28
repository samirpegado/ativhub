class CoreClientesFiltroModel {
  final String? busca;
  final String? tipoContrato;
  final bool? ativo;
  final String? dataCriacaoInicial;
  final String? dataCriacaoFinal;

  const CoreClientesFiltroModel({
    this.busca,
    this.tipoContrato,
    this.ativo,
    this.dataCriacaoInicial,
    this.dataCriacaoFinal,
  });

  // sentinela público p/ defaults de parâmetro (precisa ser const)
  static const Object kUnset = Object();

  CoreClientesFiltroModel copyWith({
    Object? busca = kUnset,
    Object? tipoContrato = kUnset,
    Object? ativo = kUnset,
    Object? dataCriacaoInicial = kUnset,
    Object? dataCriacaoFinal = kUnset,
  }) {
    return CoreClientesFiltroModel(
      busca: identical(busca, kUnset) ? this.busca : busca as String?,
      tipoContrato: identical(tipoContrato, kUnset)
          ? this.tipoContrato
          : tipoContrato as String?,
      ativo: identical(ativo, kUnset) ? this.ativo : ativo as bool?,
      dataCriacaoInicial: identical(dataCriacaoInicial, kUnset)
          ? this.dataCriacaoInicial
          : dataCriacaoInicial as String?,
      dataCriacaoFinal: identical(dataCriacaoFinal, kUnset)
          ? this.dataCriacaoFinal
          : dataCriacaoFinal as String?,
    );
  }
}

