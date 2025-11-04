import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferencesService {
  // Storage key for theme preference
  static const String _themeKey = 'app_theme_mode';
  static const String _darkModeValue = 'dark';
  static const String _lightModeValue = 'light';

  final SharedPreferences _prefs;

  ThemePreferencesService(this._prefs);

  Future<bool> setThemeMode(bool isDarkMode) async {
    final value = isDarkMode ? _darkModeValue : _lightModeValue;
    return await _prefs.setString(_themeKey, value);
  }

  bool getThemeMode() {
    final savedTheme = _prefs.getString(_themeKey);
    return savedTheme == _darkModeValue;
  }

  Future<bool> clearThemeMode() async {
    return await _prefs.remove(_themeKey);
  }

  bool hasThemePreference() {
    return _prefs.containsKey(_themeKey);
  }
}
