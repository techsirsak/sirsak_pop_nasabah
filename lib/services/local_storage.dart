import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'local_storage.g.dart';

@riverpod
LocalStorageService localStorageService(Ref ref) {
  return LocalStorageService(ref.read(loggerServiceProvider));
}

class LocalStorageService {
  LocalStorageService(this._logger);

  final LoggerService _logger;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _keyHasSeenTutorial = 'has_seen_tutorial';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';

  Future<bool> hasSeenTutorial() async {
    try {
      final result = await _storage.read(key: _keyHasSeenTutorial);
      final hasSeenTutorial = result == 'true';
      _logger.info('Checked tutorial status: $hasSeenTutorial');
      return hasSeenTutorial;
    } catch (e, stackTrace) {
      _logger.error('Failed to read tutorial status', e, stackTrace);
      return false; // Safe fallback: show tutorial
    }
  }

  Future<void> markTutorialAsSeen() async {
    try {
      await _storage.write(key: _keyHasSeenTutorial, value: 'true');
      _logger.info('Tutorial marked as seen');
    } catch (e, stackTrace) {
      _logger.error('Failed to mark tutorial as seen', e, stackTrace);
    }
  }

  Future<void> resetTutorial() async {
    try {
      await _storage.delete(key: _keyHasSeenTutorial);
      _logger.info('Tutorial status reset');
    } catch (e, stackTrace) {
      _logger.error('Failed to reset tutorial', e, stackTrace);
    }
  }

  // Token storage methods

  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _keyAccessToken, value: token);
      _logger.info('Access token saved');
    } catch (e, stackTrace) {
      _logger.error('Failed to save access token', e, stackTrace);
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final token = await _storage.read(key: _keyAccessToken);
      _logger.info('Access token retrieved: ${token != null}');
      return token;
    } catch (e, stackTrace) {
      _logger.error('Failed to read access token', e, stackTrace);
      return null;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _keyRefreshToken, value: token);
      _logger.info('Refresh token saved');
    } catch (e, stackTrace) {
      _logger.error('Failed to save refresh token', e, stackTrace);
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final token = await _storage.read(key: _keyRefreshToken);
      _logger.info('Refresh token retrieved: ${token != null}');
      return token;
    } catch (e, stackTrace) {
      _logger.error('Failed to read refresh token', e, stackTrace);
      return null;
    }
  }

  Future<void> clearAllTokens() async {
    try {
      await _storage.delete(key: _keyAccessToken);
      await _storage.delete(key: _keyRefreshToken);
      _logger.info('All tokens cleared');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear tokens', e, stackTrace);
    }
  }
}
