import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/models/auth/auth_token_response.dart';
import 'package:sirsak_pop_nasabah/models/auth/login_request.dart';
import 'package:sirsak_pop_nasabah/models/auth/register_request.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/api/dio_client.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthService(
    ref.read(apiClientProvider),
    ref.read(loggerServiceProvider),
  );
}

class AuthService {
  AuthService(this._apiClient, this._logger);

  final ApiClient _apiClient;
  final LoggerService _logger;

  /// Register a new nasabah user
  ///
  /// If [bsuId] is provided, registers via `/auth/register/nasabah/:bsuId`
  /// If [nasabahId] is provided, syncs via `/auth/register/nasabah/sync/:nasabahId`
  /// Otherwise, registers via `/auth/register/nasabah`
  ///
  /// Throws [ApiException] on failure
  Future<void> register({
    required String email,
    required String name,
    required String password,
    String? phoneNumber,
    String? bsuId,
    String? nasabahId,
  }) async {
    _logger.info('[AuthService] Registering user: $email');

    final request = RegisterRequest(
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      password: password,
    );

    // Determine endpoint based on provided IDs (bsuId takes priority)
    final String path;
    if (bsuId != null) {
      path = '/auth/register/nasabah/$bsuId';
    } else if (nasabahId != null) {
      path = '/auth/register/nasabah/sync/$nasabahId';
    } else {
      path = '/auth/register/nasabah';
    }

    await _apiClient.post(
      path: path,
      data: request.toJson(),
      fromJson: (json) {},
    );

    _logger.info('[AuthService] Registration successful for: $email');
  }

  /// Login a nasabah user
  ///
  /// Throws [ApiException] on failure
  Future<AuthTokenResponse> login({
    required String email,
    required String password,
  }) async {
    _logger.info('[AuthService] Logging in user: $email');

    final request = LoginRequest(
      email: email,
      password: password,
    );

    final response = await _apiClient.post(
      path: '/auth/login',
      data: request.toJson(),
      fromJson: AuthTokenResponse.fromJson,
    );

    _logger.info('[AuthService] Login successful for: $email');
    return response;
  }

  /// Refresh access token using refresh token
  ///
  /// Throws [ApiException] on failure
  Future<AuthTokenResponse> refreshToken({
    required String refreshToken,
  }) async {
    _logger.info('[AuthService] Refreshing access token');

    final response = await _apiClient.post(
      path: '/auth/refresh-token',
      data: {
        'refresh_token': refreshToken,
      },
      fromJson: AuthTokenResponse.fromJson,
    );

    _logger.info('[AuthService] Token refresh successful');
    return response;
  }

  /// Update user password
  ///
  /// Throws [ApiException] on failure
  Future<void> updatePassword({
    required String email,
    required String password,
  }) async {
    _logger.info('[AuthService] Updating password for: $email');

    await _apiClient.patch(
      path: '/auth/update-password',
      data: {
        'email': email,
        'password': password,
      },
      fromJson: (json) {},
    );

    _logger.info('[AuthService] Password updated successfully for: $email');
  }
}
