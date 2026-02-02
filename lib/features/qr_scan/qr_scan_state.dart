import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_scan_state.freezed.dart';

@freezed
abstract class QrScanState with _$QrScanState {
  const factory QrScanState({
    @Default(false) bool isScanning,
    @Default(false) bool isTorchOn,
    @Default(false) bool isFrontCamera,
    @Default(false) bool hasPermission,
    String? scannedData,
    String? errorMessage,
  }) = _QrScanState;
}
