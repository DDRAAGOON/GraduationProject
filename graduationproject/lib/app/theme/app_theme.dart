// Light/dark [ThemeData], color tokens, and component themes.

import 'package:flutter/material.dart';

final class AppTheme {
  static const _darkBg = Color(0xFF001E3A);
  static const _darkSurface = Color(0xFF0A2A45);
  static const _darkPrimary = Color(0xFF4E86C6);
  static const _darkText = Color(0xFFEAF2F8);
  static const _darkMuted = Color(0xFF9AB4C8);

  static const _lightBg = Color(0xFFF9FBFE);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightPrimary = Color(0xFF094174);
  static const _lightText = Color(0xFF111827);
  static const _lightMuted = Color(0xFF6B7280);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _lightPrimary,
        brightness: Brightness.light,
        surface: _lightSurface,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: _lightBg,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightBg.withValues(alpha: 0.98),
        elevation: 0,
        foregroundColor: _lightText,
        centerTitle: true,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: _lightText,
        displayColor: _lightText,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        hintStyle: const TextStyle(color: _lightMuted),
        labelStyle: const TextStyle(color: _lightMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _lightBg.withValues(alpha: 0.96),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? _lightPrimary
                : _lightMuted,
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _darkPrimary,
        brightness: Brightness.dark,
        surface: _darkSurface,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: _darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: _darkText,
        centerTitle: true,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: _darkText,
        displayColor: _darkText,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        hintStyle: const TextStyle(color: _darkMuted),
        labelStyle: const TextStyle(color: _darkMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkSurface,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? _darkPrimary
                : _darkMuted,
          ),
        ),
      ),
    );
  }
}
