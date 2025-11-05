import 'package:personal_github/data/datasources/github_remote_data_source.dart';
import 'package:personal_github/domain/models/github_user.dart';
import 'package:personal_github/domain/models/github_repository.dart';

abstract class GitHubUserRepository {
  /// Search for GitHub users by username
  Future<List<GitHubUser>> searchUsers({
    required String query,
    int page = 1,
    int perPage = 10,
  });

  /// Get user details by username
  Future<GitHubUser> getUserDetails(String username);

  /// Get user repositories by username
  Future<List<GitHubRepository>> getUserRepositories(
    String username, {
    int page = 1,
    int perPage = 10,
  });
}

class GitHubUserRepositoryImpl implements GitHubUserRepository {
  final GitHubRemoteDataSource _remoteDataSource;

  GitHubUserRepositoryImpl({required GitHubRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<List<GitHubUser>> searchUsers({
    required String query,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final models = await _remoteDataSource.searchUsers(
        query: query,
        page: page,
        perPage: perPage,
      );
      // Convert models to entities
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GitHubUser> getUserDetails(String username) async {
    try {
      final model = await _remoteDataSource.getUserDetails(username);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<GitHubRepository>> getUserRepositories(
    String username, {
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final models = await _remoteDataSource.getUserRepositories(
        username,
        page: page,
        perPage: perPage,
      );
      // Convert models to entities
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }
}
