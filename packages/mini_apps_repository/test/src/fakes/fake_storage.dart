import 'package:storage/storage.dart';

class FakeStorage implements Storage {
  FakeStorage({this.failing = false});

  final bool failing;
  final values = <String, String>{};

  @override
  Future<String?> read({required String key}) async {
    if (failing) {
      throw const StorageException('read failed');
    }
    return values[key];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    if (failing) {
      throw const StorageException('write failed');
    }
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async => values.remove(key);

  @override
  Future<void> clear() async => values.clear();
}
