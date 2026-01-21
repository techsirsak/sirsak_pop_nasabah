import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileFaqTitle,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontVariations: AppFonts.bold,
            ),
          ),
          const Gap(8),
          Text(
            l10n.profileFaqQuestion,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontVariations: AppFonts.regular,
            ),
          ),
          const Gap(4),
          RichText(
            text: TextSpan(
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontVariations: AppFonts.regular,
              ),
              children: [
                TextSpan(text: l10n.profileFaqLinkPre),
                TextSpan(
                  text: l10n.profileFaqLinkText,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontVariations: AppFonts.bold,
                    decoration: TextDecoration.none,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = viewModel.navigateToFaq,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
