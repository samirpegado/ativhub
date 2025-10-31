import 'package:flutter/material.dart';
import 'package:repsys/domain/models/dashboard_kpi_model.dart';
import 'package:repsys/domain/models/dashboard_os_recente_model.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/dashboard/widgets/kpi_card.dart';
import 'package:repsys/ui/dashboard/widgets/os_recente_item.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Dados mockados - substituir por dados reais do repositório depois
  final List<DashboardKpiModel> _kpis = [
    DashboardKpiModel(
      id: '1',
      titulo: 'OS Abertas',
      valor: '24',
      descricao: 'Aguardando atribuição',
      cor: const Color(0xFF2563EB),
      icon: Icons.description,
    ),
    DashboardKpiModel(
      id: '2',
      titulo: 'Em Execução',
      valor: '12',
      descricao: 'Técnicos trabalhando',
      tendencia: '+8% vs. semana passada',
      cor: AppColors.success,
      icon: Icons.access_time,
    ),
    DashboardKpiModel(
      id: '3',
      titulo: 'Concluídas',
      valor: '156',
      descricao: 'Este mês',
      cor: AppColors.success,
    ),
    DashboardKpiModel(
      id: '4',
      titulo: 'Atrasadas',
      valor: '3',
      descricao: 'Requerem atenção',
      cor: AppColors.error,
      icon: Icons.warning,
    ),
    DashboardKpiModel(
      id: '5',
      titulo: 'Ativos',
      valor: '342',
      descricao: 'Em monitoramento',
      cor: const Color(0xFFFF9800),
      icon: Icons.category,
    ),
    DashboardKpiModel(
      id: '6',
      titulo: 'Técnicos',
      valor: '18',
      descricao: 'Disponíveis hoje',
      cor: const Color(0xFFFF9800),
      icon: Icons.people,
    ),
    DashboardKpiModel(
      id: '7',
      titulo: 'Taxa de Conclusão',
      valor: '94%',
      tendencia: '+2% vs. mês anterior',
      cor: const Color(0xFF2563EB),
      icon: Icons.trending_up,
    ),
  ];

  final List<DashboardOsRecenteModel> _osRecentes = [
    DashboardOsRecenteModel(
      id: '1',
      numeroOs: 'OS-2024-001',
      descricao: 'Compressor Industrial',
      localCliente: 'Hospital São Lucas',
      tecnicoNome: 'Carlos Silva',
      prioridade: 'Alta',
      status: 'Em Execução',
      corIcone: const Color(0xFF2563EB),
    ),
    DashboardOsRecenteModel(
      id: '2',
      numeroOs: 'OS-2024-002',
      descricao: 'Sistema de Refrigeração',
      localCliente: 'Shopping Center Norte',
      tecnicoNome: 'Maria Santos',
      prioridade: 'Média',
      status: 'Aguardando Peça',
      corIcone: const Color(0xFFFF9800),
    ),
    DashboardOsRecenteModel(
      id: '3',
      numeroOs: 'OS-2024-003',
      descricao: 'Manutenção Preventiva',
      localCliente: 'Indústria ABC',
      tecnicoNome: 'João Oliveira',
      prioridade: 'Baixa',
      status: 'Aberta',
      corIcone: AppColors.secondaryText,
    ),
    DashboardOsRecenteModel(
      id: '4',
      numeroOs: 'OS-2024-004',
      descricao: 'Reparo Elétrico',
      localCliente: 'Escola Municipal',
      tecnicoNome: 'Ana Costa',
      prioridade: 'Alta',
      status: 'Concluída',
      corIcone: AppColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primeira linha de KPIs (4 cards)
          _buildKpiRow(_kpis.take(4).toList()),
          const SizedBox(height: 24),
          // Segunda linha de KPIs (3 cards)
          _buildKpiRow(_kpis.skip(4).take(3).toList()),
          const SizedBox(height: 32),
          // Seção de Ordens de Serviço Recentes
          _buildOsRecentesSection(),
        ],
      ),
    );
  }

  Widget _buildKpiRow(List<DashboardKpiModel> kpis) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determina o número de colunas baseado na largura da tela
        int crossAxisCount;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = kpis.length > 3 ? 4 : 3;
        } else if (constraints.maxWidth > 900) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 2.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: kpis.length,
          itemBuilder: (context, index) {
            return KpiCard(kpi: kpis[index]);
          },
        );
      },
    );
  }

  Widget _buildOsRecentesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho da seção
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ordens de Serviço Recentes',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Últimas OS registradas no sistema',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                              backgroundColor:
                                  WidgetStatePropertyAll(AppColors.primary),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.list, color: AppColors.secondary),
                                const SizedBox(width: 8),
                                Text(
                                  'Ver Todas',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ordens de Serviço Recentes',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Últimas OS registradas no sistema',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Navegar para a página completa de OS
                            // Navigator.pushNamed(context, '/ordens-servico');
                          },
                          style: ButtonStyle(
                            minimumSize: const WidgetStatePropertyAll(Size(0, 50)),
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.primary),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.list, color: AppColors.secondary),
                              const SizedBox(width: 8),
                              Text(
                                'Ver Todas',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
            },
          ),
          const SizedBox(height: 24),
          // Lista de OS recentes
          ..._osRecentes.map((os) => OsRecenteItem(os: os)),
        ],
      ),
    );
  }
}
