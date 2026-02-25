import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';
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
  static const String _keyCollectionPoints = 'collection_points';
  static const String _keyCollectionPointsCachedAt =
      'collection_points_cached_at';
  static const String _keyTokensSavedAt = 'tokens_saved_at';

  static const Duration _collectionPointExpiration = Duration(days: 2);
  static const Duration _tokenExpiration = Duration(days: 7);

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
      await _storage.write(
        key: _keyTokensSavedAt,
        value: DateTime.now().toIso8601String(),
      );
      _logger.info('Access token saved');
    } catch (e, stackTrace) {
      _logger.error('Failed to save access token', e, stackTrace);
    }
  }

  /// Get access token
  /// Returns null if token is expired (> 7 days) or not found
  Future<String?> getAccessToken() async {
    try {
      // Check token expiration
      final savedAtStr = await _storage.read(key: _keyTokensSavedAt);
      if (savedAtStr != null) {
        final savedAt = DateTime.parse(savedAtStr);
        if (DateTime.now().difference(savedAt) > _tokenExpiration) {
          _logger.info('[LocalStorage] Tokens expired, clearing...');
          await clearAllTokens();
          return null;
        }
      }

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

  /// Get refresh token
  /// Returns null if token is expired (> 7 days) or not found
  Future<String?> getRefreshToken() async {
    try {
      // Check token expiration
      final savedAtStr = await _storage.read(key: _keyTokensSavedAt);
      if (savedAtStr != null) {
        final savedAt = DateTime.parse(savedAtStr);
        if (DateTime.now().difference(savedAt) > _tokenExpiration) {
          _logger.info('[LocalStorage] Tokens expired, clearing...');
          await clearAllTokens();
          return null;
        }
      }

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
      await _storage.delete(key: _keyTokensSavedAt);
      _logger.info('All tokens cleared');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear tokens', e, stackTrace);
    }
  }

  // Collection points cache methods

  /// Save collection points to cache with timestamp
  Future<void> saveCollectionPoints(List<CollectionPointModel> points) async {
    try {
      final jsonList = points.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _storage.write(key: _keyCollectionPoints, value: jsonString);
      await _storage.write(
        key: _keyCollectionPointsCachedAt,
        value: DateTime.now().toIso8601String(),
      );
      _logger.info('[LocalStorage] Saved ${points.length} collection points');
    } catch (e, stackTrace) {
      _logger.error('Failed to save collection points', e, stackTrace);
    }
  }

  /// Get cached collection points
  /// Returns null if cache is expired (> 1 day) or not found
  Future<List<CollectionPointModel>?> getCachedCollectionPoints() async {
    try {
      final cachedAtStr = await _storage.read(
        key: _keyCollectionPointsCachedAt,
      );
      if (cachedAtStr == null) return null;

      final cachedAt = DateTime.parse(cachedAtStr);
      if (DateTime.now().difference(cachedAt) > _collectionPointExpiration) {
        _logger.info('[LocalStorage] Collection points cache expired');
        return null;
      }

      final jsonString = await _storage.read(key: _keyCollectionPoints);
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final points = jsonList
          .map(
            (json) =>
                CollectionPointModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      _logger.info(
        '[LocalStorage] Retrieved ${points.length} cached collection points',
      );
      return points;
    } catch (e, stackTrace) {
      _logger.error('Failed to read collection points cache', e, stackTrace);
      return null;
    }
  }

  /// Clear collection points cache
  Future<void> clearCollectionPointsCache() async {
    try {
      await _storage.delete(key: _keyCollectionPoints);
      await _storage.delete(key: _keyCollectionPointsCachedAt);
      _logger.info('[LocalStorage] Collection points cache cleared');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear collection points cache', e, stackTrace);
    }
  }
}
