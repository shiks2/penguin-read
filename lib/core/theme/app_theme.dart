import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const FlexScheme _scheme = FlexScheme.blueWhale; // "Penguin" feel (Ice Blue/Dark Grey)

  static ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: _scheme,
      useMaterial3: true,
      swapColors: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarStyle: FlexAppBarStyle.primary,
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        bottomNavigationBarElevation: 0,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorUnfocusedHasBorder: true,
      ),
    );
  }

  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      scheme: _scheme,
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarStyle: FlexAppBarStyle.background,
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        bottomNavigationBarElevation: 0,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorUnfocusedHasBorder: true,
      ),
    );
  }
}
