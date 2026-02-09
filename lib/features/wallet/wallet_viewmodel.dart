import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_state.dart';
import 'package:sirsak_pop_nasabah/features/wallet/widgets/balance_info_dialog.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_history_model.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';
import 'package:sirsak_pop_nasabah/services/dialog_service.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

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
      sirsakPoints: user?.points ?? 0,
      bankSampahBalance: user?.balance ?? 0,
      expiryDate: '31 Dec 2026',
      monthlyBankSampahEarned: calculateMonthlyBankSampahEarned(
        bankSampahHistory,
      ),
      // monthlyPointsEarned: 0,
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
    final logger = ref.read(loggerServiceProvider);
    if (history == null || history.isEmpty) {
      logger.info('Returning 0: history is null or empty');
      return 0;
    }

    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    final filteredTransactions = history.where(
      (transaction) =>
          transaction.createdAt.month == currentMonth &&
          transaction.createdAt.year == currentYear,
    );

    final total = filteredTransactions.fold<double>(
      0,
      (sum, transaction) => transaction.type == TransactionType.debit
          ? sum + transaction.amount
          : sum - transaction.amount,
    );
    logger.info('Total monthly saldo earned: $total');

    return total;
  }
}
