import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

/// A confirmation dialog for deleting user account.
///
/// Returns `true` when user confirms deletion, `null` when canceled.
class DeleteAccountConfirmationDialog extends StatelessWidget {
  const DeleteAccountConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning icon
            Icon(
              PhosphorIcons.warning(PhosphorIconsStyle.fill),
              color: colorScheme.error,
              size: 48,
            ),
            const Gap(16),
            // Title
            Text(
              l10n.deleteAccountConfirmationTitle,
              style: textTheme.titleLarge?.copyWith(
                fontVariations: AppFonts.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            // Message
            Text(
              l10n.deleteAccountConfirmationMessage,
              style: textTheme.bodyMedium?.copyWith(
                fontVariations: AppFonts.regular,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            // Buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: textTheme.labelLarge?.copyWith(
                        fontVariations: AppFonts.semiBold,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                // Delete button
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.deleteAccountConfirmButton,
                      style: textTheme.labelLarge?.copyWith(
                        fontVariations: AppFonts.semiBold,
                        color: colorScheme.onError,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
