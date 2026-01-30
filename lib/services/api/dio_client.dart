import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/config/env_config.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/api/auth_interceptor.dart';
import 'package:sirsak_pop_nasabah/services/local_storage.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'dio_client.g.dart';

/// Provider for Dio HTTP client
@riverpod
Dio dioClient(Ref ref) {
  final envConfig = ref.read(envConfigProvider);
  final logger = ref.read(loggerServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: envConfig.baseApiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add logging interceptor
  dio.interceptors.add(LoggingInterceptor());

  // Add retry interceptor for transient failures
  dio.interceptors.add(RetryInterceptor(dio: dio));

  // Add auth interceptor to inject Bearer token
  final localStorage = ref.read(localStorageServiceProvider);
  dio.interceptors.add(AuthInterceptor(localStorage, logger));

  return dio;
}

/// Provider for API client wrapper with error handling
@riverpod
ApiClient apiClient(Ref ref) {
  return ApiClient(
    ref.read(dioClientProvider),
    ref.read(loggerServiceProvider),
  );
}

/// API client wrapper with standardized error handling
class ApiClient {
  ApiClient(this._dio, this._logger);

  final Dio _dio;
  final LoggerService _logger;

  /// Execute a POST request with error handling
  Future<T> post<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      _logger.error('[API] Unexpected error', e, stackTrace);
      throw ApiException.unknown(message: e.toString(), error: e);
    }
  }

  /// Execute a GET request with error handling
  Future<T> get<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );

      return fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      _logger.error('[API] Unexpected error', e, stackTrace);
      throw ApiException.unknown(message: e.toString(), error: e);
    }
  }

  /// Execute a PUT request with error handling
  Future<T> put<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      _logger.error('[API] Unexpected error', e, stackTrace);
      throw ApiException.unknown(message: e.toString(), error: e);
    }
  }

  /// Execute a PATCH request with error handling
  Future<T> patch<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      _logger.error('[API] Unexpected error', e, stackTrace);
      throw ApiException.unknown(message: e.toString(), error: e);
    }
  }

  /// Execute a DELETE request with error handling
  Future<T> delete<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );

      return fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      _logger.error('[API] Unexpected error', e, stackTrace);
      throw ApiException.unknown(message: e.toString(), error: e);
    }
  }

  /// Execute a GET request that returns a list
  Future<List<T>> getList<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        path,
        queryParameters: queryParameters,
      );

      return response.data!
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e, stackTrace) {
      _logger.error('[API] Unexpected error', e, stackTrace);
      throw ApiException.unknown(message: e.toString(), error: e);
    }
  }

  /// Convert DioException to ApiException
  ApiException _handleDioError(DioException error) {
    // Log error details for tracking in release mode
    final requestPath = error.requestOptions.path;
    final method = error.requestOptions.method;
    final statusCode = error.response?.statusCode;

    unawaited(
      _logger.error(
        '[API] ${error.type.name}: $method $requestPath (status: $statusCode)',
        error,
        error.stackTrace,
      ),
    );

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException.network(
          message: 'Connection timeout. Please try again.',
        );

      case DioExceptionType.connectionError:
        return const ApiException.network(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final data = error.response?.data;

        var message = 'An error occurred';
        Map<String, dynamic>? errors;

        if (data is Map<String, dynamic>) {
          message = data['message'] as String? ?? message;
          errors = data['errors'] as Map<String, dynamic>?;

          // Check for nested auth error with invalid_credentials code
          final errorData = data['error'] as Map<String, dynamic>?;
          if (errorData != null) {
            final details = errorData['details'] as Map<String, dynamic>?;
            if (details != null) {
              final isAuthError = details['__isAuthError'] as bool? ?? false;
              final code = details['code'] as String?;
              if (isAuthError && code == 'invalid_credentials') {
                throw const InvalidCredentialsException(
                  'Invalid email or password',
                );
              }
            }
          }
        }

        if (statusCode >= 500) {
          return ApiException.server(
            message: message,
            statusCode: statusCode,
          );
        }

        return ApiException.client(
          message: message,
          statusCode: statusCode,
          errors: errors,
        );

      case DioExceptionType.cancel:
        return const ApiException.network(
          message: 'Request was cancelled.',
        );

      case DioExceptionType.badCertificate:
        return const ApiException.network(
          message: 'Certificate verification failed.',
        );

      case DioExceptionType.unknown:
        return ApiException.unknown(
          message: error.message ?? 'An unexpected error occurred',
          error: error,
        );
    }
  }
}

/// Retry interceptor for transient failures
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
  });

  final Dio dio;
  final int maxRetries;
  final List<Duration> retryDelays;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = _getAttempt(err.requestOptions);

    if (_shouldRetry(err) && attempt < maxRetries) {
      final delay = retryDelays[attempt];

      if (kDebugMode) {
        debugPrint(
          '[Retry] Attempt ${attempt + 1}/$maxRetries after ${delay.inSeconds}s',
        );
      }

      await Future<void>.delayed(delay);

      try {
        final options = err.requestOptions;
        options.extra['retry_attempt'] = attempt + 1;

        final response = await dio.fetch<dynamic>(options);
        return handler.resolve(response);
      } on DioException catch (e) {
        return super.onError(e, handler);
      }
    }

    return super.onError(err, handler);
  }

  int _getAttempt(RequestOptions options) {
    return options.extra['retry_attempt'] as int? ?? 0;
  }

  bool _shouldRetry(DioException err) {
    // Retry on connection/timeout issues
    if (_isRetryableError(err.type)) {
      return true;
    }

    // Retry on 5xx server errors
    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode >= 500) {
      return true;
    }

    return false;
  }

  bool _isRetryableError(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.connectionError;
  }
}

/// HTTP Logger
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    if (kDebugMode) {
      debugPrint(
        '<------------ REQUEST '
        '${options.method} ${options.baseUrl}${options.path}',
      );
      log('HEADERS: ${options.headers}');
      debugPrint('QueryParam: ${options.queryParameters}');
      debugPrint('Payload:  ${options.data}');
    }
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    super.onResponse(response, handler);
    if (kDebugMode) {
      debugPrint('<------------ ${response.statusCode} Response Data:');
      log('${response.data}');
    }
  }
}
