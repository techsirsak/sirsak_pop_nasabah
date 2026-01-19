import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_state.dart';

part 'wallet_viewmodel.g.dart';

@riverpod
class WalletViewModel extends _$WalletViewModel {
  @override
  WalletState build() {
    return WalletState(
      sirsalPoints: 1400,
      bankSampahBalance: 19750,
      expiryDate: '31 Dec 2026',
      monthlyBankSampahEarned: 19750,
      monthlyPointsEarned: 1400,
      pointsHistory: _getMockPointsHistory(),
      bankSampahHistory: _getMockBankSampahHistory(),
    );
  }

  void navigateToWithdraw() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.withdraw));
  }

  void navigateToRewards() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.rewards));
  }

  void showBalanceInfo() {
    // TODO(devin): Show info dialog/modal about balance
  }

  void selectHistoryTab(HistoryTabType tab) {
    state = state.copyWith(selectedHistoryTab: tab);
  }

  Future<void> loadWalletData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // TODO(devin): Fetch from API
      await Future<void>.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  List<TransactionHistory> _getMockPointsHistory() {
    return [
      TransactionHistory(
        id: '1',
        title: 'Drop Point Visit',
        description: 'Recycled 5kg plastic bottles',
        date: DateTime.now(),
        amount: 10000,
        type: TransactionType.credit,
      ),
      TransactionHistory(
        id: '2',
        title: 'Voucher Redemption',
        description: 'Tokopedia voucher 50k',
        date: DateTime.now().subtract(const Duration(days: 1)),
        amount: 5000,
        type: TransactionType.debit,
      ),
      TransactionHistory(
        id: '3',
        title: 'Drop Point Visit',
        description: 'Recycled 3kg paper waste',
        date: DateTime.now().subtract(const Duration(days: 2)),
        amount: 6000,
        type: TransactionType.credit,
      ),
    ];
  }

  List<TransactionHistory> _getMockBankSampahHistory() {
    return [
      TransactionHistory(
        id: '1',
        title: 'Bank Sampah Deposit',
        description: 'Plastic bottles 5kg',
        date: DateTime.now(),
        amount: 15000,
        type: TransactionType.credit,
      ),
      TransactionHistory(
        id: '2',
        title: 'Withdrawal',
        description: 'Transfer to GoPay',
        date: DateTime.now().subtract(const Duration(days: 3)),
        amount: 10000,
        type: TransactionType.debit,
      ),
    ];
  }
}
