import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_item_model.freezed.dart';
part 'transaction_item_model.g.dart';

@freezed
abstract class TransactionItemModel with _$TransactionItemModel {
  const factory TransactionItemModel({
    required String id,
    @JsonKey(name: 'material_name') required String materialName,
    required double quantity,
    @JsonKey(name: 'unit_of_measurement') required String unitOfMeasurement,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'total_price') required double totalPrice,
  }) = _TransactionItemModel;

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemModelFromJson(json);
}
