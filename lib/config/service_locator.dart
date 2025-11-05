import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_github/core/services/dio_service.dart';
import 'package:personal_github/core/services/github_api_service.dart';
import 'package:personal_github/core/services/theme_preferences_service.dart';
import 'package:personal_github/data/datasources/github_remote_data_source.dart';
import 'package:personal_github/domain/repositories/github_user_repository.dart';
import 'package:personal_github/domain/usecases/search_github_user_usecase.dart';
import 'package:personal_github/domain/usecases/get_github_user_details_usecase.dart';
import 'package:personal_github/presentation/controllers/theme_controller.dart';

final getIt = GetIt.instance;

/// Service Locator - Dependency Injection setup

class ServiceLocator {
  static Future<void> setup() async {
    // Initialize SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();

    // Register SharedPreferences instance
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    // Register ThemePreferencesService
    getIt.registerSingleton<ThemePreferencesService>(
      ThemePreferencesService(sharedPreferences),
    );

    // Register ThemeController with dependencies
    getIt.registerSingleton<ThemeController>(
      ThemeController(
        themePreferencesService: getIt<ThemePreferencesService>(),
      ),
    );

    // Register Dio Service
    getIt.registerSingleton<DioService>(DioService());

    // Register GitHub API Service
    getIt.registerSingleton<GitHubApiService>(
      GitHubApiService(dioService: getIt<DioService>()),
    );

    // Register GitHub Remote Data Source
    getIt.registerSingleton<GitHubRemoteDataSource>(
      GitHubRemoteDataSourceImpl(apiService: getIt<GitHubApiService>()),
    );

    // Register GitHub User Repository
    getIt.registerSingleton<GitHubUserRepository>(
      GitHubUserRepositoryImpl(
        remoteDataSource: getIt<GitHubRemoteDataSource>(),
      ),
    );

    // Register Search GitHub User UseCase
    getIt.registerSingleton<SearchGitHubUserUseCase>(
      SearchGitHubUserUseCase(repository: getIt<GitHubUserRepository>()),
    );

    // Register Get GitHub User Details UseCase
    getIt.registerSingleton<GetGitHubUserDetailsUseCase>(
      GetGitHubUserDetailsUseCase(repository: getIt<GitHubUserRepository>()),
    );
  }
}
