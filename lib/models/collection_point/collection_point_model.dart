import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/drop_point_model.dart';

part 'collection_point_model.freezed.dart';
part 'collection_point_model.g.dart';

/// Model representing a collection point (bank sampah)
@freezed
abstract class CollectionPointModel with _$CollectionPointModel {
  const factory CollectionPointModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    String? pengurus,
    @JsonKey(name: 'no_hp') String? noHp,
    @JsonKey(name: 'collection_point_type_id') String? collectionPointTypeId,
    @JsonKey(name: 'address_id') String? addressId,
    @JsonKey(name: 'address_url') String? addressUrl,
    @JsonKey(name: 'next_scheduled_weighing') DateTime? nextScheduledWeighing,
    @JsonKey(name: 'alamat_lengkap') String? alamatLengkap,
    @JsonKey(name: 'map_url') String? mapUrl,
    String? latitude,
    String? longitude,
  }) = _CollectionPointModel;

  factory CollectionPointModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionPointModelFromJson(json);
}

extension CollectionPointModelX on CollectionPointModel {
  double get lat => double.tryParse(latitude ?? '0') ?? 0.0;
  double get long => double.tryParse(longitude ?? '0') ?? 0.0;

  /// Calculate distance between user and drop point using Haversine formula
  double calculateDistanceInKM(
    UserLocation? userLocation,
  ) {
    if (userLocation == null) return double.infinity;
    if (latitude == null || longitude == null) {
      return double.infinity;
    }

    const earthRadius = 6371.0; // km

    final lat1 = userLocation.latitude * pi / 180;
    final lat2 = lat * pi / 180;
    final deltaLat = (lat - userLocation.latitude) * pi / 180;
    final deltaLng = (long - userLocation.longitude) * pi / 180;

    final a =
        sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Get distance string for display
  String getDistanceString(
    UserLocation? userLocation,
  ) {
    final distance = calculateDistanceInKM(userLocation);
    if (distance == double.infinity) return '';
    return distance.toStringAsFixed(1);
  }
}
