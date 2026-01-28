import 'dart:async';
import 'dart:math';

import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/drop_point_state.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';
import 'package:sirsak_pop_nasabah/models/drop_point_model.dart';
import 'package:sirsak_pop_nasabah/services/collection_points_cache_provider.dart';
import 'package:sirsak_pop_nasabah/services/location_service.dart';

part 'drop_point_viewmodel.g.dart';

@riverpod
class DropPointViewModel extends _$DropPointViewModel {
  @override
  DropPointState build() {
    // Load collection points from cache
    unawaited(Future.microtask(_loadCollectionPoints));

    // Listen for changes to the cache
    ref.listen(collectionPointsCacheProvider, (prev, next) {
      if (next.points.isNotEmpty && !next.isLoading) {
        _updateFromCache(next.points);
      }
    });

    return const DropPointState();
  }

  /// Initialize location - call when Drop Point view becomes visible
  Future<void> initLocation() async {
    // Prevent multiple calls if already initialized
    if (state.locationPermissionStatus != LocationPermissionStatus.unknown) {
      return;
    }
    await _initUserLocation();
  }

  /// Load collection points from cache
  void _loadCollectionPoints() {
    final cacheState = ref.read(collectionPointsCacheProvider);

    if (cacheState.isLoading) {
      state = state.copyWith(isLoading: true);
      return;
    }

    if (cacheState.points.isNotEmpty) {
      _updateFromCache(cacheState.points);
    }
  }

  /// Update state from cached collection points
  void _updateFromCache(List<CollectionPointModel> points) {
    // Filter out points without valid coordinates
    final validPoints = points
        .where((p) => p.latitude != null && p.longitude != null)
        .toList();

    state = state.copyWith(
      dropPoints: points,
      validDropPoints: validPoints,
      filteredDropPoints: points,
      isLoading: false,
    );

    // Re-apply filters if any were active
    if (state.searchQuery.isNotEmpty || state.activeFilters.isNotEmpty) {
      _applyFiltersAndSort();
    }
  }

  /// Check and request location permission
  Future<bool> _checkAndRequestLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      state = state.copyWith(
        locationPermissionStatus: LocationPermissionStatus.granted,
      );
      return true;
    }

    if (status.isPermanentlyDenied) {
      state = state.copyWith(
        locationPermissionStatus: LocationPermissionStatus.deniedForever,
      );
      return false;
    }

    // Request permission
    final result = await Permission.location.request();

    if (result.isGranted) {
      state = state.copyWith(
        locationPermissionStatus: LocationPermissionStatus.granted,
      );
      return true;
    }

    if (result.isPermanentlyDenied) {
      state = state.copyWith(
        locationPermissionStatus: LocationPermissionStatus.deniedForever,
      );
      return false;
    }

    state = state.copyWith(
      locationPermissionStatus: LocationPermissionStatus.denied,
    );
    return false;
  }

  /// Initialize user location service
  Future<void> _initUserLocation() async {
    state = state.copyWith(isLoadingLocation: true, locationError: null);

    // Check permission first
    final hasPermission = await _checkAndRequestLocationPermission();
    if (!hasPermission) {
      state = state.copyWith(isLoadingLocation: false);
      return;
    }

    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();

      if (position != null) {
        final userLocation = UserLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        state = state.copyWith(
          userLocation: userLocation,
          isLocationFound: true,
          isLoadingLocation: false,
          mapCenterLat: position.latitude,
          mapCenterLng: position.longitude,
        );

        _applyFiltersAndSort();
      } else {
        state = state.copyWith(
          isLoadingLocation: false,
          locationError: 'Could not get location',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingLocation: false,
        locationError: e.toString(),
      );
    }
  }

  /// Request location permission and get user location
  Future<void> requestLocation() async {
    await _initUserLocation();
  }

  /// Open app settings for location permission
  Future<void> openLocationAppSettings() async {
    await openAppSettings();
  }

  /// Update search query and filter results
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFiltersAndSort();
  }

  /// Clear search query
  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    _applyFiltersAndSort();
  }

  /// Toggle filter type
  void toggleFilter(DropPointFilterType type) {
    final currentFilters = Set<DropPointFilterType>.from(state.activeFilters);

    if (currentFilters.contains(type)) {
      currentFilters.remove(type);
    } else {
      currentFilters.add(type);
    }

    state = state.copyWith(activeFilters: currentFilters);
    _applyFiltersAndSort();
  }

  /// Set sort order
  void setSortBy(DropPointSortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
    _applyFiltersAndSort();
  }

  /// Apply filters and sorting to drop points list
  void _applyFiltersAndSort() {
    var filtered = List<CollectionPointModel>.from(state.dropPoints);

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((dp) {
        final name = dp.name.toLowerCase();
        final address = (dp.alamatLengkap ?? '').toLowerCase();
        return name.contains(query) || address.contains(query);
      }).toList();
    }

    switch (state.sortBy) {
      case DropPointSortBy.distance:
        if (state.userLocation != null) {
          filtered.sort((a, b) {
            final distA = _calculateDistance(a);
            final distB = _calculateDistance(b);
            return distA.compareTo(distB);
          });
        }
      case DropPointSortBy.rating:
        // Rating not available in API, sort by name instead
        filtered.sort((a, b) => a.name.compareTo(b.name));
    }
    state = state.copyWith(filteredDropPoints: filtered);
  }

  /// Calculate distance between user and drop point using Haversine formula
  double _calculateDistance(CollectionPointModel dropPoint) {
    if (state.userLocation == null) return double.infinity;
    if (dropPoint.latitude == null || dropPoint.longitude == null) {
      return double.infinity;
    }

    const earthRadius = 6371.0; // km

    final lat1 = state.userLocation!.latitude * pi / 180;
    final lat2 = dropPoint.lat * pi / 180;
    final deltaLat = (dropPoint.lat - state.userLocation!.latitude) * pi / 180;
    final deltaLng =
        (dropPoint.long - state.userLocation!.longitude) * pi / 180;

    final a =
        sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Get distance string for display
  String getDistanceString(CollectionPointModel dropPoint) {
    final distance = _calculateDistance(dropPoint);
    if (distance == double.infinity) return '-';
    return distance.toStringAsFixed(1);
  }

  /// Zoom in on map
  void zoomIn() {
    final newZoom = (state.mapZoom + 1).clamp(5.0, 18.0);
    state = state.copyWith(mapZoom: newZoom);
  }

  /// Zoom out on map
  void zoomOut() {
    final newZoom = (state.mapZoom - 1).clamp(5.0, 18.0);
    state = state.copyWith(mapZoom: newZoom);
  }

  /// Center map on user location
  void centerOnUserLocation() {
    if (state.userLocation != null) {
      state = state.copyWith(
        mapCenterLat: state.userLocation!.latitude,
        mapCenterLng: state.userLocation!.longitude,
      );
    }
  }

  /// Move map to specific coordinates
  void moveMapTo(double lat, double lng) {
    state = state.copyWith(
      mapCenterLat: lat,
      mapCenterLng: lng,
    );
  }

  /// Select a drop point
  void selectDropPoint(CollectionPointModel dropPoint) {
    if (dropPoint.latitude == null || dropPoint.longitude == null) return;

    state = state.copyWith(
      selectedDropPoint: dropPoint,
      mapCenterLat: dropPoint.lat,
      mapCenterLng: dropPoint.long,
      mapZoom: 15,
    );
  }

  /// Clear selected drop point
  void clearSelection() {
    state = state.copyWith(selectedDropPoint: null);
  }

  /// Dismiss location found toast
  void dismissLocationFound() {
    state = state.copyWith(isLocationFound: false);
  }
}
