import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/tutorial/tutorial_state.dart';
import 'package:sirsak_pop_nasabah/services/local_storage.dart';

part 'tutorial_viewmodel.g.dart';

@riverpod
class TutorialViewModel extends _$TutorialViewModel {
  @override
  TutorialState build() {
    return const TutorialState();
  }

  void onPageChanged(int page) {
    state = state.copyWith(currentPage: page);
  }

  Future<void> completeTutorial() async {
    state = state.copyWith(isCompleting: true);

    try {
      final localStorage = ref.read(localStorageServiceProvider);
      await localStorage.markTutorialAsSeen();

      ref.read(routerProvider).go(SAppRoutePath.home);
    } catch (e) {
      state = state.copyWith(isCompleting: false);
    }
  }

  Future<void> skipTutorial() async {
    await completeTutorial();
  }
}
