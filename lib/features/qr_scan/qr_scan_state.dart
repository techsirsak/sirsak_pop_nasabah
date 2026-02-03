import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_scan_state.freezed.dart';
part 'qr_scan_state.g.dart';

/// Camera permission status for QR scanning
enum CameraPermissionStatus {
  unknown,
  granted,
  denied,
  deniedForever,
}

/// QR code type for registration flows
enum QrType {
  registerBsu,
  registerNasabah,
  unknown;

  /// Converts a string value from QR JSON to [QrType]
  ///
  /// Expected values: 'register-bsu', 'register-nasabah'
  /// Returns [QrType.unknown] for unrecognized values
  static QrType fromString(String value) {
    switch (value) {
      case 'register-bsu':
        return QrType.registerBsu;
      case 'register-nasabah':
        return QrType.registerNasabah;
      default:
        return QrType.unknown;
    }
  }
}

/// BSU data from QR code
@freezed
abstract class QrBsuData with _$QrBsuData {
  const factory QrBsuData({
    required int id,
    @JsonKey(name: 'bsu_name') required String bsuName,
  }) = _QrBsuData;

  factory QrBsuData.fromJson(Map<String, dynamic> json) =>
      _$QrBsuDataFromJson(json);
}

/// Nasabah data from QR code
@freezed
abstract class QrNasabahData with _$QrNasabahData {
  const factory QrNasabahData({
    required int id,
    required String name,
    required String email,
    @JsonKey(name: 'no_hp') String? noHp,
  }) = _QrNasabahData;

  factory QrNasabahData.fromJson(Map<String, dynamic> json) =>
      _$QrNasabahDataFromJson(json);
}

/// Parsed QR data containing type and typed data
@freezed
abstract class ParsedQrData with _$ParsedQrData {
  const factory ParsedQrData({
    required QrType type,
    QrBsuData? bsuData,
    QrNasabahData? nasabahData,
  }) = _ParsedQrData;
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
    ParsedQrData? parsedQrData,
  }) = _QrScanState;
}
