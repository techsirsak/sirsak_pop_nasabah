import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_history_model.freezed.dart';
part 'transaction_history_model.g.dart';

@freezed
abstract class TransactionHistoryModel with _$TransactionHistoryModel {
  const factory TransactionHistoryModel({
    required String id,
    @JsonKey(name: 'nasabah_details_id') required String nasabahDetailsId,
    required int amount,
    required TransactionType type,
    @JsonKey(name: 'balance_after') required int balanceAfter,
    required String description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'transaction_code') String? transactionCode,
    @JsonKey(name: 'transaction_id') String? transactionId,
  }) = _TransactionHistoryModel;

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionHistoryModelFromJson(json);
}

@JsonEnum(valueField: 'value')
enum TransactionType {
  credit('CREDIT'),
  debit('DEBIT')
  ;

  const TransactionType(this.value);
  final String value;
}
