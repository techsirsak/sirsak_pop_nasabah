import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';

part 'collection_points_response.freezed.dart';
part 'collection_points_response.g.dart';

/// Paginated response model for collection points API
@freezed
abstract class CollectionPointsResponse with _$CollectionPointsResponse {
  const factory CollectionPointsResponse({
    required int total,
    required int page,
    required int limit,
    @JsonKey(name: 'total_pages') required int totalPages,
    required List<CollectionPointModel> data,
  }) = _CollectionPointsResponse;

  factory CollectionPointsResponse.fromJson(Map<String, dynamic> json) =>
      _$CollectionPointsResponseFromJson(json);
}
