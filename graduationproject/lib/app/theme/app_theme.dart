// Light/dark [ThemeData], color tokens, and component themes.

import 'package:flutter/material.dart';

final class AppTheme {
  static const _darkBg = Color(0xFF0B1020);
  static const _darkSurface = Color(0xFF161D33);
  static const _darkPrimary = Color(0xFF4A6ED1);
  static const _darkAccent = Color(0xFFFF7A2A);
  static const _darkText = Color(0xFFEAF0FF);
  static const _darkMuted = Color(0xFFB59A90);

  static const _lightBg = Color(0xFFF7F9FC);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightPrimary = Color(0xFF4A6ED1);
  static const _lightAccent = Color(0xFFFF7A2A);
  static const _lightText = Color(0xFF0B1020);
  static const _lightMuted = Color(0xFFB59A90);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _lightPrimary,
        brightness: Brightness.light,
        surface: _lightSurface,
      ).copyWith(primary: _lightPrimary, secondary: _lightAccent),
    );

    return base.copyWith(
      scaffoldBackgroundColor: _lightBg,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightBg.withValues(alpha: 0.98),
        elevation: 0,
        foregroundColor: _lightText,
        centerTitle: false,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: _lightText,
        displayColor: _lightText,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black.withValues(alpha: 0.05),
        hintStyle: const TextStyle(color: _lightMuted),
        labelStyle: const TextStyle(color: _lightMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightPrimary, width: 1.3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
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
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFD7DDED)),
          foregroundColor: _lightText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
      ).copyWith(primary: _darkPrimary, secondary: _darkAccent),
    );

    return base.copyWith(
      scaffoldBackgroundColor: _darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: _darkText,
        centerTitle: false,
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _darkPrimary, width: 1.3),
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
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
