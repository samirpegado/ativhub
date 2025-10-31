class CorePlanosChecklistModel {
  final String? id;
  final String? planoManutencaoId;
  final String? recorrencia;
  final List<String>? tituloChecklist;

  CorePlanosChecklistModel({
    this.id,
    this.planoManutencaoId,
    this.recorrencia,
    this.tituloChecklist,
  });

  factory CorePlanosChecklistModel.fromJson(Map<String, dynamic> json) {
    return CorePlanosChecklistModel(
      id: json['id'],
      planoManutencaoId: json['plano_manutencao_id'],
      recorrencia: json['recorrencia'],
      tituloChecklist: json['titulo_checklist'] != null
          ? List<String>.from(json['titulo_checklist'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plano_manutencao_id': planoManutencaoId,
      'recorrencia': recorrencia,
      'titulo_checklist': tituloChecklist,
    };
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      'plano_manutencao_id': planoManutencaoId,
      'recorrencia': recorrencia,
      'titulo_checklist': tituloChecklist,
    };
  }
}
