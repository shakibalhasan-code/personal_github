import 'package:personal_github/domain/models/github_repository.dart';
import 'package:personal_github/domain/repositories/github_user_repository.dart';

class GetGitHubUserRepositoriesUseCase {
  final GitHubUserRepository _repository;

  GetGitHubUserRepositoriesUseCase({required GitHubUserRepository repository})
    : _repository = repository;

  /// Get repositories for a GitHub user by username
  /// Returns a [List<GitHubRepository>] entity with repository information
  Future<List<GitHubRepository>> call(
    String username, {
    int page = 1,
    int perPage = 10,
  }) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }

    return await _repository.getUserRepositories(
      username,
      page: page,
      perPage: perPage,
    );
  }
}
