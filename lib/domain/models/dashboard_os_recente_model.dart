import 'package:flutter/material.dart';

/// Modelo para representar uma Ordem de Serviço recente no dashboard
class DashboardOsRecenteModel {
  final String id;
  final String numeroOs;
  final String descricao;
  final String localCliente;
  final String? tecnicoNome;
  final String prioridade; // Alta, Média, Baixa
  final String status; // Em Execução, Aguardando Peça, Aberta, Concluída
  final Color corIcone;

  DashboardOsRecenteModel({
    required this.id,
    required this.numeroOs,
    required this.descricao,
    required this.localCliente,
    this.tecnicoNome,
    required this.prioridade,
    required this.status,
    required this.corIcone,
  });
}
