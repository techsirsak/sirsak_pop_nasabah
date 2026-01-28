import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/user/impact_model.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_history_model.dart';
import 'package:sirsak_pop_nasabah/models/user/user_model.dart';

part 'current_user_state.freezed.dart';

@freezed
abstract class CurrentUserState with _$CurrentUserState {
  const factory CurrentUserState({
    UserModel? user,
    @Default(false) bool isLoading,
    String? errorMessage,
    ImpactModel? impact,
    @Default([]) List<TransactionHistoryModel>? transactionHistory,
  }) = _CurrentUserState;
}
