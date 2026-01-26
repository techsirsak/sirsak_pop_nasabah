import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

part 'toast_service.g.dart';

/// {@template toast_service}
/// ToastService handles toast notifications in Sirsak Pop Nasabah.
/// Supports 4 common cases: success, info, warning & error.
///
/// Uses Riverpod for dependency injection instead of service locator.
/// {@endtemplate}

/// Provider for UrlLauncherService
@riverpod
ToastService toastService(Ref ref) {
  return ToastService(ref.read(routerProvider));
}

enum ToastType {
  success,
  info,
  warning,
  error
  ;

  ToastificationType get toastificationType {
    return switch (this) {
      ToastType.success => ToastificationType.success,
      ToastType.info => ToastificationType.info,
      ToastType.warning => ToastificationType.warning,
      ToastType.error => ToastificationType.error,
    };
  }

  MaterialColor get color {
    return switch (this) {
      ToastType.success => Colors.green,
      ToastType.info => Colors.blue,
      ToastType.warning => Colors.yellow,
      ToastType.error => Colors.red,
    };
  }
}

class ToastService {
  ToastService(this._router);

  final GoRouter _router;

  /// Get router current context
  BuildContext? get currentContext =>
      _router.routerDelegate.navigatorKey.currentContext;

  /// Show success toast
  void success({required String title, int? duration}) {
    _displayToast(message: title, type: ToastType.success, duration: duration);
  }

  /// Show info toast
  void info({required String title, int? duration}) {
    _displayToast(message: title, type: ToastType.info, duration: duration);
  }

  /// Show warning toast
  void warning({required String title, int? duration}) {
    _displayToast(message: title, type: ToastType.warning, duration: duration);
  }

  /// Show error toast
  void error({required String title, int? duration}) {
    _displayToast(
      message: title,
      type: ToastType.error,
      duration: duration ?? 8,
    );
  }

  /// Show custom toast
  void customIcon({
    required String title,
    required String customIconPath,
    int? duration,
  }) {
    _displayToast(
      message: title,
      type: ToastType.info,
      duration: duration,
      customIconPath: customIconPath,
    );
  }

  /// Show error toast
  void generalError({int? duration}) {
    final l10n = currentContext?.l10n;

    error(
      title: l10n?.error ?? 'Something went wrong',
      duration: duration,
    );
  }

  /// Show toast based on given type
  void _displayToast({
    required String message,
    required ToastType type,
    int? duration,
    String? customIconPath,
  }) {
    toastification.show(
      context: currentContext,
      autoCloseDuration: Duration(seconds: duration ?? 5),
      type: type.toastificationType,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  void showUpdateNotification({
    required String title,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) {
    toastification.show(
      context: currentContext,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      showIcon: false,
      title: Row(
        children: [
          Icon(PhosphorIcons.info(), size: 20),
          const Gap(8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontVariations: AppFonts.medium,
              ),
            ),
          ),
        ],
      ),
      description: Container(
        margin: const EdgeInsets.only(left: 32),
        padding: const EdgeInsets.only(top: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 14,
                fontVariations: AppFonts.semiBold,
              ),
            ),
          ),
        ),
      ),
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 300),
      autoCloseDuration: const Duration(days: 1),
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: false,
      backgroundColor: Colors.white,
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.all(16),
    );
  }

  void showWithAction({
    required String title,
    required String actionLabel,
    required String url,
    String? message,
    ToastType type = ToastType.info,
    int? duration,
  }) {
    toastification.show(
      context: currentContext,
      type: type.toastificationType,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: Duration(seconds: duration ?? 5),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontVariations: AppFonts.medium,
        ),
      ),
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message != null)
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                fontVariations: AppFonts.regular,
                color: Colors.grey.shade100,
              ),
            ),
          const Gap(8),
          InkWell(
            onTap: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 14,
                fontVariations: AppFonts.semiBold,
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 300),
      primaryColor: Colors.white.withValues(alpha: .06),
      backgroundColor: Colors.white.withValues(alpha: .06),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      borderRadius: BorderRadius.circular(18),
      showProgressBar: false,
      closeOnClick: false,
      dragToClose: true,
    );
  }

  /// Show loading toast
  ToastificationItem loading({required String title}) {
    return toastification.showCustom(
      context: currentContext,
      builder: (context, holder) {
        final textTheme = Theme.of(context).textTheme;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 8),
                blurRadius: 12,
                color: Colors.black.withValues(alpha: .06),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 30,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIcons.circleNotch(),
                        size: 24,
                        color: Colors.blue,
                      ),
                      const Gap(8),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: Text(
                          title,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const LinearProgressIndicator(minHeight: 4),
              ],
            ),
          ),
        );
      },
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Show loading toast
  ToastificationItem showCustomLoadingToast({
    required Widget body,
    bool isComplete = false,
  }) {
    return toastification.showCustom(
      context: currentContext,
      builder: (context, holder) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        final textTheme = theme.textTheme;
        final colorScheme = theme.colorScheme;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 8),
                blurRadius: 12,
                color: Colors.black.withValues(alpha: .06),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 30,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: body,
                ),
                if (!isComplete)
                  const LinearProgressIndicator(minHeight: 4)
                else ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: toastification.dismissAll,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: .06),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            l10n.cancel,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                              fontVariations: AppFonts.medium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                ],
              ],
            ),
          ),
        );
      },
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
