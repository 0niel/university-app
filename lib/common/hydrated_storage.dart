import 'dart:convert';
import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage keys for the [CustomHydratedStorage].
abstract class HydratedStorageKeys {
  /// The key for the hydrated bloc storage.
  static const prefixKey = '__hydrated_bloc__';
}

/// A custom hydrated storage implementation using the [storage] package.
class CustomHydratedStorage implements Storage {
  const CustomHydratedStorage({
    required SharedPreferences sharedPreferences,
  }) : _storage = sharedPreferences;

  final SharedPreferences _storage;

  String _key(String key) => '${HydratedStorageKeys.prefixKey}$key';

  @override
  Future<void> clear() {
    return _storage.clear();
  }

  @override
  Future<void> close() {
    return Future.value();
  }

  @override
  Future<void> delete(String key) {
    return _storage.remove(_key(key));
  }

  @override
  dynamic read(String key) {
    final value = _storage.getString(_key(key));
    if (value != null) {
      return json.decode(value);
    }

    return null;
  }

  @override
  Future<void> write(String key, value) {
    final encoded = json.encode(value);
    return _storage.setString(_key(key), encoded);
  }
}
