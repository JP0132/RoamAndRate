import 'package:flutter/material.dart';

class CustomColours extends ThemeExtension<CustomColours> {
  final Color background;
  final Color surface;
  final Color secondarySurface;
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color primaryText;
  final Color secondaryText;
  final Color icon;
  final Color success;
  final Color error;
  final Map<String, Color> categoryColours;

  const CustomColours({
    required this.background,
    required this.surface,
    required this.secondarySurface,
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.primaryText,
    required this.secondaryText,
    required this.icon,
    required this.success,
    required this.error,
    required this.categoryColours,
  });

  static const darkGreyGreen = CustomColours(
    background: Color(0xFF343B46),
    surface: Color(0xFF606888),
    secondarySurface: Color(0xFF484e65),
    primary: Color(0xFFc5ee7e),
    primaryVariant: Color(0xFFeafda7),
    secondary: Color(0xFF71f7b0),
    primaryText: Color(0xFFFFFFFF),
    secondaryText: Color(0xFFa9a9a9),
    icon: Color(0xFFc5ee7e),
    success: Color.fromRGBO(240, 97, 109, 1),
    error: Color.fromRGBO(39, 173, 117, 1),
    categoryColours: {
      "food": Color.fromARGB(255, 227, 42, 42),
      "tourism": Color.fromARGB(255, 248, 52, 238),
      "transport": Color.fromARGB(255, 248, 215, 66),
      "stay": Color.fromARGB(255, 7, 146, 21),
      "shopping": Color.fromARGB(255, 36, 57, 247),
      "nature": Color.fromARGB(255, 41, 247, 175),
      "health": Color.fromARGB(255, 159, 244, 90),
      "other": Color.fromARGB(255, 123, 124, 123),
    },
  );

  static const coffee = CustomColours(
    background: Color(0xFF2B2118),
    surface: Color(0xFF3A2C22),
    secondarySurface: Color(0xFF4A382C),
    primary: Color(0xFFC08B5C),
    primaryVariant: Color(0xFFA56E45),
    secondary: Color(0xFFD7B899),
    primaryText: Color(0xFFF5E9DC),
    secondaryText: Color(0xFFCCB7A1),
    icon: Color(0xFFC08B5C),
    success: Color(0xFF6FA36F),
    error: Color(0xFFB85C4B),
    categoryColours: {
      "food": Color.fromARGB(255, 227, 42, 42),
      "tourism": Color.fromARGB(255, 248, 52, 238),
      "transport": Color.fromARGB(255, 248, 215, 66),
      "stay": Color.fromARGB(255, 7, 146, 21),
      "shopping": Color.fromARGB(255, 36, 57, 247),
      "nature": Color.fromARGB(255, 41, 247, 175),
      "health": Color.fromARGB(255, 159, 244, 90),
      "other": Color.fromARGB(255, 123, 124, 123),
    },
  );

  static const ocean = CustomColours(
    background: Color(0xFF0B1F2A),
    surface: Color(0xFF123040),
    secondarySurface: Color(0xFF1A455A),
    primary: Color(0xFF3FA7D6),
    primaryVariant: Color(0xFF2D7FA3),
    secondary: Color(0xFF7FD1C8),
    primaryText: Color(0xFFEAF7FF),
    secondaryText: Color(0xFFB8D4E3),
    icon: Color(0xFFFFFFFF),
    success: Color(0xFF4CAF88),
    error: Color(0xFFE06C75),
    categoryColours: {
      "food": Color.fromARGB(255, 227, 42, 42),
      "tourism": Color.fromARGB(255, 248, 52, 238),
      "transport": Color.fromARGB(255, 248, 215, 66),
      "stay": Color.fromARGB(255, 7, 146, 21),
      "shopping": Color.fromARGB(255, 36, 57, 247),
      "nature": Color.fromARGB(255, 41, 247, 175),
      "health": Color.fromARGB(255, 159, 244, 90),
      "other": Color.fromARGB(255, 123, 124, 123),
    },
  );

  static const travel = CustomColours(
    background: Color(0xFFF4F7F9),
    surface: Color(0xFFFFFFFF),
    secondarySurface: Color(0xFFE3EDF2),
    primary: Color(0xFF2E86AB),
    primaryVariant: Color(0xFF1F5F7A),
    secondary: Color(0xFFFFC857),
    primaryText: Color(0xFF1C2A33),
    secondaryText: Color(0xFF60717D),
    icon: Color(0xFFFFFFFF),
    success: Color(0xFF3FA37C),
    error: Color(0xFFD95D5D),
    categoryColours: {
      "food": Color.fromARGB(255, 227, 42, 42),
      "tourism": Color.fromARGB(255, 248, 52, 238),
      "transport": Color.fromARGB(255, 248, 215, 66),
      "stay": Color.fromARGB(255, 7, 146, 21),
      "shopping": Color.fromARGB(255, 36, 57, 247),
      "nature": Color.fromARGB(255, 41, 247, 175),
      "health": Color.fromARGB(255, 159, 244, 90),
      "other": Color.fromARGB(255, 123, 124, 123),
    },
  );

  @override
  ThemeExtension<CustomColours> copyWith({
    Color? background,
    Color? surface,
    Color? secondarySurface,
    Color? primary,
    Color? primaryVariant,
    Color? secondary,
    Color? primaryText,
    Color? secondaryText,
    Color? icon,
    Color? success,
    Color? error,
    Map<String, Color>? categorieColours,
  }) {
    return CustomColours(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      secondarySurface: secondarySurface ?? this.secondarySurface,
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      secondary: secondary ?? this.secondary,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      icon: icon ?? this.icon,
      success: success ?? this.success,
      error: error ?? this.error,
      categoryColours: categorieColours ?? this.categoryColours,
    );
  }

  @override
  ThemeExtension<CustomColours> lerp(
    covariant ThemeExtension<CustomColours>? other,
    double t,
  ) {
    if (other is! CustomColours) return this;
    return CustomColours(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      secondarySurface: Color.lerp(
        secondarySurface,
        other.secondarySurface,
        t,
      )!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      categoryColours: {
        "food": Color.lerp(
          categoryColours["food"],
          other.categoryColours["food"],
          t,
        )!,
        "tourism": Color.lerp(
          categoryColours["tourism"],
          other.categoryColours["tourism"],
          t,
        )!,
        "transport": Color.lerp(
          categoryColours["transport"],
          other.categoryColours["transport"],
          t,
        )!,
        "stay": Color.lerp(
          categoryColours["stay"],
          other.categoryColours["stay"],
          t,
        )!,
        "shopping": Color.lerp(
          categoryColours["shopping"],
          other.categoryColours["shopping"],
          t,
        )!,
        "nature": Color.lerp(
          categoryColours["nature"],
          other.categoryColours["nature"],
          t,
        )!,
        "health": Color.lerp(
          categoryColours["health"],
          other.categoryColours["health"],
          t,
        )!,
        "other": Color.lerp(
          categoryColours["other"],
          other.categoryColours["other"],
          t,
        )!,
      },
    );
  }
}
