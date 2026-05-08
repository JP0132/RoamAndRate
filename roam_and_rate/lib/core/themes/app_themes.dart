

import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/app_theme_mode.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';

class AppThemes {
  AppThemes._();

   static ThemeData of(AppThemeMode mode) => switch (mode) {
    AppThemeMode.coffee => _coffee,
    AppThemeMode.darkGrayGreen   => _darkGrayGreen,
  };

  static final _darkGrayGreen = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF343B46),
      primary: Color(0xFFc5ee7e),
      onPrimary: Color(0xFF1a1a1a),
      onSurface: Color(0xFFFFFFFF),
      error: Color.fromRGBO(240, 97, 109, 1),
    ),
    extensions: const [CustomColours.darkGreyGreen],
  );

    static final _coffee = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF2C1A0E),
      primary: Color(0xFFD4956A),
      onPrimary: Color(0xFF1a0e06),
      onSurface: Color(0xFFF5E6D3),
      error: Color(0xFFCF6679),
    ),
    extensions: const [CustomColours.coffee],
  );

}