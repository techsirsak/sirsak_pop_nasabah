import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_state.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({
    required this.state,
    required this.viewModel,
    super.key,
  });

  final ProfileState state;
  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.profilePersonalInfo,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontVariations: AppFonts.bold,
                ),
              ),
              GestureDetector(
                onTap: viewModel.navigateToEditProfile,
                child: Text(
                  l10n.profileEdit,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontVariations: AppFonts.semiBold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          // Info fields
          _InfoField(
            label: l10n.profileNameLabel,
            value: state.userName,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const Gap(16),
          _InfoField(
            label: l10n.profileEmailLabel,
            value: state.email,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const Gap(16),
          _InfoField(
            label: l10n.profilePhoneLabel,
            value: state.phoneNumber,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.label,
    required this.value,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final String value;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontVariations: AppFonts.regular,
          ),
        ),
        const Gap(8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontVariations: AppFonts.regular,
            ),
          ),
        ),
      ],
    );
  }
}
