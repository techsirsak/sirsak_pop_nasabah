import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_scan_state.freezed.dart';

/// Camera permission status for QR scanning
enum CameraPermissionStatus {
  unknown,
  granted,
  denied,
  deniedForever,
}

@freezed
abstract class QrScanState with _$QrScanState {
  const factory QrScanState({
    @Default(false) bool isScanning,
    @Default(false) bool isTorchOn,
    @Default(false) bool isFrontCamera,
    @Default(CameraPermissionStatus.unknown)
    CameraPermissionStatus cameraPermissionStatus,
    String? scannedData,
    String? errorMessage,
  }) = _QrScanState;
}
