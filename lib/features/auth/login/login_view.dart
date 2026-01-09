import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/auth/login/login_provider.dart';
import 'package:sirsak_pop_nasabah/shared/ui_helpers.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/custom_button.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/custom_text_field.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final router = ref.read(routerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceMassive,

              // Logo/Branding
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: .1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: 60,
                        color: colorScheme.primary,
                      ),
                    ),
                    verticalSpaceMedium,
                    Text(
                      'appName',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    verticalSpaceSmall,
                    Text(
                      'loginTitle',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              verticalSpaceLarge,
              verticalSpaceMedium,

              // Email Field
              CustomTextField(
                label: 'emailLabel',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                errorText: state.emailError,
                prefixIcon: const Icon(Icons.email_outlined),
                onChanged: viewModel.setEmail,
              ),

              verticalSpaceMedium,

              // Password Field
              CustomTextField(
                label: 'passwordLabel',
                hintText: 'Enter your password',
                obscureText: true,
                errorText: state.passwordError,
                prefixIcon: const Icon(Icons.lock_outlined),
                onChanged: viewModel.setPassword,
              ),

              verticalSpaceMedium,

              // Error Message
              if (state.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
              ],

              // Login Button
              CustomButton(
                text: 'loginButton',
                isLoading: state.isLoading,
                icon: Icons.login,
                onPressed: () => viewModel.login(router),
              ),

              verticalSpaceMedium,

              // Additional info (optional)
              Center(
                child: Text(
                  'Version 0.1.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
