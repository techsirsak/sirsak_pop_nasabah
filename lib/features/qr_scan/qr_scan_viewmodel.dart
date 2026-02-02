import 'dart:async';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'qr_scan_viewmodel.g.dart';

@riverpod
class QrScanViewModel extends _$QrScanViewModel {
  MobileScannerController? _controller;

  MobileScannerController get controller {
    _controller ??= MobileScannerController();
    return _controller!;
  }

  @override
  QrScanState build() {
    ref.onDispose(() {
      unawaited(_controller?.dispose());
    });
    return const QrScanState(isScanning: true, hasPermission: true);
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

  Future<void> switchCamera() async {
    try {
      await _controller?.switchCamera();
      state = state.copyWith(
        isFrontCamera: !state.isFrontCamera,
        isTorchOn: false,
      );
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error('[QrScanViewModel] Failed to switch camera', e, stackTrace);
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

  void setPermissionDenied() {
    state = state.copyWith(
      hasPermission: false,
      isScanning: false,
    );
  }
}
