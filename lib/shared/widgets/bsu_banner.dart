import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class BsuBanner extends StatelessWidget {
  const BsuBanner({
    required this.bsuName,
    this.isRegistered = false,
    this.onClear,
    super.key,
  });

  final String bsuName;
  final bool isRegistered;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.storefront(),
            color: colorScheme.onPrimaryContainer,
            size: 32,
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRegistered
                      ? context.l10n.registeredAt
                      : context.l10n.signupRegisteringAt,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
                const Gap(2),
                Text(
                  bsuName,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontVariations: AppFonts.semiBold,
                  ),
                ),
              ],
            ),
          ),
          // Clear button
          if (onClear != null)
            IconButton(
              onPressed: onClear,
              icon: Icon(
                PhosphorIcons.x(),
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                size: 20,
              ),
              tooltip: context.l10n.cancel,
            ),
        ],
      ),
    );
  }
}
