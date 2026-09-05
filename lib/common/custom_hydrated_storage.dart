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
      if (!await _storage.remove(key)) {
        throw StateError('Local storage removal failed');
      }
    }
  }

  @override
  Future<void> close() => .value();

  @override
  Future<void> delete(String key) async {
    if (!await _storage.remove(_key(key))) {
      throw StateError('Local storage removal failed');
    }
  }

  @override
  Object? read(String key) {
    final value = _storage.getString(_key(key));
    return value == null ? null : jsonDecode(value) as Object?;
  }

  @override
  Future<void> write(String key, Object? value) async {
    if (!await _storage.setString(_key(key), jsonEncode(value))) {
      throw StateError('Local storage write failed');
    }
  }
}
