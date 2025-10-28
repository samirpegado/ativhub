import 'package:flutter/material.dart';
import 'package:repsys/ui/core/themes/colors.dart';

class ProgressBarSignup extends StatefulWidget {
  const ProgressBarSignup({super.key, required this.currentStep});
  final int currentStep;

  @override
  State<ProgressBarSignup> createState() => _ProgressBarSignupState();
}

class _ProgressBarSignupState extends State<ProgressBarSignup> {
  int get stepIndex => widget.currentStep;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: Center(
          child: Icon(Icons.person_rounded, color: Colors.white),
        ),
      ),
      Expanded(
        child: Container(
            height: 4,
            color: stepIndex >= 1 ? AppColors.primary : AppColors.borderColor),
      ),
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: stepIndex >= 1 ? AppColors.primary : AppColors.borderColor),
        child: Center(
          child: Icon(Icons.store_rounded, color: Colors.white),
        ),
      ),
      Expanded(
        child: Container(
            height: 4,
            color: stepIndex >= 2 ? AppColors.primary : AppColors.borderColor),
      ),
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: stepIndex >= 2 ? AppColors.primary : AppColors.borderColor),
        child: Center(
          child: Icon(Icons.location_on_rounded, color: Colors.white),
        ),
      ),
      Expanded(
        child: Container(
            height: 4,
            color: stepIndex >= 3 ? AppColors.primary : AppColors.borderColor),
      ),
      Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  stepIndex >= 3 ? AppColors.success : AppColors.borderColor),
          child: Center(
            child: Icon(Icons.rocket_launch_rounded, color: Colors.white),
          )),
    ]);
  }
}
