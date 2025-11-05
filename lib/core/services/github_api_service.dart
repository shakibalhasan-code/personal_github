import 'package:dio/dio.dart';
import 'package:personal_github/core/constants/app_constants.dart';
import 'package:personal_github/core/services/dio_service.dart';

class GitHubApiService {
  final DioService _dioService;

  GitHubApiService({DioService? dioService})
    : _dioService = dioService ?? DioService();

  /// Search for GitHub users by username Returns a map containing the search results
  Future<Map<String, dynamic>> searchUsers({
    required String query,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dioService.get<Map<String, dynamic>>(
        AppConstants.searchUsersEndpoint,
        queryParameters: {'q': query, 'page': page, 'per_page': perPage},
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!;
      } else {
        throw Exception('Failed to search users: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    }
  }

  /// Get user details by username
  Future<Map<String, dynamic>> getUserDetails(String username) async {
    try {
      final response = await _dioService.get<Map<String, dynamic>>(
        '/users/$username',
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!;
      } else {
        throw Exception('Failed to fetch user details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    }
  }

  /// Get user repositories by username
  Future<List<Map<String, dynamic>>> getUserRepositories(
    String username, {
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dioService.get<List<dynamic>>(
        '/users/$username/repos',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      if (response.statusCode == 200 && response.data != null) {
        return List<Map<String, dynamic>>.from(
          response.data!.map((item) => item as Map<String, dynamic>),
        );
      } else {
        throw Exception('Failed to fetch repositories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    }
  }
}
