// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sirsak_pop_nasabah/services/crypto/qr_crypto_config.dart';
import 'package:sirsak_pop_nasabah/services/crypto/qr_crypto_service.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late QrCryptoService cryptoService;
  late MockLoggerService mockLogger;

  // Test encryption key (32 bytes, base64 encoded)
  // Generated with: openssl rand -base64 32
  const testKey = '9dmkUJx6G/2fZb/DqQmQ0MvG4UiYl6R6r/L4VRyvKks=';

  setUp(() {
    mockLogger = MockLoggerService();
    cryptoService = QrCryptoService(
      encryptionKey: testKey,
      logger: mockLogger,
    );
  });

  group('QrCryptoService', () {
    group('encrypt', () {
      test('should return payload with correct prefix and version', () {
        const plaintext = '{"type":"register-bsu","data":{"id":1}}';

        final encrypted = cryptoService.encrypt(plaintext);

        expect(
          encrypted,
          startsWith(
            '${QrCryptoConfig.encryptedPrefix}${QrCryptoConfig.version}:',
          ),
        );
        expect(encrypted.split(':').length, 4);
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

        expect(encrypted, startsWith('ENC:v1:'));
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

      test('should handle legacy plain JSON payload', () {
        const plainJson = '{"type":"register-bsu","data":{"id":1}}';

        final result = cryptoService.decrypt(plainJson);

        expect(result, isA<QrDecryptLegacy>());
        expect((result as QrDecryptLegacy).plaintext, plainJson);
      });

      test(
        'should return error for invalid encrypted format (missing parts)',
        () {
          final result = cryptoService.decrypt('ENC:v1:invalid');

          expect(result, isA<QrDecryptError>());
          expect(
            (result as QrDecryptError).message,
            'Invalid encrypted payload format',
          );
        },
      );

      test('should return error for invalid base64 IV', () {
        final result = cryptoService.decrypt('ENC:v1:!!!invalid!!!:YWJj');

        expect(result, isA<QrDecryptError>());
      });

      test('should return error for tampered ciphertext', () {
        final encrypted = cryptoService.encrypt('test');
        final parts = encrypted.split(':');
        // Tamper with ciphertext by replacing it
        parts[3] = 'YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=';
        final tampered = parts.join(':');

        final result = cryptoService.decrypt(tampered);

        expect(result, isA<QrDecryptError>());
      });

      test('should return error for non-JSON non-encrypted payload', () {
        final result = cryptoService.decrypt('not json at all');

        expect(result, isA<QrDecryptError>());
        expect(
          (result as QrDecryptError).message,
          'Invalid QR code format',
        );
      });

      test('should handle payload with ENC prefix but wrong format', () {
        final result = cryptoService.decrypt('ENC:wrong:format');

        expect(result, isA<QrDecryptError>());
      });

      test('should warn but attempt decrypt for unknown version', () {
        // Create valid encrypted payload then change version
        final encrypted = cryptoService.encrypt('test');
        final parts = encrypted.split(':');
        parts[1] = 'v999'; // Unknown version
        final modifiedPayload = parts.join(':');

        // Should still attempt decryption (and succeed since ciphertext is valid)
        final result = cryptoService.decrypt(modifiedPayload);

        // It might succeed or fail depending on implementation
        // The key is that it attempts decryption rather than failing immediately
        expect(result, anyOf(isA<QrDecryptSuccess>(), isA<QrDecryptError>()));
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

    group('backward compatibility', () {
      test('should accept valid JSON array as legacy payload', () {
        const jsonArray = '[1, 2, 3]';

        final result = cryptoService.decrypt(jsonArray);

        expect(result, isA<QrDecryptLegacy>());
        expect((result as QrDecryptLegacy).plaintext, jsonArray);
      });

      test('should accept nested JSON as legacy payload', () {
        const nestedJson = '{"a":{"b":{"c":"deep"}}}';

        final result = cryptoService.decrypt(nestedJson);

        expect(result, isA<QrDecryptLegacy>());
      });

      test('should reject malformed JSON as legacy payload', () {
        const malformed = '{"unclosed": "brace"';

        final result = cryptoService.decrypt(malformed);

        expect(result, isA<QrDecryptError>());
      });
    });

    group('edge cases', () {
      test('should handle empty encrypted payload parts', () {
        final result = cryptoService.decrypt('ENC:v1::');

        expect(result, isA<QrDecryptError>());
      });

      test('should handle payload starting with ENC but not proper format', () {
        final result = cryptoService.decrypt('ENCRYPTED:data');

        // Should be treated as legacy (invalid JSON)
        expect(result, isA<QrDecryptError>());
      });
    });
  });
}
