import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sirsak_pop_nasabah/services/api/dio_client.dart';

class MockDio extends Mock implements Dio {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  late MockDio mockDio;
  late RetryInterceptor interceptor;

  setUp(() {
    mockDio = MockDio();
    interceptor = RetryInterceptor(
      dio: mockDio,
      maxRetries: 3,
      retryDelays: const [
        Duration(milliseconds: 10),
        Duration(milliseconds: 20),
        Duration(milliseconds: 40),
      ],
    );
  });

  group('RetryInterceptor', () {
    test('should retry on connection timeout and succeed on retry', () async {
      final requestOptions = RequestOptions(path: '/test');
      final successResponse = Response<dynamic>(
        data: {'success': true},
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(() => mockDio.fetch<dynamic>(any())).thenAnswer(
        (_) async => successResponse,
      );

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: requestOptions,
        ),
        handler,
      );

      verify(() => mockDio.fetch<dynamic>(any())).called(1);
      expect(handler.resolvedResponse, successResponse);
    });

    test('should retry on connection error', () async {
      final requestOptions = RequestOptions(path: '/test');
      final successResponse = Response<dynamic>(
        data: {'success': true},
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(() => mockDio.fetch<dynamic>(any())).thenAnswer(
        (_) async => successResponse,
      );

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.connectionError,
          requestOptions: requestOptions,
        ),
        handler,
      );

      verify(() => mockDio.fetch<dynamic>(any())).called(1);
      expect(handler.resolvedResponse, isNotNull);
    });

    test('should retry on send timeout', () async {
      final requestOptions = RequestOptions(path: '/test');
      final successResponse = Response<dynamic>(
        data: {'success': true},
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(() => mockDio.fetch<dynamic>(any())).thenAnswer(
        (_) async => successResponse,
      );

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.sendTimeout,
          requestOptions: requestOptions,
        ),
        handler,
      );

      verify(() => mockDio.fetch<dynamic>(any())).called(1);
    });

    test('should retry on receive timeout', () async {
      final requestOptions = RequestOptions(path: '/test');
      final successResponse = Response<dynamic>(
        data: {'success': true},
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(() => mockDio.fetch<dynamic>(any())).thenAnswer(
        (_) async => successResponse,
      );

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: requestOptions,
        ),
        handler,
      );

      verify(() => mockDio.fetch<dynamic>(any())).called(1);
    });

    test('should retry on 5xx server error', () async {
      final requestOptions = RequestOptions(path: '/test');
      final successResponse = Response<dynamic>(
        data: {'success': true},
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(() => mockDio.fetch<dynamic>(any())).thenAnswer(
        (_) async => successResponse,
      );

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: requestOptions,
          response: Response<dynamic>(
            statusCode: 500,
            requestOptions: requestOptions,
          ),
        ),
        handler,
      );

      verify(() => mockDio.fetch<dynamic>(any())).called(1);
      expect(handler.resolvedResponse, isNotNull);
    });

    test('should NOT retry on 4xx client error', () async {
      final requestOptions = RequestOptions(path: '/test');

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: requestOptions,
          response: Response<dynamic>(
            statusCode: 400,
            requestOptions: requestOptions,
          ),
        ),
        handler,
      );

      verifyNever(() => mockDio.fetch<dynamic>(any()));
      expect(handler.nextCalled, true);
    });

    test('should NOT retry on 401 unauthorized', () async {
      final requestOptions = RequestOptions(path: '/test');

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: requestOptions,
          response: Response<dynamic>(
            statusCode: 401,
            requestOptions: requestOptions,
          ),
        ),
        handler,
      );

      verifyNever(() => mockDio.fetch<dynamic>(any()));
      expect(handler.nextCalled, true);
    });

    test('should NOT retry on 422 validation error', () async {
      final requestOptions = RequestOptions(path: '/test');

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: requestOptions,
          response: Response<dynamic>(
            statusCode: 422,
            data: {'errors': {}},
            requestOptions: requestOptions,
          ),
        ),
        handler,
      );

      verifyNever(() => mockDio.fetch<dynamic>(any()));
      expect(handler.nextCalled, true);
    });

    test('should stop retrying after max retries exceeded', () async {
      final requestOptions = RequestOptions(
        path: '/test',
        extra: {'retry_attempt': 3}, // Already at max
      );

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: requestOptions,
        ),
        handler,
      );

      verifyNever(() => mockDio.fetch<dynamic>(any()));
      expect(handler.nextCalled, true);
    });

    test('should increment retry attempt in request options', () async {
      final requestOptions = RequestOptions(path: '/test');
      final successResponse = Response<dynamic>(
        data: {'success': true},
        statusCode: 200,
        requestOptions: requestOptions,
      );

      RequestOptions? capturedOptions;
      when(() => mockDio.fetch<dynamic>(any())).thenAnswer((invocation) async {
        capturedOptions =
            invocation.positionalArguments[0] as RequestOptions;
        return successResponse;
      });

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: requestOptions,
        ),
        handler,
      );

      expect(capturedOptions?.extra['retry_attempt'], 1);
    });

    test('should pass error to next handler if retry also fails', () async {
      final requestOptions = RequestOptions(path: '/test');

      when(() => mockDio.fetch<dynamic>(any())).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: requestOptions,
        ),
      );

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: requestOptions,
        ),
        handler,
      );

      verify(() => mockDio.fetch<dynamic>(any())).called(1);
      expect(handler.nextCalled, true);
    });

    test('should NOT retry cancelled requests', () async {
      final requestOptions = RequestOptions(path: '/test');

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.cancel,
          requestOptions: requestOptions,
        ),
        handler,
      );

      verifyNever(() => mockDio.fetch<dynamic>(any()));
      expect(handler.nextCalled, true);
    });

    test('should retry on 502 bad gateway', () async {
      final requestOptions = RequestOptions(path: '/test');
      final successResponse = Response<dynamic>(
        data: {'success': true},
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(() => mockDio.fetch<dynamic>(any())).thenAnswer(
        (_) async => successResponse,
      );

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: requestOptions,
          response: Response<dynamic>(
            statusCode: 502,
            requestOptions: requestOptions,
          ),
        ),
        handler,
      );

      verify(() => mockDio.fetch<dynamic>(any())).called(1);
    });

    test('should retry on 503 service unavailable', () async {
      final requestOptions = RequestOptions(path: '/test');
      final successResponse = Response<dynamic>(
        data: {'success': true},
        statusCode: 200,
        requestOptions: requestOptions,
      );

      when(() => mockDio.fetch<dynamic>(any())).thenAnswer(
        (_) async => successResponse,
      );

      final handler = _MockErrorInterceptorHandler();

      await interceptor.onError(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: requestOptions,
          response: Response<dynamic>(
            statusCode: 503,
            requestOptions: requestOptions,
          ),
        ),
        handler,
      );

      verify(() => mockDio.fetch<dynamic>(any())).called(1);
    });
  });
}

/// Mock handler to track what the interceptor does
class _MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {
  Response<dynamic>? resolvedResponse;
  bool nextCalled = false;

  @override
  void resolve(Response<dynamic> response) {
    resolvedResponse = response;
  }

  @override
  void next(DioException err) {
    nextCalled = true;
  }
}
