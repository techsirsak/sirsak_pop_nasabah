import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/models/user/impact_model.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default('') String userName,
    @Default(0) int points,
    @Default(0) int balance,
    @Default(ImpactModel()) ImpactModel impacts,
    Challenge? challenge,
    @Default([]) List<Event> events,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _HomeState;
}

@freezed
abstract class Challenge with _$Challenge {
  const factory Challenge({
    required String title,
    required int current,
    required int total,
    required String itemType,
  }) = _Challenge;
}

@freezed
abstract class Event with _$Event {
  const factory Event({
    required String title,
    required String date,
    required String description,
    String? imageAsset,
  }) = _Event;
}
