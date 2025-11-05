import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_github/presentation/controllers/home_controller.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Enter GitHub username',
          prefixIcon: Icon(Icons.search),
          suffixIcon: GetBuilder<HomeController>(
            builder: (_) => controller.searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      controller.clearSearch();
                    },
                  )
                : SizedBox.shrink(),
          ),
        ),
        onChanged: (_) {
          // Trigger UI update for clear button
          controller.update();
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            controller.searchGitHubUser(value);
          }
        },
      ),
    );
  }
}
