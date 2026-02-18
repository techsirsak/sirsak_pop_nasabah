import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/models/setor/setor_session_response.dart';
import 'package:sirsak_pop_nasabah/services/api/dio_client.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'setor_service.g.dart';

@riverpod
SetorService setorService(Ref ref) {
  return SetorService(
    ref.read(apiClientProvider),
    ref.read(loggerServiceProvider),
  );
}

class SetorService {
  SetorService(this._apiClient, this._logger);

  final ApiClient _apiClient;
  final LoggerService _logger;

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
        if (sessionId != null) 'session_id': sessionId,
      },
      fromJson: SetorSessionResponse.fromJson,
    );

    _logger.info(
      '[SetorService] Session created: ${response.sessionId}',
    );
    return response;
  }
}
