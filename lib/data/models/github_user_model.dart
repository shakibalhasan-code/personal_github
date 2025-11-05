import 'package:json_annotation/json_annotation.dart';
import 'package:personal_github/domain/models/github_user.dart';

@JsonSerializable()
class GitHubUserModel {
  final String login;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  final String? name;
  final String? bio;
  final int followers;
  final int following;
  @JsonKey(name: 'public_repos')
  final int publicRepos;
  final String? location;
  final String? company;
  final String? blog;

  GitHubUserModel({
    required this.login,
    required this.avatarUrl,
    this.name,
    this.bio,
    required this.followers,
    required this.following,
    required this.publicRepos,
    this.location,
    this.company,
    this.blog,
  });

  /// Convert JSON to GitHubUserModel
  factory GitHubUserModel.fromJson(Map<String, dynamic> json) {
    return GitHubUserModel(
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      followers: (json['followers'] ?? 0) as int,
      following: (json['following'] ?? 0) as int,
      publicRepos: (json['public_repos'] ?? 0) as int,
      location: json['location'] as String?,
      company: json['company'] as String?,
      blog: json['blog'] as String?,
    );
  }

  /// Convert GitHubUserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'avatar_url': avatarUrl,
      'name': name,
      'bio': bio,
      'followers': followers,
      'following': following,
      'public_repos': publicRepos,
      'location': location,
      'company': company,
      'blog': blog,
    };
  }

  /// Convert GitHubUserModel to GitHubUser entity
  GitHubUser toEntity() {
    return GitHubUser(
      username: login,
      avatarUrl: avatarUrl,
      name: name ?? 'N/A',
      bio: bio ?? 'No bio available',
      followers: followers,
      following: following,
      publicRepos: publicRepos,
      location: location ?? 'Not specified',
      company: company ?? 'Not specified',
      blog: blog ?? 'Not specified',
    );
  }
}
