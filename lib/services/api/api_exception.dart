import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';

/// Base exception for API errors
@freezed
sealed class ApiException with _$ApiException implements Exception {
  /// Network error (no internet, timeout, etc.)
  const factory ApiException.network({
    required String message,
    int? statusCode,
  }) = NetworkException;

  /// Server error (5xx status codes)
  const factory ApiException.server({
    required String message,
    required int statusCode,
  }) = ServerException;

  /// Client error (4xx status codes)
  const factory ApiException.client({
    required String message,
    required int statusCode,
    Map<String, dynamic>? errors,
  }) = ClientException;

  /// Unknown/unexpected error
  const factory ApiException.unknown({
    required String message,
    Object? error,
  }) = UnknownException;
}

/// Invalid credentials error - separate from sealed union
/// Catch explicitly where needed (e.g., login), other places can ignore it
class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException(this.message);
  final String message;

  @override
  String toString() => 'InvalidCredentialsException: $message';
}
