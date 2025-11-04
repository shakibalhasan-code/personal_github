/// Base exception class
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AppException({required this.message, this.code, this.originalException});

  @override
  String toString() => message;
}

/// Server exception for API errors
class ServerException extends AppException {
  ServerException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
         message: message,
         code: code,
         originalException: originalException,
       );
}

/// Network exception for connectivity issues
class NetworkException extends AppException {
  NetworkException({
    String message = 'Network error',
    String? code,
    dynamic originalException,
  }) : super(
         message: message,
         code: code,
         originalException: originalException,
       );
}

/// Cache exception
class CacheException extends AppException {
  CacheException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
         message: message,
         code: code,
         originalException: originalException,
       );
}

/// Validation exception
class ValidationException extends AppException {
  ValidationException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
         message: message,
         code: code,
         originalException: originalException,
       );
}
