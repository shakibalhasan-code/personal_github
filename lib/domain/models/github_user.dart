import 'package:equatable/equatable.dart';

class GitHubUser extends Equatable {
  final String username;
  final String avatarUrl;
  final String name;
  final String bio;
  final int followers;
  final int following;
  final int publicRepos;
  final String location;
  final String company;
  final String blog;

  const GitHubUser({
    required this.username,
    required this.avatarUrl,
    required this.name,
    required this.bio,
    required this.followers,
    required this.following,
    required this.publicRepos,
    required this.location,
    required this.company,
    required this.blog,
  });

  @override
  List<Object?> get props => [
    username,
    avatarUrl,
    name,
    bio,
    followers,
    following,
    publicRepos,
    location,
    company,
    blog,
  ];
}
