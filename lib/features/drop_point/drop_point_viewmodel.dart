import 'dart:async';
import 'dart:math';

import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/drop_point_state.dart';
import 'package:sirsak_pop_nasabah/models/drop_point_model.dart';
import 'package:sirsak_pop_nasabah/services/location_service.dart';

part 'drop_point_viewmodel.g.dart';

@riverpod
class DropPointViewModel extends _$DropPointViewModel {
  @override
  DropPointState build() {
    unawaited(Future.microtask(_loadMockData));
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

  /// Load mock drop point data (to be replaced with API call)
  void _loadMockData() {
    final mockDropPoints = [
      const DropPointModel(
        id: '1',
        name: 'Green Recycle Center',
        address: 'Jl. Sudirman No. 45, Jakarta',
        latitude: -6.2100,
        longitude: 106.8450,
        type: DropPointType.bankSampah,
        rating: 4.8,
        reviewCount: 120,
        openingTime: '08:00',
        closingTime: '18:00',
        acceptedWasteTypes: ['plastic', 'paper', 'metal'],
      ),
      const DropPointModel(
        id: '2',
        name: 'EcoBot RVM Station',
        address: 'Mall Central Park, Lt. 1',
        latitude: -6.1780,
        longitude: 106.7900,
        type: DropPointType.rvm,
        rating: 4.5,
        reviewCount: 85,
        openingTime: '10:00',
        closingTime: '22:00',
        acceptedWasteTypes: ['plastic bottles'],
      ),
      const DropPointModel(
        id: '3',
        name: 'Bank Sampah Sejahtera',
        address: 'Jl. Gatot Subroto No. 12, Jakarta',
        latitude: -6.2350,
        longitude: 106.8230,
        type: DropPointType.bankSampah,
        rating: 4.6,
        reviewCount: 95,
        openingTime: '07:00',
        closingTime: '17:00',
        acceptedWasteTypes: ['plastic', 'paper', 'glass', 'metal'],
      ),
      const DropPointModel(
        id: '4',
        name: 'RVM Plaza Indonesia',
        address: 'Plaza Indonesia, Ground Floor',
        latitude: -6.1930,
        longitude: 106.8230,
        type: DropPointType.rvm,
        rating: 4.7,
        reviewCount: 150,
        openingTime: '10:00',
        closingTime: '22:00',
        acceptedWasteTypes: ['plastic bottles', 'cans'],
      ),
      const DropPointModel(
        id: '5',
        name: 'Bank Sampah Indah',
        address: 'Jl. Thamrin No. 88, Jakarta',
        latitude: -6.1950,
        longitude: 106.8100,
        type: DropPointType.bankSampah,
        rating: 4.4,
        reviewCount: 78,
        openingTime: '08:00',
        closingTime: '16:00',
        acceptedWasteTypes: ['plastic', 'paper'],
      ),
    ];

    state = state.copyWith(
      dropPoints: mockDropPoints,
      filteredDropPoints: mockDropPoints,
    );
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
    var filtered = List<DropPointModel>.from(state.dropPoints);

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((dp) {
        return dp.name.toLowerCase().contains(query) ||
            dp.address.toLowerCase().contains(query);
      }).toList();
    }

    // Apply type filters
    if (state.activeFilters.isNotEmpty &&
        !state.activeFilters.contains(DropPointFilterType.all)) {
      filtered = filtered.where((dp) {
        if (state.activeFilters.contains(DropPointFilterType.bankSampah) &&
            dp.type == DropPointType.bankSampah) {
          return true;
        }
        if (state.activeFilters.contains(DropPointFilterType.rvm) &&
            dp.type == DropPointType.rvm) {
          return true;
        }
        return false;
      }).toList();
    }

    // Apply sorting
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
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    state = state.copyWith(filteredDropPoints: filtered);
  }

  /// Calculate distance between user and drop point using Haversine formula
  double _calculateDistance(DropPointModel dropPoint) {
    if (state.userLocation == null) return double.infinity;

    const earthRadius = 6371.0; // km

    final lat1 = state.userLocation!.latitude * pi / 180;
    final lat2 = dropPoint.latitude * pi / 180;
    final deltaLat =
        (dropPoint.latitude - state.userLocation!.latitude) * pi / 180;
    final deltaLng =
        (dropPoint.longitude - state.userLocation!.longitude) * pi / 180;

    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Get distance string for display
  String getDistanceString(DropPointModel dropPoint) {
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
  void selectDropPoint(DropPointModel dropPoint) {
    state = state.copyWith(
      selectedDropPoint: dropPoint,
      mapCenterLat: dropPoint.latitude,
      mapCenterLng: dropPoint.longitude,
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
