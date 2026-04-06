import 'package:flutter/material.dart';

class ThemeController {
  ThemeController._();

  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
    ThemeMode.dark,
  );

  void setDark() {
    themeMode.value = ThemeMode.dark;
  }

  void setLight() {
    themeMode.value = ThemeMode.light;
  }
}
