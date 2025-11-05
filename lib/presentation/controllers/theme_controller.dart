import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_github/core/services/theme_preferences_service.dart';

class ThemeController extends GetxController {
  final ThemePreferencesService _themePreferencesService;

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeController({required ThemePreferencesService themePreferencesService})
    : _themePreferencesService = themePreferencesService;

  /// Initialize theme from saved preferences
  void initializeTheme() {
    _isDarkMode = _themePreferencesService.getThemeMode();
    // Notify GetBuilder listeners
    update();
  }

  /// Saves the preference to SharedPreferences
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _themePreferencesService.setThemeMode(_isDarkMode);
    Get.changeThemeMode(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
    // Notify GetBuilder listeners
    update();
  }
}
