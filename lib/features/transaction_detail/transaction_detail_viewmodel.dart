import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/transaction_detail/transaction_detail_state.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_history_model.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_item_model.dart';

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

  /// Load transaction items
  /// Currently returns mock data - replace with API call when endpoint is available
  Future<void> _loadTransactionItems() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // TODO: Replace with actual API call when endpoint is available
      // final service = ref.read(userServiceProvider);
      // final items = await service.getTransactionItems(state.transaction.id);

      // Simulate network delay for mock data
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final items = _getMockItems();

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

  /// Mock data for development
  List<TransactionItemModel> _getMockItems() {
    return [
      const TransactionItemModel(
        id: '1',
        materialName: 'Kardus',
        quantity: 2.0,
        unitOfMeasurement: 'kg',
        unitPrice: 800,
        totalPrice: 1600,
      ),
      const TransactionItemModel(
        id: '2',
        materialName: 'Plastik',
        quantity: 1.5,
        unitOfMeasurement: 'kg',
        unitPrice: 500,
        totalPrice: 750,
      ),
      const TransactionItemModel(
        id: '3',
        materialName: 'Botol PET',
        quantity: 3,
        unitOfMeasurement: 'pcs',
        unitPrice: 200,
        totalPrice: 600,
      ),
    ];
  }
}
