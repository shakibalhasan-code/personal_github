import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_github/domain/models/github_user.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();
  final _searchResults = <GitHubUser>[].obs;
  final _isLoading = false.obs;
  final _hasSearched = false.obs;

  List<GitHubUser> get searchResults => _searchResults;
  bool get isLoading => _isLoading.value;
  bool get hasSearched => _hasSearched.value;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void searchGitHubUser(String username) {
    if (username.isEmpty) {
      _hasSearched.value = false;
      _searchResults.clear();
      return;
    }

    _isLoading.value = true;
    _hasSearched.value = true;

    // Simulate API call delay
    Future.delayed(Duration(milliseconds: 800), () {
      // Mock data - replace with actual API call
      final mockUser = GitHubUser(
        username: username,
        avatarUrl: 'https://api.github.com/users/$username/avatar.jpg',
        name: 'GitHub User',
        bio: 'Passionate developer',
        followers: 150,
        following: 50,
        publicRepos: 25,
        location: 'San Francisco, CA',
        company: 'Tech Company',
        blog: 'https://example.com',
      );

      _searchResults.clear();
      _searchResults.add(mockUser);
      _isLoading.value = false;
    });
  }

  void clearSearch() {
    searchController.clear();
    _searchResults.clear();
    _hasSearched.value = false;
  }
}
