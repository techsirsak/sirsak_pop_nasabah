import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_showcase_state.freezed.dart';

@freezed
abstract class WidgetShowcaseState with _$WidgetShowcaseState {
  const factory WidgetShowcaseState({
    @Default(false) bool isLoading,
  }) = _WidgetShowcaseState;
}
