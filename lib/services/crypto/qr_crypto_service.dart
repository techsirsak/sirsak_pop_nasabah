import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/config/env_config.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'qr_crypto_service.g.dart';

/// Result of QR decryption attempt.
sealed class QrDecryptResult {
  const QrDecryptResult();
}

/// Successful decryption of an encrypted payload.
class QrDecryptSuccess extends QrDecryptResult {
  const QrDecryptSuccess(this.decryptedText);

  final String decryptedText;
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
    hmacKey: config.hmacKey,
    logger: logger,
  );
}

/// Service for encrypting and decrypting QR code payloads.
///
/// Uses AES-256-GCM for authenticated encryption with HMAC-SHA256 verification.
///
/// Encrypted payloads are base64url-encoded binary with the structure:
/// ```text
/// | "ENC" (3B) | version 0x02 (1B) | IV (12B) | ciphertext | HMAC (16B) |
/// ```
///
/// The HMAC-SHA256 (truncated to 16 bytes) covers all preceding bytes.
class QrCryptoService {
  QrCryptoService({
    required String encryptionKey,
    required String hmacKey,
    required LoggerService logger,
  }) : _logger = logger,
       _encrypter = Encrypter(
         AES(Key.fromBase64(encryptionKey), mode: AESMode.gcm),
       ),
       _hmacKeyHex = hmacKey;

  final LoggerService _logger;
  final Encrypter _encrypter;
  final String _hmacKeyHex;

  static const String _encryptedPrefix = 'ENC';
  static const int _versionV2 = 0x02;
  static const int _ivLength = 12;
  static const int _hmacLength = 16;

  /// Encrypt text to QR payload format.
  ///
  /// Returns base64url-encoded binary payload.
  String encrypt(String text) {
    final iv = IV.fromSecureRandom(_ivLength);
    final encrypted = _encrypter.encrypt(text, iv: iv);

    final buffer = BytesBuilder()
      ..add(utf8.encode(_encryptedPrefix)) // prefix (3 bytes)
      ..add([_versionV2]) // version byte
      ..add(iv.bytes) // IV (12 bytes)
      ..add(encrypted.bytes); // ciphertext

    final hmac = Hmac(
      sha256,
      _hmacKeyBytes,
    ).convert(buffer.toBytes()).bytes.sublist(0, _hmacLength);

    buffer.add(hmac);

    _logger.info('[QrCryptoService] Encrypted ${text.length} chars');

    return base64UrlEncode(buffer.toBytes());
  }

  /// Decrypt QR payload to text.
  ///
  /// Only accepts V2 encrypted payloads. Returns error for invalid formats.
  QrDecryptResult decrypt(String payload) {
    try {
      final bytes = base64Url.decode(payload);

      // Minimum size: prefix(3) + version(1) + IV(12) + HMAC(16) = 32 bytes
      if (bytes.length < 32) {
        return const QrDecryptError('Invalid payload: too short');
      }

      var offset = 0;

      // Verify prefix
      final prefix = utf8.decode(bytes.sublist(0, 3));
      if (prefix != _encryptedPrefix) {
        return const QrDecryptError('Invalid payload: missing ENC prefix');
      }
      offset += 3;

      // Verify version
      final version = bytes[offset++];
      if (version != _versionV2) {
        _logger.warning(
          '[QrCryptoService] Unsupported version: $version',
        );
        return const QrDecryptError('Unsupported payload version');
      }

      // Extract IV
      final ivBytes = bytes.sublist(offset, offset + _ivLength);
      final iv = IV(Uint8List.fromList(ivBytes));
      offset += _ivLength;

      // Split payload and HMAC
      final hmacStart = bytes.length - _hmacLength;
      final ciphertext = bytes.sublist(offset, hmacStart);
      final receivedHmac = bytes.sublist(hmacStart);

      // Verify HMAC
      final expectedHmac = Hmac(
        sha256,
        _hmacKeyBytes,
      ).convert(bytes.sublist(0, hmacStart)).bytes.sublist(0, _hmacLength);

      if (!_secureEquals(receivedHmac, expectedHmac)) {
        _logger.warning('[QrCryptoService] HMAC verification failed');
        return const QrDecryptError('QR payload tampered or corrupted');
      }

      // Decrypt
      final decrypted = _encrypter.decrypt(
        Encrypted(Uint8List.fromList(ciphertext)),
        iv: iv,
      );
      _logger.info('[QrCryptoService] Decrypted successfully: $decrypted');

      return QrDecryptSuccess(decrypted);
    } on FormatException catch (e) {
      _logger.warning('[QrCryptoService] Invalid base64 format: $e');
      return const QrDecryptError('Invalid encrypted data format');
    } on Exception catch (_) {
      return const QrDecryptError('Decryption failed - data may be corrupted');
    }
  }

  List<int> get _hmacKeyBytes {
    final bytes = <int>[];
    for (var i = 0; i < _hmacKeyHex.length; i += 2) {
      bytes.add(int.parse(_hmacKeyHex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  bool _secureEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  // ============================================================
  // QR Parsing Methods
  // ============================================================

  /// Extract QR data from deeplink URL if applicable.
  ///
  /// If the input is a deeplink URL like `com.sirsak.app://qr-scan?data=...`,
  /// extracts and URL-decodes the `data` query parameter.
  /// Otherwise, returns the input unchanged.
  String extractDataFromDeeplink(String qrData) {
    if (!qrData.contains('://') || !qrData.contains('?')) {
      return qrData;
    }

    try {
      final uri = Uri.parse(qrData);
      final dataParam = uri.queryParameters['data'];

      if (dataParam != null && dataParam.isNotEmpty) {
        _logger.info('[QrCryptoService] Extracted data from deeplink URL');
        return dataParam;
      }
    } catch (e) {
      _logger.warning('[QrCryptoService] Failed to parse as deeplink URL: $e');
    }

    return qrData;
  }

  /// Parse encrypted QR data into typed [ParsedQrData].
  ///
  /// Handles deeplink URLs with encoded data in query parameters.
  /// Decrypts the payload and parses the JSON structure.
  ///
  /// [allowedTypes] - Optional filter for accepted QR types.
  /// If provided, returns null for types not in the set.
  ///
  /// Expected JSON format after decryption:
  /// ```json
  /// {
  ///   "type": "register-bsu" | "register-nasabah" | "setor-rvm",
  ///   "data": { ... }
  /// }
  /// ```
  ///
  /// Returns [ParsedQrData] if valid, null otherwise.
  ParsedQrData? parseQrData(String qrData, {Set<QrType>? allowedTypes}) {
    final extractedData = extractDataFromDeeplink(qrData);
    _logger.info('[QrCryptoService] extractedData: $extractedData');

    final decryptResult = decrypt(extractedData);

    final String jsonData;

    switch (decryptResult) {
      case QrDecryptSuccess(:final decryptedText):
        jsonData = decryptedText;
      case QrDecryptError(:final message):
        _logger.warning('[QrCryptoService] QR decryption failed: $message');
        return null;
    }

    try {
      final json = jsonDecode(jsonData) as Map<String, dynamic>;
      final typeParam = json['type'] as String?;
      final data = json['data'] as Map<String, dynamic>?;

      if (typeParam == null || data == null) {
        _logger.warning(
          '[QrCryptoService] Missing type or data in QR: $jsonData',
        );
        return null;
      }

      final qrType = QrType.fromString(typeParam);

      // Check if type is allowed
      if (allowedTypes != null && !allowedTypes.contains(qrType)) {
        _logger.warning(
          '[QrCryptoService] QR type not allowed: $typeParam',
        );
        return null;
      }

      switch (qrType) {
        case QrType.registerBsu:
          final bsuData = QrBsuData.fromJson(data);
          _logger.info(
            '[QrCryptoService] Parsed BSU QR - '
            'id: ${bsuData.id}, name: ${bsuData.bsuName}',
          );
          return ParsedQrData(type: QrType.registerBsu, bsuData: bsuData);

        case QrType.registerNasabah:
          final nasabahData = QrNasabahData.fromJson(data);
          _logger.info(
            '[QrCryptoService] Parsed Nasabah QR - '
            'id: ${nasabahData.id}, name: ${nasabahData.name}',
          );
          return ParsedQrData(
            type: QrType.registerNasabah,
            nasabahData: nasabahData,
          );

        case QrType.setorRvm:
          final setorRvmData = QrSetorRvmData.fromJson(data);
          _logger.info(
            '[QrCryptoService] Parsed Setor RVM QR - '
            'id: ${setorRvmData.id}, name: ${setorRvmData.rvmName}',
          );
          return ParsedQrData(
            type: QrType.setorRvm,
            setorRvmData: setorRvmData,
          );

        case QrType.unknown:
          _logger.warning('[QrCryptoService] Unknown QR type: $typeParam');
          return null;
      }
    } catch (e, stackTrace) {
      unawaited(
        _logger.error(
          '[QrCryptoService] Failed to parse QR JSON: $jsonData',
          e,
          stackTrace,
        ),
      );
      return null;
    }
  }

  /// Parse RVM JSON format: {"type": "setor-rvm", "data": "encrypted"}.
  ///
  /// This is for RVM QR codes that contain a JSON wrapper with encrypted data.
  /// Returns the encrypted data string if valid, null otherwise.
  String? parseRvmJson(String rawValue) {
    try {
      final json = jsonDecode(rawValue) as Map<String, dynamic>;
      final type = json['type'] as String?;
      final data = json['data'] as String?;

      if (type == QrType.setorRvm.toString() &&
          data != null &&
          data.isNotEmpty) {
        _logger.info('[QrCryptoService] Parsed RVM JSON QR');
        return data;
      }

      _logger.warning(
        '[QrCryptoService] Invalid RVM JSON - type: $type, '
        'hasData: ${data != null}',
      );
    } catch (e) {
      _logger.warning('[QrCryptoService] Failed to parse as RVM JSON: $e');
    }
    return null;
  }
}
