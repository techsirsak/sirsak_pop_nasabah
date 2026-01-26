import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/models/user/user_model.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/api/dio_client.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'user_service.g.dart';

@riverpod
UserService userService(Ref ref) {
  return UserService(
    ref.read(apiClientProvider),
    ref.read(loggerServiceProvider),
  );
}

class UserService {
  UserService(this._apiClient, this._logger);

  final ApiClient _apiClient;
  final LoggerService _logger;

  /// Fetch current user profile from /api/v2/users/me
  ///
  /// Throws [ApiException] on failure
  Future<UserModel> getCurrentUser() async {
    _logger.info('[UserService] Fetching current user');

    final response = await _apiClient.get(
      path: '/users/me',
      fromJson: UserModel.fromJson,
    );

    _logger.info('[UserService] User fetched successfully: ${response.email}');
    return response;
  }

  Future<void> updateUserProfile() async {
    _logger.info('[UserService] Update User Profile');

    final response = await _apiClient.patch(
      path: '/nasabah/profile',
      fromJson: UserModel.fromJson,
    );

    _logger.info(
      '[UserService] User profile updated successfully: ${response.email}',
    );
  }
}
