import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/detail/drop_point_detail_state.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_stock_model.dart';
import 'package:sirsak_pop_nasabah/models/drop_point_model.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/collection_point_service.dart';
import 'package:sirsak_pop_nasabah/services/geocoding_service.dart';
import 'package:sirsak_pop_nasabah/services/location_service.dart';
import 'package:sirsak_pop_nasabah/services/url_launcher_service.dart';

part 'drop_point_detail_viewmodel.g.dart';

@riverpod
class DropPointDetailViewModel extends _$DropPointDetailViewModel {
  @override
  DropPointDetailState build(CollectionPointModel collectionPoint) {
    // Initialize with the collection point immediately
    final initialState = DropPointDetailState(
      collectionPoint: collectionPoint,
      isLoading: true,
    );

    // Load data asynchronously after build
    unawaited(
      Future.microtask(() async {
        await Future.wait([
          _geocodeAddress(),
          _loadStockItems(collectionPoint.id),
        ]);
        await _calculateDistance();

        state = state.copyWith(isLoading: false);
      }),
    );

    return initialState;
  }

  /// Geocode the address to get coordinates
  Future<void> _geocodeAddress() async {
    final collectionPoint = state.collectionPoint;
    // If coordinates are missing, try to geocode the address
    if (collectionPoint.hasValidCoordinates) {
      _calculateDistance();
      return;
    }
    final addressForCoordinates = collectionPoint.addressForCoordinates;
    if (addressForCoordinates.isEmpty) return;

    state = state.copyWith(isGeocodingAddress: true);

    try {
      final geocodingService = ref.read(geocodingServiceProvider);
      final coordinates = await geocodingService.getCoordinatesFromAddress(
        addressForCoordinates,
      );

      if (coordinates != null) {
        state = state.copyWith(
          geocodedLat: coordinates.lat,
          geocodedLng: coordinates.lng,
          isGeocodingAddress: false,
        );
        _calculateDistance();
      } else {
        state = state.copyWith(isGeocodingAddress: false);
      }
    } catch (_) {
      state = state.copyWith(isGeocodingAddress: false);
    }
  }

  /// Calculate distance from user location to collection point
  Future<void> _calculateDistance() async {
    final collectionPoint = state.collectionPoint;

    try {
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();

      if (position != null) {
        final userLocation = UserLocation(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        state = state.copyWith(
          distance: collectionPoint.getDistanceString(
            userLocation,
          ),
        );
      }
    } catch (_) {
      // Location not available, leave distance as null
    }
  }

  /// Load stock items for the collection point
  Future<void> _loadStockItems(String bsuId) async {
    state = state.copyWith(isLoadingStock: true, errorMessage: null);

    try {
      final service = ref.read(collectionPointServiceProvider);
      final stockItems = await service.getCollectionPointStock(bsuId: bsuId);

      state = state.copyWith(
        stockItems: stockItems,
        isLoadingStock: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoadingStock: false,
        errorMessage: e.when(
          network: (message, _) => message,
          server: (message, _) => message,
          client: (message, statusCode, errors) => message,
          unknown: (message, _) => message,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingStock: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Launch maps app with directions to the collection point
  ///
  /// Uses original coordinates if available, otherwise uses geocoded
  /// coordinates, and falls back to address search if neither is available.
  /// Get stock items grouped by category (trimmed)
  Map<String, List<CollectionPointStockModel>> get groupedStockItems {
    final grouped = <String, List<CollectionPointStockModel>>{};
    for (final item in state.stockItems) {
      final category = item.category.trim();
      grouped.putIfAbsent(category, () => []).add(item);
    }
    // Sort alphabetically by category name
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Launch maps app with directions to the collection point
  ///
  /// Uses original coordinates if available, otherwise uses geocoded
  /// coordinates, and falls back to address search if neither is available.
  Future<void> getDirections() async {
    final collectionPoint = state.collectionPoint;
    final urlLauncher = ref.read(urlLauncherServiceProvider);

    // Use original coordinates if available
    if (collectionPoint.hasValidCoordinates) {
      await urlLauncher.launchMap(
        lat: collectionPoint.lat,
        lng: collectionPoint.long,
      );
      return;
    }

    // Use geocoded coordinates if available
    final geocodedLat = state.geocodedLat;
    final geocodedLng = state.geocodedLng;
    if (geocodedLat != null && geocodedLng != null) {
      await urlLauncher.launchMap(lat: geocodedLat, lng: geocodedLng);
      return;
    }

    // Fall back to address search
    final address = collectionPoint.alamatLengkap;
    if (address != null && address.isNotEmpty) {
      await urlLauncher.launchMapWithAddress(address: address);
    }
  }
}
