import 'package:get/get.dart';
import 'package:personal_github/presentation/bindings/home_binding.dart';
import 'package:personal_github/presentation/screens/home_screen.dart';

class AppRoutes {
  static const String home = '/home';

  static final List<GetPage> routes = [
    GetPage(name: home, page: () => HomeScreen(), binding: HomeBinding()),
  ];

  static String initialRoute = home;
}
