import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirsak_pop_nasabah/features/auth/login/login_state.dart';
import 'package:sirsak_pop_nasabah/features/auth/login/login_viewmodel.dart';

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
      return LoginViewModel();
    });
