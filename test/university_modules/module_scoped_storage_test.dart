import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/university_modules/module_scoped_storage.dart';
import 'package:storage/storage.dart';

void main() {
  late _MemoryStorage underlying;
  late bool active;

  setUp(() {
    underlying = _MemoryStorage();
    active = true;
  });

  ModuleScopedStorage scoped({
    String organization = 'university-a',
    String account = 'student-a',
    String module = 'campus-services',
  }) => ModuleScopedStorage(
    storage: underlying,
    organizationId: organization,
    accountId: account,
    moduleId: module,
    isAccountActive: () => active,
  );

  test('separates organization, account and module credentials', () async {
    final first = scoped();
    await first.write('session', 'first-session');
    expect(await first.read('session'), 'first-session');
    expect(await scoped(account: 'student-b').read('session'), isNull);
    expect(await scoped(module: 'another-module').read('session'), isNull);
    expect(await scoped(organization: 'university-b').read('session'), isNull);

    await scoped(account: 'student-b').delete('session');
    expect(await first.read('session'), 'first-session');
    await first.delete('session');
    expect(underlying.values, isEmpty);
  });

  test('rejects invalid keys before accessing underlying storage', () async {
    final storage = scoped();
    for (final key in ['', '../session', 'module:session', 'token/session']) {
      await expectLater(storage.read(key), throwsArgumentError);
      await expectLater(storage.write(key, 'value'), throwsArgumentError);
      await expectLater(storage.delete(key), throwsArgumentError);
    }
    expect(underlying.operations, 0);
  });

  test('blocks old session access after an account change', () async {
    final storage = scoped();
    await storage.write('session', 'private-session');
    active = false;
    final operations = underlying.operations;

    await expectLater(
      storage.read('session'),
      throwsA(isA<ModuleAccountChangedException>()),
    );
    await expectLater(
      storage.write('session', 'replacement'),
      throwsA(isA<ModuleAccountChangedException>()),
    );
    await expectLater(
      storage.delete('session'),
      throwsA(isA<ModuleAccountChangedException>()),
    );
    expect(underlying.operations, operations);
  });

  test('does not return a pending read after account change', () async {
    final storage = scoped();
    await storage.write('session', 'private-session');
    final gate = Completer<void>();
    underlying.readGate = gate;
    final pending = storage.read('session');
    active = false;
    gate.complete();

    await expectLater(
      pending,
      throwsA(isA<ModuleAccountChangedException>()),
    );
  });

  test('encodes scope separators without namespace collisions', () async {
    final first = scoped(account: 'first:second', module: 'third');
    final second = scoped(account: 'first', module: 'second:third');
    await first.write('session', 'first-session');
    expect(await second.read('session'), isNull);
  });
}

class _MemoryStorage implements Storage {
  final values = <String, String>{};
  int operations = 0;
  Completer<void>? readGate;

  @override
  Future<String?> read({required String key}) async {
    operations++;
    await readGate?.future;
    return values[key];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    operations++;
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    operations++;
    values.remove(key);
  }

  @override
  Future<void> clear() async => values.clear();
}
