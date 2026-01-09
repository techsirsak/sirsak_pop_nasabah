import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirsak_pop_nasabah/core/localization/locale_state.dart';

/// StateNotifier for managing app locale
class LocaleNotifier extends StateNotifier<LocaleState> {
  LocaleNotifier() : super(const LocaleState());

  /// Switch to English locale
  void setEnglish() {
    state = state.copyWith(locale: const Locale('en'));
  }

  /// Switch to Indonesian locale
  void setIndonesian() {
    state = state.copyWith(locale: const Locale('id'));
  }

  /// Set custom locale
  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
  }

  /// Toggle between English and Indonesian
  void toggleLocale() {
    final currentLanguageCode = state.locale.languageCode;
    if (currentLanguageCode == 'en') {
      setIndonesian();
    } else {
      setEnglish();
    }
  }
}

/// Provider for locale management
///
/// Usage:
/// - Read current locale: ref.watch(localeProvider).locale
/// - Change locale: ref.read(localeProvider.notifier).setEnglish()
/// - Toggle locale: ref.read(localeProvider.notifier).toggleLocale()
final localeProvider =
    StateNotifierProvider<LocaleNotifier, LocaleState>((ref) {
  return LocaleNotifier();
});

/// Convenience provider to access just the locale
///
/// Usage: ref.watch(currentLocaleProvider)
final currentLocaleProvider = Provider<Locale>((ref) {
  return ref.watch(localeProvider).locale;
});
