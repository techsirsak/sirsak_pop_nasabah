import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_history_model.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_item_model.dart';

part 'transaction_detail_state.freezed.dart';

@freezed
abstract class TransactionDetailState with _$TransactionDetailState {
  const factory TransactionDetailState({
    required TransactionHistoryModel transaction,
    @Default([]) List<TransactionItemModel> items,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _TransactionDetailState;
}
