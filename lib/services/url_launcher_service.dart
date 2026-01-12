import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:url_launcher/url_launcher.dart';

part 'url_launcher_service.g.dart';

/// Provider for UrlLauncherService
@riverpod
UrlLauncherService urlLauncherService(Ref ref) {
  return UrlLauncherService(ref.read(loggerServiceProvider));
}

/// {@template url_launcher_service}
///
/// UrlLauncherService handles launching external URLs and applications
///
/// This is a stateless service that can be safely instantiated multiple times.
/// Riverpod manages the lifecycle through the provider.
///
/// Supports launching:
/// - Email clients (mailto:)
/// - Phone dialers (tel:)
/// - Social media apps (Instagram, etc.)
/// - Generic URLs (http/https)
///
/// Usage in Views (with WidgetRef):
/// ```dart
/// final urlLauncher = ref.read(urlLauncherServiceProvider);
/// await urlLauncher.launchEmail('contact@example.com');
/// ```
///
/// Usage in ViewModels (with Ref):
/// ```dart
/// final urlLauncher = ref.read(urlLauncherServiceProvider);
/// await urlLauncher.launchPhone('+1234567890');
/// ```
///
/// Direct usage (without Riverpod):
/// ```dart
/// final logger = LoggerService();
/// final urlLauncher = UrlLauncherService(logger);
/// await urlLauncher.launchInstagram('username');
/// ```
///
/// {@endtemplate}
class UrlLauncherService {
  /// Creates a UrlLauncherService with the provided logger
  UrlLauncherService(this._logger);

  final LoggerService _logger;

  /// Launch email client with the specified [email] address
  ///
  /// Creates a mailto: URI and opens the default email client.
  ///
  /// Example:
  /// ```dart
  /// await urlLauncher.launchEmail('support@example.com');
  /// ```
  ///
  /// Throws an exception if the email client cannot be launched.
  Future<void> launchEmail(String email) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await _launchUri(emailUri);
  }

  /// Launch phone dialer with the specified [phone] number
  ///
  /// Creates a tel: URI and opens the default phone dialer.
  ///
  /// Example:
  /// ```dart
  /// await urlLauncher.launchPhone('+1234567890');
  /// ```
  ///
  /// Throws an exception if the phone dialer cannot be launched.
  Future<void> launchPhone(String phone) async {
    final phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    await _launchUri(phoneUri);
  }

  /// Launch Instagram app or web with the specified [handle]
  ///
  /// Opens the Instagram app if installed, otherwise opens in browser.
  /// Uses external application mode to ensure proper app launching.
  ///
  /// Example:
  /// ```dart
  /// await urlLauncher.launchInstagram('username');
  /// ```
  ///
  /// Throws an exception if Instagram cannot be launched.
  Future<void> launchInstagram(String handle) async {
    final instagramUri = Uri.parse('https://instagram.com/$handle');
    await _launchUri(instagramUri, mode: LaunchMode.externalApplication);
  }

  /// Launch a generic URL
  ///
  /// Opens any valid URL in the default browser or appropriate app.
  ///
  /// Example:
  /// ```dart
  /// await urlLauncher.launchGenericUrl('https://example.com');
  /// ```
  ///
  /// Throws an exception if the URL cannot be launched.
  Future<void> launchGenericUrl(
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    final uri = Uri.parse(url);
    await _launchUri(uri, mode: mode);
  }

  /// Internal method to launch a URI with error handling and logging
  Future<void> _launchUri(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
        _logger.info('Successfully launched URL: $uri');
      } else {
        _logger.warning('Cannot launch URL: $uri');
        throw Exception('Cannot launch URL: $uri');
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to launch URL: $uri', e, stackTrace);
      rethrow;
    }
  }
}
