import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/landing_page/landing_page_state.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final router = ref.read(routerProvider);
    await router.push(SAppRoutePath.login);
    state = state.copyWith(isNavigating: false);
  }

  /// Navigate to login page when "Sign in" button is tapped
  Future<void> navigateToSignIn() async {
    state = state.copyWith(isNavigating: true);
    final router = ref.read(routerProvider);
    await router.push(SAppRoutePath.login);
    state = state.copyWith(isNavigating: false);
  }

  /// Launch email client
  Future<void> launchEmail(String email) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  /// Launch phone dialer
  Future<void> launchPhone(String phone) async {
    final phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  /// Launch Instagram app or web
  Future<void> launchInstagram(String handle) async {
    final instagramUri = Uri.parse('https://instagram.com/$handle');
    if (await canLaunchUrl(instagramUri)) {
      await launchUrl(instagramUri, mode: LaunchMode.externalApplication);
    }
  }
}
