import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_github/presentation/controllers/home_controller.dart';
import 'package:personal_github/presentation/controllers/theme_controller.dart';
import 'package:personal_github/presentation/widgets/search_bar.dart'
    as local_widgets;
import 'package:personal_github/presentation/widgets/search_results_view.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Search'),
        actions: [
          GetBuilder<ThemeController>(
            builder: (themeController) => IconButton(
              icon: Icon(
                themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                themeController.toggleTheme();
              },
              tooltip: 'Toggle theme',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          local_widgets.SearchBar(),
          Expanded(child: SearchResultsView()),
        ],
      ),
    );
  }
}
