import 'package:freezed_annotation/freezed_annotation.dart';

part 'tutorial_state.freezed.dart';

@freezed
abstract class TutorialState with _$TutorialState {
  const factory TutorialState({
    @Default(0) int currentPage,
    @Default(4) int totalPages,
    @Default(false) bool isCompleting,
  }) = _TutorialState;
}
