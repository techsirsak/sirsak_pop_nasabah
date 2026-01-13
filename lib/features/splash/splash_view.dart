import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirsak_pop_nasabah/features/splash/splash_viewmodel.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    // Initialize splash after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ref.read(splashViewModelProvider.notifier).initializeSplash(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    ref.watch(splashViewModelProvider);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sirsak Logo
            Hero(
              tag: 'sirsak_logo',
              child: Image.asset(
                Assets.images.sirsakMainLogoWhite.path,
                height: 160,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
