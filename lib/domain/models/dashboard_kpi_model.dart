import 'package:flutter/material.dart';

/// Modelo para representar um KPI do dashboard
class DashboardKpiModel {
  final String id;
  final String titulo;
  final String valor;
  final String? descricao;
  final String? tendencia;
  final Color cor;
  final IconData? icon;

  DashboardKpiModel({
    required this.id,
    required this.titulo,
    required this.valor,
    this.descricao,
    this.tendencia,
    required this.cor,
    this.icon,
  });
}
