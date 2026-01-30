import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/models/user/impact_model.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_history_model.dart';
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

  Future<void> updateUserProfile({
    required String fullName,
    required String email,
    String? phoneNumber,
  }) async {
    _logger.info('[UserService] Update User Profile');

    await _apiClient.patch(
      path: '/nasabah/profile',
      data: {
        'name': fullName,
        'no_hp': ?phoneNumber,
      },
      fromJson: (_) {},
    );

    _logger.info(
      '[UserService] User profile updated successfully: $email}',
    );
  }

  /// Fetch current user profile from /api/v2/users/me
  ///
  /// Throws [ApiException] on failure
  Future<void> requestDeleteUser() async {
    _logger.info('[UserService] Requesting delete current user');

    await _apiClient.delete(
      path: '/users/me',
      fromJson: (json) {},
    );

    _logger.info('[UserService] User delete requested');
  }

  /// Fetch user impact data from /nasabah/impact
  ///
  /// Throws [ApiException] on failure
  Future<ImpactModel> getImpact() async {
    _logger.info('[UserService] Fetching user impact');

    final response = await _apiClient.get(
      path: '/nasabah/impact',
      fromJson: ImpactModel.fromJson,
    );

    _logger.info('[UserService] Impact fetched successfully');
    return response;
  }

  /// Fetch transaction history from /nasabah/journal
  ///
  /// Throws [ApiException] on failure
  Future<List<TransactionHistoryModel>> getTransactionHistory() async {
    _logger.info('[UserService] Fetching transaction history');

    final response = await _apiClient.getList(
      path: '/nasabah/journal',
      fromJson: TransactionHistoryModel.fromJson,
    );

    _logger.info(
      '[UserService] Transaction history fetched: ${response.length} entries',
    );
    return response;
  }
}
