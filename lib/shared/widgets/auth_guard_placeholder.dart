import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

/// A placeholder widget shown when a user tries to access a protected feature
/// without being authenticated.
///
/// This widget displays a lock icon and a message indicating that login is
/// required. It's used as the background content while the login bottom sheet
/// is displayed.
class AuthGuardPlaceholder extends StatelessWidget {
  const AuthGuardPlaceholder({
    this.onTap,
    super.key,
  });

  /// Optional callback when the placeholder is tapped.
  /// Typically used to show the login bottom sheet.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return GestureDetector(
      onTap: onTap,
      child: ColoredBox(
        color: colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.lock(),
                  size: 40,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(16),
              Text(
                l10n.authGuardLoginRequired,
                style: textTheme.titleMedium?.copyWith(
                  fontVariations: AppFonts.semiBold,
                  color: colorScheme.onSurface,
                ),
              ),
              const Gap(8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  l10n.authGuardLoginMessage,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
