import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirsak_pop_nasabah/features/splash/splash_viewmodel.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, bool>((
  ref,
) {
  return SplashViewModel();
});
