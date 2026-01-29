import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/models/user/user_model.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/current_user_state.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:sirsak_pop_nasabah/services/user_service.dart';

part 'current_user_provider.g.dart';

/// Notifier for managing current user state globally
///
/// Use `keepAlive: true` to ensure the provider is not disposed
/// when no longer watched, maintaining the user state globally.
@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  CurrentUserState build() {
    return const CurrentUserState();
  }

  /// Fetch user from API and update state
  ///
  /// Returns `true` if successful, `false` otherwise
  Future<bool> fetchCurrentUser() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final userService = ref.read(userServiceProvider);
      final user = await userService.getCurrentUser();

      ref
          .read(loggerServiceProvider)
          .setSentryUser(
            id: user.id,
            email: user.email,
            name: user.namaLengkap,
          );

      // Parallel with Future.wait and records:
      final (impact, transactionHistory) = await (
        userService.getImpact(),
        userService.getTransactionHistory(),
      ).wait;

      state = state.copyWith(
        user: user,
        impact: impact,
        transactionHistory: transactionHistory,
        isLoading: false,
      );

      return true;
    } on ApiException catch (e) {
      ref
          .read(loggerServiceProvider)
          .warning(
            '[CurrentUserNotifier] Failed to fetch user: $e',
          );

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.when(
          network: (message, _) => message,
          server: (message, _) => message,
          client: (message, _, _) => message,
          unknown: (message, _) => message,
        ),
      );

      return false;
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error(
            '[CurrentUserNotifier] Unexpected error fetching user',
            e,
            stackTrace,
          );

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch user data',
      );

      return false;
    }
  }

  /// Set user directly (e.g., from login response if API returns user data)
  void setUser(UserModel user) {
    state = state.copyWith(user: user, errorMessage: null);
  }

  /// Clear user data (on logout)
  void clearUser() {
    unawaited(ref.read(loggerServiceProvider).clearSentryUser());
    state = const CurrentUserState();
  }
}
