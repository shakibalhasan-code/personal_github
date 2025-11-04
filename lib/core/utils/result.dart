import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Result wrapper class for handling success and failure cases
abstract class Result<T> extends Equatable {
  const Result();

  @override
  List<Object?> get props => [];
}

/// Success result
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

/// Failure result
class Failed<T> extends Result<T> {
  final Failure failure;

  const Failed(this.failure);

  @override
  List<Object?> get props => [failure];
}

extension ResultExtension<T> on Result<T> {
  /// Fold result into a single value
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T success) onSuccess,
  ) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onFailure((this as Failed<T>).failure);
    }
  }

  /// Get data or null
  T? getOrNull() {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// Get failure or null
  Failure? getFailureOrNull() {
    if (this is Failed<T>) {
      return (this as Failed<T>).failure;
    }
    return null;
  }

  /// Check if success
  bool isSuccess() => this is Success<T>;

  /// Check if failure
  bool isFailure() => this is Failed<T>;
}
