import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/services/crypto/qr_crypto_service.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'qr_scan_viewmodel.g.dart';

@riverpod
class QrScanViewModel extends _$QrScanViewModel {
  MobileScannerController? _controller;

  MobileScannerController get controller {
    _controller ??= MobileScannerController(
      autoStart: false,
    );
    return _controller!;
  }

  @override
  QrScanState build() {
    ref.onDispose(() {
      unawaited(_controller?.dispose());
    });

    // Initialize camera permission on build
    unawaited(Future.microtask(initCameraPermission));

    return const QrScanState();
  }

  /// Initialize camera permission - checks and requests if needed
  Future<void> initCameraPermission() async {
    // Prevent multiple calls if already initialized
    if (state.cameraPermissionStatus != CameraPermissionStatus.unknown) {
      return;
    }

    await _checkAndRequestCameraPermission();
    // Note: startScanner() is called from the View after MobileScanner widget
    // is in the tree to avoid black screen issue
  }

  /// Start the scanner after permission is granted
  Future<void> startScanner() async {
    try {
      await controller.start();
      state = state.copyWith(isScannerReady: true, isScanning: true);
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error('[QrScanViewModel] Failed to start scanner', e, stackTrace);
      state = state.copyWith(
        isScannerReady: false,
        errorMessage: 'Failed to start camera',
      );
    }
  }

  /// Check and request camera permission
  Future<bool> _checkAndRequestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      state = state.copyWith(
        cameraPermissionStatus: CameraPermissionStatus.granted,
      );
      return true;
    }

    if (status.isPermanentlyDenied) {
      state = state.copyWith(
        cameraPermissionStatus: CameraPermissionStatus.deniedForever,
      );
      return false;
    }

    // Request permission
    final result = await Permission.camera.request();

    if (result.isGranted) {
      state = state.copyWith(
        cameraPermissionStatus: CameraPermissionStatus.granted,
      );
      return true;
    }

    if (result.isPermanentlyDenied) {
      state = state.copyWith(
        cameraPermissionStatus: CameraPermissionStatus.deniedForever,
      );
      return false;
    }

    state = state.copyWith(
      cameraPermissionStatus: CameraPermissionStatus.denied,
    );
    return false;
  }

  /// Open app settings for camera permission
  Future<void> openCameraSettings() async {
    await openAppSettings();
  }

  bool _isShowingError = false;

  void onDetect(BarcodeCapture capture) {
    if (state.scannedData != null || _isShowingError) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final rawValue = barcode.rawValue;

    if (rawValue != null && rawValue.isNotEmpty) {
      ref
          .read(loggerServiceProvider)
          .info('[QrScanViewModel] QR Code detected: $rawValue');

      final parsedData = parseQrData(rawValue);

      if (parsedData != null) {
        state = state.copyWith(
          scannedData: rawValue,
          parsedQrData: parsedData,
          isScanning: false,
        );

        unawaited(controller.stop());
        ref.read(routerProvider).pop(parsedData);
      } else {
        _handleInvalidQr();
      }
    }
  }

  void _handleInvalidQr() {
    _isShowingError = true;
    unawaited(controller.stop());
    state = state.copyWith(
      isScanning: false,
      errorMessage: 'qrScanError',
    );
  }

  /// Called from View after error dialog is dismissed to resume scanning
  void dismissErrorAndRescan() {
    _isShowingError = false;
    state = state.copyWith(errorMessage: null);
    resetScan();
  }

  /// Parse QR data using QrCryptoService
  ParsedQrData? parseQrData(String qrData) {
    final cryptoService = ref.read(qrCryptoServiceProvider);
    return cryptoService.parseQrData(qrData);
  }

  Future<void> toggleTorch() async {
    try {
      await controller.toggleTorch();
      state = state.copyWith(isTorchOn: !state.isTorchOn);
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error('[QrScanViewModel] Failed to toggle torch', e, stackTrace);
    }
  }

  void resetScan() {
    state = state.copyWith(
      scannedData: null,
      isScanning: false,
      isScannerReady: false,
      errorMessage: null,
    );
    unawaited(startScanner());
  }

  void setError(String message) {
    state = state.copyWith(
      errorMessage: message,
      isScanning: false,
    );
  }

  /// Handle app lifecycle changes to pause/resume scanner
  void handleAppLifecycleChange(AppLifecycleState lifecycleState) {
    // Don't handle if scanner not ready
    if (!state.isScannerReady) return;

    switch (lifecycleState) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart scanner when app is resumed
        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop scanner when app goes inactive
        unawaited(controller.stop());
    }
  }

  /// Process deeplink data passed from router
  ///
  /// This is called when the app is opened via deeplink with QR parameters
  void processDeeplink(String deeplinkData) {
    final parsed = parseQrData(deeplinkData);
    if (parsed != null) {
      state = state.copyWith(
        scannedData: deeplinkData,
        parsedQrData: parsed,
        isScanning: false,
      );
      ref.read(routerProvider).pop(parsed);
    } else {
      _handleInvalidQr();
    }
  }
}
