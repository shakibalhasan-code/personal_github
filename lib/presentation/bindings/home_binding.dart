import 'package:get/get.dart';
import 'package:personal_github/config/service_locator.dart';
import 'package:personal_github/presentation/controllers/home_controller.dart';
import 'package:personal_github/presentation/controllers/theme_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    // Use ThemeController from service locator (already registered as singleton)
    Get.put(getIt<ThemeController>());
  }
}
