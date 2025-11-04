import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_github/config/routes.dart';
import 'package:personal_github/config/service_locator.dart';
import 'package:personal_github/config/theme.dart';
import 'package:personal_github/presentation/controllers/theme_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize theme from saved preferences on first build
    final themeController = getIt<ThemeController>();
    themeController.initializeTheme();

    return GetBuilder<ThemeController>(
      init: themeController,
      builder: (controller) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GitHub Search',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: controller.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          getPages: AppRoutes.routes,
          initialRoute: AppRoutes.initialRoute,
        );
      },
    );
  }
}
