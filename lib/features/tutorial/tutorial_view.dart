import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/tutorial/tutorial_viewmodel.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/rich_text_helper.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class TutorialView extends ConsumerStatefulWidget {
  const TutorialView({super.key});

  @override
  ConsumerState<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends ConsumerState<TutorialView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    ref.read(tutorialViewModelProvider.notifier).onPageChanged(page);
  }

  Future<void> _handleNext() async {
    final state = ref.read(tutorialViewModelProvider);

    if (state.currentPage < state.totalPages - 1) {
      await _pageController.animateToPage(
        state.currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await ref.read(tutorialViewModelProvider.notifier).completeTutorial();
    }
  }

  Future<void> _handleSkip() async {
    await ref.read(tutorialViewModelProvider.notifier).skipTutorial();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tutorialViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Main PageView
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                _TutorialPage(
                  image: Assets.images.tutorial1.path,
                  title: l10n.tutorialTitle1,
                  description: l10n.tutorialDesc1,
                ),
                _TutorialPage(
                  image: Assets.images.tutorial2.path,
                  title: l10n.tutorialTitle2,
                  description: l10n.tutorialDesc2,
                ),
                _TutorialPage(
                  image: Assets.images.tutorial3.path,
                  title: l10n.tutorialTitle3,
                  description: l10n.tutorialDesc3,
                ),
                _TutorialPage(
                  image: Assets.images.tutorial4.path,
                  title: l10n.tutorialTitle4,
                  description: l10n.tutorialDesc4,
                ),
              ],
            ),

            // Skip button (top-right)
            if (state.currentPage < state.totalPages - 1)
              Positioned(
                top: 16,
                right: 16,
                child: TextButton(
                  onPressed: state.isCompleting ? null : _handleSkip,
                  child: Text(
                    l10n.tutorialSkip,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                      fontVariations: AppFonts.semiBold,
                    ),
                  ),
                ),
              ),

            // Bottom controls (indicators + button)
            Positioned(
              bottom: 60,
              left: 24,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicators
                  _PageIndicator(
                    currentPage: state.currentPage,
                    totalPages: state.totalPages,
                  ),
                  const Gap(32),

                  // Next / Start button
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: state.currentPage == state.totalPages - 1
                        ? SButton(
                            text: l10n.tutorialStartButton,
                            onPressed: state.isCompleting ? null : _handleNext,
                            isLoading: state.isCompleting,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialPage extends StatelessWidget {
  const _TutorialPage({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tutorial image
        Image.asset(
          image,
          width: screenWidth * 0.8,
          fit: BoxFit.contain,
        ),

        const Gap(20),

        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontVariations: AppFonts.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const Gap(16),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: parseRichText(
                description,
                baseStyle:
                    textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ) ??
                    const TextStyle(),
                boldFontVariations: AppFonts.bold,
              ),
            ),
          ),
        ),

        const Gap(120),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) {
          final isActive = index == currentPage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? colorScheme.tertiary
                    : colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        },
      ),
    );
  }
}
