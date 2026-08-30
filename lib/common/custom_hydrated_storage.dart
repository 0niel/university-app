import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/common/hydrated_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomHydratedStorage implements Storage {
  const CustomHydratedStorage({required SharedPreferences sharedPreferences})
    : _storage = sharedPreferences;

  final SharedPreferences _storage;

  String _key(String key) => '${HydratedStorageKeys.prefix}$key';

  @override
  Future<void> clear() async {
    final keys = _storage.getKeys().where(
      (key) => key.startsWith(HydratedStorageKeys.prefix),
    );
    for (final key in keys) {
      await _storage.remove(key);
    }
  }

  @override
  Future<void> close() => .value();

  @override
  Future<void> delete(String key) => _storage.remove(_key(key));

  @override
  Object? read(String key) {
    final value = _storage.getString(_key(key));
    return value == null ? null : jsonDecode(value) as Object?;
  }

  @override
  Future<void> write(String key, Object? value) =>
      _storage.setString(_key(key), jsonEncode(value));
}
