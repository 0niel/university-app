// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/blocs.dart';

void main() {
  group('Result', () {
    test('Equality', () {
      const data = 'someData';

      var a = Result(
        data,
        null,
        isLoading: true,
        isCached: false,
      );
      var b = Result(
        data,
        null,
        isLoading: true,
        isCached: true,
      );

      expect(a, equals(a), reason: 'identical');
      expect(a, equals(b), reason: 'ignore cached state in equality');

      expect(a.hashCode, equals(a.hashCode), reason: 'identical');
      expect(a.hashCode, isNot(equals(b.hashCode)), reason: 'hashCode should respect the cached state');

      a = Result(
        data,
        Exception(),
        isLoading: true,
        isCached: false,
      );
      b = Result(
        data,
        Exception(),
        isLoading: true,
        isCached: true,
      );

      expect(a, equals(b), reason: 'error should be compared as string');
    });

    test('Transform to loading', () {
      const data = 'someData';

      final a = Result.success(data);
      final b = Result(
        data,
        null,
        isLoading: true,
        isCached: false,
      );

      expect(a, isNot(equals(b)));
      expect(a.asLoading(), equals(b));
    });

    test('data check', () {
      const data = 'someData';

      final loading = Result<String>.loading();
      final success = Result.success(data);
      final error = Result.error(data);
      final cached = Result(
        data,
        null,
        isLoading: false,
        isCached: true,
      );

      expect(success.hasData, isTrue);
      expect(loading.hasData, isFalse);
      expect(error.hasData, isFalse);

      expect(success.requireData, equals(data));
      expect(() => loading.requireData, throwsStateError);
      expect(() => error.requireData, throwsStateError);

      expect(success.hasSuccessfulData, isTrue);
      expect(cached.hasSuccessfulData, isFalse);
      expect(error.hasSuccessfulData, isFalse);
    });

    test('error check', () {
      const error = 'someError';

      final a = Result<String>.error(error);

      expect(a.hasError, true);
    });

    test('transform', () {
      const data = 1;

      final a = Result.success(data);

      String transformer(int data) => data.toString();

      expect(a.transform(transformer), equals(Result.success(data.toString())));
    });

    test('copyWith', () {
      expect(Result<dynamic>('String', 'error', isLoading: false, isCached: false).copyWith(data: '').data, '');
      expect(Result<String>('String', 'error', isLoading: false, isCached: false).copyWith(data: '').data, '');

      expect(Result<dynamic>.loading().copyWith(data: '').isLoading, true);
      expect(Result<String>.loading().copyWith(data: '').isLoading, true);

      expect(Result<dynamic>.success('String').copyWith(data: '').data, '');
      expect(Result<String>.success('String').copyWith(data: '').data, '');

      expect(Result<dynamic>.error('error').copyWith(data: '').error, 'error');
      expect(Result<String>.error('error').copyWith(data: '').error, 'error');
    });

    test('toString', () {
      final result = Result<dynamic>('value', Exception(), isLoading: false, isCached: true);

      expect(result.toString(), 'Result(value, Exception, isLoading: false, isCached: true)');
    });
  });
}
