import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_service.g.dart';

/// Provider for LoggerService
@riverpod
LoggerService loggerService(Ref ref) {
  return LoggerService();
}

/// {@template logger_service}
///
/// LoggerService deals with internal logging
///
/// This is a stateless service that can be safely instantiated multiple times.
/// Riverpod manages the lifecycle through the provider.
///
/// Currently support [info], [warning], and [error] log type
///
/// Usage in Views (with WidgetRef):
/// ```dart
/// final logger = ref.read(loggerServiceProvider);
/// logger.info('My info here');
/// ```
///
/// Usage in ViewModels (with Ref):
/// ```dart
/// final logger = ref.read(loggerServiceProvider);
/// logger.info('My info here');
/// ```
///
/// Direct usage (without Riverpod, e.g., in bootstrap):
/// ```dart
/// final logger = LoggerService();
/// logger.info('My info here');
/// ```
///
/// {@endtemplate}
class LoggerService {
  LoggerService();

  final _logger = Logger(
    printer: PrettyPrinter(
      lineLength: 50,
      methodCount: 0,
      errorMethodCount: 0,
      printEmojis: false,
      excludeBox: {Level.info: true, Level.warning: true},
    ),
    output: _ConsoleOutput(),
  );

  /// Check if logs can be printed,
  /// we will disable any prints from production
  bool get canPrint => kDebugMode;

  // TODO(devin): setup sentry
  /// Set user data to sentry
  // void setSentryUser({User? user, String? tokenLast4}) {
  //   Sentry.configureScope(
  //     (scope) => scope.setUser(
  //       SentryUser(
  //         id: user?.id,
  //         email: user?.email,
  //         name: user?.name,
  //         data: {
  //           'responsibilities': user?.responsibilities,
  //           'position': user?.position,
  //           'token_last_4': tokenLast4,
  //         },
  //       ),
  //     ),
  //   );
  // }

  /// Log [message] with color blue
  void info(String message) {
    if (canPrint) _logger.i(message);
    // Sentry.captureMessage(message);
  }

  /// Log [message] with color orange
  void warning(String message) {
    if (canPrint) _logger.w(message);
  }

  /// Log [message] with [error] and [stackTrace]
  void error(String message, dynamic error, [StackTrace? stackTrace]) {
    if (canPrint) _logger.e(message, error: error, stackTrace: stackTrace);
    if (error.toString().toLowerCase().contains('location') ||
        error.toString().toLowerCase().contains('connection') ||
        error.toString().toLowerCase().contains('timeout')) {
      return;
    }
    // Sentry.captureException(error, stackTrace: stackTrace);
  }
}

/// Extends 'LogOutput' to correctly display console colors on macOS systems.
///
/// The behavior is determined by the application's run mode (Release or Debug)
///
/// For more information, see: https://github.com/simc/logger/issues/1#issuecomment-1582076726
class _ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    if (kReleaseMode) {
      event.lines.forEach(debugPrint);
    } else {
      event.lines.forEach(developer.log);
    }
  }
}
