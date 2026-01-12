import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/landing_page/landing_page_viewmodel.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class LandingPageView extends ConsumerWidget {
  const LandingPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(landingPageViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.landingpageBackground.path),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Sirsak Logo
                Image.asset(
                  Assets.images.sirsakLogoWhite.path,
                  height: 120,
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
                      TextSpan(text: context.l10n.landingPageTitlePart1),
                      TextSpan(
                        text: context.l10n.landingPageTitlePart2,
                        style: const TextStyle(
                          fontVariations: AppFonts.extraBold,
                        ),
                      ),
                      TextSpan(text: context.l10n.landingPageTitlePart3),
                    ],
                  ),
                ),
                const Gap(30),

                // Feature 1: Search
                _FeatureItem(
                  icon: PhosphorIcons.mapPin(),
                  title: context.l10n.landingPageFeature1Title,
                  description: context.l10n.landingPageFeature1Desc,
                ),
                const Gap(20),

                // Feature 2: Drop
                _FeatureItem(
                  icon: PhosphorIcons.trash(),
                  title: context.l10n.landingPageFeature2Title,
                  description: context.l10n.landingPageFeature2Desc,
                ),
                const Gap(20),

                // Feature 3: Get points
                _FeatureItem(
                  icon: PhosphorIcons.gift(),
                  title: context.l10n.landingPageFeature3Title,
                  description: context.l10n.landingPageFeature3Desc,
                ),
                const Gap(30),

                // Photo Showcase - Three waste bins
                Image.asset(
                  Assets.images.trashCans.path,
                  // height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const Gap(40),

                // Get Started Button
                Container(
                  width: size.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: viewModel.navigateToGetStarted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: colorScheme.primary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      context.l10n.landingPageGetStartedButton,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign In Button (Outlined)
                SizedBox(
                  width: size.width / 2,
                  child: OutlinedButton(
                    onPressed: viewModel.navigateToSignIn,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      context.l10n.landingPageSignInButton,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Gap(30),
                // Contact Information
                _ContactLink(
                  icon: PhosphorIcons.envelope(),
                  text: context.l10n.landingPageContactEmail,
                  onTap: () => viewModel.launchEmail(
                    context.l10n.landingPageContactEmail,
                  ),
                ),
                _ContactLink(
                  icon: PhosphorIcons.phone(),
                  text: context.l10n.landingPageContactPhone,
                  onTap: () => viewModel.launchPhone('+6287770808578'),
                ),
                _ContactLink(
                  icon: PhosphorIcons.instagramLogo(),
                  text: context.l10n.landingPageContactInstagram,
                  onTap: () => viewModel.launchInstagram(
                    context.l10n.landingPageContactInstagram,
                  ),
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

/// Feature item widget with icon, title, and description
class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                text: title,
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: ' $description',
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
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
