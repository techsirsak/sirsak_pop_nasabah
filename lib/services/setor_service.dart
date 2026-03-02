import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/config/env_config.dart';
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
