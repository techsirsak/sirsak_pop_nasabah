import 'package:dio/dio.dart';
import 'package:sirsak_pop_nasabah/services/local_storage.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

/// Interceptor that adds Bearer token to authenticated requests
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._localStorage, this._logger);

  final LocalStorageService _localStorage;
  final LoggerService _logger;

  /// Public endpoints that don't require authentication
  static const _publicPaths = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
  ];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    final isPublicEndpoint = _publicPaths.any(
      (path) => options.path.contains(path),
    );

    if (!isPublicEndpoint) {
      final token = await _localStorage.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        _logger.info('[AuthInterceptor] Added auth header to ${options.path}');
      }
    }

    handler.next(options);
  }
}
