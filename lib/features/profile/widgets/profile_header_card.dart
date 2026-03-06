import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
// Extension for colorScheme.pointsCardGradient
import 'package:sirsak_pop_nasabah/core/theme/app_colors.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/profile/widgets/profile_badges_section.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/services/auth_state_provider.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/string_extensions.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/guest_card.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/impacts_stat_row.dart';

class ProfileHeaderCard extends ConsumerWidget {
  const ProfileHeaderCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final state = ref.watch(profileViewModelProvider);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.landingpageBackground.path),
          fit: .cover,
        ),
        gradient: colorScheme.pointsCardGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(24),
          // Avatar and user info row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // TODO(devin): implement user profile photo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      PhosphorIcons.smiley(),
                      size: 40,
                      color: colorScheme.primary.withValues(alpha: .8),
                    ),
                  ),
                ),
                const Gap(16),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isAuthenticated) ...[
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
                      ] else
                        Text(
                          l10n.guest,
                          style: textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontVariations: AppFonts.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(24),
          // Stats row
          ImpactsStatRow(impact: state.impacts),
          // Badges section
          if (state.badges.isNotEmpty) ...[
            const Gap(24),
            ProfileBadgesSection(badges: state.badges),
          ],

          if (!isAuthenticated) ...[
            const Gap(24),
            const GuestCard(),
          ],
        ],
      ),
    );
  }
}
