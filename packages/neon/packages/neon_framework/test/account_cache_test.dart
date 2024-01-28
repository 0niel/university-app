import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/src/models/account_cache.dart';
import 'package:neon_framework/src/models/disposable.dart';

class DisposableMock extends Mock implements Disposable {}

// ignore: avoid_implementing_value_types
class AccountMock extends Mock implements Account {}

void main() {
  final disposable0 = DisposableMock();
  final disposable1 = DisposableMock();
  final account0 = AccountMock();
  final account1 = AccountMock();

  when(() => account0.id).thenReturn('key0');
  when(() => account1.id).thenReturn('key1');

  group('AccountCache', () {
    test('map functionality', () {
      final cache = AccountCache<DisposableMock>();

      expect(cache[account0], isNull);

      cache[account0] = disposable0;
      expect(cache[account0], disposable0);

      expect(cache[account0] ??= disposable1, disposable0);
      expect(cache[account1] ??= disposable1, disposable1);
    });

    test('prune', () {
      final cache = AccountCache<DisposableMock>();
      cache[account0] = disposable0;
      cache[account1] = disposable1;

      cache.pruneAgainst([account0]);

      expect(cache[account0], disposable0);
      expect(cache[account1], isNull);
      verify(disposable1.dispose).called(1);
    });

    test('dispose', () {
      final cache = AccountCache<DisposableMock>();
      cache[account0] = disposable0;
      cache[account1] = disposable1;

      cache.dispose();

      expect(cache[account0], isNull);
      expect(cache[account1], isNull);
      verify(disposable0.dispose).called(1);
      verify(disposable1.dispose).called(1);
    });

    test('remove', () {
      final cache = AccountCache<DisposableMock>();
      cache[account0] = disposable0;
      cache[account1] = disposable1;

      cache.remove(null);

      expect(cache[account0], disposable0);
      expect(cache[account1], disposable1);

      cache.remove(account0);
      expect(cache[account0], isNull);
      verify(disposable0.dispose).called(1);
    });
  });
}
