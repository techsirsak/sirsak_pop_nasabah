import 'package:flutter/material.dart';

/// Font variation constants for variable fonts.
///
/// This class provides semantic font weight variations to be used with
/// variable fonts (Montserrat, League Spartan, Nunito Sans).
///
/// Example usage:
/// ```dart
/// TextStyle(
///   fontFamily: FontFamily.montserrat,
///   fontSize: 16,
///   fontVariations: AppFonts.semiBold,
/// )
/// ```
class AppFonts {
  AppFonts._(); // Private constructor prevents instantiation

  /// Font Variation Presets
  /// Use these instead of inline FontVariation declarations

  /// Thin weight (100) - for very light, delicate text
  static const List<FontVariation> thin = [FontVariation('wght', 100)];

  /// Extra light weight (200) - for light decorative text
  static const List<FontVariation> extraLight = [FontVariation('wght', 200)];

  /// Light weight (300) - for subtle text
  static const List<FontVariation> light = [FontVariation('wght', 300)];

  /// Regular weight (400) - for body text
  static const List<FontVariation> regular = [FontVariation('wght', 400)];

  /// Medium weight (500) - for labels and secondary emphasis
  static const List<FontVariation> medium = [FontVariation('wght', 500)];

  /// Semi-bold weight (600) - for sub-headings and important text
  static const List<FontVariation> semiBold = [FontVariation('wght', 600)];

  /// Bold weight (700) - for headings and emphasis
  static const List<FontVariation> bold = [FontVariation('wght', 700)];

  /// Extra bold weight (800) - for strong emphasis
  static const List<FontVariation> extraBold = [FontVariation('wght', 800)];

  /// Black weight (900) - for maximum emphasis and impact
  static const List<FontVariation> black = [FontVariation('wght', 900)];
}
