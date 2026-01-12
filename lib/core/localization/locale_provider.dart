import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/localization/locale_state.dart';

part 'locale_provider.g.dart';

/// Notifier for managing app locale
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  LocaleState build() {
    return const LocaleState();
  }

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

/// Convenience provider to access just the locale
///
/// Usage: ref.watch(currentLocaleProvider)
@riverpod
Locale currentLocale(Ref ref) {
  return ref.watch(localeProvider).locale;
}
