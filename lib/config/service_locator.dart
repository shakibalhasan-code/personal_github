import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_github/core/services/theme_preferences_service.dart';
import 'package:personal_github/presentation/controllers/theme_controller.dart';

final getIt = GetIt.instance;

/// Service Locator - Dependency Injection setup

class ServiceLocator {
  static Future<void> setup() async {
    // Initialize SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();

    // Register SharedPreferences instance
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    // Register ThemePreferencesService
    getIt.registerSingleton<ThemePreferencesService>(
      ThemePreferencesService(sharedPreferences),
    );

    // Register ThemeController with dependencies
    getIt.registerSingleton<ThemeController>(
      ThemeController(
        themePreferencesService: getIt<ThemePreferencesService>(),
      ),
    );
  }
}
