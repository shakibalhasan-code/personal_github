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

      return ListView.builder(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.searchResults.length,
        itemBuilder: (context, index) {
          final user = controller.searchResults[index];
          return _buildUserCard(context, user);
        },
      );
    });
  }

  Widget _buildUserCard(BuildContext context, GitHubUser user) {
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
          ],
        ),
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
