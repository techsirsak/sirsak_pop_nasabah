import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/detail/drop_point_detail_state.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';
import 'package:sirsak_pop_nasabah/models/drop_point_model.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/collection_point_service.dart';
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
        await _calculateDistance();
        await _loadStockItems(collectionPoint.id);
        state = state.copyWith(isLoading: false);
      }),
    );

    return initialState;
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
  Future<void> getDirections() async {
    final collectionPoint = state.collectionPoint;
    final lat = collectionPoint.lat;
    final lng = collectionPoint.long;

    final urlLauncher = ref.read(urlLauncherServiceProvider);
    await urlLauncher.launchMap(lat: lat, lng: lng);
  }
}
