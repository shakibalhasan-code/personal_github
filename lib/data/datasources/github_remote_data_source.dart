import 'package:personal_github/core/services/github_api_service.dart';
import 'package:personal_github/data/models/github_user_model.dart';

abstract class GitHubRemoteDataSource {
  /// Search for GitHub users by username
  Future<List<GitHubUserModel>> searchUsers({
    required String query,
    int page = 1,
    int perPage = 10,
  });

  /// Get user details by username
  Future<GitHubUserModel> getUserDetails(String username);
}

class GitHubRemoteDataSourceImpl implements GitHubRemoteDataSource {
  final GitHubApiService _apiService;

  GitHubRemoteDataSourceImpl({required GitHubApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<GitHubUserModel>> searchUsers({
    required String query,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _apiService.searchUsers(
        query: query,
        page: page,
        perPage: perPage,
      );

      // Parse the 'items' array from the response
      if (response.containsKey('items') && response['items'] is List) {
        final items = response['items'] as List;
        return items
            .map(
              (item) => GitHubUserModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }

      throw Exception('Invalid API response: missing or invalid items field');
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  @override
  Future<GitHubUserModel> getUserDetails(String username) async {
    try {
      final response = await _apiService.getUserDetails(username);
      return GitHubUserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }
}
