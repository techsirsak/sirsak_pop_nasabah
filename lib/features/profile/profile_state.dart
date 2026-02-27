import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/user/impact_model.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default('') String userName,
    @Default('') String email,
    @Default('') String phoneNumber,
    @Default('') String memberSince,
    @Default(ImpactModel()) ImpactModel impacts,
    @Default([]) List<ProfileBadge> badges,
    @Default(false) bool isLoading,
    @Default(false) bool isLoggingOut,
    @Default(false) bool isDeletingAccount,
    @Default(false) bool isApplyingBsu,
    String? errorMessage,
    String? bsuId,
    String? bsuName,
  }) = _ProfileState;
}

@freezed
abstract class ProfileBadge with _$ProfileBadge {
  const factory ProfileBadge({
    required String id,
    required String name,
    @Default(false) bool isEarned,
  }) = _ProfileBadge;
}
