import 'package:flutter/material.dart';

/// Paleta AtivHub — mantendo o amarelo #ffb304
abstract class AppColors {
  // BRAND
  static const primary       = Color(0xFFFFB304); // amarelo industrial
  static const primaryDark   = Color(0xFFD49500); // hover/ativo
  static const primaryLight  = Color(0xFFFFD96A); // highlight/gradiente

  // Contraste principal (para fundos escuros, menus, headers)
  static const brandDark     = Color(0xFF1F2937); // azul petróleo

  // Compat (mantido para não quebrar): branco como "secondary"
  static const secondary     = Color(0xFFFFFFFF);

  // TEXTOS
  static const primaryText   = Color(0xFF111827); // títulos
  static const secondaryText = Color(0xFF6B7280); // descrições/placeholder

  // NEUTROS / UI
  static const borderColor   = Color(0xFFE5E7EB); // linhas/bordas de cards/inputs
  static const background    = Color(0xFFF9FAFB); // fundo app (dash/forms)
  static const surfaceLight  = Colors.white;
  static const surfaceDark   = Colors.black;

  // FEEDBACK
  static const error         = Color(0xFFE74C3C);
  static const warning       = Color(0xFFA57500);
  static const success       = Color(0xFF249658);
  static const info          = Color(0xFF2563EB);

    static const white         = Colors.white;
  static const black05       = Color.fromRGBO(0, 0, 0, .05);

  // Extras
  static const moneyColor        = Color(0xFF249658);
  static const grey1             = Color(0xFFF2F2F2);
  static const grey2             = Color.fromARGB(255, 197, 197, 197);
  static const grey3             = Color.fromARGB(255, 216, 216, 216);
  static const alternate         = Color(0xFFF6F6F6);
  static const whiteTransparent  = Color.fromARGB(10, 255, 255, 255);
  static const blackTransparent  = Color(0x4D000000);

  // Schemes prontos para ThemeData
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    secondary: brandDark,        // usar como cor de ênfase/contraste
    onSecondary: Colors.white,
    surface: surfaceLight,
    onSurface: primaryText,
    error: error,
    onError: Colors.white,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: Colors.black,     // no dark, texto escuro sobre amarelo claro fica ok
    secondary: brandDark,
    onSecondary: Colors.white,
    surface: surfaceDark,
    onSurface: Colors.white,
    error: error,
    onError: Colors.black,
  );

  /// Gradiente sugerido para botões especiais/hero
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
