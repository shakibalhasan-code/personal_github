import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_github/config/service_locator.dart';
import 'package:personal_github/domain/models/github_user.dart';
import 'package:personal_github/domain/models/github_repository.dart';
import 'package:personal_github/domain/models/sort_filter_option.dart';
import 'package:personal_github/domain/usecases/search_github_user_usecase.dart';
import 'package:personal_github/domain/usecases/get_github_user_details_usecase.dart';
import 'package:personal_github/domain/usecases/get_github_user_repositories_usecase.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();
  final _searchResults = <GitHubUser>[].obs;
  final _selectedUserRepositories = <GitHubRepository>[].obs;
  final _displayedRepositories = <GitHubRepository>[].obs;
  final _selectedUserUsername = ''.obs;
  final _isLoading = false.obs;
  final _isLoadingRepos = false.obs;
  final _hasSearched = false.obs;
  final _errorMessage = ''.obs;
  final _isGridView = false.obs;
  final _currentSortOption = SortOption.dateUpdated.obs;
  final _currentFilterOption = FilterOption.all.obs;

  late final SearchGitHubUserUseCase _searchGitHubUserUseCase;
  late final GetGitHubUserDetailsUseCase _getGitHubUserDetailsUseCase;
  late final GetGitHubUserRepositoriesUseCase _getGitHubUserRepositoriesUseCase;

  List<GitHubUser> get searchResults => _searchResults;
  List<GitHubRepository> get selectedUserRepositories => _displayedRepositories;
  String get selectedUserUsername => _selectedUserUsername.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingRepos => _isLoadingRepos.value;
  bool get hasSearched => _hasSearched.value;
  String get errorMessage => _errorMessage.value;
  bool get isGridView => _isGridView.value;
  SortOption get currentSortOption => _currentSortOption.value;
  FilterOption get currentFilterOption => _currentFilterOption.value;

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
    _displayedRepositories.clear();

    try {
      final repositories = await _getGitHubUserRepositoriesUseCase(
        username,
        perPage: 100,
      );
      _selectedUserRepositories.assignAll(repositories);
      _applyFilterAndSort();
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
    _displayedRepositories.clear();
    _selectedUserUsername.value = '';
    _hasSearched.value = false;
    _errorMessage.value = '';
    _currentSortOption.value = SortOption.dateUpdated;
    _currentFilterOption.value = FilterOption.all;
  }

  /// Toggle between list and grid view for repositories
  void toggleViewMode() {
    _isGridView.toggle();
    update();
  }

  /// Apply sort option and refresh displayed repositories
  void setSortOption(SortOption option) {
    _currentSortOption.value = option;
    _applyFilterAndSort();
  }

  /// Apply filter option and refresh displayed repositories
  void setFilterOption(FilterOption option) {
    _currentFilterOption.value = option;
    _applyFilterAndSort();
  }

  /// Apply both filter and sort to repositories
  void _applyFilterAndSort() {
    List<GitHubRepository> result = List.from(_selectedUserRepositories);

    // Apply filter
    result = _applyFilter(result, _currentFilterOption.value);

    // Apply sort
    result = _applySort(result, _currentSortOption.value);

    _displayedRepositories.assignAll(result);
    update();
  }

  /// Apply filter to repositories list
  List<GitHubRepository> _applyFilter(
    List<GitHubRepository> repos,
    FilterOption filter,
  ) {
    switch (filter) {
      case FilterOption.all:
        return repos;
      case FilterOption.withDescription:
        return repos.where((repo) => repo.description.isNotEmpty).toList();
      case FilterOption.withLanguage:
        return repos.where((repo) => repo.language != 'Unknown').toList();
      case FilterOption.starredOnly:
        return repos.where((repo) => repo.stars > 0).toList();
      case FilterOption.forkedOnly:
        return repos.where((repo) => repo.forks > 0).toList();
    }
  }

  /// Apply sort to repositories list
  List<GitHubRepository> _applySort(
    List<GitHubRepository> repos,
    SortOption sort,
  ) {
    final sorted = List<GitHubRepository>.from(repos);
    switch (sort) {
      case SortOption.dateCreated:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.dateUpdated:
        sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case SortOption.datePushed:
        sorted.sort((a, b) {
          final aDate = a.pushedAt ?? DateTime(1970);
          final bDate = b.pushedAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
        break;
      case SortOption.starsHighToLow:
        sorted.sort((a, b) => b.stars.compareTo(a.stars));
        break;
      case SortOption.starsLowToHigh:
        sorted.sort((a, b) => a.stars.compareTo(b.stars));
        break;
      case SortOption.forksHighToLow:
        sorted.sort((a, b) => b.forks.compareTo(a.forks));
        break;
      case SortOption.forksLowToHigh:
        sorted.sort((a, b) => a.forks.compareTo(b.forks));
        break;
      case SortOption.nameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
    }
    return sorted;
  }
}
