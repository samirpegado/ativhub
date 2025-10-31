import 'package:flutter/material.dart';
import 'package:repsys/domain/models/dashboard_os_recente_model.dart';
import 'package:repsys/ui/core/themes/colors.dart';

/// Item de Ordem de Serviço recente para o dashboard
class OsRecenteItem extends StatelessWidget {
  final DashboardOsRecenteModel os;

  const OsRecenteItem({
    super.key,
    required this.os,
  });

  Color _getCorPrioridade(String prioridade) {
    switch (prioridade.toLowerCase()) {
      case 'alta':
        return AppColors.error;
      case 'média':
        return AppColors.info;
      case 'baixa':
        return AppColors.secondaryText;
      default:
        return AppColors.secondaryText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Ícone colorido
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: os.corIcone,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.build,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        // Informações principais
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                os.numeroOs,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                os.descricao,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 2),
              Text(
                os.localCliente,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Técnico e Tags
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (os.tecnicoNome != null) ...[
              Text(
                'Técnico',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                os.tecnicoNome!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tag de Prioridade
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCorPrioridade(os.prioridade).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    os.prioridade,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _getCorPrioridade(os.prioridade),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                // Tag de Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryText.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    os.status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Ícone colorido
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: os.corIcone,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.build,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Informações principais
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    os.numeroOs,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    os.descricao,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    os.localCliente,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Técnico e Tags (empilhados em mobile)
        if (os.tecnicoNome != null) ...[
          Row(
            children: [
              Text(
                'Técnico: ',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
              ),
              Text(
                os.tecnicoNome!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Tag de Prioridade
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _getCorPrioridade(os.prioridade).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                os.prioridade,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _getCorPrioridade(os.prioridade),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            // Tag de Status
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondaryText.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                os.status,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
