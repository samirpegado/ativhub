import 'package:flutter/material.dart';
import 'package:repsys/ui/components/sidebar.dart';
import 'package:repsys/ui/components/topbar.dart';
import 'package:repsys/utils/constants.dart';

/// Layout base reutilizável com Sidebar e Topbar
/// Cada página usa esse layout para manter consistência
class BaseLayout extends StatelessWidget {
  final Widget child;
  final String? title;

  const BaseLayout({
    super.key,
    required this.child,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= desktopWidth;

    return Scaffold(
      drawer: isDesktop ? null : const Drawer(child: Sidebar()),
      body: Row(
        children: [
          if (isDesktop) const Sidebar(),
          Expanded(
            child: Column(
              children: [
                const Topbar(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

