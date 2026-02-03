import 'dart:async';
import 'dart:convert';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

      final parsedData = parseQrData(rawValue);

      state = state.copyWith(
        scannedData: rawValue,
        parsedQrData: parsedData,
        isScanning: false,
      );

      unawaited(_controller?.stop());
    }
  }

  /// Parse QR data from JSON format (with decryption support)
  ///
  /// Handles both encrypted (ENC:v1:...) and legacy plain JSON payloads.
  ///
  /// Expected JSON format after decryption:
  /// ```json
  /// {
  ///   "type": "register-bsu" | "register-nasabah",
  ///   "data": { ... }
  /// }
  /// ```
  ///
  /// Returns [ParsedQrData] if valid, null otherwise
  ParsedQrData? parseQrData(String qrData) {
    final logger = ref.read(loggerServiceProvider);

    // First, attempt decryption
    final cryptoService = ref.read(qrCryptoServiceProvider);
    final decryptResult = cryptoService.decrypt(qrData);

    final String jsonData;

    switch (decryptResult) {
      case QrDecryptSuccess(:final plaintext):
        jsonData = plaintext;
      case QrDecryptLegacy(:final plaintext):
        // Log for monitoring legacy QR usage
        logger.info('[QrScanViewModel] Processing legacy unencrypted QR');
        jsonData = plaintext;
      case QrDecryptError(:final message):
        logger.warning('[QrScanViewModel] QR decryption failed: $message');
        return null;
    }

    // Continue with JSON parsing
    try {
      final json = jsonDecode(jsonData) as Map<String, dynamic>;
      final typeParam = json['type'] as String?;
      final data = json['data'] as Map<String, dynamic>?;

      if (typeParam == null || data == null) {
        logger.warning(
          '[QrScanViewModel] Missing type or data in QR: $jsonData',
        );
        return null;
      }

      final qrType = QrType.fromString(typeParam);
      switch (qrType) {
        case QrType.registerBsu:
          final bsuData = QrBsuData.fromJson(data);
          logger.info(
            '[QrScanViewModel] Parsed BSU QR - id: ${bsuData.id}, '
            'name: ${bsuData.bsuName}',
          );
          return ParsedQrData(
            type: QrType.registerBsu,
            bsuData: bsuData,
          );

        case QrType.registerNasabah:
          final nasabahData = QrNasabahData.fromJson(data);
          logger.info(
            '[QrScanViewModel] Parsed Nasabah QR - id: ${nasabahData.id}, '
            'name: ${nasabahData.name}',
          );
          return ParsedQrData(
            type: QrType.registerNasabah,
            nasabahData: nasabahData,
          );

        case QrType.unknown:
          logger.warning('[QrScanViewModel] Unknown QR type: $typeParam');
          return const ParsedQrData(type: QrType.unknown);
      }
    } catch (e, stackTrace) {
      unawaited(
        logger.error(
          '[QrScanViewModel] Failed to parse QR JSON: $jsonData',
          e,
          stackTrace,
        ),
      );
      return null;
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
    } else {
      setError('Invalid QR code format');
    }
  }
}
