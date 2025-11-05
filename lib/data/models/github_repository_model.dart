import 'package:json_annotation/json_annotation.dart';
import 'package:personal_github/domain/models/github_repository.dart';

class GitHubRepositoryModel {
  final String name;
  final String? description;
  @JsonKey(name: 'html_url')
  final String url;
  final String? language;
  @JsonKey(name: 'stargazers_count')
  final int stars;
  @JsonKey(name: 'forks_count')
  final int forks;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'pushed_at')
  final String? pushedAt;

  GitHubRepositoryModel({
    required this.name,
    this.description,
    required this.url,
    this.language,
    required this.stars,
    required this.forks,
    required this.createdAt,
    required this.updatedAt,
    this.pushedAt,
  });

  /// Convert JSON to GitHubRepositoryModel
  factory GitHubRepositoryModel.fromJson(Map<String, dynamic> json) {
    return GitHubRepositoryModel(
      name: json['name'] as String,
      description: json['description'] as String?,
      url: json['html_url'] as String,
      language: json['language'] as String?,
      stars: (json['stargazers_count'] ?? 0) as int,
      forks: (json['forks_count'] ?? 0) as int,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      pushedAt: json['pushed_at'] as String?,
    );
  }

  /// Convert GitHubRepositoryModel to GitHubRepository entity
  GitHubRepository toEntity() {
    return GitHubRepository(
      name: name,
      description: description ?? 'No description',
      url: url,
      language: language ?? 'Unknown',
      stars: stars,
      forks: forks,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
      pushedAt: pushedAt != null ? DateTime.tryParse(pushedAt!) : null,
    );
  }
}
