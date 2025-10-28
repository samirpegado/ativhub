import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repsys/app_state/app_state.dart';
import 'package:repsys/ui/components/profile_menu.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/utils/constants.dart';
import 'package:repsys/utils/functions.dart';

class Topbar extends StatefulWidget {
  const Topbar({super.key});

  @override
  State<Topbar> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  OverlayEntry? _overlayEntry;

  void _showProfileMenu(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Fecha ao clicar fora
          GestureDetector(
            onTap: _removeOverlay,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Menu flutuante no topo direito com padding
          Positioned(
            top: 70,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: const ProfileMenu(),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= desktopWidth;
    final appState = context.watch<AppState>();
    return Material(
      elevation: 3,
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: !isDesktop,
                child: Builder(
                  builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ),
              const Text(''),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_rounded,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => _showProfileMenu(context),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Olá,',
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              getFirstAndLastName(appState.usuario?.nome),
                              style: const TextStyle(color: AppColors.secondaryText),
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.secondaryText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
