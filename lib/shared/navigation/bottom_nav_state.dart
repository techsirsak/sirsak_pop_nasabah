import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_nav_state.freezed.dart';

@freezed
abstract class BottomNavState with _$BottomNavState {
  const factory BottomNavState({
    @Default(0) int selectedIndex,
  }) = _BottomNavState;
}
