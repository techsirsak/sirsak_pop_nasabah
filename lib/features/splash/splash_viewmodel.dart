import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';

part 'splash_viewmodel.g.dart';

@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  bool build() {
    return false;
  }

  Future<void> initializeSplash() async {
    state = true; // Set loading state

    // Simulate initialization delay (2 seconds)
    await Future<void>.delayed(const Duration(seconds: 2));

    // Navigate to landing page
    final router = ref.read(routerProvider);
    router.go(SAppRoutePath.landingPage);
  }
}
