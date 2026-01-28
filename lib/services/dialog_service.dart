import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';

part 'dialog_service.g.dart';

@riverpod
DialogService dialogService(Ref ref) {
  return DialogService(ref.read(routerProvider));
}

/// Service for showing dialogs from ViewModels
///
/// This service provides access to Flutter's dialog system from ViewModels
/// by using the router's navigator context.
class DialogService {
  DialogService(this._router);

  final GoRouter _router;

  /// Gets the current navigator context from the router
  BuildContext? get currentContext =>
      _router.routerDelegate.navigatorKey.currentContext;

  /// Shows a custom dialog with the provided widget
  ///
  /// Returns the result of the dialog, or null if dismissed
  Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
  }) async {
    final context = currentContext;
    if (context == null) return null;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => child,
    );
  }
}
