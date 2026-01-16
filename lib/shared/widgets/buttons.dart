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
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
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

  /// Optional custom background color (overrides theme defaults)
  final Color? backgroundColor;

  /// Optional custom foreground color for text/icons (overrides theme defaults)
  final Color? foregroundColor;

  /// Optional custom border radius (overrides default border radius)
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return _ButtonWrapper(
      text: text,
      icon: icon,
      isLoading: isLoading,
      onPressed: onPressed,
      variant: variant,
      size: size,
      isFullWidth: isFullWidth,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderRadius: borderRadius,
    );
  }

  /// Size configuration presets
  static const Map<ButtonSize, _ButtonSizeConfig> _sizeConfigs = {
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
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      fontSize: 16,
      fontVariations: AppFonts.bold,
      iconSize: 20,
      iconGap: 8,
    ),
    ButtonSize.large: _ButtonSizeConfig(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

// ============================================================================
// Content-Level Widget Classes
// ============================================================================

/// Loading indicator with variant-specific color
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({
    required this.variant,
    required this.size,
  });

  final ButtonVariant variant;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorColor = switch (variant) {
      ButtonVariant.primary => Colors.white,
      ButtonVariant.outlined => colorScheme.primaryContainer,
      ButtonVariant.text => colorScheme.tertiary,
    };

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        ),
      ),
    );
  }
}

/// Button label with optional icon
class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel({
    required this.text,
    required this.icon,
    required this.config,
  });

  final String text;
  final IconData? icon;
  final _ButtonSizeConfig config;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Text(text);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: config.iconSize),
        Gap(config.iconGap),
        Flexible(child: Text(text)),
      ],
    );
  }
}

/// Button content that switches between label and loading indicator
class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.text,
    required this.icon,
    required this.isLoading,
    required this.variant,
    required this.config,
  });

  final String text;
  final IconData? icon;
  final bool isLoading;
  final ButtonVariant variant;
  final _ButtonSizeConfig config;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _LoadingIndicator(
        variant: variant,
        size: config.iconSize,
      );
    }

    return _ButtonLabel(
      text: text,
      icon: icon,
      config: config,
    );
  }
}

// ============================================================================
// Button Variant Widget Classes
// ============================================================================

/// ElevatedButton variant for primary buttons
class _ElevatedButtonVariant extends StatelessWidget {
  const _ElevatedButtonVariant({
    required this.text,
    required this.icon,
    required this.isLoading,
    required this.onPressed,
    required this.isFullWidth,
    required this.config,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
  });

  final String text;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final _ButtonSizeConfig config;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: config.height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.primaryContainer,
          foregroundColor: foregroundColor ?? colorScheme.surface,
          disabledBackgroundColor: colorScheme.surfaceContainerHighest,
          disabledForegroundColor: colorScheme.onSurfaceVariant.withValues(
            alpha: 0.38,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          elevation: 0,
          padding: config.padding,
          textStyle: textTheme.titleMedium?.copyWith(
            fontSize: config.fontSize,
            fontVariations: config.fontVariations,
          ),
        ),
        child: _ButtonContent(
          text: text,
          icon: icon,
          isLoading: isLoading,
          variant: ButtonVariant.primary,
          config: config,
        ),
      ),
    );
  }
}

/// OutlinedButton variant for outlined buttons
class _OutlinedButtonVariant extends StatelessWidget {
  const _OutlinedButtonVariant({
    required this.text,
    required this.icon,
    required this.isLoading,
    required this.onPressed,
    required this.isFullWidth,
    required this.config,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
  });

  final String text;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final _ButtonSizeConfig config;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final effectiveOnPressed = isLoading ? null : onPressed;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: config.height,
      child: OutlinedButton(
        onPressed: effectiveOnPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: foregroundColor ?? colorScheme.primaryContainer,
          disabledForegroundColor: colorScheme.onSurfaceVariant.withValues(
            alpha: 0.38,
          ),
          side: BorderSide(
            color: effectiveOnPressed == null
                ? colorScheme.onSurfaceVariant.withValues(alpha: 0.12)
                : (foregroundColor ?? colorScheme.primaryContainer),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          padding: config.padding,
          textStyle: textTheme.titleMedium?.copyWith(
            fontSize: config.fontSize,
            fontVariations: config.fontVariations,
          ),
        ),
        child: _ButtonContent(
          text: text,
          icon: icon,
          isLoading: isLoading,
          variant: ButtonVariant.outlined,
          config: config,
        ),
      ),
    );
  }
}

/// TextButton variant for text buttons
class _TextButtonVariant extends StatelessWidget {
  const _TextButtonVariant({
    required this.text,
    required this.icon,
    required this.isLoading,
    required this.onPressed,
    required this.isFullWidth,
    required this.config,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
  });

  final String text;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final _ButtonSizeConfig config;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: config.height,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: foregroundColor ?? colorScheme.primary,
          disabledForegroundColor: colorScheme.onSurfaceVariant.withValues(
            alpha: 0.38,
          ),
          overlayColor: colorScheme.tertiary.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          padding: config.padding,
          textStyle: textTheme.titleMedium?.copyWith(
            fontSize: config.fontSize,
            fontVariations: config.fontVariations,
          ),
        ),
        child: _ButtonContent(
          text: text,
          icon: icon,
          isLoading: isLoading,
          variant: ButtonVariant.text,
          config: config,
        ),
      ),
    );
  }
}

// ============================================================================
// Button Wrapper Widget
// ============================================================================

/// Wrapper that adds semantics and touch target adjustments
class _ButtonWrapper extends StatelessWidget {
  const _ButtonWrapper({
    required this.text,
    required this.icon,
    required this.isLoading,
    required this.onPressed,
    required this.variant,
    required this.size,
    required this.isFullWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
  });

  final String text;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final config = SButton._sizeConfigs[size]!;

    final button = switch (variant) {
      ButtonVariant.primary => _ElevatedButtonVariant(
        text: text,
        icon: icon,
        isLoading: isLoading,
        onPressed: onPressed,
        isFullWidth: isFullWidth,
        config: config,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        borderRadius: borderRadius,
      ),
      ButtonVariant.outlined => _OutlinedButtonVariant(
        text: text,
        icon: icon,
        isLoading: isLoading,
        onPressed: onPressed,
        isFullWidth: isFullWidth,
        config: config,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        borderRadius: borderRadius,
      ),
      ButtonVariant.text => _TextButtonVariant(
        text: text,
        icon: icon,
        isLoading: isLoading,
        onPressed: onPressed,
        isFullWidth: isFullWidth,
        config: config,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        borderRadius: borderRadius,
      ),
    };

    // Apply touch target size adjustment for small buttons
    final wrappedButton = size == ButtonSize.small
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: button,
          )
        : button;

    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: text,
      child: wrappedButton,
    );
  }
}
