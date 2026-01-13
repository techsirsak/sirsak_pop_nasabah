import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/widget_showcase/widget_showcase_state.dart';

part 'widget_showcase_viewmodel.g.dart';

@riverpod
class WidgetShowcaseViewModel extends _$WidgetShowcaseViewModel {
  @override
  WidgetShowcaseState build() {
    return const WidgetShowcaseState();
  }

  void toggleLoading() {
    state = state.copyWith(isLoading: !state.isLoading);
  }

  void showSnackbar() {
    // This will be called from the view context
    // The view will need to show a snackbar when this is called
  }
}
