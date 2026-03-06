import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';

part 'setor_qr_scan_state.freezed.dart';

enum SetorSuccessType { deposit, bsuApply }

@freezed
abstract class SetorQrScanState with _$SetorQrScanState {
  const factory SetorQrScanState({
    @Default(false) bool isScanning,
    @Default(false) bool isScannerReady,
    @Default(false) bool isTorchOn,
    @Default(false) bool isSubmitting,
    @Default(CameraPermissionStatus.unknown)
    CameraPermissionStatus cameraPermissionStatus,
    ParsedQrData? scannedData,
    String? errorMessage,
    @Default(false) bool isSuccess,
    SetorSuccessType? successType,
  }) = _SetorQrScanState;
}
