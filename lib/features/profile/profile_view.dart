import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/profile/widgets/account_section.dart';
import 'package:sirsak_pop_nasabah/features/profile/widgets/contact_section.dart';
import 'package:sirsak_pop_nasabah/features/profile/widgets/faq_section.dart';
import 'package:sirsak_pop_nasabah/features/profile/widgets/personal_info_section.dart';
import 'package:sirsak_pop_nasabah/features/profile/widgets/profile_header_card.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/services/auth_state_provider.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/app_version_test.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final state = ref.watch(profileViewModelProvider);
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(16),
          const ProfileHeaderCard(),
          const Gap(24),
          if (isAuthenticated) ...[
            PersonalInfoSection(state: state, viewModel: viewModel),
            const Gap(24),
          ],
          FaqSection(viewModel: viewModel),
          const Gap(24),
          ContactSection(viewModel: viewModel),
          const Gap(24),
          if (isAuthenticated) ...[
            AccountSection(viewModel: viewModel),
            const Gap(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SButton(
                text: l10n.profileLogout,
                onPressed: viewModel.logout,
                size: ButtonSize.large,
                isLoading: state.isLoggingOut,
              ),
            ),
          ],

          const Gap(24),
          // App Version
          const Align(
            alignment: .bottomCenter,
            child: AppVersionText(),
          ),
          const Gap(32),
        ],
      ),
    );
  }
}
