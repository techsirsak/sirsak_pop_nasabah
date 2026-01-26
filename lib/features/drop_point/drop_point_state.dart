import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';
import 'package:sirsak_pop_nasabah/models/drop_point_model.dart';

part 'drop_point_state.freezed.dart';

/// Filter type for drop points
enum DropPointFilterType {
  all,
  bankSampah,
  rvm,
}

/// Location permission status
enum LocationPermissionStatus {
  unknown,
  granted,
  denied,
  deniedForever,
}

/// Sort options for drop point list
enum DropPointSortBy {
  distance,
  rating,
}

@freezed
abstract class DropPointState with _$DropPointState {
  const factory DropPointState({
    // Data - using CollectionPointModel from API
    @Default([]) List<CollectionPointModel> dropPoints,
    @Default([]) List<CollectionPointModel> filteredDropPoints,

    // User location
    UserLocation? userLocation,
    @Default(false) bool isLocationFound,
    @Default(false) bool isLoadingLocation,
    String? locationError,
    @Default(LocationPermissionStatus.unknown)
    LocationPermissionStatus locationPermissionStatus,

    // Search
    @Default('') String searchQuery,

    // Filters
    @Default({}) Set<DropPointFilterType> activeFilters,
    @Default(DropPointSortBy.distance) DropPointSortBy sortBy,

    // Selection
    CollectionPointModel? selectedDropPoint,

    // Map state
    @Default(-6.2088) double mapCenterLat,
    @Default(106.8456) double mapCenterLng,
    @Default(12.0) double mapZoom,

    // Loading states
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _DropPointState;
}
