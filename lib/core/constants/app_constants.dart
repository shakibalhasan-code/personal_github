class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // App Information
  static const String appName = 'Personal GitHub';
  static const String appVersion = '1.0.0';

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);

  // Routes
  static const String homeRoute = '/home';
  static const String splashRoute = '/';
  static const String detailRoute = '/detail';
}
