import 'package:storage/storage.dart';
import 'package:test/test.dart';

void main() {
  test('StorageException exposes its cause and a readable description', () {
    final cause = StateError('unavailable');
    final exception = StorageException(cause);

    expect(exception.error, same(cause));
    expect(exception.toString(), 'StorageException: Bad state: unavailable');
  });
}
