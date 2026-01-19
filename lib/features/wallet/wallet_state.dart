import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_state.freezed.dart';

@freezed
abstract class WalletState with _$WalletState {
  const factory WalletState({
    @Default(0) int sirsalPoints,
    @Default(0) double bankSampahBalance,
    String? expiryDate,
    @Default(0) double monthlyBankSampahEarned,
    @Default(0) int monthlyPointsEarned,
    @Default(HistoryTabType.sirsalPoints) HistoryTabType selectedHistoryTab,
    @Default([]) List<TransactionHistory> pointsHistory,
    @Default([]) List<TransactionHistory> bankSampahHistory,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _WalletState;
}

enum HistoryTabType {
  sirsalPoints,
  bankSampah,
}

@freezed
abstract class TransactionHistory with _$TransactionHistory {
  const factory TransactionHistory({
    required String id,
    required String title,
    required String description,
    required DateTime date,
    required double amount,
    required TransactionType type,
    String? iconAsset,
  }) = _TransactionHistory;
}

enum TransactionType {
  credit,
  debit,
}
