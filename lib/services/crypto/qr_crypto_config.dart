/// Configuration constants for QR code encryption.
///
/// Uses AES-256-GCM for authenticated encryption.
class QrCryptoConfig {
  QrCryptoConfig._();

  /// Current encryption version identifier.
  static const String version = 'v1';

  /// Prefix that identifies an encrypted payload.
  static const String encryptedPrefix = 'ENC:';

  /// IV (Initialization Vector) length in bytes.
  /// 12 bytes (96 bits) is the recommended length for GCM mode.
  static const int ivLength = 12;

  /// Authentication tag length in bytes.
  /// 16 bytes (128 bits) provides full authentication strength.
  static const int authTagLength = 16;
}
