import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/route_path.dart';

class SplashViewModel extends StateNotifier<bool> {
  SplashViewModel() : super(false);

  Future<void> initializeSplash(GoRouter router) async {
    state = true; // Set loading state

    // Simulate initialization delay (2 seconds)
    await Future<void>.delayed(const Duration(seconds: 2));

    // Navigate to landing page
    router.go(SAppRoutePath.landingPage);
  }
}
