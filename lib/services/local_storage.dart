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
}
