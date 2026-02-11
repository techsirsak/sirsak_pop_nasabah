import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/auth/login/login_viewmodel.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/password_field.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
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
          context.l10n.signIn,
          style: textTheme.titleLarge?.copyWith(
            fontVariations: AppFonts.semiBold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 32,
          ),
          onPressed: () => context.go(SAppRoutePath.landingPage),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(20),

              // Logo
              Center(
                child: Image.asset(
                  Assets.images.sirsakLogoWhite.path,
                  width: 160,
                  height: 50,
                  fit: BoxFit.cover,
                  color: colorScheme.primary,
                ),
              ),

              const Gap(40),

              // Email Address Field
              Text(
                context.l10n.emailAddress,
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
                            ? context.l10n.emailRequired
                            : state.emailError == 'emailInvalid'
                            ? context.l10n.emailInvalid
                            : state.emailError)
                      : null,
                ),
              ),

              const Gap(20),

              // Password Field
              Text(
                context.l10n.passwordLabel,
                style: textTheme.bodyLarge?.copyWith(
                  fontVariations: AppFonts.medium,
                ),
              ),
              const Gap(8),
              SPasswordField(
                onChanged: viewModel.setPassword,
                onSubmitted: () => unawaited(viewModel.login()),
                errorText: state.passwordError != null
                    ? (state.passwordError == 'passwordRequired'
                          ? context.l10n.passwordRequired
                          : state.passwordError == 'passwordMinLength'
                          ? context.l10n.passwordMinLength
                          : state.passwordError)
                    : null,
              ),

              const Gap(12),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: SButton(
                  text: context.l10n.forgotPassword,
                  onPressed: viewModel.navigateToForgotPassword,
                  variant: ButtonVariant.text,
                  size: ButtonSize.small,
                  isFullWidth: false,
                ),
              ),

              const Gap(24),

              // Sign In Button
              SButton(
                text: context.l10n.signIn,
                onPressed: viewModel.login,
                size: ButtonSize.large,
                isLoading: state.isLoading,
              ),

              // const Gap(12),

              // TODO(devin): enabled when implement sign in with google
              // // Divider with "or" text
              // Row(
              //   children: [
              //     Expanded(
              //       child: Divider(
              //         color: colorScheme.outline.withValues(alpha: 0.3),
              //         thickness: 1,
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 16),
              //       child: Text(
              //         context.l10n.or,
              //         style: textTheme.bodyMedium?.copyWith(
              //           color: colorScheme.onSurfaceVariant,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Divider(
              //         color: colorScheme.outline.withValues(alpha: 0.3),
              //         thickness: 1,
              //       ),
              //     ),
              //   ],
              // ),

              // const Gap(12),

              // // Continue with Google Button (Disabled)
              // SButton(
              //   icon: PhosphorIcons.googleLogo(),
              //   text: context.l10n.continueWithGoogle,
              //   variant: ButtonVariant.outlined,
              //   size: ButtonSize.large,
              // ),
              const Gap(24),

              // Don't have account? Sign Up
              Center(
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(text: context.l10n.dontHaveAccount),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: context.l10n.signUp,
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.tertiary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = viewModel.navigateToSignUp,
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(12),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: context.l10n.landingPageRegisterWithQrButton,
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.tertiary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = viewModel.registerWithQR,
                      ),
                    ],
                  ),
                ),
              ),

              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
