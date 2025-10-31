import 'package:flutter/material.dart';
import 'package:repsys/ui/components/base_layout.dart';
import 'package:repsys/ui/dashboard/widgets/dashboard.dart';
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
      child: const Dashboard(),
    );
  }
}
