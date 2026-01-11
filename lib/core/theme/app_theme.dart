import 'package:flutter/material.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_colors.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/gen/fonts.gen.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = AppColors.lightColorScheme();

    return ThemeData(
      useMaterial3: true,
      fontFamily: FontFamily.montserrat,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
        errorStyle: TextStyle(
          color: colorScheme.error,
          fontSize: 12,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: FontFamily.leagueSpartan,
          fontSize: 32,
          color: colorScheme.onSurface,
          fontVariations: AppFonts.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: FontFamily.leagueSpartan,
          fontSize: 28,
          color: colorScheme.onSurface,
          fontVariations: AppFonts.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: FontFamily.leagueSpartan,
          fontSize: 24,
          color: colorScheme.onSurface,
          fontVariations: AppFonts.bold,
        ),
        headlineLarge: TextStyle(
          fontFamily: FontFamily.montserrat,
          fontSize: 22,
          color: colorScheme.onSurface,
          fontVariations: AppFonts.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: FontFamily.montserrat,
          fontSize: 20,
          color: colorScheme.onSurface,
          fontVariations: AppFonts.semiBold,
        ),
        headlineSmall: TextStyle(
          fontFamily: FontFamily.nunitoSans,
          fontSize: 18,
          color: colorScheme.onSurface,
          fontVariations: AppFonts.semiBold,
        ),
        bodyLarge: TextStyle(
          fontFamily: FontFamily.montserrat,
          fontSize: 16,
          color: colorScheme.onSurface,
          fontVariations: AppFonts.regular,
        ),
        bodyMedium: TextStyle(
          fontFamily: FontFamily.montserrat,
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
          fontVariations: AppFonts.regular,
        ),
        bodySmall: TextStyle(
          fontFamily: FontFamily.montserrat,
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
          fontVariations: AppFonts.regular,
        ),
        labelLarge: TextStyle(
          fontFamily: FontFamily.montserrat,
          fontSize: 14,
          color: colorScheme.onSurface,
          fontVariations: AppFonts.semiBold,
        ),
        labelMedium: TextStyle(
          fontFamily: FontFamily.montserrat,
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
          fontVariations: AppFonts.medium,
        ),
        labelSmall: TextStyle(
          fontFamily: FontFamily.montserrat,
          fontSize: 10,
          color: colorScheme.onSurfaceVariant,
          fontVariations: AppFonts.medium,
        ),
      ),
    );
  }
}
