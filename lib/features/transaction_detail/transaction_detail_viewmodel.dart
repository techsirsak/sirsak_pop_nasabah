import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/transaction_detail/transaction_detail_state.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_detail_model.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_history_model.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_item_model.dart';
import 'package:sirsak_pop_nasabah/services/user_service.dart';

part 'transaction_detail_viewmodel.g.dart';

@riverpod
class TransactionDetailViewModel extends _$TransactionDetailViewModel {
  @override
  TransactionDetailState build(TransactionHistoryModel transaction) {
    final initialState = TransactionDetailState(
      transaction: transaction,
      isLoading: true,
    );

    // Load items asynchronously after build
    unawaited(
      Future.microtask(() async {
        await _loadTransactionItems();
      }),
    );

    return initialState;
  }

  /// Load transaction items from API
  Future<void> _loadTransactionItems() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final transactionCode = state.transaction.transactionCode;

      // If no transaction code, show empty state
      if (transactionCode == null) {
        state = state.copyWith(items: [], isLoading: false);
        return;
      }

      final userService = ref.read(userServiceProvider);
      final detail = await userService.getTransactionDetail(
        transactionCode: transactionCode,
      );

      // Map TransactionDetailModel to TransactionItemModel
      final items = detail != null
          ? detail.map((e) => e.toTrxItemModel).toList()
          : <TransactionItemModel>[];

      state = state.copyWith(
        items: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
