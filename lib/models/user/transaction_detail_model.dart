import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_item_model.dart';

part 'transaction_detail_model.freezed.dart';
part 'transaction_detail_model.g.dart';

/// Model representing a party (buyer or seller) in a transaction
@freezed
abstract class TransactionPartyModel with _$TransactionPartyModel {
  const factory TransactionPartyModel({
    required String id,
    @JsonKey(name: 'nama_institusi') String? namaInstitusi,
    @JsonKey(name: 'nama_lengkap') String? namaLengkap,
    String? email,
    @JsonKey(name: 'no_hp') String? noHp,
    @JsonKey(name: 'user_type') String? userType,
  }) = _TransactionPartyModel;

  factory TransactionPartyModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionPartyModelFromJson(json);
}

/// Model representing material details in a transaction
@freezed
abstract class TransactionMaterialModel with _$TransactionMaterialModel {
  const factory TransactionMaterialModel({
    required String id,
    @JsonKey(name: 'material_name') required String materialName,
    required String category,
    @JsonKey(name: 'waste_code') String? wasteCode,
    @JsonKey(name: 'unit_of_measurement') String? unitOfMeasurement,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _TransactionMaterialModel;

  factory TransactionMaterialModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionMaterialModelFromJson(json);
}

/// Model representing detailed transaction information from /nasabah/transactions
@freezed
abstract class TransactionDetailModel with _$TransactionDetailModel {
  const factory TransactionDetailModel({
    required String id,
    required double weight,
    @JsonKey(name: 'price_per_kg') required double pricePerKg,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'transaction_code') required String transactionCode,
    TransactionPartyModel? buyer,
    TransactionPartyModel? seller,
    TransactionMaterialModel? material,
  }) = _TransactionDetailModel;

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionDetailModelFromJson(json);
}

/// Paginated response wrapper for transaction detail API
@freezed
abstract class TransactionDetailResponse with _$TransactionDetailResponse {
  const factory TransactionDetailResponse({
    required int total,
    required int page,
    required int limit,
    @JsonKey(name: 'total_pages') required int totalPages,
    required List<TransactionDetailModel> data,
  }) = _TransactionDetailResponse;

  factory TransactionDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionDetailResponseFromJson(json);
}

extension TransactionDetailModelX on TransactionDetailModel {
  TransactionItemModel get toTrxItemModel {
    return TransactionItemModel(
      id: id,
      materialName: material?.materialName ?? '',
      quantity: weight,
      unitOfMeasurement: material?.unitOfMeasurement ?? 'kg',
      unitPrice: pricePerKg,
      totalPrice: totalPrice,
    );
  }
}
