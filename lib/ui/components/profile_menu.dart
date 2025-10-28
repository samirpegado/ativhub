import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repsys/data/repositories/auth_repository.dart';
import 'package:repsys/ui/core/themes/colors.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({super.key});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: AppColors.secondaryText),
                SizedBox(width: 8),
                Text('Perfil',
                    style: TextStyle(
                        color: AppColors.secondaryText, fontSize: 16)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.settings, color: AppColors.secondaryText),
                SizedBox(width: 8),
                Text('Configurações',
                    style: TextStyle(
                        color: AppColors.secondaryText, fontSize: 16)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info, color: AppColors.secondaryText),
                SizedBox(width: 8),
                Text('Sobre',
                    style: TextStyle(
                        color: AppColors.secondaryText, fontSize: 16)),
              ],
            ),
            SizedBox(height: 8),
            Divider(color: AppColors.borderColor),
            SizedBox(height: 8),
            InkWell(
              onTap: () async {
                await context.read<AuthRepository>().logout();
              },
              child: Row(
                children: [
                  Icon(Icons.logout, color: AppColors.secondaryText),
                  SizedBox(width: 8),
                  Text('Sair',
                      style: TextStyle(
                          color: AppColors.secondaryText, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
