import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class LocationPermissionBanner extends StatelessWidget {
  const LocationPermissionBanner({
    required this.onOpenSettings,
    super.key,
  });

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: .95),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const Gap(8),
          Flexible(
            child: Text(
              context.l10n.dropPointLocationPermissionMessage,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontVariations: AppFonts.medium,
              ),
            ),
          ),
          const Gap(8),
          TextButton(
            onPressed: onOpenSettings,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              context.l10n.dropPointOpenSettings,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontVariations: AppFonts.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
