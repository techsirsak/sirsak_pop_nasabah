import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sirsak_pop_nasabah/core/config/env_config.dart';
import 'package:sirsak_pop_nasabah/core/localization/locale_provider.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_theme.dart';
import 'package:sirsak_pop_nasabah/gen/l10n/app_localizations.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:toastification/toastification.dart';

Future<void> bootstrap({
  required String env,
  required String baseApiUrl,
}) async {
  // Create logger instance for bootstrap (before Riverpod is available)
  final logger = LoggerService();

  // Initialize environment config before ProviderScope
  initEnvConfig(baseApiUrl: baseApiUrl, env: env);
  logger.info('[Bootstrap] Env: $env, API URL: $baseApiUrl');

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      initializeDateFormatting('id_ID');
      runApp(const ProviderScope(child: MainApp()));

      /// Catches all unhandled errors in the Flutter environment.
      FlutterError.onError = (FlutterErrorDetails errorDetails) {
        if (kDebugMode) {
          print(errorDetails);
        }

        /// Logs exceptions to Sentry.
        logger.error(
          '[bootstrap] - Unhandled error',
          errorDetails.exception,
          errorDetails.stack,
        );
      };
    },
    (exception, stackTrace) async {
      logger.error(
        '[bootstrap] - Error on runZonedGuarded',
        exception,
        stackTrace,
      );
    },
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(currentLocaleProvider);

    return ToastificationWrapper(
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
