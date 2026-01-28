import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_point_stock_model.freezed.dart';
part 'collection_point_stock_model.g.dart';

@freezed
abstract class CollectionPointStockModel with _$CollectionPointStockModel {
  const factory CollectionPointStockModel({
    required String id,
    @JsonKey(name: 'bsu_id') required String bsuId,
    required double weight,
    @JsonKey(name: 'purchase_price') required double purchasePrice,
    @JsonKey(name: 'sell_price') required double sellPrice,
    required String label,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'material_id') required String materialId,
    @JsonKey(name: 'material_name') required String materialName,
    @JsonKey(name: 'waste_code') required String wasteCode,
    required String category,
    @JsonKey(name: 'unit_of_measurement') required String unitOfMeasurement,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _CollectionPointStockModel;

  factory CollectionPointStockModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionPointStockModelFromJson(json);
}
