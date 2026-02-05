import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
  required String sentryDsn,
  required String qrEncryptionKey,
  required String hmacKey,
}) async {
  SentryWidgetsFlutterBinding.ensureInitialized();
  // Create logger instance for bootstrap (before Riverpod is available)
  final logger = LoggerService();

  // Initialize environment config before ProviderScope
  initEnvConfig(
    baseApiUrl: baseApiUrl,
    env: env,
    sentryDsn: sentryDsn,
    qrEncryptionKey: qrEncryptionKey,
    hmacKey: hmacKey,
  );
  logger.info('[Bootstrap] Env: $env, API URL: $baseApiUrl');
  await initializeDateFormatting('id_ID');

  // Get package info for version tracking
  final packageInfo = await PackageInfo.fromPlatform();
  final appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

  // Initialize Sentry for error tracking in release mode
  if (sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = sentryDsn
          ..environment = env
          ..release = 'sirsak-pop-nasabah@$appVersion'
          ..tracesSampleRate = 1.0
          ..maxBreadcrumbs = 100
          ..debug = kDebugMode;

        options.replay.sessionSampleRate = 1.0;
        options.replay.onErrorSampleRate = 1.0;
      },
      appRunner: () => _runApp(logger),
    );
  } else {
    // Run without Sentry - use runZonedGuarded for error handling
    runZonedGuarded(
      () => _runApp(logger),
      (exception, stackTrace) {
        unawaited(
          logger.error(
            '[bootstrap] - Error on runZonedGuarded',
            exception,
            stackTrace,
          ),
        );
      },
    );
  }
}

void _runApp(LoggerService logger) {
  // Set up Flutter error handling before running the app
  FlutterError.onError = (FlutterErrorDetails errorDetails) {
    if (kDebugMode) {
      debugPrint(errorDetails.toString());
    }

    // Logs exceptions to Sentry
    unawaited(
      logger.error(
        '[bootstrap] - Unhandled error',
        errorDetails.exception,
        errorDetails.stack,
      ),
    );
  };

  // Run the app - Sentry's appRunner already handles zone-based error capture
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(currentLocaleProvider);

    return SentryWidget(
      child: ToastificationWrapper(
        child: MaterialApp.router(
          theme: AppTheme.lightTheme,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
