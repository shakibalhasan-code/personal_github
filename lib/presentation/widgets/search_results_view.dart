import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_github/domain/models/github_user.dart';
import 'package:personal_github/presentation/controllers/home_controller.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (!controller.hasSearched) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'Search for GitHub users',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
      }

      if (controller.isLoading) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              SizedBox(height: 16),
              Text(
                controller.errorMessage,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.red[400]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      if (controller.searchResults.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'No user found',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.searchResults.length,
              itemBuilder: (context, index) {
                final user = controller.searchResults[index];
                return _buildUserCard(context, user, controller);
              },
            ),
            // Show repositories if a user is selected
            if (controller.selectedUserUsername.isNotEmpty)
              _buildRepositoriesSection(context, controller),
          ],
        ),
      );
    });
  }

  Widget _buildUserCard(
    BuildContext context,
    GitHubUser user,
    HomeController controller,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User header
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.avatarUrl),
                  onBackgroundImageError: (exception, stackTrace) {},
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '@${user.username}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Bio
            if (user.bio.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.bio,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                ],
              ),

            // Stats grid
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                children: [
                  _buildStatItem(
                    context,
                    user.followers.toString(),
                    'Followers',
                  ),
                  _buildStatItem(
                    context,
                    user.following.toString(),
                    'Following',
                  ),
                  _buildStatItem(context, user.publicRepos.toString(), 'Repos'),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Info section
            if (user.location.isNotEmpty || user.company.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user.location.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              user.location,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (user.company.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.business, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user.company,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            SizedBox(height: 16),

            // View repositories button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.fetchUserRepositories(user.username);
                },
                icon: Icon(Icons.folder_open),
                label: Text('View Repositories'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepositoriesSection(
    BuildContext context,
    HomeController controller,
  ) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Repositories - ${controller.selectedUserUsername}',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '${controller.selectedUserRepositories.length} repositories',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          SizedBox(height: 16),

          // Loading
          if (controller.isLoadingRepos)
            Center(child: CircularProgressIndicator())
          // Empty
          else if (controller.selectedUserRepositories.isEmpty)
            Text(
              'No repositories found',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          // List
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.selectedUserRepositories.length,
              itemBuilder: (context, index) {
                final repo = controller.selectedUserRepositories[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Repo name
                        Text(
                          repo.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        // Description
                        if (repo.description.isNotEmpty)
                          Text(
                            repo.description,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        SizedBox(height: 10),
                        // Stats
                        Row(
                          children: [
                            if (repo.language != 'Unknown')
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  repo.language,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            SizedBox(width: 12),
                            Row(
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.amber),
                                SizedBox(width: 4),
                                Text(
                                  repo.stars.toString(),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                            SizedBox(width: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.call_split,
                                  size: 14,
                                  color: Colors.grey,
                                ),
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
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey[300]!, width: 1),
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
