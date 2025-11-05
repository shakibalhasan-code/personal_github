import 'package:personal_github/domain/models/github_user.dart';
import 'package:personal_github/domain/repositories/github_user_repository.dart';

class SearchGitHubUserUseCase {
  final GitHubUserRepository _repository;

  SearchGitHubUserUseCase({required GitHubUserRepository repository})
    : _repository = repository;

  /// Search for GitHub users by query
  /// Returns a list of [GitHubUser] entities
  Future<List<GitHubUser>> call({
    required String query,
    int page = 1,
    int perPage = 10,
  }) async {
    if (query.trim().isEmpty) {
      throw ArgumentError('Query cannot be empty');
    }

    return await _repository.searchUsers(
      query: query,
      page: page,
      perPage: perPage,
    );
  }
}
