import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/profile/change_password/change_password_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class ChangePasswordView extends ConsumerWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changePasswordViewModelProvider);
    final viewModel = ref.read(changePasswordViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        shape: Border(
          bottom: BorderSide(
            color: colorScheme.outline,
          ),
        ),
        title: Text(
          context.l10n.changePasswordTitle,
          style: textTheme.titleLarge?.copyWith(
            fontVariations: AppFonts.semiBold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(40),

              // New Password Field
              _buildFieldLabel(context, context.l10n.changePasswordNewPassword),
              const Gap(8),
              _buildTextField(
                onChanged: viewModel.setPassword,
                obscureText: true,
                colorScheme: colorScheme,
                errorText: _mapError(context, state.passwordError),
              ),

              const Gap(20),

              // Confirm Password Field
              _buildFieldLabel(
                context,
                context.l10n.changePasswordConfirmPassword,
              ),
              const Gap(8),
              _buildTextField(
                onChanged: viewModel.setConfirmPassword,
                obscureText: true,
                colorScheme: colorScheme,
                errorText: _mapError(context, state.confirmPasswordError),
              ),

              const Gap(32),

              // Error Message
              if (state.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.errorMessage!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                const Gap(16),
              ],

              // Change Password Button
              SButton(
                text: context.l10n.changePasswordButton,
                onPressed: viewModel.changePassword,
                size: ButtonSize.large,
                isLoading: state.isLoading,
              ),

              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    final textTheme = Theme.of(context).textTheme;

    return Text(
      label,
      style: textTheme.bodyLarge?.copyWith(
        fontVariations: AppFonts.medium,
      ),
    );
  }

  Widget _buildTextField({
    required ValueChanged<String> onChanged,
    required ColorScheme colorScheme,
    bool obscureText = false,
    String? errorText,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE8EFF5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorText: errorText,
      ),
    );
  }

  String? _mapError(BuildContext context, String? errorKey) {
    if (errorKey == null) return null;

    return switch (errorKey) {
      'passwordRequired' => context.l10n.passwordRequired,
      'passwordMinLength' => context.l10n.passwordMinLength,
      'confirmPasswordRequired' => context.l10n.signupConfirmPasswordRequired,
      'passwordsDoNotMatch' => context.l10n.signupPasswordsDoNotMatch,
      _ => errorKey,
    };
  }
}
