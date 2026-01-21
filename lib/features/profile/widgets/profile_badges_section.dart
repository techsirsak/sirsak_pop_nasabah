import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_state.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class ProfileBadgesSection extends StatelessWidget {
  const ProfileBadgesSection({
    required this.badges,
    super.key,
  });

  final List<ProfileBadge> badges;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIcons.medal(),
              color: Colors.white,
              size: 20,
            ),
            const Gap(8),
            Text(
              l10n.profileBadgesTitle,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontVariations: AppFonts.semiBold,
              ),
            ),
          ],
        ),
        const Gap(12),
        Row(
          children: badges.map((badge) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _BadgeItem(
                badge: badge,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  const _BadgeItem({
    required this.badge,
    required this.colorScheme,
    required this.textTheme,
  });

  final ProfileBadge badge;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.tertiary,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              PhosphorIcons.trophy(PhosphorIconsStyle.fill),
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const Gap(6),
        Text(
          badge.name,
          style: textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontVariations: AppFonts.medium,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
