import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/profile/edit_profile/edit_profile_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class EditProfileView extends ConsumerWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editProfileViewModelProvider);
    final viewModel = ref.read(editProfileViewModelProvider.notifier);
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
          context.l10n.editProfileTitle,
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

              // Full Name Field
              _buildFieldLabel(context, context.l10n.signupFullName),
              const Gap(8),
              _buildTextField(
                initialValue: state.fullName,
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
                initialValue: state.email,
                readOnly: true,
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
                initialValue: state.phoneNumber,
                onChanged: viewModel.setPhoneNumber,
                keyboardType: TextInputType.phone,
                colorScheme: colorScheme,
                errorText: _mapError(context, state.phoneNumberError),
                hintText: context.l10n.signupPhoneHint,
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

              // Save Button
              SButton(
                text: context.l10n.editProfileSaveButton,
                onPressed: viewModel.saveProfile,
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
    String? initialValue,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? errorText,
    String? hintText,
    bool readOnly = false,
  }) {
    return TextFormField(
      readOnly: readOnly,
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
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

  String? _mapError(BuildContext context, String? errorKey) {
    if (errorKey == null) return null;

    return switch (errorKey) {
      // Full Name errors
      'fullNameRequired' => context.l10n.signupFullNameRequired,
      'fullNameTooShort' => context.l10n.signupFullNameTooShort,
      // Email errors
      'emailRequired' => context.l10n.emailRequired,
      'emailInvalid' => context.l10n.emailInvalid,
      // Phone errors
      'phoneNumberInvalid' => context.l10n.signupPhoneInvalid,
      // Default fallback
      _ => errorKey,
    };
  }
}
