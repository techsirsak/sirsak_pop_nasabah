import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_stock_model.dart';

part 'drop_point_detail_state.freezed.dart';

@freezed
abstract class DropPointDetailState with _$DropPointDetailState {
  const factory DropPointDetailState({
    required CollectionPointModel collectionPoint,
    @Default([]) List<CollectionPointStockModel> stockItems,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingStock,
    String? errorMessage,
    String? distance,
  }) = _DropPointDetailState;
}
