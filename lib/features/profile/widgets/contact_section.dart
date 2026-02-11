import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/constants/app_constants.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({
    required this.viewModel,
    super.key,
  });

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
          Text(
            l10n.profileContactUs,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontVariations: AppFonts.bold,
            ),
          ),
          const Gap(12),
          _ContactItem(
            label: l10n.profileContactEmail,
            value: sirsakEmailCP,
            onTap: viewModel.openEmail,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const Gap(8),
          _ContactItem(
            label: l10n.profileContactPhone,
            value: sirsakPhoneCP,
            onTap: viewModel.openWhatsApp,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const Gap(8),
          _ContactItem(
            label: l10n.profileContactInstagram,
            value: '@$sirsakIG',
            onTap: viewModel.openInstagram,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.label,
    required this.value,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontVariations: AppFonts.semiBold,
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontVariations: AppFonts.regular,
            ),
          ),
        ],
      ),
    );
  }
}
