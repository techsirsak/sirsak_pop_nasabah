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
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(16),
          ProfileHeaderCard(state: state),
          const Gap(24),
          PersonalInfoSection(state: state, viewModel: viewModel),
          const Gap(24),
          FaqSection(viewModel: viewModel),
          const Gap(24),
          ContactSection(viewModel: viewModel),
          const Gap(24),
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
          const Gap(32),
        ],
      ),
    );
  }
}
