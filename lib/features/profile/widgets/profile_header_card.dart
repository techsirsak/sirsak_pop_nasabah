import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// Extension for colorScheme.pointsCardGradient
import 'package:sirsak_pop_nasabah/core/theme/app_colors.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_state.dart';
import 'package:sirsak_pop_nasabah/features/profile/widgets/profile_badges_section.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/string_extensions.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/impacts_stat_row.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    required this.state,
    super.key,
  });

  final ProfileState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: colorScheme.pointsCardGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar and user info row
            Row(
              children: [
                // TODO(devin): implement user profile photo
                // Container(
                //   width: 60,
                //   height: 60,
                //   decoration: BoxDecoration(
                //     color: colorScheme.surfaceContainerHighest,
                //     shape: BoxShape.circle,
                //     border: Border.all(
                //       color: Colors.white.withValues(alpha: 0.3),
                //       width: 2,
                //     ),
                //   ),
                //   child: const Center(
                //     child: Text(
                //       '😊',
                //       style: TextStyle(fontSize: 32),
                //     ),
                //   ),
                // ),
                // const Gap(16),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.userName.firstWord.capitalize,
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontVariations: AppFonts.bold,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        l10n.profileMemberSince(state.memberSince),
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontVariations: AppFonts.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(20),
            // Stats row
            ImpactsStatRow(impact: state.impacts),
            // Badges section
            if (state.badges.isNotEmpty) ...[
              const Gap(20),
              ProfileBadgesSection(badges: state.badges),
            ],
          ],
        ),
      ),
    );
  }
}
