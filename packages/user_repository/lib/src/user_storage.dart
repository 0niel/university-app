import 'package:storage/storage.dart';
import 'package:user_repository/src/user_storage_keys.dart';

export 'user_storage_keys.dart';

class UserStorage {
  const UserStorage({required this._storage});

  final Storage _storage;

  Future<void> setAppOpenedCount({required int count}) => _storage.write(
    key: UserStorageKeys.appOpenedCount,
    value: count.toString(),
  );

  Future<int> fetchAppOpenedCount() async {
    final count = await _storage.read(key: UserStorageKeys.appOpenedCount);
    return int.parse(count ?? '0');
  }
}
