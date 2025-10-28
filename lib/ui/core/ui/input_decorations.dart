import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:repsys/ui/core/themes/colors.dart';
import 'package:repsys/ui/core/themes/dimens.dart';

class AppInputDecorations {
  static InputDecoration normal({
    required String label,
    IconData? icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: label,
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.primaryText, fontSize: 14),
      hintStyle: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
      suffixIcon: suffix ?? (icon != null ? Icon(icon) : null),
      suffixIconColor: AppColors.grey3,
      errorStyle: const TextStyle(color: AppColors.error),
      border: OutlineInputBorder(borderRadius: Dimens.borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.error),
      ),
    );
  }

    static InputDecoration dropdownNoLabel({
    IconData? icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelStyle: const TextStyle(color: AppColors.primaryText, fontSize: 14),
      hintStyle: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
      isDense: true,
      errorStyle: const TextStyle(color: AppColors.error),
      border: OutlineInputBorder(borderRadius: Dimens.borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.error),
      ),
    );
  }

  static InputDecoration password({
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return InputDecoration(
      hintText: label,
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.primaryText, fontSize: 14),
      hintStyle: const TextStyle(color: AppColors.secondaryText, fontSize: 14),

      suffixIcon: InkWell(
        onTap: onToggleVisibility,
        child: Icon(
          isVisible ? Icons.visibility_off : Icons.visibility,
        ),
      ),
      errorStyle: const TextStyle(color: AppColors.error),
      border: OutlineInputBorder(borderRadius: Dimens.borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.borderColor),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.error),
      ),
    );
  }

  
}

class DiaMesInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'\D'), ''); // só dígitos

    if (text.length > 4) {
      text = text.substring(0, 4); // limita em 4 dígitos
    }

    String newText = '';
    if (text.length >= 2) {
      newText = '${text.substring(0, 2)}/${text.substring(2)}';
    } else {
      newText = text;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

