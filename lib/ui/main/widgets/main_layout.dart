import 'package:flutter/material.dart';
import 'package:repsys/ui/components/base_layout.dart';
import 'package:repsys/ui/main/view_models/main_layout_viewmodel.dart';

/// Página inicial do dashboard
class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.viewModel});
  final MainLayoutViewmodel viewModel;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              'Bem-vindo ao sistema',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
