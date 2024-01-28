// ignore_for_file: unnecessary_lambdas

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/utils/request_manager.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:rxdart/rxdart.dart';

// ignore: avoid_implementing_value_types
class MockAccount extends Mock implements Account {}

class MockCallbackFunction<T> extends Mock {
  FutureOr<T> call();
}

class MockedCache extends Mock implements Cache {}

String base64String(String value) => base64.encode(utf8.encode(value));

void main() {
  final account = MockAccount();
  when(() => account.id).thenReturn('clientID');

  tearDown(() {
    RequestManager.instance = null;
    Cache.instance = null;
  });

  group('Cache', () {
    test('singleton', () {
      expect(identical(Cache(), Cache()), isTrue);
    });
  });

  group('RequestManager', () {
    test('singleton', () {
      expect(identical(RequestManager.instance, RequestManager.instance), isTrue);
    });

    test('timeout', () async {
      final callback = MockCallbackFunction<bool>();
      when(callback.call).thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 100), () => true));

      expect(
        () => RequestManager.instance.timeout<bool>(
          () async => callback.call(),
          timeLimit: const Duration(milliseconds: 50),
        ),
        throwsA(isA<TimeoutException>()),
      );
      verify(callback.call).called(1);

      var result = await RequestManager.instance.timeout<bool>(
        () async => callback.call(),
        disableTimeout: true,
        timeLimit: const Duration(milliseconds: 50),
      );
      expect(result, isTrue);
      verify(callback.call).called(1);

      result = await RequestManager.instance.timeout<bool>(
        () async => callback.call(),
        timeLimit: const Duration(milliseconds: 150),
      );
      expect(result, isTrue);
      verify(callback.call).called(1);
    });

    test('throwing DynamiteException should retry', () async {
      final subject = BehaviorSubject<Result<String>>();
      final callback = MockCallbackFunction<Uint8List>();
      when(callback.call).thenAnswer((_) async => throw DynamiteStatusCodeException(500));

      await RequestManager.instance.wrap<String, Uint8List>(
        account: account,
        cacheKey: 'key',
        subject: subject,
        request: () async => callback.call(),
        unwrap: (deserialized) => base64.encode(deserialized),
        serialize: (deserialized) => utf8.decode(deserialized),
        deserialize: (serialized) => utf8.encode(serialized),
      );

      verify(callback.call).called(kMaxRetries + 1);

      await subject.close();
    });

    group('wrap without cache', () {
      test('successful request', () async {
        var subject = BehaviorSubject<Result<String>>();

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result<String>.loading()),
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () async => utf8.encode('Test value'),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();

        subject = BehaviorSubject<Result<String>>.seeded(Result.success('Seed value'));

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result.success('Seed value')),
            equals(Result.success('Seed value').asLoading()),
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () async => utf8.encode('Test value'),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();
      });

      test('timeout request', () async {
        var subject = BehaviorSubject<Result<String>>();

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result<String>.loading()),
            equals(Result<String>.error('TimeoutException after 0:00:00.050000: Future not completed')),
            emitsDone,
          ]),
        );

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          neverEmits([
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () => Future.delayed(const Duration(milliseconds: 100), () => utf8.encode('Test value')),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
          timeLimit: const Duration(milliseconds: 50),
        );

        await subject.close();

        subject = BehaviorSubject<Result<String>>.seeded(Result.success('Seed value'));

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result.success('Seed value')),
            equals(Result.success('Seed value').asLoading()),
            equals(
              Result(
                'Seed value',
                'TimeoutException after 0:00:00.050000: Future not completed',
                isLoading: false,
                isCached: false,
              ),
            ),
            emitsDone,
          ]),
        );

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          neverEmits([
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () => Future.delayed(const Duration(milliseconds: 100), () => utf8.encode('Test value')),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
          timeLimit: const Duration(milliseconds: 50),
        );

        await subject.close();
      });

      test('throwing request', () async {
        var subject = BehaviorSubject<Result<String>>();

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result<String>.loading()),
            equals(Result<String>.error('ClientException: ')),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () async => throw ClientException(''),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();

        subject = BehaviorSubject<Result<String>>.seeded(Result.success('Seed value'));

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result.success('Seed value')),
            equals(Result.success('Seed value').asLoading()),
            equals(Result('Seed value', 'ClientException: ', isLoading: false, isCached: false)),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () async => throw ClientException(''),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();
      });
    });

    group('wrap with fast cache', () {
      late Cache cache;

      setUp(() async {
        cache = MockedCache();
        Cache.mocked(cache);

        when(() => cache.get(any())).thenAnswer(
          (_) => Future.value('Cached value'),
        );

        when(() => cache.set(any(), any())).thenAnswer(
          (_) => Future.value(),
        );

        when(() => cache.init()).thenAnswer(
          (_) => Future.value(),
        );

        await RequestManager.instance.initCache();
      });

      test('successful request', () async {
        var subject = BehaviorSubject<Result<String>>();

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result<String>.loading()),
            equals(Result(base64String('Cached value'), null, isLoading: true, isCached: true)),
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () => Future.value(utf8.encode('Test value')),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verify(() => cache.set(any(that: equals('clientID-key')), any(that: equals('Test value')))).called(1);

        subject = BehaviorSubject<Result<String>>.seeded(Result.success('Seed value'));

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result.success('Seed value')),
            equals(Result.success('Seed value').asLoading()),
            equals(Result(base64String('Cached value'), null, isLoading: true, isCached: true)),
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () => Future.value(utf8.encode('Test value')),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verify(() => cache.set(any(that: equals('clientID-key')), any(that: equals('Test value')))).called(1);
      });

      test('timeout request', () async {
        var subject = BehaviorSubject<Result<String>>();

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result<String>.loading()),
            equals(Result(base64String('Cached value'), null, isLoading: true, isCached: true)),
            equals(
              Result(
                base64String('Cached value'),
                'TimeoutException after 0:00:00.050000: Future not completed',
                isLoading: false,
                isCached: true,
              ),
            ),
            emitsDone,
          ]),
        );

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          neverEmits([
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () => Future.delayed(const Duration(milliseconds: 100), () => utf8.encode('Test value')),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
          timeLimit: const Duration(milliseconds: 50),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verifyNever(() => cache.set(any(), any()));

        subject = BehaviorSubject<Result<String>>.seeded(Result.success('Seed value'));

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result.success('Seed value')),
            equals(Result.success('Seed value').asLoading()),
            equals(Result(base64String('Cached value'), null, isLoading: true, isCached: true)),
            equals(
              Result(
                base64String('Cached value'),
                'TimeoutException after 0:00:00.050000: Future not completed',
                isLoading: false,
                isCached: true,
              ),
            ),
            emitsDone,
          ]),
        );

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          neverEmits([
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () => Future.delayed(const Duration(milliseconds: 100), () => utf8.encode('Test value')),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
          timeLimit: const Duration(milliseconds: 50),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verifyNever(() => cache.set(any(), any()));
      });

      test('throwing request', () async {
        var subject = BehaviorSubject<Result<String>>();

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result<String>.loading()),
            equals(Result(base64String('Cached value'), null, isLoading: true, isCached: true)),
            equals(Result(base64String('Cached value'), 'ClientException: ', isLoading: false, isCached: true)),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () async => throw ClientException(''),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verifyNever(() => cache.set(any(), any()));

        subject = BehaviorSubject<Result<String>>.seeded(Result.success('Seed value'));

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result.success('Seed value')),
            equals(Result.success('Seed value').asLoading()),
            equals(Result(base64String('Cached value'), null, isLoading: true, isCached: true)),
            equals(Result(base64String('Cached value'), 'ClientException: ', isLoading: false, isCached: true)),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () async => throw ClientException(''),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verifyNever(() => cache.set(any(), any()));
      });
    });

    group('wrap with slow cache', () {
      late Cache cache;

      setUp(() async {
        cache = MockedCache();
        Cache.mocked(cache);

        when(() => cache.get(any())).thenAnswer(
          (_) => Future.delayed(const Duration(milliseconds: 100), () => 'Cached value'),
        );

        when(() => cache.set(any(), any())).thenAnswer(
          (_) => Future.value(),
        );

        when(() => cache.init()).thenAnswer(
          (_) => Future.value(),
        );

        await RequestManager.instance.initCache();
      });

      test('successful request', () async {
        var subject = BehaviorSubject<Result<String>>();

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result<String>.loading()),
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () => Future.value(utf8.encode('Test value')),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verify(() => cache.set(any(that: equals('clientID-key')), any(that: equals('Test value')))).called(1);

        subject = BehaviorSubject<Result<String>>.seeded(Result.success('Seed value'));

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result.success('Seed value')),
            equals(Result.success('Seed value').asLoading()),
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () => Future.value(utf8.encode('Test value')),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verify(() => cache.set(any(that: equals('clientID-key')), any(that: equals('Test value')))).called(1);
      });

      test('timeout request', () async {
        var subject = BehaviorSubject<Result<String>>();

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result<String>.loading()),
            equals(
              Result(
                null,
                'TimeoutException after 0:00:00.050000: Future not completed',
                isLoading: false,
                isCached: true,
              ),
            ),
            equals(
              Result(
                base64String('Cached value'),
                'TimeoutException after 0:00:00.050000: Future not completed',
                isLoading: false,
                isCached: true,
              ),
            ),
            emitsDone,
          ]),
        );

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          neverEmits([
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () => Future.delayed(const Duration(milliseconds: 100), () => utf8.encode('Test value')),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
          timeLimit: const Duration(milliseconds: 50),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verifyNever(() => cache.set(any(), any()));

        subject = BehaviorSubject<Result<String>>.seeded(Result.success('Seed value'));

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result.success('Seed value')),
            equals(Result.success('Seed value').asLoading()),
            equals(
              Result(
                'Seed value',
                'TimeoutException after 0:00:00.050000: Future not completed',
                isLoading: false,
                isCached: false,
              ),
            ),
            equals(
              Result(
                base64String('Cached value'),
                'TimeoutException after 0:00:00.050000: Future not completed',
                isLoading: false,
                isCached: true,
              ),
            ),
            emitsDone,
          ]),
        );

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          neverEmits([
            equals(Result.success(base64String('Test value'))),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () => Future.delayed(const Duration(milliseconds: 100), () => utf8.encode('Test value')),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
          timeLimit: const Duration(milliseconds: 50),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verifyNever(() => cache.set(any(), any()));
      });

      test('throwing request', () async {
        var subject = BehaviorSubject<Result<String>>();

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result<String>.loading()),
            equals(Result(null, 'ClientException: ', isLoading: false, isCached: true)),
            equals(Result(base64String('Cached value'), 'ClientException: ', isLoading: false, isCached: true)),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () async => throw ClientException(''),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verifyNever(() => cache.set(any(), any()));

        subject = BehaviorSubject<Result<String>>.seeded(Result.success('Seed value'));

        // ignore: unawaited_futures
        expectLater(
          subject.stream,
          emitsInOrder([
            equals(Result.success('Seed value')),
            equals(Result.success('Seed value').asLoading()),
            equals(Result('Seed value', 'ClientException: ', isLoading: false, isCached: true)),
            equals(Result(base64String('Cached value'), 'ClientException: ', isLoading: false, isCached: true)),
            emitsDone,
          ]),
        );

        await RequestManager.instance.wrap<String, Uint8List>(
          account: account,
          cacheKey: 'key',
          subject: subject,
          request: () async => throw ClientException(''),
          unwrap: (deserialized) => base64.encode(deserialized),
          serialize: (deserialized) => utf8.decode(deserialized),
          deserialize: (serialized) => utf8.encode(serialized),
        );

        await subject.close();
        verify(() => cache.get(any(that: equals('clientID-key')))).called(1);
        verifyNever(() => cache.set(any(), any()));
      });
    });
  });
}
