import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/app_constants.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/features/setor_qr_scan/setor_qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/services/crypto/qr_crypto_service.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:sirsak_pop_nasabah/services/setor_service.dart';
import 'package:sirsak_pop_nasabah/services/user_service.dart';

part 'setor_qr_scan_viewmodel.g.dart';

@riverpod
class SetorQrScanViewModel extends _$SetorQrScanViewModel {
  MobileScannerController? _controller;

  MobileScannerController get controller {
    _controller ??= MobileScannerController(
      autoStart: false,
    );
    return _controller!;
  }

  @override
  SetorQrScanState build() {
    ref.onDispose(() {
      unawaited(_controller?.dispose());
    });

    // Initialize camera when provider is first accessed
    unawaited(Future.microtask(_resetForNewScan));

    return const SetorQrScanState();
  }

  /// Initialize camera permission - checks and requests if needed
  Future<void> initCameraPermission() async {
    if (state.cameraPermissionStatus != CameraPermissionStatus.unknown) {
      return;
    }

    await _checkAndRequestCameraPermission();
  }

  /// Called when the page opens to initialize/reset state
  Future<void> onPageOpen() async {
    _resetForNewScan();
  }

  /// Start the scanner after permission is granted
  Future<void> startScanner() async {
    try {
      await controller.start();
      state = state.copyWith(isScannerReady: true, isScanning: true);
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error(
            '[SetorQrScanViewModel] Failed to start scanner',
            e,
            stackTrace,
          );
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
    if (state.scannedData != null || _isShowingError || state.isSubmitting) {
      return;
    }

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final rawValue = barcode.rawValue;

    if (rawValue != null && rawValue.isNotEmpty) {
      ref
          .read(loggerServiceProvider)
          .info('[SetorQrScanViewModel] QR Code detected: $rawValue');

      state = state.copyWith(isScanning: false);
      unawaited(controller.stop());
      unawaited(_processQrData(rawValue));
    }
  }

  /// Process QR data and route to appropriate handler
  Future<void> _processQrData(String rawValue) async {
    final cryptoService = ref.read(qrCryptoServiceProvider);

    // Check if it's a deeplink URL (BSU QR)
    if (rawValue.startsWith(appBundleID)) {
      final parsedData = cryptoService.parseQrData(
        rawValue,
        allowedTypes: {QrType.registerBsu, QrType.setorRvm},
      );
      if (parsedData?.type == QrType.registerBsu &&
          parsedData?.bsuData != null) {
        return _applyBsu(parsedData!.bsuData!.id);
      }
      return _handleInvalidQr();
    }

    // Try to parse as RVM JSON: {"type": "setor-rvm", "data": "..."}
    final rvmData = cryptoService.parseRvmJson(rawValue);
    if (rvmData != null) {
      return _submitDeposit(rvmData);
    }

    // Neither format matched
    _handleInvalidQr();
  }

  void _handleInvalidQr() {
    _isShowingError = true;
    unawaited(controller.stop());
    state = state.copyWith(
      isScanning: false,
      errorMessage: 'setorQrScanErrorInvalidQr',
    );
  }

  /// Called from View after error dialog is dismissed to resume scanning
  void dismissErrorAndRescan() {
    _isShowingError = false;
    state = state.copyWith(
      errorMessage: null,
      isSuccess: false,
      successType: null,
    );
    _resetForNewScan();
  }

  /// Submit deposit session to API immediately after scan
  Future<void> _submitDeposit(String encryptedData) async {
    final logger = ref.read(loggerServiceProvider);
    final setorService = ref.read(setorServiceProvider);

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await setorService.qrTransaction(encryptedData);
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        successType: SetorSuccessType.deposit,
      );
    } catch (e, stackTrace) {
      logger.error(
        '[SetorQrScanViewModel] Failed to submit deposit',
        e,
        stackTrace,
      );
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'setorQrScanErrorApi',
      );
    }
  }

  /// Apply for BSU membership after scanning BSU QR
  Future<void> _applyBsu(String bsuId) async {
    final logger = ref.read(loggerServiceProvider);

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(userServiceProvider).applyBSU(bsuId: bsuId);
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
        successType: SetorSuccessType.bsuApply,
      );
    } catch (e, stackTrace) {
      logger.error(
        '[SetorQrScanViewModel] Failed to apply BSU',
        e,
        stackTrace,
      );
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'setorQrScanErrorApi',
      );
    }
  }

  Future<void> toggleTorch() async {
    try {
      await controller.toggleTorch();
      state = state.copyWith(isTorchOn: !state.isTorchOn);
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error(
            '[SetorQrScanViewModel] Failed to toggle torch',
            e,
            stackTrace,
          );
    }
  }

  void _resetForNewScan() {
    state = const SetorQrScanState();
    unawaited(
      Future.microtask(() async {
        await initCameraPermission();
        if (state.cameraPermissionStatus == CameraPermissionStatus.granted) {
          await startScanner();
        }
      }),
    );
  }

  /// Handle app lifecycle changes to pause/resume scanner
  void handleAppLifecycleChange(AppLifecycleState lifecycleState) {
    if (!state.isScannerReady) return;

    switch (lifecycleState) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(controller.stop());
    }
  }
}
