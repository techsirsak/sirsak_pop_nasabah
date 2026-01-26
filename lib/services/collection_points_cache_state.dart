import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';

part 'collection_points_cache_state.freezed.dart';

/// State for cached collection points
@freezed
abstract class CollectionPointsCacheState with _$CollectionPointsCacheState {
  const factory CollectionPointsCacheState({
    @Default([]) List<CollectionPointModel> points,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _CollectionPointsCacheState;
}
