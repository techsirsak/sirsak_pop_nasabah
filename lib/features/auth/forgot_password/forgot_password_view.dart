import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/auth/forgot_password/forgot_password_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/email_sent_success_view.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');

    // Set initial email in viewmodel if provided
    if (widget.initialEmail != null && widget.initialEmail!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(forgotPasswordViewModelProvider.notifier)
            .setEmail(widget.initialEmail!);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordViewModelProvider);

    if (state.isSuccess) {
      final viewModel = ref.read(forgotPasswordViewModelProvider.notifier);
      final l10n = context.l10n;
      return EmailSentSuccessView(
        title: l10n.forgotPasswordSuccessTitle,
        description: l10n.forgotPasswordSuccessDescription,
        primaryButtonText: l10n.forgotPasswordOpenEmail,
        secondaryButtonText: l10n.forgotPasswordBackToLogin,
        onPrimaryPressed: viewModel.openEmailApp,
        onSecondaryPressed: viewModel.navigateToLogin,
      );
    }

    return _EmailInputScreen(ref: ref, emailController: _emailController);
  }
}

class _EmailInputScreen extends StatelessWidget {
  const _EmailInputScreen({
    required this.ref,
    required this.emailController,
  });

  final WidgetRef ref;
  final TextEditingController emailController;

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
                  controller: emailController,
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
