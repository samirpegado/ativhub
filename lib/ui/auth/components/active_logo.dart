import 'package:flutter/material.dart';

import 'package:repsys/ui/core/themes/colors.dart';

class ActiveLogo extends StatelessWidget {
  const ActiveLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network('https://api.ativhub.sognolabs.org/storage/v1/object/public/assets//ah_logo_60.png',  fit: BoxFit.contain,),
            SizedBox(width: 10),
            Text(
            'AtivHub',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.surfaceDark),
          ),
        ],
      ),
    );
  }
}
