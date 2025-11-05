import 'package:personal_github/domain/models/github_user.dart';
import 'package:personal_github/domain/repositories/github_user_repository.dart';

class GetGitHubUserDetailsUseCase {
  final GitHubUserRepository _repository;

  GetGitHubUserDetailsUseCase({required GitHubUserRepository repository})
    : _repository = repository;

  /// Get full details for a GitHub user by username
  /// Returns a [GitHubUser] entity with complete information
  Future<GitHubUser> call(String username) async {
    if (username.trim().isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }

    return await _repository.getUserDetails(username);
  }
}
