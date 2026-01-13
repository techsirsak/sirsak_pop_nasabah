import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';

/// Button visual variants following Material Design 3
enum ButtonVariant {
  /// Filled button with primary background (ElevatedButton)
  /// Use for: Primary CTAs, main actions
  primary,

  /// Button with border outline (OutlinedButton)
  /// Use for: Secondary actions, alternative choices
  outlined,

  /// Text-only button with no background (TextButton)
  /// Use for: Tertiary actions, links, less emphasis
  text,
}

/// Button size presets defining height, padding, and typography
enum ButtonSize {
  /// Small button: 40px height
  /// Use for: Compact UIs, secondary actions in tight spaces
  small,

  /// Medium button: 50px height (default)
  /// Use for: Most standard buttons, forms, cards
  medium,

  /// Large button: 56px height
  /// Use for: Primary CTAs on key screens, login/signup
  large,
}

/// Comprehensive button component with multiple variants and sizes.
///
/// This component replaces the deprecated `CustomButton` with a more
/// comprehensive design system that supports three visual variants
/// (primary, outlined, text) in three size options (small, medium, large).
///
/// ## Features
/// - Three button variants (Primary, Outlined, Text)
/// - Three size options (Small, Medium, Large)
/// - Loading state support with themed indicators
/// - Icon support with proper spacing
/// - Full accessibility (touch targets, semantics, focus)
/// - Follows Material Design 3 guidelines
///
/// ## Usage Examples
///
/// ### 1. Primary button (most common - form submissions, CTAs):
/// ```dart
/// SButton(
///   text: context.l10n.submit,
///   onPressed: viewModel.handleSubmit,
///   variant: ButtonVariant.primary,
///   size: ButtonSize.large,
///   isLoading: state.isSubmitting,
/// )
/// ```
///
/// ### 2. Outlined button (secondary actions):
/// ```dart
/// SButton(
///   text: context.l10n.continueWithGoogle,
///   onPressed: viewModel.signInWithGoogle,
///   variant: ButtonVariant.outlined,
///   size: ButtonSize.medium,
///   icon: Icons.g_mobiledata,
/// )
/// ```
///
/// ### 3. Text button (tertiary actions, navigation links):
/// ```dart
/// SButton(
///   text: context.l10n.forgotPassword,
///   onPressed: viewModel.navigateToForgotPassword,
///   variant: ButtonVariant.text,
///   size: ButtonSize.small,
///   isFullWidth: false,
/// )
/// ```
///
/// ### 4. With icon:
/// ```dart
/// SButton(
///   text: context.l10n.addItem,
///   onPressed: viewModel.addItem,
///   variant: ButtonVariant.primary,
///   icon: Icons.add,
/// )
/// ```
///
/// ### 5. Disabled button:
/// ```dart
/// SButton(
///   text: context.l10n.submit,
///   onPressed: null,  // null disables button
///   variant: ButtonVariant.primary,
/// )
/// ```
class SButton extends StatelessWidget {
  const SButton({
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    super.key,
  });

  /// Button label text (should be localized)
  final String text;

  /// Callback when button is pressed (null disables button)
  final VoidCallback? onPressed;

  /// Visual style of the button (primary, outlined, text)
  final ButtonVariant variant;

  /// Size preset (small, medium, large)
  final ButtonSize size;

  /// Shows loading indicator when true (also disables button)
  final bool isLoading;

  /// Optional leading icon before text
  final IconData? icon;

  /// Whether button should take full width of parent
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: text,
      child: _buildButton(context),
    );
  }

  /// Builds the appropriate Material button based on variant
  Widget _buildButton(BuildContext context) {
    final button = switch (variant) {
      ButtonVariant.primary => _buildElevatedButton(context),
      ButtonVariant.outlined => _buildOutlinedButton(context),
      ButtonVariant.text => _buildTextButton(context),
    };

    // Apply touch target size adjustment for small buttons
    return _applyTouchTarget(button);
  }

  /// Builds an ElevatedButton for primary variant
  Widget _buildElevatedButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final config = _sizeConfigs[size]!;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: config.height,
      child: ElevatedButton(
        onPressed: _getEffectiveOnPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colorScheme.surfaceContainerHighest,
          disabledForegroundColor:
              colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          padding: config.padding,
          textStyle: TextStyle(
            fontSize: config.fontSize,
            fontVariations: config.fontVariations,
          ),
        ),
        child: _buildContent(context),
      ),
    );
  }

  /// Builds an OutlinedButton for outlined variant
  Widget _buildOutlinedButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final config = _sizeConfigs[size]!;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: config.height,
      child: OutlinedButton(
        onPressed: _getEffectiveOnPressed(),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primaryContainer,
          disabledForegroundColor:
              colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
          side: BorderSide(
            color: _getEffectiveOnPressed() == null
                ? colorScheme.onSurfaceVariant.withValues(alpha: 0.12)
                : colorScheme.primaryContainer,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: config.padding,
          textStyle: TextStyle(
            fontSize: config.fontSize,
            fontVariations: config.fontVariations,
          ),
        ),
        child: _buildContent(context),
      ),
    );
  }

  /// Builds a TextButton for text variant
  Widget _buildTextButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final config = _sizeConfigs[size]!;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: config.height,
      child: TextButton(
        onPressed: _getEffectiveOnPressed(),
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.tertiary,
          disabledForegroundColor:
              colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
          overlayColor: colorScheme.tertiary.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: config.padding,
          textStyle: TextStyle(
            fontSize: config.fontSize,
            fontVariations: config.fontVariations,
          ),
        ),
        child: _buildContent(context),
      ),
    );
  }

  /// Builds the button content (text, icon, or loading indicator)
  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingIndicator(Theme.of(context).colorScheme);
    }
    return _buildButtonContent();
  }

  /// Builds the text and optional icon
  Widget _buildButtonContent() {
    final config = _sizeConfigs[size]!;

    if (icon == null) {
      // Text only
      return Text(text);
    }

    // Icon + Text
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: config.iconSize),
        Gap(config.iconGap),
        Text(text),
      ],
    );
  }

  /// Builds a loading indicator with variant-specific color
  Widget _buildLoadingIndicator(ColorScheme colorScheme) {
    final indicatorColor = _getLoadingIndicatorColor(colorScheme);
    final config = _sizeConfigs[size]!;

    // Indicator size is 60% of button height for visual balance
    final indicatorSize = config.height * 0.6;

    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    );
  }

  /// Gets the appropriate loading indicator color based on variant
  Color _getLoadingIndicatorColor(ColorScheme colorScheme) {
    return switch (variant) {
      ButtonVariant.primary => Colors.white,
      ButtonVariant.outlined => colorScheme.primaryContainer,
      ButtonVariant.text => colorScheme.tertiary,
    };
  }

  /// Gets the effective onPressed callback (null if loading or disabled)
  VoidCallback? _getEffectiveOnPressed() {
    if (isLoading || onPressed == null) {
      return null;
    }
    return onPressed;
  }

  /// Adds vertical padding to small buttons to meet minimum touch target size
  Widget _applyTouchTarget(Widget button) {
    if (size == ButtonSize.small) {
      // Add 8px vertical padding to reach 48px minimum (40px + 8px = 48px)
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: button,
      );
    }
    // Medium (50px) and Large (56px) already meet minimum
    return button;
  }

  /// Size configuration presets
  static const _sizeConfigs = {
    ButtonSize.small: _ButtonSizeConfig(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      fontSize: 14,
      fontVariations: AppFonts.semiBold,
      iconSize: 18,
      iconGap: 8,
    ),
    ButtonSize.medium: _ButtonSizeConfig(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      fontSize: 16,
      fontVariations: AppFonts.semiBold,
      iconSize: 20,
      iconGap: 8,
    ),
    ButtonSize.large: _ButtonSizeConfig(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      fontSize: 16,
      fontVariations: AppFonts.bold,
      iconSize: 24,
      iconGap: 12,
    ),
  };
}

/// Internal configuration for button sizes
class _ButtonSizeConfig {
  const _ButtonSizeConfig({
    required this.height,
    required this.padding,
    required this.fontSize,
    required this.fontVariations,
    required this.iconSize,
    required this.iconGap,
  });

  final double height;
  final EdgeInsets padding;
  final double fontSize;
  final List<FontVariation> fontVariations;
  final double iconSize;
  final double iconGap;
}
