import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/landing_page/landing_page_state.dart';
import 'package:sirsak_pop_nasabah/services/url_launcher_service.dart';

part 'landing_page_viewmodel.g.dart';

@riverpod
class LandingPageViewModel extends _$LandingPageViewModel {
  @override
  LandingPageState build() {
    return const LandingPageState();
  }

  /// Navigate to login page when "Get Started" button is tapped
  Future<void> navigateToGetStarted() async {
    state = state.copyWith(isNavigating: true);
    ref.read(routerProvider).push(SAppRoutePath.home);
    state = state.copyWith(isNavigating: false);
  }

  /// Navigate to login page when "Sign in" button is tapped
  Future<void> navigateToSignIn() async {
    state = state.copyWith(isNavigating: true);
    ref.read(routerProvider).push(SAppRoutePath.login);
    state = state.copyWith(isNavigating: false);
  }

  void openWhatsApp() {
    ref.read(urlLauncherServiceProvider).contactSirsakWA();
  }

  void openEmail() {
    ref.read(urlLauncherServiceProvider).openEmailSirsak();
  }

  void openInstagram() {
    ref.read(urlLauncherServiceProvider).openSirsakInstagram();
  }
}
