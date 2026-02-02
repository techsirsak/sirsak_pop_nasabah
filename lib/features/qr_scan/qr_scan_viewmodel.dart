import 'dart:async';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
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

  /// Start the scanner after permission is granted
  Future<void> startScanner() async {
    try {
      await _controller?.start();
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error('[QrScanViewModel] Failed to start scanner', e, stackTrace);
    }
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

    final hasPermission = await _checkAndRequestCameraPermission();
    if (hasPermission) {
      state = state.copyWith(isScanning: true);
      await startScanner();
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

  void onDetect(BarcodeCapture capture) {
    if (state.scannedData != null) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final rawValue = barcode.rawValue;

    if (rawValue != null && rawValue.isNotEmpty) {
      ref
          .read(loggerServiceProvider)
          .info('[QrScanViewModel] QR Code detected: $rawValue');

      state = state.copyWith(
        scannedData: rawValue,
        isScanning: false,
      );

      unawaited(_controller?.stop());
    }
  }

  Future<void> toggleTorch() async {
    try {
      await _controller?.toggleTorch();
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
      isScanning: true,
      errorMessage: null,
    );
    unawaited(_controller?.start());
  }

  void setError(String message) {
    state = state.copyWith(
      errorMessage: message,
      isScanning: false,
    );
  }
}
