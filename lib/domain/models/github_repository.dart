import 'package:equatable/equatable.dart';

class GitHubRepository extends Equatable {
  final String name;
  final String description;
  final String url;
  final String language;
  final int stars;
  final int forks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? pushedAt;

  const GitHubRepository({
    required this.name,
    required this.description,
    required this.url,
    required this.language,
    required this.stars,
    required this.forks,
    required this.createdAt,
    required this.updatedAt,
    this.pushedAt,
  });

  @override
  List<Object?> get props => [name, description, url, language, stars, forks, createdAt, updatedAt, pushedAt];
}
