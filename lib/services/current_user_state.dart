import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/user/user_model.dart';

part 'current_user_state.freezed.dart';

@freezed
abstract class CurrentUserState with _$CurrentUserState {
  const factory CurrentUserState({
    UserModel? user,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _CurrentUserState;
}
