import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                const SizedBox(height: 24),

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
                        style: const TextStyle(fontVariations: AppFonts.extraBold),
                      ),
                      TextSpan(text: context.l10n.landingPageTitlePart3),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Feature 1: Search
                _FeatureItem(
                  icon: Icons.location_on_outlined,
                  title: context.l10n.landingPageFeature1Title,
                  description: context.l10n.landingPageFeature1Desc,
                ),
                const SizedBox(height: 24),

                // Feature 2: Drop
                _FeatureItem(
                  icon: Icons.delete_outline,
                  title: context.l10n.landingPageFeature2Title,
                  description: context.l10n.landingPageFeature2Desc,
                ),
                const SizedBox(height: 24),

                // Feature 3: Get points
                _FeatureItem(
                  icon: Icons.card_giftcard_outlined,
                  title: context.l10n.landingPageFeature3Title,
                  description: context.l10n.landingPageFeature3Desc,
                ),
                const SizedBox(height: 40),

                // Photo Showcase - Three waste bins
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    Assets.images.trashCans.path,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 40),

                // Get Started Button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
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
                OutlinedButton(
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
                const SizedBox(height: 40),

                // Contact Information
                _ContactLink(
                  icon: Icons.email_outlined,
                  text: context.l10n.landingPageContactEmail,
                  onTap: () => viewModel.launchEmail(
                    context.l10n.landingPageContactEmail,
                  ),
                ),
                const SizedBox(height: 12),
                _ContactLink(
                  icon: Icons.phone_outlined,
                  text: context.l10n.landingPageContactPhone,
                  onTap: () => viewModel.launchPhone('+6287770808578'),
                ),
                const SizedBox(height: 12),
                _ContactLink(
                  icon: Icons.camera_alt_outlined,
                  text: context.l10n.landingPageContactInstagram,
                  onTap: () => viewModel.launchInstagram(
                    context.l10n.landingPageContactInstagram,
                  ),
                ),
                const SizedBox(height: 20),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon container
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),

        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Contact link widget with icon and text
class _ContactLink extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ContactLink({
    required this.icon,
    required this.text,
    required this.onTap,
  });

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
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
