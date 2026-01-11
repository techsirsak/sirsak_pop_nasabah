import 'package:freezed_annotation/freezed_annotation.dart';

part 'landing_page_state.freezed.dart';

@freezed
class LandingPageState with _$LandingPageState {
  const factory LandingPageState({
    @Default(false) bool isNavigating,
  }) = _LandingPageState;
}
