import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/config/env_config.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
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
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.info('[API Request] ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        logger.info(
          '[API Response] ${response.statusCode} ${response.requestOptions.path}',
        );
        return handler.next(response);
      },
      onError: (error, handler) {
        logger.error(
          '[API Error] ${error.requestOptions.path}',
          error,
          error.stackTrace,
        );
        return handler.next(error);
      },
    ),
  );

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

  /// Convert DioException to ApiException
  ApiException _handleDioError(DioException error) {
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
