import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/auth/forgot_password/forgot_password_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class ForgotPasswordView extends ConsumerWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgotPasswordViewModelProvider);

    if (state.isSuccess) {
      return _SuccessScreen(ref: ref);
    }

    return _EmailInputScreen(ref: ref);
  }
}

class _EmailInputScreen extends StatelessWidget {
  const _EmailInputScreen({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordViewModelProvider);
    final viewModel = ref.read(forgotPasswordViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return AbsorbPointer(
      absorbing: state.isLoading,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          shape: Border(
            bottom: BorderSide(
              color: colorScheme.outline,
            ),
          ),
          title: Text(
            l10n.forgotPasswordTitle,
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
                const Gap(32),

                // Description
                Text(
                  l10n.forgotPasswordDescription,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Gap(32),

                // Email Address Field
                Text(
                  l10n.emailAddress,
                  style: textTheme.bodyLarge?.copyWith(
                    fontVariations: AppFonts.medium,
                  ),
                ),
                const Gap(8),
                TextField(
                  onChanged: viewModel.setEmail,
                  keyboardType: TextInputType.emailAddress,
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
                    errorText: state.emailError != null
                        ? (state.emailError == 'emailRequired'
                              ? l10n.emailRequired
                              : state.emailError == 'emailInvalid'
                              ? l10n.emailInvalid
                              : state.emailError)
                        : null,
                  ),
                ),

                const Gap(32),

                // Send Reset Link Button
                SButton(
                  text: l10n.forgotPasswordSendLink,
                  onPressed: viewModel.requestPasswordReset,
                  size: ButtonSize.large,
                  isLoading: state.isLoading,
                ),

                const Gap(16),

                // Back to Login Button
                SButton(
                  text: l10n.forgotPasswordBackToLogin,
                  onPressed: () => Navigator.of(context).pop(),
                  variant: ButtonVariant.outlined,
                  size: ButtonSize.large,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessScreen extends StatelessWidget {
  const _SuccessScreen({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(forgotPasswordViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              const Gap(48),
              // Email Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.envelopeSimple(),
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),
              const Gap(32),
              // Title
              Text(
                l10n.forgotPasswordSuccessTitle,
                style: textTheme.titleLarge?.copyWith(
                  fontVariations: AppFonts.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              // Description
              Text(
                l10n.forgotPasswordSuccessDescription,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Open Email App Button
              SButton(
                onPressed: viewModel.openEmailApp,
                text: l10n.forgotPasswordOpenEmail,
              ),
              const Gap(16),
              // Go to Login Button
              SButton(
                onPressed: viewModel.navigateToLogin,
                variant: ButtonVariant.outlined,
                text: l10n.forgotPasswordBackToLogin,
              ),
              const Gap(48),
            ],
          ),
        ),
      ),
    );
  }
}
