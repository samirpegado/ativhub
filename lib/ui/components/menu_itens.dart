import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:repsys/routing/routes.dart';
import 'package:repsys/ui/core/themes/colors.dart';

class MenuItens extends StatefulWidget {
  const MenuItens({super.key});

  @override
  State<MenuItens> createState() => _MenuItensState();
}

class _MenuItensState extends State<MenuItens> {
  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();

    final items = <_MenuItem>[
      _MenuItem(title: 'Dashboard',         icon: Icons.space_dashboard,         route: Routes.dashboard),
      _MenuItem(title: 'Clientes',          icon: Icons.groups_2,                route: Routes.clientes),
      _MenuItem(title: 'Ativos',            icon: Icons.precision_manufacturing, route: Routes.ativos),
      _MenuItem(title: 'Planos',            icon: Icons.calendar_month,          route: Routes.planos),
      _MenuItem(title: 'Ordens de Serviço', icon: Icons.assignment_turned_in,   route: Routes.ordensServico),
      _MenuItem(title: 'Checklists',        icon: Icons.checklist,               route: Routes.checklists),
      _MenuItem(title: 'Faturamento',       icon: Icons.request_quote,           route: Routes.faturamento),
      _MenuItem(title: 'Fornecedores',      icon: Icons.local_shipping,          route: Routes.fornecedores),
      _MenuItem(title: 'Relatórios',        icon: Icons.bar_chart,               route: Routes.relatorios),
    ];

    return Column(
      children: [
        for (final item in items) ...[
          _buildMenuButton(
            context: context,
            title: item.title,
            icon: item.icon,
            isSelected: currentLocation.startsWith(item.route),
            onTap: () {
              context.go(item.route);
              if (Scaffold.of(context).isDrawerOpen) {
                Scaffold.of(context).closeDrawer();
              }
            },
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Cores de estado
    final Color textColor = isSelected ? AppColors.secondary : AppColors.secondaryText;
    final Color bgSelected = AppColors.secondary.withValues(alpha: 0.08);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? bgSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.secondary.withValues(alpha: 0.25) : Colors.transparent,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Indicador lateral de seleção
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 4,
              height: 22,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(icon, size: 20, color: textColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final String route;
  const _MenuItem({required this.title, required this.icon, required this.route});
}
