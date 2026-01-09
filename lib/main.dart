import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirsak_pop_nasabah/core/localization/locale_provider.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_theme.dart';
import 'package:sirsak_pop_nasabah/gen/l10n/app_localizations.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final router = ref.watch(routerProvider);
    final locale = ref.watch(currentLocaleProvider);

    return MaterialApp.router(
      title: l10n.appName,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],
    );
  }
}
