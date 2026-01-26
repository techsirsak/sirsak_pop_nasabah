import 'package:freezed_annotation/freezed_annotation.dart';

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
}
