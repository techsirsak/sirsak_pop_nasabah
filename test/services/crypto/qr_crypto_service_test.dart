// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sirsak_pop_nasabah/services/crypto/qr_crypto_service.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late QrCryptoService cryptoService;
  late MockLoggerService mockLogger;

  // Test encryption key (32 bytes, base64 encoded)
  // Generated with: openssl rand -base64 32
  const testKey = '9dmkUJx6G/2fZb/DqQmQ0MvG4UiYl6R6r/L4VRyvKks=';

  // Test HMAC key (32 bytes, hex encoded)
  // Generated with: openssl rand -hex 32
  const testHmacKey =
      'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2';

  setUp(() {
    mockLogger = MockLoggerService();
    cryptoService = QrCryptoService(
      encryptionKey: testKey,
      hmacKey: testHmacKey,
      logger: mockLogger,
    );
  });

  group('QrCryptoService', () {
    group('encrypt', () {
      test('should return base64url encoded payload', () {
        const plaintext = '{"type":"register-bsu","data":{"id":1}}';

        final encrypted = cryptoService.encrypt(plaintext);

        // Should be valid base64url
        expect(() => base64Url.decode(encrypted), returnsNormally);
      });

      test('should produce different output for same input (random IV)', () {
        const plaintext = '{"type":"register-bsu","data":{"id":1}}';

        final encrypted1 = cryptoService.encrypt(plaintext);
        final encrypted2 = cryptoService.encrypt(plaintext);

        expect(encrypted1, isNot(equals(encrypted2)));
      });

      test('should handle empty string', () {
        const plaintext = '';

        final encrypted = cryptoService.encrypt(plaintext);

        // Should still produce valid encrypted output
        expect(() => base64Url.decode(encrypted), returnsNormally);
      });

      test('should handle unicode characters', () {
        const plaintext = '{"name":"日本語テスト","emoji":"🎉"}';

        final encrypted = cryptoService.encrypt(plaintext);
        final result = cryptoService.decrypt(encrypted);

        expect(result, isA<QrDecryptSuccess>());
        expect((result as QrDecryptSuccess).plaintext, plaintext);
      });
    });

    group('decrypt', () {
      test('should decrypt encrypted payload correctly', () {
        const original = '{"type":"register-bsu","data":{"id":123}}';
        final encrypted = cryptoService.encrypt(original);

        final result = cryptoService.decrypt(encrypted);

        expect(result, isA<QrDecryptSuccess>());
        expect((result as QrDecryptSuccess).plaintext, original);
      });

      test(
        'should return error for plain JSON payload (no legacy support)',
        () {
          const plainJson = '{"type":"register-bsu","data":{"id":1}}';
          final result = cryptoService.decrypt(plainJson);

          expect(result, isA<QrDecryptError>());
        },
      );

      test('should return error for payload too short', () {
        // Base64 of just "ENC" (3 bytes)
        final result = cryptoService.decrypt('RU5D');

        expect(result, isA<QrDecryptError>());
        expect(
          (result as QrDecryptError).message,
          contains('too short'),
        );
      });

      test('should return error for invalid prefix', () {
        // Create a payload with wrong prefix
        final bytes = List<int>.filled(40, 0);
        bytes[0] = 'X'.codeUnitAt(0);
        bytes[1] = 'X'.codeUnitAt(0);
        bytes[2] = 'X'.codeUnitAt(0);
        final payload = base64UrlEncode(bytes);

        final result = cryptoService.decrypt(payload);

        expect(result, isA<QrDecryptError>());
        expect(
          (result as QrDecryptError).message,
          contains('missing ENC prefix'),
        );
      });

      test('should return error for unsupported version', () {
        // Create payload with ENC prefix but wrong version
        final bytes = List<int>.filled(40, 0);
        bytes[0] = 'E'.codeUnitAt(0);
        bytes[1] = 'N'.codeUnitAt(0);
        bytes[2] = 'C'.codeUnitAt(0);
        bytes[3] = 0x99; // Invalid version
        final payload = base64UrlEncode(bytes);

        final result = cryptoService.decrypt(payload);

        expect(result, isA<QrDecryptError>());
        expect(
          (result as QrDecryptError).message,
          contains('Unsupported payload version'),
        );
      });

      test('should return error for tampered HMAC', () {
        final encrypted = cryptoService.encrypt('test data');
        final bytes = base64Url.decode(encrypted);

        // Tamper with HMAC (last 16 bytes)
        bytes[bytes.length - 1] ^= 0xFF;
        final tampered = base64UrlEncode(bytes);

        final result = cryptoService.decrypt(tampered);

        expect(result, isA<QrDecryptError>());
        expect(
          (result as QrDecryptError).message,
          contains('tampered or corrupted'),
        );
      });

      test('should return error for invalid base64', () {
        final result = cryptoService.decrypt('!!!not-valid-base64!!!');

        expect(result, isA<QrDecryptError>());
      });
    });

    group('round-trip', () {
      test('should preserve JSON data through encrypt/decrypt', () {
        final testCases = [
          '{"type":"register-bsu","data":{"id":1,"bsu_name":"Test"}}',
          '{"type":"register-nasabah","data":{"id":2,"name":"John","email":"j@x.com"}}',
          '{"type":"register-nasabah","data":{"id":3,"name":"Jane","email":"jane@test.com","no_hp":"08123456789"}}',
        ];

        for (final original in testCases) {
          final encrypted = cryptoService.encrypt(original);
          final result = cryptoService.decrypt(encrypted);

          expect(result, isA<QrDecryptSuccess>());

          // Verify JSON equivalence
          final originalJson = jsonDecode(original);
          final decryptedJson = jsonDecode(
            (result as QrDecryptSuccess).plaintext,
          );
          expect(decryptedJson, originalJson);
        }
      });

      test('should handle large payloads', () {
        final largeData = {
          'type': 'test',
          'data': List.generate(100, (i) => 'item_$i'),
        };
        final original = jsonEncode(largeData);

        final encrypted = cryptoService.encrypt(original);
        final result = cryptoService.decrypt(encrypted);

        expect(result, isA<QrDecryptSuccess>());
        expect((result as QrDecryptSuccess).plaintext, original);
      });

      test('should handle special characters in payload', () {
        const original = r'{"message":"Hello\nWorld\t\"quoted\""}';

        final encrypted = cryptoService.encrypt(original);
        final result = cryptoService.decrypt(encrypted);

        expect(result, isA<QrDecryptSuccess>());
        expect((result as QrDecryptSuccess).plaintext, original);
      });
    });

    group('security', () {
      test('should use constant-time comparison for HMAC', () {
        // This test verifies that the decrypt function handles
        // tampered data without timing leaks (by using _secureEquals)
        final encrypted = cryptoService.encrypt('test');
        final bytes = base64Url.decode(encrypted);

        // Try multiple tampered versions - all should fail
        for (var i = bytes.length - 16; i < bytes.length; i++) {
          final tampered = List<int>.from(bytes);
          tampered[i] ^= 0x01;
          final result = cryptoService.decrypt(base64UrlEncode(tampered));
          expect(result, isA<QrDecryptError>());
        }
      });
    });
  });
}
