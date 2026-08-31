import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:storage/storage.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorage client;
  late SecureStorage storage;

  setUp(() {
    client = _MockFlutterSecureStorage();
    storage = SecureStorage(client);
  });

  test('delegates every storage operation', () async {
    when(() => client.read(key: 'token')).thenAnswer((_) async => 'secret');
    when(
      () => client.write(key: 'token', value: 'updated'),
    ).thenAnswer((_) async {});
    when(() => client.delete(key: 'token')).thenAnswer((_) async {});
    when(client.deleteAll).thenAnswer((_) async {});

    expect(await storage.read(key: 'token'), 'secret');
    await storage.write(key: 'token', value: 'updated');
    await storage.delete(key: 'token');
    await storage.clear();

    verify(() => client.read(key: 'token')).called(1);
    verify(() => client.write(key: 'token', value: 'updated')).called(1);
    verify(() => client.delete(key: 'token')).called(1);
    verify(client.deleteAll).called(1);
  });

  test('wraps failures in StorageException', () async {
    final readFailure = Exception('read failed');
    final writeFailure = Exception('write failed');
    final deleteFailure = Exception('delete failed');
    final clearFailure = Exception('clear failed');
    when(() => client.read(key: 'token')).thenThrow(readFailure);
    when(
      () => client.write(key: 'token', value: 'updated'),
    ).thenThrow(writeFailure);
    when(() => client.delete(key: 'token')).thenThrow(deleteFailure);
    when(client.deleteAll).thenThrow(clearFailure);

    await expectLater(
      storage.read(key: 'token'),
      throwsA(
        isA<StorageException>().having(
          (exception) => exception.error,
          'error',
          same(readFailure),
        ),
      ),
    );
    await expectLater(
      storage.write(key: 'token', value: 'updated'),
      throwsA(
        isA<StorageException>().having(
          (exception) => exception.error,
          'error',
          same(writeFailure),
        ),
      ),
    );
    await expectLater(
      storage.delete(key: 'token'),
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
}
