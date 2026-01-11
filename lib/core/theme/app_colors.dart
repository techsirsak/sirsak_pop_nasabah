import 'package:flutter/material.dart';

/// Material Design 3 color system for Sirsak Pop Nasabah
///
/// This class defines the app's color palette following Material Design 3 
/// guidelines.
/// All designer colors are preserved and mapped to semantic ColorScheme roles.
///
/// Usage:
/// ```dart
/// // In app_theme.dart
/// colorScheme: AppColors.lightColorScheme()
///
/// // In widgets
/// Theme.of(context).colorScheme.primary
/// Theme.of(context).colorScheme.secondary
/// ```
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ========================================================================
  // Brand Colors (Designer-provided palette)
  // ========================================================================

  /// Primary brand color - Dark green (#325B0C)
  /// Used for: Main actions, app bar, primary buttons
  static const Color _brandGreenDark = Color(0xFF325B0C);

  /// Darker green variant (#254804)
  /// Used for: Text on light green containers, high contrast elements
  static const Color _brandGreenDarker = Color(0xFF254804);

  /// Light green variant (#E4EFDA)
  /// Used for: Card backgrounds, primary container surfaces
  static const Color _brandGreenLight = Color(0xFFE4EFDA);

  /// Orange accent color (#FFB559)
  /// Used for: Secondary actions, highlights, accents
  static const Color _brandOrange = Color(0xFFFFB559);

  /// Light yellow variant (#FDF8E0)
  /// Used for: Info backgrounds, secondary container surfaces
  static const Color _brandYellow = Color(0xFFFDF8E0);

  /// Medium green variant (#709C79)
  /// Used for: Tertiary accents, decorative elements
  static const Color _brandGreenMedium = Color(0xFF709C79);

  // ========================================================================
  // Material Design 3 Light ColorScheme
  // ========================================================================

  /// Creates a complete Material Design 3 ColorScheme for light mode
  static ColorScheme lightColorScheme() {
    return const ColorScheme.light(
      // Primary colors - Main brand identity
      primary: _brandGreenDark, // Main green for CTAs, app bar
      primaryContainer: _brandGreenLight, // Light green containers
      onPrimaryContainer: _brandGreenDarker, // Text on light containers

      // Secondary colors - Accents and secondary actions
      secondary: _brandOrange, // Orange for highlights, secondary CTAs
      secondaryContainer: _brandYellow, // Light yellow for info
      onSecondaryContainer: Color(0xFF2D1600), // Dark brown text

      // Tertiary colors - Alternative accents
      tertiary: _brandGreenMedium, // Medium green decorative
      tertiaryContainer: Color(0xFFD5E8D8), // Very light green
      onTertiaryContainer: Color(0xFF1A3520), // Dark green text

      // Error colors - Validation and error states
      errorContainer: Color(0xFFFFDAD6), // Light red backgrounds
      onErrorContainer: Color(0xFF410002), // Dark red text

      // Surface colors - Backgrounds for components
      onSurface: Color(0xFF1C1B1F), // Primary text (was kcDarkGreyColor)
      // surfaceContainerHighest replaces deprecated surfaceVariant
      surfaceContainerHighest: Color(0xFFE7E0EC), // (was kcVeryLightGrey)
      onSurfaceVariant: Color(0xFF49454F), // Secondary text (kcMediumGrey)

      // Outline colors - Borders and dividers
      outline: Color(0xFF79747E), // Border color (was kcLightGrey)
      outlineVariant: Color(0xFFCAC4D0), // Subtle borders
    );
  }
}
