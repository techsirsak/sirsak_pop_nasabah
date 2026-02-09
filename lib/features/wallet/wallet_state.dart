import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_history_model.dart';

part 'wallet_state.freezed.dart';

@freezed
abstract class WalletState with _$WalletState {
  const factory WalletState({
    @Default(0) int sirsakPoints,
    @Default(0) int bankSampahBalance,
    String? expiryDate,
    @Default(0) double monthlyBankSampahEarned,
    @Default(0) int monthlyPointsEarned,
    @Default(HistoryTabType.bankSampah) HistoryTabType selectedHistoryTab,
    @Default([]) List<TransactionHistoryModel> pointsHistory,
    @Default([]) List<TransactionHistoryModel> bankSampahHistory,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _WalletState;
}

enum HistoryTabType {
  sirsakPoints,
  bankSampah,
}
