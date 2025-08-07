import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.system,
  );

  static void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = themeMode.value == ThemeMode.dark;

    themeMode.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    prefs.setBool('isDarkMode', !isDarkMode);
  }

  static Future<void> setInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode');
    if (isDark != null) {
      themeMode.value = (isDark) ? ThemeMode.dark : ThemeMode.light;
    }
  }
}
