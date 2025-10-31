import 'package:flutter/material.dart';
import 'package:repsys/domain/models/dashboard_kpi_model.dart';
import 'package:repsys/ui/core/themes/colors.dart';

/// Card de KPI para o dashboard
class KpiCard extends StatelessWidget {
  final DashboardKpiModel kpi;

  const KpiCard({
    super.key,
    required this.kpi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kpi.titulo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.secondaryText,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      kpi.valor,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: kpi.cor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (kpi.descricao != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        kpi.descricao!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.secondaryText,
                              fontSize: 12,
                            ),
                      ),
                    ],
                    if (kpi.tendencia != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 16,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            kpi.tendencia!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.success,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (kpi.icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kpi.cor.withValues(alpha: 0.05),
                   
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    kpi.icon,
                    color: kpi.cor,
                    size: 24,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
