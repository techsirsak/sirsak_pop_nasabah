import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';

part 'auth_state_provider.g.dart';

/// Provider that derives authentication status from the current user state.
///
/// Returns `true` if a user is logged in, `false` otherwise.
/// This provider automatically updates when the user logs in or out.
@riverpod
bool isAuthenticated(Ref ref) {
  final currentUserState = ref.watch(currentUserProvider);
  return currentUserState.user != null;
}
