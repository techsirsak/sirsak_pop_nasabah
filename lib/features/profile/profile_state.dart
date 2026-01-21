import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default('') String userName,
    @Default('') String email,
    @Default('') String phoneNumber,
    @Default('') String memberSince,
    @Default(ProfileStats()) ProfileStats stats,
    @Default([]) List<ProfileBadge> badges,
    @Default(false) bool isLoading,
    @Default(false) bool isLoggingOut,
    String? errorMessage,
  }) = _ProfileState;
}

@freezed
abstract class ProfileStats with _$ProfileStats {
  const factory ProfileStats({
    @Default(0.0) double wasteCollected,
    @Default(0.0) double wasteRecycled,
    @Default(0.0) double carbonAvoided,
  }) = _ProfileStats;
}

@freezed
abstract class ProfileBadge with _$ProfileBadge {
  const factory ProfileBadge({
    required String id,
    required String name,
    @Default(false) bool isEarned,
  }) = _ProfileBadge;
}
