// ignore_for_file: directives_ordering

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sirsak_pop_nasabah/features/landing_page/landing_page_state.dart';

class LandingPageViewModel extends StateNotifier<LandingPageState> {
  LandingPageViewModel() : super(const LandingPageState());

  /// Navigate to login page when "Get Started" button is tapped
  Future<void> navigateToGetStarted(GoRouter router) async {
    state = state.copyWith(isNavigating: true);
    await router.push(SAppRoutePath.login);
    state = state.copyWith(isNavigating: false);
  }

  /// Navigate to login page when "Sign in" button is tapped
  Future<void> navigateToSignIn(GoRouter router) async {
    state = state.copyWith(isNavigating: true);
    await router.push(SAppRoutePath.login);
    state = state.copyWith(isNavigating: false);
  }

  /// Launch email client
  Future<void> launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  /// Launch phone dialer
  Future<void> launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  /// Launch Instagram app or web
  Future<void> launchInstagram(String handle) async {
    final Uri instagramUri = Uri.parse('https://instagram.com/$handle');
    if (await canLaunchUrl(instagramUri)) {
      await launchUrl(instagramUri, mode: LaunchMode.externalApplication);
    }
  }
}
