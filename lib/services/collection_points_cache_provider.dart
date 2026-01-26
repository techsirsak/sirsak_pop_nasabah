import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';
import 'package:sirsak_pop_nasabah/services/collection_point_service.dart';
import 'package:sirsak_pop_nasabah/services/collection_points_cache_state.dart';
import 'package:sirsak_pop_nasabah/services/local_storage.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'collection_points_cache_provider.g.dart';

/// Global provider for cached collection points
/// Uses `keepAlive: true` to persist across the app lifecycle
@Riverpod(keepAlive: true)
class CollectionPointsCacheNotifier extends _$CollectionPointsCacheNotifier {
  @override
  CollectionPointsCacheState build() {
    return const CollectionPointsCacheState();
  }

  /// Fetch collection points from cache or API
  /// Returns true if successful
  Future<bool> fetchAndCacheCollectionPoints() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // First try to load from cache
      final localStorage = ref.read(localStorageServiceProvider);
      final cached = await localStorage.getCachedCollectionPoints();

      if (cached != null) {
        state = state.copyWith(points: cached, isLoading: false);
        ref
            .read(loggerServiceProvider)
            .info(
              '[CollectionPointsCache] Loaded ${cached.length} points from cache',
            );
        return true;
      }

      // Cache miss or expired, fetch from API
      return await _fetchFromApi();
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error(
            '[CollectionPointsCache] Failed to fetch collection points',
            e,
            stackTrace,
          );
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load collection points',
      );
      return false;
    }
  }

  /// Force refresh from API (ignores cache)
  Future<bool> forceRefresh() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    return _fetchFromApi();
  }

  /// Internal method to fetch from API and save to cache
  Future<bool> _fetchFromApi() async {
    try {
      final service = ref.read(collectionPointServiceProvider);
      final response = await service.getCollectionPoints(limit: 500);

      // Save to cache
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.saveCollectionPoints(response.data);

      state = state.copyWith(points: response.data, isLoading: false);
      ref
          .read(loggerServiceProvider)
          .info(
            '[CollectionPointsCache] Fetched and cached ${response.data.length} '
            'points from API',
          );
      return true;
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error(
            '[CollectionPointsCache] Failed to fetch from API',
            e,
            stackTrace,
          );
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load collection points',
      );
      return false;
    }
  }

  /// Clear cache (called on logout)
  Future<void> clearCache() async {
    state = const CollectionPointsCacheState();
    await ref.read(localStorageServiceProvider).clearCollectionPointsCache();
  }

  /// Get points with valid coordinates only (for map display)
  List<CollectionPointModel> getPointsWithCoordinates() {
    return state.points
        .where((p) => p.latitude != null && p.longitude != null)
        .toList();
  }
}
