// ignore_for_file: cascade_invocations

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_viewmodel.dart';
import 'package:sirsak_pop_nasabah/services/crypto/qr_crypto_service.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

// Mock classes
class MockLoggerService extends Mock implements LoggerService {}

// Test encryption key (32 bytes, base64 encoded)
// Generated with: openssl rand -base64 32
const testEncryptionKey = '9dmkUJx6G/2fZb/DqQmQ0MvG4UiYl6R6r/L4VRyvKks=';

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
    "id": 123,
    "bsu_name": "Test BSU Name"
  }
}
''';

const validNasabahQrJsonFull = '''
{
  "type": "register-nasabah",
  "data": {
    "id": 456,
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
    "id": 789,
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
    "id": 123
  }
}
''';

const nasabahMissingFieldsJson = '''
{
  "type": "register-nasabah",
  "data": {
    "id": 123
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

    setUp(() {
      mockLoggerService = MockLoggerService();

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

      container = ProviderContainer(
        overrides: [
          loggerServiceProvider.overrideWithValue(mockLoggerService),
          qrCryptoServiceProvider.overrideWithValue(
            QrCryptoService(
              encryptionKey: testEncryptionKey,
              logger: mockLoggerService,
            ),
          ),
        ],
      );
    });

    tearDown(() {
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

        final result = notifier.parseQrData(validBsuQrJson);

        expect(result, isNotNull);
        expect(result!.type, QrType.registerBsu);
        expect(result.bsuData, isNotNull);
        expect(result.bsuData!.id, 123);
        expect(result.bsuData!.bsuName, 'Test BSU Name');
        expect(result.nasabahData, isNull);
      });

      test('should parse valid Nasabah QR data with all fields', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(validNasabahQrJsonFull);

        expect(result, isNotNull);
        expect(result!.type, QrType.registerNasabah);
        expect(result.nasabahData, isNotNull);
        expect(result.nasabahData!.id, 456);
        expect(result.nasabahData!.name, 'John Doe');
        expect(result.nasabahData!.email, 'john@example.com');
        expect(result.nasabahData!.noHp, '081234567890');
        expect(result.bsuData, isNull);
      });

      test('should parse valid Nasabah QR data with optional noHp as null', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(validNasabahQrJsonMinimal);

        expect(result, isNotNull);
        expect(result!.type, QrType.registerNasabah);
        expect(result.nasabahData!.noHp, isNull);
      });

      test('should return null for invalid JSON', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(invalidJson);

        expect(result, isNull);
        // Now the crypto service handles this first, logging a warning
        verify(
          () => mockLoggerService.warning(any<String>()),
        ).called(1);
      });

      test('should return null for JSON missing type field', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(missingTypeQrJson);

        expect(result, isNull);
        verify(() => mockLoggerService.warning(any<String>())).called(1);
      });

      test('should return null for JSON missing data field', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(missingDataQrJson);

        expect(result, isNull);
      });

      test(
        'should return ParsedQrData with unknown type for unrecognized type',
        () {
          final notifier = container.read(qrScanViewModelProvider.notifier);

          final result = notifier.parseQrData(unknownTypeQrJson);

          expect(result, isNotNull);
          expect(result!.type, QrType.unknown);
          expect(result.bsuData, isNull);
          expect(result.nasabahData, isNull);
        },
      );

      test('should return null for BSU data missing required id field', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(bsuMissingIdJson);

        expect(result, isNull);
      });

      test(
        'should return null for BSU data missing required bsu_name field',
        () {
          final notifier = container.read(qrScanViewModelProvider.notifier);

          final result = notifier.parseQrData(bsuMissingNameJson);

          expect(result, isNull);
        },
      );

      test('should return null for Nasabah data missing required fields', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        final result = notifier.parseQrData(nasabahMissingFieldsJson);

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

    group('resetScan', () {
      test('should clear scannedData', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        // First set some scanned data via processDeeplink
        notifier.processDeeplink(validBsuQrJson);

        notifier.resetScan();

        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, isNull);
      });

      test('should set isScanning to true', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.resetScan();

        final state = container.read(qrScanViewModelProvider);
        expect(state.isScanning, true);
      });

      test('should clear errorMessage', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        // First set an error
        notifier.setError('existing error');

        notifier.resetScan();

        final state = container.read(qrScanViewModelProvider);
        expect(state.errorMessage, isNull);
      });
    });

    group('processDeeplink', () {
      test('should process valid BSU deeplink data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.processDeeplink(validBsuQrJson);

        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, validBsuQrJson);
        expect(state.parsedQrData, isNotNull);
        expect(state.parsedQrData!.type, QrType.registerBsu);
      });

      test('should process valid Nasabah deeplink data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.processDeeplink(validNasabahQrJsonFull);

        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, validNasabahQrJsonFull);
        expect(state.parsedQrData!.type, QrType.registerNasabah);
      });

      test('should set error for invalid deeplink data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.processDeeplink(invalidJson);

        final state = container.read(qrScanViewModelProvider);
        expect(state.errorMessage, 'Invalid QR code format');
        expect(state.isScanning, false);
      });

      test('should stop scanning after processing valid deeplink', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);

        notifier.processDeeplink(validBsuQrJson);

        final state = container.read(qrScanViewModelProvider);
        expect(state.isScanning, false);
      });
    });

    group('onDetect', () {
      test('should ignore detection if scannedData already exists', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        // First set some scanned data
        notifier.processDeeplink(validBsuQrJson);
        final previousState = container.read(qrScanViewModelProvider);

        const capture = BarcodeCapture(
          barcodes: [Barcode(rawValue: validNasabahQrJsonFull)],
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
        const capture = BarcodeCapture(
          barcodes: [Barcode(rawValue: validBsuQrJson)],
        );

        notifier.onDetect(capture);

        final state = container.read(qrScanViewModelProvider);
        expect(state.scannedData, validBsuQrJson);
        expect(state.parsedQrData, isNotNull);
        expect(state.isScanning, false);
      });
    });

    group('parseQrData with encryption', () {
      test('should parse encrypted BSU QR data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        final cryptoService = QrCryptoService(
          encryptionKey: testEncryptionKey,
          logger: mockLoggerService,
        );

        // Encrypt the valid BSU QR JSON
        final encryptedPayload = cryptoService.encrypt(validBsuQrJson);

        final result = notifier.parseQrData(encryptedPayload);

        expect(result, isNotNull);
        expect(result!.type, QrType.registerBsu);
        expect(result.bsuData, isNotNull);
        expect(result.bsuData!.id, 123);
        expect(result.bsuData!.bsuName, 'Test BSU Name');
      });

      test('should parse encrypted Nasabah QR data', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        final cryptoService = QrCryptoService(
          encryptionKey: testEncryptionKey,
          logger: mockLoggerService,
        );

        // Encrypt the valid Nasabah QR JSON
        final encryptedPayload = cryptoService.encrypt(validNasabahQrJsonFull);

        final result = notifier.parseQrData(encryptedPayload);

        expect(result, isNotNull);
        expect(result!.type, QrType.registerNasabah);
        expect(result.nasabahData, isNotNull);
        expect(result.nasabahData!.id, 456);
        expect(result.nasabahData!.name, 'John Doe');
        expect(result.nasabahData!.email, 'john@example.com');
      });

      test('should handle both encrypted and legacy QR in same session', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        final cryptoService = QrCryptoService(
          encryptionKey: testEncryptionKey,
          logger: mockLoggerService,
        );

        // Test legacy (plain JSON)
        final legacyResult = notifier.parseQrData(validBsuQrJson);
        expect(legacyResult, isNotNull);
        expect(legacyResult!.type, QrType.registerBsu);

        // Test encrypted
        final encryptedPayload = cryptoService.encrypt(validNasabahQrJsonFull);
        final encryptedResult = notifier.parseQrData(encryptedPayload);
        expect(encryptedResult, isNotNull);
        expect(encryptedResult!.type, QrType.registerNasabah);
      });

      test('should return null for tampered encrypted payload', () {
        final notifier = container.read(qrScanViewModelProvider.notifier);
        final cryptoService = QrCryptoService(
          encryptionKey: testEncryptionKey,
          logger: mockLoggerService,
        );

        // Create encrypted payload and tamper with it
        final encryptedPayload = cryptoService.encrypt(validBsuQrJson);
        final parts = encryptedPayload.split(':');
        parts[3] = 'YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo='; // Tampered
        final tamperedPayload = parts.join(':');

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
