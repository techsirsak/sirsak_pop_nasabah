import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({
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
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileAccountTitle,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontVariations: AppFonts.bold,
              ),
            ),
            const Gap(16),
            _AccountRow(
              icon: PhosphorIcons.lock(),
              title: l10n.profileChangePassword,
              subtitle: l10n.profileChangePasswordDesc,
              onTap: viewModel.navigateToChangePassword,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            _AccountRow(
              icon: PhosphorIcons.warning(),
              title: l10n.profileDeleteAccount,
              subtitle: l10n.profileDeleteAccountDesc,
              onTap: viewModel.navigateToDeleteAccount,
              isDestructive: true,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final iconColor = isDestructive ? colorScheme.error : colorScheme.primary;
    final titleColor = isDestructive ? colorScheme.error : colorScheme.onSurface;
    final subtitleColor =
        isDestructive ? colorScheme.error.withValues(alpha: 0.8) : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isDestructive ? colorScheme.error : colorScheme.primary)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      color: titleColor,
                      fontVariations: AppFonts.semiBold,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: subtitleColor,
                      fontVariations: AppFonts.regular,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              PhosphorIcons.caretRight(),
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
