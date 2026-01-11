import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'landing_page_state.dart';
import 'landing_page_viewmodel.dart';

final landingPageViewModelProvider =
    StateNotifierProvider<LandingPageViewModel, LandingPageState>((ref) {
  return LandingPageViewModel();
});
