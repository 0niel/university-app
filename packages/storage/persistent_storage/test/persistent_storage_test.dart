import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

class _MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences preferences;
  late PersistentStorage storage;

  setUp(() {
    preferences = _MockSharedPreferences();
    storage = PersistentStorage(sharedPreferences: preferences);
  });

  test('delegates every storage operation', () async {
    when(() => preferences.getString('theme')).thenReturn('dark');
    when(
      () => preferences.setString('theme', 'light'),
    ).thenAnswer((_) async => true);
    when(() => preferences.remove('theme')).thenAnswer((_) async => true);
    when(preferences.clear).thenAnswer((_) async => true);

    expect(await storage.read(key: 'theme'), 'dark');
    await storage.write(key: 'theme', value: 'light');
    await storage.delete(key: 'theme');
    await storage.clear();

    verify(() => preferences.getString('theme')).called(1);
    verify(() => preferences.setString('theme', 'light')).called(1);
    verify(() => preferences.remove('theme')).called(1);
    verify(preferences.clear).called(1);
  });

  test('wraps failures in StorageException', () async {
    final readFailure = Exception('read failed');
    final writeFailure = Exception('write failed');
    final deleteFailure = Exception('delete failed');
    final clearFailure = Exception('clear failed');
    when(() => preferences.getString('theme')).thenThrow(readFailure);
    when(
      () => preferences.setString('theme', 'light'),
    ).thenThrow(writeFailure);
    when(() => preferences.remove('theme')).thenThrow(deleteFailure);
    when(preferences.clear).thenThrow(clearFailure);

    await expectLater(
      storage.read(key: 'theme'),
      throwsA(
        isA<StorageException>().having(
          (exception) => exception.error,
          'error',
          same(readFailure),
        ),
      ),
    );
    await expectLater(
      storage.write(key: 'theme', value: 'light'),
      throwsA(
        isA<StorageException>().having(
          (exception) => exception.error,
          'error',
          same(writeFailure),
        ),
      ),
    );
    await expectLater(
      storage.delete(key: 'theme'),
      throwsA(
        isA<StorageException>().having(
          (exception) => exception.error,
          'error',
          same(deleteFailure),
        ),
      ),
    );
    await expectLater(
      storage.clear(),
      throwsA(
        isA<StorageException>().having(
          (exception) => exception.error,
          'error',
          same(clearFailure),
        ),
      ),
    );
  });

  test('treats rejected mutations as storage failures', () async {
    when(
      () => preferences.setString('theme', 'light'),
    ).thenAnswer((_) async => false);
    when(() => preferences.remove('theme')).thenAnswer((_) async => false);
    when(preferences.clear).thenAnswer((_) async => false);

    await expectLater(
      storage.write(key: 'theme', value: 'light'),
      throwsA(isA<StorageException>()),
    );
    await expectLater(
      storage.delete(key: 'theme'),
      throwsA(isA<StorageException>()),
    );
    await expectLater(storage.clear(), throwsA(isA<StorageException>()));
  });
}
