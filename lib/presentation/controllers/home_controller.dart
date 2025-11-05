import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_github/config/service_locator.dart';
import 'package:personal_github/domain/models/github_user.dart';
import 'package:personal_github/domain/models/github_repository.dart';
import 'package:personal_github/domain/usecases/search_github_user_usecase.dart';
import 'package:personal_github/domain/usecases/get_github_user_details_usecase.dart';
import 'package:personal_github/domain/usecases/get_github_user_repositories_usecase.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();
  final _searchResults = <GitHubUser>[].obs;
  final _selectedUserRepositories = <GitHubRepository>[].obs;
  final _selectedUserUsername = ''.obs;
  final _isLoading = false.obs;
  final _isLoadingRepos = false.obs;
  final _hasSearched = false.obs;
  final _errorMessage = ''.obs;

  late final SearchGitHubUserUseCase _searchGitHubUserUseCase;
  late final GetGitHubUserDetailsUseCase _getGitHubUserDetailsUseCase;
  late final GetGitHubUserRepositoriesUseCase _getGitHubUserRepositoriesUseCase;

  List<GitHubUser> get searchResults => _searchResults;
  List<GitHubRepository> get selectedUserRepositories =>
      _selectedUserRepositories;
  String get selectedUserUsername => _selectedUserUsername.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingRepos => _isLoadingRepos.value;
  bool get hasSearched => _hasSearched.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _searchGitHubUserUseCase = getIt<SearchGitHubUserUseCase>();
    _getGitHubUserDetailsUseCase = getIt<GetGitHubUserDetailsUseCase>();
    _getGitHubUserRepositoriesUseCase =
        getIt<GetGitHubUserRepositoriesUseCase>();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Search for GitHub users
  Future<void> searchGitHubUser(String username) async {
    if (username.trim().isEmpty) {
      _hasSearched.value = false;
      _searchResults.clear();
      _selectedUserRepositories.clear();
      _selectedUserUsername.value = '';
      _errorMessage.value = '';
      return;
    }

    _isLoading.value = true;
    _hasSearched.value = true;
    _errorMessage.value = '';

    try {
      final results = await _searchGitHubUserUseCase(
        query: username,
        perPage: 10,
      );

      // Fetch full details for each user to get complete information
      final fullResults = <GitHubUser>[];
      for (final user in results) {
        try {
          final fullUserDetails = await _getGitHubUserDetailsUseCase(
            user.username,
          );
          fullResults.add(fullUserDetails);
        } catch (e) {
          // If detailed fetch fails, use the search result
          fullResults.add(user);
        }
      }

      _searchResults.assignAll(fullResults);

      if (fullResults.isEmpty) {
        _errorMessage.value = 'No users found for "$username"';
      }
    } catch (e) {
      _searchResults.clear();
      _errorMessage.value = 'Error: ${e.toString()}';
      Get.snackbar(
        'Error',
        _errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Fetch repositories for a selected user
  Future<void> fetchUserRepositories(String username) async {
    _selectedUserUsername.value = username;
    _isLoadingRepos.value = true;
    _selectedUserRepositories.clear();

    try {
      final repositories = await _getGitHubUserRepositoriesUseCase(
        username,
        perPage: 10,
      );
      _selectedUserRepositories.assignAll(repositories);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load repositories: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      _isLoadingRepos.value = false;
    }
  }

  /// Clear search results
  void clearSearch() {
    searchController.clear();
    _searchResults.clear();
    _selectedUserRepositories.clear();
    _selectedUserUsername.value = '';
    _hasSearched.value = false;
    _errorMessage.value = '';
  }
}
