import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_github/presentation/controllers/home_controller.dart';

class RepositoriesView extends StatelessWidget {
  const RepositoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return GetBuilder<HomeController>(
      builder: (_) {
        // Show nothing if no user is selected
        if (controller.selectedUserUsername.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with username and repositories count
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Repositories',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${controller.selectedUserRepositories.length} repositories found',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Loading state
            if (controller.isLoadingRepos)
              Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              )
            else if (controller.selectedUserRepositories.isEmpty)
              // Empty state
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No repositories found',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            else
              // Repositories list
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.selectedUserRepositories.length,
                itemBuilder: (context, index) {
                  final repo = controller.selectedUserRepositories[index];
                  return RepositoryCard(repo: repo);
                },
              ),
          ],
        );
      },
    );
  }
}

class RepositoryCard extends StatelessWidget {
  final dynamic repo;

  const RepositoryCard({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Repository name
            Text(
              repo.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            // Description
            if (repo.description.isNotEmpty)
              Text(
                repo.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            SizedBox(height: 12),
            // Language, Stars, and Forks row
            Row(
              children: [
                // Language badge
                if (repo.language != 'Unknown')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      repo.language,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                SizedBox(width: 12),
                // Stars
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    SizedBox(width: 4),
                    Text(
                      repo.stars.toString(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                SizedBox(width: 16),
                // Forks
                Row(
                  children: [
                    Icon(Icons.call_split, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      repo.forks.toString(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
