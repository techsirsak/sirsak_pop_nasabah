import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/features/setor_qr_scan/setor_qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/services/crypto/qr_crypto_service.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:sirsak_pop_nasabah/services/setor_service.dart';
import 'package:sirsak_pop_nasabah/shared/navigation/bottom_nav_provider.dart';

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
    // Watch for tab changes to reset state when QR tab is selected
    ref.listen(bottomNavProvider, (previous, next) {
      if (next.selectedIndex == 2 && previous?.selectedIndex != 2) {
        _resetForNewScan();
      }
    });

    ref.onDispose(() {
      unawaited(_controller?.dispose());
    });

    // Initialize camera permission on build
    unawaited(Future.microtask(initCameraPermission));

    return const SetorQrScanState();
  }

  /// Initialize camera permission - checks and requests if needed
  Future<void> initCameraPermission() async {
    if (state.cameraPermissionStatus != CameraPermissionStatus.unknown) {
      return;
    }

    await _checkAndRequestCameraPermission();
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

      final parsedData = _parseQrData(rawValue);

      if (parsedData != null && parsedData.type == QrType.setorRvm) {
        state = state.copyWith(
          scannedData: parsedData,
          isScanning: false,
        );
        unawaited(controller.stop());
        unawaited(_submitDeposit(parsedData));
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
      errorMessage: 'setorQrScanErrorInvalidQr',
    );
  }

  /// Called from View after error dialog is dismissed to resume scanning
  void dismissErrorAndRescan() {
    _isShowingError = false;
    state = state.copyWith(errorMessage: null, isSuccess: false);
    _resetForNewScan();
  }

  /// Extract QR data from deeplink URL if applicable
  String _extractQrDataFromDeeplink(String qrData) {
    if (!qrData.contains('://') || !qrData.contains('?')) {
      return qrData;
    }

    try {
      final uri = Uri.parse(qrData);
      final dataParam = uri.queryParameters['data'];

      if (dataParam != null && dataParam.isNotEmpty) {
        ref
            .read(loggerServiceProvider)
            .info('[SetorQrScanViewModel] Extracted data from deeplink URL');
        return dataParam;
      }
    } catch (e) {
      ref
          .read(loggerServiceProvider)
          .warning(
            '[SetorQrScanViewModel] Failed to parse as deeplink URL: $e',
          );
    }

    return qrData;
  }

  /// Parse QR data - only accepts setor-rvm type
  ParsedQrData? _parseQrData(String qrData) {
    final logger = ref.read(loggerServiceProvider);

    final extractedData = _extractQrDataFromDeeplink(qrData);
    logger.info('[SetorQrScanViewModel] extractedData: $extractedData');

    final cryptoService = ref.read(qrCryptoServiceProvider);
    final decryptResult = cryptoService.decrypt(extractedData);

    final String jsonData;

    switch (decryptResult) {
      case QrDecryptSuccess(:final decryptedText):
        jsonData = decryptedText;
      case QrDecryptError(:final message):
        logger.warning('[SetorQrScanViewModel] QR decryption failed: $message');
        return null;
    }

    try {
      final json = jsonDecode(jsonData) as Map<String, dynamic>;
      final typeParam = json['type'] as String?;
      final data = json['data'] as Map<String, dynamic>?;

      if (typeParam == null || data == null) {
        logger.warning(
          '[SetorQrScanViewModel] Missing type or data in QR: $jsonData',
        );
        return null;
      }

      final qrType = QrType.fromString(typeParam);

      if (qrType != QrType.setorRvm) {
        logger.warning(
          '[SetorQrScanViewModel] Invalid QR type for setor: $typeParam',
        );
        return null;
      }

      final setorRvmData = QrSetorRvmData.fromJson(data);
      logger.info(
        '[SetorQrScanViewModel] Parsed Setor RVM QR - id: ${setorRvmData.id}, '
        'name: ${setorRvmData.rvmName}',
      );
      return ParsedQrData(
        type: QrType.setorRvm,
        setorRvmData: setorRvmData,
      );
    } catch (e, stackTrace) {
      unawaited(
        logger.error(
          '[SetorQrScanViewModel] Failed to parse QR JSON: $jsonData',
          e,
          stackTrace,
        ),
      );
      return null;
    }
  }

  /// Submit deposit session to API immediately after scan
  Future<void> _submitDeposit(ParsedQrData parsedData) async {
    final logger = ref.read(loggerServiceProvider);
    final setorService = ref.read(setorServiceProvider);

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final setorRvmData = parsedData.setorRvmData!;
      await setorService.initiateSession(
        rvmId: setorRvmData.id,
        sessionId: setorRvmData.sessionId,
      );

      logger.info('[SetorQrScanViewModel] Deposit session initiated');
      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e, stackTrace) {
      logger.error(
        '[SetorQrScanViewModel] Failed to initiate deposit session',
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
    unawaited(Future.microtask(() async {
      await initCameraPermission();
      if (state.cameraPermissionStatus == CameraPermissionStatus.granted) {
        await startScanner();
      }
    }));
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
