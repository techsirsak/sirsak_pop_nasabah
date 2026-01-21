import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/models/auth/register_request.dart';
import 'package:sirsak_pop_nasabah/models/auth/register_response.dart';
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
  /// Throws [ApiException] on failure
  Future<RegisterResponse> register({
    required String email,
    required String name,
    required String password,
  }) async {
    _logger.info('[AuthService] Registering user: $email');

    final request = RegisterRequest(
      email: email,
      name: name,
      password: password,
    );

    final response = await _apiClient.post(
      path: '/auth/register/nasabah',
      data: request.toJson(),
      fromJson: RegisterResponse.fromJson,
    );

    _logger.info('[AuthService] Registration successful for: $email');
    return response;
  }
}
