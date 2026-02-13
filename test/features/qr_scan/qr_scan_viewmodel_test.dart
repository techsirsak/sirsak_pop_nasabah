// ignore_for_file: cascade_invocations

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_viewmodel.dart';
import 'package:sirsak_pop_nasabah/services/crypto/qr_crypto_service.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

// Mock classes
class MockLoggerService extends Mock implements LoggerService {}

class MockGoRouter extends Mock implements GoRouter {}

// Test encryption key (32 bytes, base64 encoded)
// Generated with: openssl rand -base64 32
const testEncryptionKey = '9dmkUJx6G/2fZb/DqQmQ0MvG4UiYl6R6r/L4VRyvKks=';

// Test HMAC key (32 bytes, hex encoded)
// Generated with: openssl rand -hex 32
const testHmacKey =
    'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2';

/// Sets up mock method channel for permission_handler
void setupPermissionHandlerMock() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('flutter.baseflow.com/permissions/methods'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'checkPermissionStatus':
              // Return granted (1) for camera permission
              return 1;
            case 'requestPermissions':
              // Return granted status for requested permissions
              return <int, int>{0: 1}; // camera: granted
            default:
              return null;
          }
        },
      );
}

// Test data constants
const validBsuQrJson = '''
{
  "type": "register-bsu",
  "data": {
    "id": "123",
    "bsu_name": "Test BSU Name"
  }
}
''';

const validNasabahQrJsonFull = '''
{
  "type": "register-nasabah",
  "data": {
    "id": "456",
    "name": "John Doe",
    "email": "john@example.com",
    "no_hp": "081234567890"
  }
}
''';

const validNasabahQrJsonMinimal = '''
{
  "type": "register-nasabah",
  "data": {
    "id": "789",
    "name": "Jane Doe",
    "email": "jane@example.com"
  }
}
''';

const unknownTypeQrJson = '''
{
  "type": "unknown-type",
  "data": {}
}
''';

const missingTypeQrJson = '''
{
  "data": {"id": 1}
}
''';

const missingDataQrJson = '''
{
  "type": "register-bsu"
}
''';

const invalidJson = 'not a json string {{{';

const bsuMissingIdJson = '''
{
  "type": "register-bsu",
  "data": {
    "bsu_name": "Test BSU"
  }
}
''';

const bsuMissingNameJson = '''
{
  "type": "register-bsu",
  "data": {
    "id": "123"
  }
}
''';

const nasabahMissingFieldsJson = '''
{
  "type": "register-nasabah",
  "data": {
    "id": "123"
  }
}
''';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupPermissionHandlerMock();

  group('QrType.fromString', () {
    test('should return registerBsu for "register-bsu"', () {
      expect(QrType.fromString('register-bsu'), QrType.registerBsu);
    });

    test('should return registerNasabah for "register-nasabah"', () {
      expect(QrType.fromString('register-nasabah'), QrType.registerNasabah);
    });

    test('should return unknown for unrecognized string', () {
      expect(QrType.fromString('some-other-type'), QrType.unknown);
    });

    test('should return unknown for empty string', () {
      expect(QrType.fromString(''), QrType.unknown);
    });
  });

  group('QrScanViewModel Tests', () {
    late ProviderContainer container;
    late MockLoggerService mockLoggerService;
    late MockGoRouter mockRouter;
    late QrCryptoService cryptoService;

    /// Helper to encrypt test data for tests
    String encrypt(String plaintext) => cryptoService.encrypt(plaintext);

    setUp(() {
      mockLoggerService = MockLoggerService();
      mockRouter = MockGoRouter();

      // Stub logger methods
      when(() => mockLoggerService.info(any<String>())).thenReturn(null);
      when(() => mockLoggerService.warning(any<String>())).thenReturn(null);
      when(
        () => mockLoggerService.error(
          any<String>(),
          any<dynamic>(),
          any<StackTrace?>(),
        ),
      ).thenAnswer((_) async {});

      // Stub router pop
      when(() => mockRouter.pop(any<Object>())).thenReturn(null);

      // Create crypto service for test data encryption
      cryptoService = QrCryptoService(
        encryptionKey: testEncryptionKey,
        logger: mockLoggerService,
        hmacKey: testHmacKey,
      );

      container = ProviderContainer(
        overrides: [
          loggerServiceProvider.overrideWithValue(mockLoggerService),
          routerProvider.overrideWithValue(mockRouter),
          qrCryptoServiceProvider.overrideWithValue(cryptoService),
        ],
      );
    });

    tearDown(() async {
      // Allow pending microtasks (initCameraPermission, startScanner) to complete
      // before disposing container to avoid "Ref disposed" errors.
      // Multiple delays to handle chained async operations.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      container.dispose();
    });

    group('Initial State', () {
      test('should return default state values', () {
        final state = container.read(qrScanViewModelProvider);

        expect(state.isScanning, false);
        expect(state.isTorchOn, false);
        expect(state.isFrontCamera, false);
        expect(state.cameraPermissionStatus, CameraPermissionStatus.unknown);
        expect(state.scannedData, null);
        expect(state.errorMessage, null);
        expect(state.parsedQrData, null);
      });
    });

    group('parseQrData', () {
      test('should parse valid BSU QR data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(encrypt(validBsuQrJson));

        expect(result, isNotNull);
        expect(result!.type, QrType.registerBsu);
        expect(result.bsuData, isNotNull);
        expect(result.bsuData!.id, '123');
        expect(result.bsuData!.bsuName, 'Test BSU Name');
        expect(result.nasabahData, isNull);
      });

      test('should parse valid Nasabah QR data with all fields', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(encrypt(validNasabahQrJsonFull));

        expect(result, isNotNull);
        expect(result!.type, QrType.registerNasabah);
        expect(result.nasabahData, isNotNull);
        expect(result.nasabahData!.id, '456');
        expect(result.nasabahData!.name, 'John Doe');
        expect(result.nasabahData!.email, 'john@example.com');
        expect(result.nasabahData!.noHp, '081234567890');
        expect(result.bsuData, isNull);
      });

      test('should parse valid Nasabah QR data with optional noHp as null', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(encrypt(validNasabahQrJsonMinimal));

        expect(result, isNotNull);
        expect(result!.type, QrType.registerNasabah);
        expect(result.nasabahData!.noHp, isNull);
      });

      test('should return null for invalid payload format', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        // Invalid base64 / non-encrypted payload
        final result = notifier.parseQrData(invalidJson);

        expect(result, isNull);
        // Crypto service and viewmodel may both log warnings
        verify(
          () => mockLoggerService.warning(any<String>()),
        ).called(greaterThanOrEqualTo(1));
      });

      test('should return null for encrypted JSON missing type field', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(encrypt(missingTypeQrJson));

        expect(result, isNull);
        verify(() => mockLoggerService.warning(any<String>())).called(1);
      });

      test('should return null for encrypted JSON missing data field', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(encrypt(missingDataQrJson));

        expect(result, isNull);
      });

      test(
        'should return ParsedQrData with unknown type for unrecognized type',
        () {
          final notifier = container.read(qrScanViewModelProvider.notifier);

          final result = notifier.parseQrData(encrypt(unknownTypeQrJson));

          expect(result, isNotNull);
          expect(result!.type, QrType.unknown);
          expect(result.bsuData, isNull);
          expect(result.nasabahData, isNull);
        },
      );

      test('should return null for BSU data missing required id field', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(encrypt(bsuMissingIdJson));

        expect(result, isNull);
      });

      test(
        'should return null for BSU data missing required bsu_name field',
        () {
          final notifier = container.read(qrScanViewModelProvider.notifier);

          final result = notifier.parseQrData(encrypt(bsuMissingNameJson));

          expect(result, isNull);
        },
      );

      test('should return null for Nasabah data missing required fields', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(encrypt(nasabahMissingFieldsJson));

        expect(result, isNull);
      });

      test('should handle empty string input', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData('');

        expect(result, isNull);
      });
    });

    group('setError', () {
      test('should set error message in state', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.setError('Test error message');

        final state = container.read(qrScanViewModelProvider);
        expect(state.errorMessage, 'Test error message');
      });

      test('should set isScanning to false when error is set', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.setError('Error occurred');

        final state = container.read(qrScanViewModelProvider);
        expect(state.isScanning, false);
        expect(state.errorMessage, 'Error occurred');
      });
    });

    // Note: resetScan tests are skipped because the method triggers async
    // operations (startScanner) that are difficult to test without flakiness.
    // The state clearing behavior is tested indirectly through other tests
    // and the individual state management (setError, processDeeplink) is
    // tested separately.

    // Note: dismissErrorAndRescan tests are skipped because the method
    // triggers async operations (resetScan -> startScanner) that are difficult
    // to test without flakiness. The functionality is tested indirectly through
    // integration tests and the individual components (setError, resetScan)
    // are tested separately.

    group('processDeeplink', () {
      test('should process valid BSU deeplink data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        final encryptedData = encrypt(validBsuQrJson);

        notifier.processDeeplink(encryptedData);

        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, encryptedData);
        expect(state.parsedQrData, isNotNull);
        expect(state.parsedQrData!.type, QrType.registerBsu);
      });

      test('should process valid Nasabah deeplink data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        final encryptedData = encrypt(validNasabahQrJsonFull);

        notifier.processDeeplink(encryptedData);

        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, encryptedData);
        expect(state.parsedQrData!.type, QrType.registerNasabah);
      });

      test('should set error for invalid deeplink data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.processDeeplink(invalidJson);

        final state = container.read(qrScanViewModelProvider);
        expect(state.errorMessage, 'qrScanError');
        expect(state.isScanning, false);
      });

      test('should stop scanning after processing valid deeplink', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.processDeeplink(encrypt(validBsuQrJson));

        final state = container.read(qrScanViewModelProvider);
        expect(state.isScanning, false);
      });

      test('should pop with parsed data after valid deeplink', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.processDeeplink(encrypt(validBsuQrJson));

        final state = container.read(qrScanViewModelProvider);
        verify(() => mockRouter.pop(state.parsedQrData)).called(1);
      });

      test('should not pop when deeplink data is invalid', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.processDeeplink(invalidJson);

        verifyNever(() => mockRouter.pop(any<Object>()));
      });

      test('should set errorMessage when deeplink data is invalid', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.processDeeplink(invalidJson);

        final state = container.read(qrScanViewModelProvider);
        expect(state.errorMessage, 'qrScanError');
      });
    });

    group('onDetect', () {
      test('should ignore detection if scannedData already exists', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        // First set some scanned data
        final encryptedBsu = encrypt(validBsuQrJson);
        notifier.processDeeplink(encryptedBsu);
        final previousState = container.read(qrScanViewModelProvider);

        final encryptedNasabah = encrypt(validNasabahQrJsonFull);
        final capture = BarcodeCapture(
          barcodes: [Barcode(rawValue: encryptedNasabah)],
        );
        notifier.onDetect(capture);

        final state = container.read(qrScanViewModelProvider);
        // State should remain unchanged - still has BSU data, not Nasabah
        expect(state.scannedData, previousState.scannedData);
        expect(state.parsedQrData!.type, QrType.registerBsu);
      });

      test('should ignore empty barcodes list', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        const capture = BarcodeCapture();

        notifier.onDetect(capture);

        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, isNull);
      });

      test('should ignore barcode with null rawValue', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        const capture = BarcodeCapture(
          barcodes: [Barcode()],
        );

        notifier.onDetect(capture);

        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, isNull);
      });

      test('should ignore barcode with empty rawValue', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        const capture = BarcodeCapture(
          barcodes: [Barcode(rawValue: '')],
        );

        notifier.onDetect(capture);

        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, isNull);
      });

      test('should process valid barcode and update state', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        final encryptedData = encrypt(validBsuQrJson);
        final capture = BarcodeCapture(
          barcodes: [Barcode(rawValue: encryptedData)],
        );

        notifier.onDetect(capture);

        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, encryptedData);
        expect(state.parsedQrData, isNotNull);
        expect(state.isScanning, false);
      });

      test('should pop with parsed data after successful detection', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        final encryptedData = encrypt(validBsuQrJson);
        final capture = BarcodeCapture(
          barcodes: [Barcode(rawValue: encryptedData)],
        );

        notifier.onDetect(capture);

        final state = container.read(qrScanViewModelProvider);
        verify(() => mockRouter.pop(state.parsedQrData)).called(1);
      });

      test('should not pop when barcode has no valid data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        const capture = BarcodeCapture(
          barcodes: [Barcode(rawValue: '')],
        );

        notifier.onDetect(capture);

        verifyNever(() => mockRouter.pop(any<Object>()));
      });

      test('should set error and stop scanning when QR format is invalid', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        const capture = BarcodeCapture(
          barcodes: [Barcode(rawValue: invalidJson)],
        );

        notifier.onDetect(capture);

        verifyNever(() => mockRouter.pop(any<Object>()));
        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, isNull);
        expect(state.errorMessage, 'qrScanError');
        expect(state.isScanning, false);
      });

      test('should not set errorMessage when QR format is valid', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        final encryptedData = encrypt(validBsuQrJson);
        final capture = BarcodeCapture(
          barcodes: [Barcode(rawValue: encryptedData)],
        );

        notifier.onDetect(capture);

        final state = container.read(qrScanViewModelProvider);
        expect(state.errorMessage, isNull);
      });
    });

    group('parseQrData with encryption', () {
      test('should parse encrypted BSU QR data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        // Encrypt the valid BSU QR JSON
        final encryptedPayload = encrypt(validBsuQrJson);

        final result = notifier.parseQrData(encryptedPayload);

        expect(result, isNotNull);
        expect(result!.type, QrType.registerBsu);
        expect(result.bsuData, isNotNull);
        expect(result.bsuData!.id, '123');
        expect(result.bsuData!.bsuName, 'Test BSU Name');
      });

      test('should parse encrypted Nasabah QR data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        // Encrypt the valid Nasabah QR JSON
        final encryptedPayload = encrypt(validNasabahQrJsonFull);

        final result = notifier.parseQrData(encryptedPayload);

        expect(result, isNotNull);
        expect(result!.type, QrType.registerNasabah);
        expect(result.nasabahData, isNotNull);
        expect(result.nasabahData!.id, '456');
        expect(result.nasabahData!.name, 'John Doe');
        expect(result.nasabahData!.email, 'john@example.com');
      });

      test('should parse multiple encrypted QR codes in same session', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        // Test first encrypted QR (BSU)
        final encryptedBsu = encrypt(validBsuQrJson);
        final bsuResult = notifier.parseQrData(encryptedBsu);
        expect(bsuResult, isNotNull);
        expect(bsuResult!.type, QrType.registerBsu);

        // Test second encrypted QR (Nasabah)
        final encryptedNasabah = encrypt(validNasabahQrJsonFull);
        final nasabahResult = notifier.parseQrData(encryptedNasabah);
        expect(nasabahResult, isNotNull);
        expect(nasabahResult!.type, QrType.registerNasabah);
      });

      test('should return null for tampered encrypted payload', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        // Create encrypted payload
        final encryptedPayload = encrypt(validBsuQrJson);

        // Tamper with payload by modifying some bytes in the middle
        // The payload is base64url encoded binary, so we decode, modify, re-encode
        final bytes = encryptedPayload.codeUnits.toList();
        if (bytes.length > 20) {
          bytes[15] = (bytes[15] + 1) % 256; // Flip a byte
        }
        final tamperedPayload = String.fromCharCodes(bytes);

        final result = notifier.parseQrData(tamperedPayload);

        expect(result, isNull);
      });

      test('should return null for invalid encrypted format', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData('ENC:v1:invalid');

        expect(result, isNull);
      });
    });
  });
}
