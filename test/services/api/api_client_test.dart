import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/api/dio_client.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

class MockDio extends Mock implements Dio {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockDio mockDio;
  late MockLoggerService mockLogger;
  late ApiClient apiClient;

  setUp(() {
    mockDio = MockDio();
    mockLogger = MockLoggerService();
    apiClient = ApiClient(mockDio, mockLogger);
  });

  Map<String, dynamic> fromJson(Map<String, dynamic> json) => json;

  group('ApiClient.get', () {
    test('should return parsed response on successful GET request', () async {
      final responseData = {'id': 1, 'name': 'Test'};
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      final result = await apiClient.get(
        path: '/test',
        fromJson: fromJson,
      );

      expect(result, responseData);
      verify(
        () => mockDio.get<Map<String, dynamic>>(
          '/test',
          queryParameters: null,
        ),
      ).called(1);
    });

    test('should pass query parameters on GET request', () async {
      final responseData = {'id': 1};
      final queryParams = {'page': 1, 'limit': 10};

      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      await apiClient.get(
        path: '/test',
        fromJson: fromJson,
        queryParameters: queryParams,
      );

      verify(
        () => mockDio.get<Map<String, dynamic>>(
          '/test',
          queryParameters: queryParams,
        ),
      ).called(1);
    });

    test('should throw NetworkException on connection timeout', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      expect(
        () => apiClient.get(path: '/test', fromJson: fromJson),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should throw ClientException on 4xx response', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 400,
            data: {'message': 'Bad request'},
            requestOptions: RequestOptions(path: '/test'),
          ),
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      expect(
        () => apiClient.get(path: '/test', fromJson: fromJson),
        throwsA(isA<ClientException>()),
      );
    });

    test('should throw ServerException on 5xx response', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 500,
            data: {'message': 'Internal server error'},
            requestOptions: RequestOptions(path: '/test'),
          ),
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      expect(
        () => apiClient.get(path: '/test', fromJson: fromJson),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('ApiClient.post', () {
    test('should return parsed response on successful POST request', () async {
      final responseData = {'id': 1, 'created': true};
      final requestData = {'name': 'Test'};

      when(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      final result = await apiClient.post(
        path: '/test',
        fromJson: fromJson,
        data: requestData,
      );

      expect(result, responseData);
      verify(
        () => mockDio.post<Map<String, dynamic>>(
          '/test',
          data: requestData,
          queryParameters: null,
        ),
      ).called(1);
    });

    test('should throw NetworkException on connection error', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      expect(
        () => apiClient.post(path: '/test', fromJson: fromJson),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('ApiClient.put', () {
    test('should return parsed response on successful PUT request', () async {
      final responseData = {'id': 1, 'updated': true};
      final requestData = {'name': 'Updated'};

      when(
        () => mockDio.put<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/test/1'),
        ),
      );

      final result = await apiClient.put(
        path: '/test/1',
        fromJson: fromJson,
        data: requestData,
      );

      expect(result, responseData);
      verify(
        () => mockDio.put<Map<String, dynamic>>(
          '/test/1',
          data: requestData,
          queryParameters: null,
        ),
      ).called(1);
    });

    test('should throw ClientException on 404 response', () async {
      when(
        () => mockDio.put<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            data: {'message': 'Not found'},
            requestOptions: RequestOptions(path: '/test/1'),
          ),
          requestOptions: RequestOptions(path: '/test/1'),
        ),
      );

      expect(
        () => apiClient.put(path: '/test/1', fromJson: fromJson),
        throwsA(isA<ClientException>()),
      );
    });
  });

  group('ApiClient.patch', () {
    test('should return parsed response on successful PATCH request', () async {
      final responseData = {'id': 1, 'patched': true};
      final requestData = {'field': 'value'};

      when(
        () => mockDio.patch<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/test/1'),
        ),
      );

      final result = await apiClient.patch(
        path: '/test/1',
        fromJson: fromJson,
        data: requestData,
      );

      expect(result, responseData);
      verify(
        () => mockDio.patch<Map<String, dynamic>>(
          '/test/1',
          data: requestData,
          queryParameters: null,
        ),
      ).called(1);
    });
  });

  group('ApiClient.delete', () {
    test('should return parsed response on successful DELETE request',
        () async {
      final responseData = {'deleted': true};

      when(
        () => mockDio.delete<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/test/1'),
        ),
      );

      final result = await apiClient.delete(
        path: '/test/1',
        fromJson: fromJson,
      );

      expect(result, responseData);
      verify(
        () => mockDio.delete<Map<String, dynamic>>(
          '/test/1',
          queryParameters: null,
        ),
      ).called(1);
    });

    test('should throw ClientException on 403 response', () async {
      when(
        () => mockDio.delete<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 403,
            data: {'message': 'Forbidden'},
            requestOptions: RequestOptions(path: '/test/1'),
          ),
          requestOptions: RequestOptions(path: '/test/1'),
        ),
      );

      expect(
        () => apiClient.delete(path: '/test/1', fromJson: fromJson),
        throwsA(isA<ClientException>()),
      );
    });
  });

  group('Error handling', () {
    test('should include validation errors from response', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 422,
            data: {
              'message': 'Validation failed',
              'errors': {
                'email': ['Email is required'],
                'password': ['Password too short'],
              },
            },
            requestOptions: RequestOptions(path: '/test'),
          ),
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      try {
        await apiClient.post(path: '/test', fromJson: fromJson);
        fail('Should have thrown');
      } on ClientException catch (e) {
        expect(e.statusCode, 422);
        expect(e.message, 'Validation failed');
        expect(e.errors, isNotNull);
        expect(e.errors!['email'], ['Email is required']);
      }
    });

    test('should handle send timeout', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.sendTimeout,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      expect(
        () => apiClient.post(path: '/test', fromJson: fromJson),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should handle receive timeout', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      expect(
        () => apiClient.get(path: '/test', fromJson: fromJson),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should handle cancelled request', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.cancel,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      expect(
        () => apiClient.get(path: '/test', fromJson: fromJson),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should handle unknown error', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(path: '/test'),
          message: 'Something went wrong',
        ),
      );

      expect(
        () => apiClient.get(path: '/test', fromJson: fromJson),
        throwsA(isA<UnknownException>()),
      );
    });

    test('should log and wrap unexpected exceptions', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(Exception('Unexpected'));

      when(
        () => mockLogger.error(any(), any(), any()),
      ).thenReturn(null);

      expect(
        () => apiClient.get(path: '/test', fromJson: fromJson),
        throwsA(isA<UnknownException>()),
      );

      verify(() => mockLogger.error(any(), any(), any())).called(1);
    });
  });
}
