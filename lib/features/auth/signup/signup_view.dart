import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/auth/signup/signup_state.dart';
import 'package:sirsak_pop_nasabah/features/auth/signup/signup_viewmodel.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class SignUpView extends ConsumerWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signupViewModelProvider);
    final viewModel = ref.read(signupViewModelProvider.notifier);
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
          context.l10n.signUp,
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

              // Full Name Field
              _buildFieldLabel(context, context.l10n.signupFullName),
              const Gap(8),
              _buildTextField(
                onChanged: viewModel.setFullName,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                colorScheme: colorScheme,
                errorText: _mapError(context, state.fullNameError),
              ),

              const Gap(20),

              // Email Address Field
              _buildFieldLabel(context, context.l10n.emailAddress),
              const Gap(8),
              _buildTextField(
                onChanged: viewModel.setEmail,
                keyboardType: TextInputType.emailAddress,
                colorScheme: colorScheme,
                errorText: _mapError(context, state.emailError),
              ),

              const Gap(20),

              // Phone Number Field (Optional)
              _buildFieldLabel(
                context,
                context.l10n.signupPhoneNumber,
                isOptional: true,
              ),
              const Gap(8),
              _buildTextField(
                onChanged: viewModel.setPhoneNumber,
                keyboardType: TextInputType.phone,
                colorScheme: colorScheme,
                errorText: _mapError(context, state.phoneNumberError),
                hintText: context.l10n.signupPhoneHint,
              ),

              const Gap(20),

              // Password Field
              _buildFieldLabel(context, context.l10n.passwordLabel),
              const Gap(8),
              _buildTextField(
                onChanged: viewModel.setPassword,
                obscureText: true,
                colorScheme: colorScheme,
                errorText: _mapError(context, state.passwordError),
              ),

              const Gap(20),

              // Confirm Password Field
              _buildFieldLabel(context, context.l10n.signupConfirmPassword),
              const Gap(8),
              _buildTextField(
                onChanged: viewModel.setConfirmPassword,
                obscureText: true,
                colorScheme: colorScheme,
                errorText: _mapError(context, state.confirmPasswordError),
              ),

              const Gap(20),

              // Terms & Conditions Checkbox
              // _buildTermsCheckbox(
              //   context: context,
              //   state: state,
              //   viewModel: viewModel,
              //   colorScheme: colorScheme,
              //   textTheme: textTheme,
              // ),
              const Gap(24),

              // Sign Up Button
              SButton(
                text: context.l10n.signUp,
                onPressed: viewModel.signUp,
                size: ButtonSize.large,
                isLoading: state.isLoading,
              ),

              const Gap(24),

              // Already have account? Sign In
              Center(
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(text: context.l10n.signupAlreadyHaveAccount),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: context.l10n.signIn,
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.tertiary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = viewModel.navigateToLogin,
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

  // ============================================
  // Helper Widgets
  // ============================================

  Widget _buildFieldLabel(
    BuildContext context,
    String label, {
    bool isOptional = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          label,
          style: textTheme.bodyLarge?.copyWith(
            fontVariations: AppFonts.medium,
          ),
        ),
        if (isOptional) ...[
          const Gap(4),
          Text(
            '(${context.l10n.signupOptional})',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required ValueChanged<String> onChanged,
    required ColorScheme colorScheme,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool obscureText = false,
    String? errorText,
    String? hintText,
  }) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE8EFF5),
        hintText: hintText,
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
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

  // ignore: unused_element
  Widget _buildTermsCheckbox({
    required BuildContext context,
    required SignupState state,
    required SignupViewModel viewModel,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: state.acceptedTerms,
                onChanged: (value) =>
                    viewModel.setAcceptedTerms(value: value ?? false),
                activeColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: GestureDetector(
                onTap: () => viewModel.setAcceptedTerms(
                  value: !state.acceptedTerms,
                ),
                child: RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(text: context.l10n.signupTermsPrefix),
                      TextSpan(
                        text: context.l10n.signupTermsLink,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = viewModel.navigateToTermsAndConditions,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (state.termsError != null) ...[
          const Gap(8),
          Text(
            _mapError(context, state.termsError) ?? '',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  // ============================================
  // Error Mapping (i18n keys to localized strings)
  // ============================================

  String? _mapError(BuildContext context, String? errorKey) {
    if (errorKey == null) return null;

    return switch (errorKey) {
      // Full Name errors
      'fullNameRequired' => context.l10n.signupFullNameRequired,
      'fullNameTooShort' => context.l10n.signupFullNameTooShort,
      // Email errors (reuse from login)
      'emailRequired' => context.l10n.emailRequired,
      'emailInvalid' => context.l10n.emailInvalid,
      // Phone errors
      'phoneNumberInvalid' => context.l10n.signupPhoneInvalid,
      // Password errors (reuse from login)
      'passwordRequired' => context.l10n.passwordRequired,
      'passwordMinLength' => context.l10n.passwordMinLength,
      // Confirm password errors
      'confirmPasswordRequired' => context.l10n.signupConfirmPasswordRequired,
      'passwordsDoNotMatch' => context.l10n.signupPasswordsDoNotMatch,
      // Terms errors
      'termsRequired' => context.l10n.signupTermsRequired,
      // Default fallback
      _ => errorKey,
    };
  }
}
