import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/widget_showcase/widget_showcase_viewmodel.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class WidgetShowcaseView extends ConsumerWidget {
  const WidgetShowcaseView({super.key});

  void _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Button pressed!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(widgetShowcaseViewModelProvider);
    final viewModel = ref.read(widgetShowcaseViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          'Widget Showcase',
          style: textTheme.titleLarge?.copyWith(
            fontVariations: AppFonts.semiBold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Buttons Section
              _buildSectionHeader('Buttons', textTheme, colorScheme),
              const Gap(16),

              // Primary Buttons
              _buildSubsectionHeader(
                'Primary Buttons',
                textTheme,
                colorScheme,
              ),
              const Gap(12),

              Text(
                'Large (56px)',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Large Primary Button',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.primary,
                size: ButtonSize.large,
              ),
              const Gap(12),

              Text(
                'Medium (50px) - Default',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Medium Primary Button',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.primary,
                size: ButtonSize.medium,
              ),
              const Gap(12),

              Text(
                'Small (40px)',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Small Primary Button',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.primary,
                size: ButtonSize.small,
              ),
              const Gap(12),

              Text(
                'With Icon',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Add Item',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.primary,
                icon: Icons.add,
              ),
              const Gap(12),

              Text(
                'Loading State',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Loading Button',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.primary,
                isLoading: state.isLoading,
              ),
              const Gap(8),
              SButton(
                text: state.isLoading ? 'Stop Loading' : 'Start Loading',
                onPressed: viewModel.toggleLoading,
                variant: ButtonVariant.primary,
                size: ButtonSize.small,
              ),
              const Gap(12),

              Text(
                'Disabled State',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              const SButton(
                text: 'Disabled Button',
                onPressed: null,
                variant: ButtonVariant.primary,
              ),

              const Gap(32),

              // Outlined Buttons
              _buildSubsectionHeader(
                'Outlined Buttons',
                textTheme,
                colorScheme,
              ),
              const Gap(12),

              Text(
                'Large (56px)',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Large Outlined Button',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.outlined,
                size: ButtonSize.large,
              ),
              const Gap(12),

              Text(
                'Medium (50px)',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Medium Outlined Button',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.outlined,
                size: ButtonSize.medium,
              ),
              const Gap(12),

              Text(
                'Small (40px)',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Small Outlined Button',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.outlined,
                size: ButtonSize.small,
              ),
              const Gap(12),

              Text(
                'With Icon',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Continue with Google',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.outlined,
                icon: Icons.g_mobiledata,
              ),
              const Gap(12),

              Text(
                'Disabled State',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              const SButton(
                text: 'Disabled Outlined',
                onPressed: null,
                variant: ButtonVariant.outlined,
              ),

              const Gap(32),

              // Text Buttons
              _buildSubsectionHeader('Text Buttons', textTheme, colorScheme),
              const Gap(12),

              Text(
                'Large (56px)',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Large Text Button',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.text,
                size: ButtonSize.large,
              ),
              const Gap(12),

              Text(
                'Medium (50px)',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Medium Text Button',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.text,
                size: ButtonSize.medium,
              ),
              const Gap(12),

              Text(
                'Small (40px)',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              SButton(
                text: 'Small Text Button',
                onPressed: () => _showSnackbar(context),
                variant: ButtonVariant.text,
                size: ButtonSize.small,
              ),
              const Gap(12),

              Text(
                'Not Full Width',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              Align(
                alignment: Alignment.centerLeft,
                child: SButton(
                  text: 'Forgot Password?',
                  onPressed: () => _showSnackbar(context),
                  variant: ButtonVariant.text,
                  size: ButtonSize.small,
                  isFullWidth: false,
                ),
              ),
              const Gap(12),

              Text(
                'Disabled State',
                style: textTheme.bodySmall?.copyWith(
                  fontVariations: AppFonts.medium,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(8),
              const SButton(
                text: 'Disabled Text Button',
                onPressed: null,
                variant: ButtonVariant.text,
              ),

              const Gap(40),

              // Color Palette Section
              _buildSectionHeader('Color Palette', textTheme, colorScheme),
              const Gap(16),

              _buildColorSwatch('Primary', colorScheme.primary, colorScheme),
              const Gap(8),
              _buildColorSwatch(
                'Primary Container',
                colorScheme.primaryContainer,
                colorScheme,
              ),
              const Gap(8),
              _buildColorSwatch(
                'Secondary',
                colorScheme.secondary,
                colorScheme,
              ),
              const Gap(8),
              _buildColorSwatch('Tertiary', colorScheme.tertiary, colorScheme),
              const Gap(8),
              _buildColorSwatch('Surface', colorScheme.surface, colorScheme),
              const Gap(8),
              _buildColorSwatch('Outline', colorScheme.outline, colorScheme),

              const Gap(40),

              // Typography Section
              _buildSectionHeader('Typography', textTheme, colorScheme),
              const Gap(16),

              Text(
                'Display Large',
                style: textTheme.displayLarge,
              ),
              const Gap(8),
              Text(
                'Display Medium',
                style: textTheme.displayMedium,
              ),
              const Gap(8),
              Text(
                'Display Small',
                style: textTheme.displaySmall,
              ),
              const Gap(16),
              Text(
                'Headline Large',
                style: textTheme.headlineLarge,
              ),
              const Gap(8),
              Text(
                'Headline Medium',
                style: textTheme.headlineMedium,
              ),
              const Gap(8),
              Text(
                'Headline Small',
                style: textTheme.headlineSmall,
              ),
              const Gap(16),
              Text(
                'Title Large',
                style: textTheme.titleLarge,
              ),
              const Gap(8),
              Text(
                'Title Medium',
                style: textTheme.titleMedium,
              ),
              const Gap(8),
              Text(
                'Title Small',
                style: textTheme.titleSmall,
              ),
              const Gap(16),
              Text(
                'Body Large',
                style: textTheme.bodyLarge,
              ),
              const Gap(8),
              Text(
                'Body Medium',
                style: textTheme.bodyMedium,
              ),
              const Gap(8),
              Text(
                'Body Small',
                style: textTheme.bodySmall,
              ),
              const Gap(16),
              Text(
                'Label Large',
                style: textTheme.labelLarge,
              ),
              const Gap(8),
              Text(
                'Label Medium',
                style: textTheme.labelMedium,
              ),
              const Gap(8),
              Text(
                'Label Small',
                style: textTheme.labelSmall,
              ),

              const Gap(40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: textTheme.headlineSmall?.copyWith(
          fontVariations: AppFonts.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSubsectionHeader(
    String title,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Text(
      title,
      style: textTheme.titleLarge?.copyWith(
        fontVariations: AppFonts.semiBold,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildColorSwatch(
    String name,
    Color color,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: _getContrastColor(color),
              fontVariations: AppFonts.semiBold,
              fontSize: 16,
            ),
          ),
          Text(
            '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
            style: TextStyle(
              color: _getContrastColor(color),
              fontVariations: AppFonts.medium,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getContrastColor(Color color) {
    // Calculate luminance to determine if text should be black or white
    final luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
