import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/shared/navigation/bottom_nav_state.dart';

part 'bottom_nav_provider.g.dart';

@riverpod
class BottomNavNotifier extends _$BottomNavNotifier {
  @override
  BottomNavState build() {
    return const BottomNavState();
  }

  void setTab(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}
