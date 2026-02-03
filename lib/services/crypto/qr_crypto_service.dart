import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/config/env_config.dart';
import 'package:sirsak_pop_nasabah/services/crypto/qr_crypto_config.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'qr_crypto_service.g.dart';

/// Result of QR decryption attempt.
sealed class QrDecryptResult {
  const QrDecryptResult();
}

/// Successful decryption of an encrypted payload.
class QrDecryptSuccess extends QrDecryptResult {
  const QrDecryptSuccess(this.plaintext);

  final String plaintext;
}

/// Legacy plain JSON payload (backward compatibility).
class QrDecryptLegacy extends QrDecryptResult {
  const QrDecryptLegacy(this.plaintext);

  final String plaintext;
}

/// Decryption failed with an error message.
class QrDecryptError extends QrDecryptResult {
  const QrDecryptError(this.message);

  final String message;
}

/// Provider for QrCryptoService
@riverpod
QrCryptoService qrCryptoService(Ref ref) {
  final config = ref.read(envConfigProvider);
  final logger = ref.read(loggerServiceProvider);
  return QrCryptoService(
    encryptionKey: config.qrEncryptionKey,
    logger: logger,
  );
}

/// Service for encrypting and decrypting QR code payloads.
///
/// Uses AES-256-GCM for authenticated encryption.
/// Supports backward compatibility with plain JSON payloads.
class QrCryptoService {
  QrCryptoService({
    required String encryptionKey,
    required LoggerService logger,
  }) : _logger = logger,
       _encrypter = Encrypter(
         AES(Key.fromBase64(encryptionKey), mode: AESMode.gcm),
       );

  final LoggerService _logger;
  final Encrypter _encrypter;

  /// Encrypt plaintext JSON to QR payload format.
  ///
  /// Returns: `ENC:v1:<base64(iv)>:<base64(ciphertext+tag)>`
  String encrypt(String plaintext) {
    // Generate random IV for each encryption
    final iv = IV.fromSecureRandom(QrCryptoConfig.ivLength);

    // Encrypt with GCM (includes auth tag)
    final encrypted = _encrypter.encrypt(plaintext, iv: iv);

    // Build payload: ENC:v1:<iv>:<ciphertext>
    final payload =
        '${QrCryptoConfig.encryptedPrefix}'
        '${QrCryptoConfig.version}:'
        '${iv.base64}:'
        '${encrypted.base64}';

    _logger.info('[QrCryptoService] Encrypted ${plaintext.length} chars');

    return payload;
  }

  /// Decrypt QR payload to plaintext JSON.
  ///
  /// Handles both encrypted (ENC:) and legacy plain JSON payloads.
  QrDecryptResult decrypt(String payload) {
    // Check for encrypted prefix
    if (!payload.startsWith(QrCryptoConfig.encryptedPrefix)) {
      // Legacy plain JSON - attempt to validate it's JSON
      return _handleLegacyPayload(payload);
    }

    try {
      // Parse encrypted payload: ENC:v1:<iv>:<ciphertext>
      final parts = payload.split(':');
      if (parts.length != 4) {
        return const QrDecryptError('Invalid encrypted payload format');
      }

      final version = parts[1];
      final ivBase64 = parts[2];
      final ciphertextBase64 = parts[3];

      // Version check for future compatibility
      if (version != QrCryptoConfig.version) {
        _logger.warning(
          '[QrCryptoService] Unknown version: $version, attempting decrypt',
        );
      }

      final iv = IV.fromBase64(ivBase64);
      final encrypted = Encrypted.fromBase64(ciphertextBase64);

      // Decrypt and verify auth tag
      final plaintext = _encrypter.decrypt(encrypted, iv: iv);

      _logger.info('[QrCryptoService] Decrypted successfully');

      return QrDecryptSuccess(plaintext);
    } on FormatException catch (e) {
      _logger.warning('[QrCryptoService] Decryption failed: $e');
      return const QrDecryptError('Invalid encrypted data format');
    } on Exception catch (e) {
      // GCM auth failure or other crypto error
      _logger.warning('[QrCryptoService] Decryption failed: $e');
      return const QrDecryptError('Decryption failed - data may be corrupted');
    }
  }

  QrDecryptResult _handleLegacyPayload(String payload) {
    // Validate it looks like JSON
    try {
      jsonDecode(payload);
      _logger.info('[QrCryptoService] Legacy plain JSON payload detected');
      return QrDecryptLegacy(payload);
    } catch (e) {
      return const QrDecryptError('Invalid QR code format');
    }
  }
}
