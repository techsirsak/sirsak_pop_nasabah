import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_point_stock_model.freezed.dart';
part 'collection_point_stock_model.g.dart';

@freezed
abstract class CollectionPointStockModel with _$CollectionPointStockModel {
  const factory CollectionPointStockModel({
    required String id,
    required String category,
    required double weight,
    @JsonKey(name: 'bsu_id') required String bsuId,
    @JsonKey(name: 'purchase_price') required double purchasePrice,
    @JsonKey(name: 'sell_price') required double sellPrice,
    @JsonKey(name: 'material_id') required String materialId,
    @JsonKey(name: 'material_name') required String materialName,
    @JsonKey(name: 'waste_code') required String wasteCode,
    @JsonKey(name: 'unit_of_measurement') required String unitOfMeasurement,
    String? label,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _CollectionPointStockModel;

  factory CollectionPointStockModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionPointStockModelFromJson(json);
}
