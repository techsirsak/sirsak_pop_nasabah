import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_state.dart';
import 'package:sirsak_pop_nasabah/features/wallet/widgets/balance_info_dialog.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_history_model.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';
import 'package:sirsak_pop_nasabah/services/dialog_service.dart';

part 'wallet_viewmodel.g.dart';

@riverpod
class WalletViewModel extends _$WalletViewModel {
  @override
  WalletState build() {
    final currentUserState = ref.watch(currentUserProvider);
    final user = currentUserState.user;
    final bankSampahHistory = List<TransactionHistoryModel>.from(
      currentUserState.transactionHistory ?? [],
    )..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return WalletState(
      sirsalPoints: 1400,
      bankSampahBalance: user?.balance ?? 0,
      expiryDate: '31 Dec 2026',
      monthlyBankSampahEarned: calculateMonthlyBankSampahEarned(
        bankSampahHistory,
      ),
      monthlyPointsEarned: 1400,
      pointsHistory: [],
      bankSampahHistory: bankSampahHistory,
    );
  }

  void navigateToWithdraw() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.withdraw));
  }

  void navigateToRewards() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.rewards));
  }

  void showBalanceInfo() {
    unawaited(
      ref
          .read(dialogServiceProvider)
          .showCustomDialog<void>(
            child: const BalanceInfoDialog(),
          ),
    );
  }

  void selectHistoryTab(HistoryTabType tab) {
    state = state.copyWith(selectedHistoryTab: tab);
  }

  double calculateMonthlyBankSampahEarned(
    List<TransactionHistoryModel>? history,
  ) {
    if (history == null || history.isEmpty) return 0;

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    return history
        .where(
          (transaction) =>
              transaction.type == TransactionType.credit &&
              transaction.createdAt.month == currentMonth &&
              transaction.createdAt.year == currentYear,
        )
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }
}
