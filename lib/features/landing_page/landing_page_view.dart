import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/landing_page/landing_page_viewmodel.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/rich_text_helper.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class LandingPageView extends ConsumerWidget {
  const LandingPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.landingpageBackground.path),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: .zero,
            child: Column(
              children: [
                // Sirsak Logo
                Hero(
                  tag: 'sirsak_logo',
                  child: Image.asset(
                    Assets.images.sirsakMainLogoWhite.path,
                    height: 120,
                  ),
                ),
                const Gap(12),

                // Main Title
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(text: l10n.landingPageTitlePart1),
                      TextSpan(
                        text: l10n.landingPageTitlePart2,
                        style: const TextStyle(
                          fontVariations: AppFonts.extraBold,
                        ),
                      ),
                      TextSpan(text: l10n.landingPageTitlePart3),
                    ],
                  ),
                ),
                const Gap(24),

                // Feature 1: Search
                _FeatureItem(
                  icon: PhosphorIcons.mapPin(),
                  text: l10n.landingPageFeature1,
                ),
                const Gap(10),

                // Feature 2: Drop
                _FeatureItem(
                  icon: PhosphorIcons.trash(),
                  text: l10n.landingPageFeature2,
                ),
                const Gap(10),

                // Feature 3: Get points
                _FeatureItem(
                  icon: PhosphorIcons.gift(),
                  text: l10n.landingPageFeature3,
                ),
                const Gap(20),

                // Photo Showcase - Three waste bins
                Image.asset(
                  Assets.images.trashCans.path,
                  height: 150,
                  width: double.infinity,
                  fit: .cover,
                  alignment: .topCenter,
                ),
                const Gap(30),

                // Get Started Button
                SizedBox(
                  width: size.width * 2 / 3,
                  child: SButton(
                    onPressed: () => ref
                        .read(landingPageViewModelProvider.notifier)
                        .navigateToGetStarted(),
                    text: l10n.landingPageGetStartedButton,
                    backgroundColor: colorScheme.surface,
                    foregroundColor: colorScheme.onSurface,
                  ),
                ),
                const Gap(16),

                // Sign In Button (Outlined)
                SizedBox(
                  width: size.width * 2 / 3,
                  child: SButton(
                    onPressed: () => ref
                        .read(landingPageViewModelProvider.notifier)
                        .navigateToSignIn(),
                    variant: .outlined,
                    text: l10n.landingPageSignInButton,
                    foregroundColor: colorScheme.surface,
                  ),
                ),
                const Gap(30),
                // Contact Information
                _ContactLink(
                  icon: PhosphorIcons.envelope(),
                  text: l10n.landingPageContactEmail,
                  onTap: () => ref
                      .read(landingPageViewModelProvider.notifier)
                      .openEmail(),
                ),
                _ContactLink(
                  icon: PhosphorIcons.phone(),
                  text: l10n.landingPageContactPhone,
                  onTap: () => ref
                      .read(landingPageViewModelProvider.notifier)
                      .openWhatsApp(),
                ),
                _ContactLink(
                  icon: PhosphorIcons.instagramLogo(),
                  text: l10n.landingPageContactInstagram,
                  onTap: () => ref
                      .read(landingPageViewModelProvider.notifier)
                      .openInstagram(),
                ),
                const Gap(30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Feature item widget with icon and text (title in bold)
class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Icon container
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),

          Expanded(
            child: RichText(
              text: TextSpan(
                children: parseRichText(
                  text,
                  baseStyle:
                      textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ) ??
                      const TextStyle(color: Colors.white),
                  boldFontVariations: AppFonts.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Contact link widget with icon and text
class _ContactLink extends StatelessWidget {
  const _ContactLink({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
