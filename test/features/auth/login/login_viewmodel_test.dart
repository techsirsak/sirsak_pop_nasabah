import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirsak_pop_nasabah/features/auth/login/login_viewmodel.dart';

void main() {
  group('LoginViewModel Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should have empty email and password', () {
      final state = container.read(loginViewModelProvider);

      expect(state.email, '');
      expect(state.password, '');
      expect(state.isLoading, false);
      expect(state.errorMessage, null);
    });

    test('setEmail should update email in state', () {
      final viewModel = container.read(loginViewModelProvider.notifier);

      viewModel.setEmail('test@example.com');

      final state = container.read(loginViewModelProvider);
      expect(state.email, 'test@example.com');
      expect(state.emailError, null);
    });

    test('setPassword should update password in state', () {
      final viewModel = container.read(loginViewModelProvider.notifier);

      viewModel.setPassword('password123');

      final state = container.read(loginViewModelProvider);
      expect(state.password, 'password123');
      expect(state.passwordError, null);
    });

    test('setEmail should clear emailError', () {
      final viewModel = container.read(loginViewModelProvider.notifier);

      viewModel.setEmail('test@example.com');

      final state = container.read(loginViewModelProvider);
      expect(state.emailError, null);
    });

    test('setPassword should clear passwordError', () {
      final viewModel = container.read(loginViewModelProvider.notifier);

      viewModel.setPassword('password123');

      final state = container.read(loginViewModelProvider);
      expect(state.passwordError, null);
    });

    test('clearError should clear error message', () {
      final viewModel = container.read(loginViewModelProvider.notifier);

      viewModel.clearError();

      final state = container.read(loginViewModelProvider);
      expect(state.errorMessage, null);
    });
  });
}
