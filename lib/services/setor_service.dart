import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/config/env_config.dart';
import 'package:sirsak_pop_nasabah/models/setor/setor_session_response.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/api/dio_client.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'setor_service.g.dart';

@riverpod
SetorService setorService(Ref ref) {
  return SetorService(
    ref.read(apiClientProvider),
    ref.read(loggerServiceProvider),
    ref.read(envConfigProvider),
  );
}

class SetorService {
  SetorService(this._apiClient, this._logger, this._envConfig);

  final ApiClient _apiClient;
  final LoggerService _logger;
  final EnvConfig _envConfig;

  /// Initiate a waste deposit session at an RVM
  ///
  /// [rvmId] - ID of the RVM from the QR code
  /// [sessionId] - Optional session ID from the QR code
  Future<SetorSessionResponse> initiateSession({
    required String rvmId,
    String? sessionId,
  }) async {
    _logger.info('[SetorService] Initiating setor session for RVM: $rvmId');

    final response = await _apiClient.post(
      path: '/setor/session',
      data: {
        'rvm_id': rvmId,
        'session_id': ?sessionId,
      },
      fromJson: SetorSessionResponse.fromJson,
    );

    _logger.info(
      '[SetorService] Session created: ${response.sessionId}',
    );
    return response;
  }

  /// Process a QR transaction at an RVM
  ///
  /// [encryptedPayload] - Pre-encrypted payload string from RVM QR code
  ///
  /// Returns true on success
  /// Throws [ApiException] on failure
  Future<bool> qrTransaction(String encryptedPayload) async {
    _logger.info(
      '[SetorService] Processing QR transaction with encrypted payload',
    );

    await _apiClient.post(
      path: '/rvm/qr-transaction',
      data: {'encrypted_payload': encryptedPayload},
      headers: {'x-api-key': _envConfig.rvmApiKey},
      fromJson: (_) {},
    );

    _logger.info('[SetorService] QR transaction completed successfully');
    return true;
  }
}
