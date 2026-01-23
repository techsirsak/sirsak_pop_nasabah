import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/auth/verify_email/verify_email_state.dart';
import 'package:sirsak_pop_nasabah/services/url_launcher_service.dart';

part 'verify_email_viewmodel.g.dart';

@riverpod
class VerifyEmailViewModel extends _$VerifyEmailViewModel {
  @override
  VerifyEmailState build() {
    return const VerifyEmailState();
  }

  /// Open the device's email app
  Future<void> openEmailApp() async {
    final urlLauncher = ref.read(urlLauncherServiceProvider);
    await urlLauncher.openEmailApp();
  }

  /// Navigate to login page
  void navigateToLogin() {
    ref.read(routerProvider).go(SAppRoutePath.login);
  }
}
