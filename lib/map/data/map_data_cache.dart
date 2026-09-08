import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

int _mapUtf8Size(String value) => utf8.encode(value).length;

Future<int> _mapBytes(String value) => value.length > 65536
    ? compute(_mapUtf8Size, value)
    : Future.value(_mapUtf8Size(value));

abstract interface class MapDataCache {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

class PreferencesMapDataCache implements MapDataCache {
  static const _prefix = 'campus_map_v1:';
  static const int _maximumBytes = 32 * 1024 * 1024;
  static Future<void> _writeTail = Future<void>.value();

  Future<void> removeMigrated(String key) {
    final operation = _writeTail.then((_) async {
      final preferences = await SharedPreferences.getInstance();
      final name = '$_prefix$key';
      if (!preferences.containsKey(name)) return;
      await preferences.remove(name);
      final entries = preferences.getStringList('${_prefix}index');
      if (entries != null && entries.remove(name)) {
        await preferences.setStringList('${_prefix}index', entries);
      }
    });
    _writeTail = operation.catchError((Object _) {});
    return operation;
  }

  @override
  Future<String?> read(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('$_prefix$key');
  }

  @override
  Future<void> write(String key, String value) {
    final operation = _writeTail.then((_) => _write(key, value));
    _writeTail = operation.catchError((Object _) {});
    return operation;
  }

  Future<void> _write(String key, String value) async {
    final valueBytes = await _mapBytes(value);
    if (valueBytes > _maximumBytes) return;
    final preferences = await SharedPreferences.getInstance();
    final name = '$_prefix$key';
    final entries = (preferences.getStringList('${_prefix}index') ?? [])
      ..remove(name)
      ..add(name);
    final sizes = <String, int>{};
    try {
      final decoded = jsonDecode(
        preferences.getString('${_prefix}sizes') ?? '{}',
      );
      if (decoded is Map) {
        for (final entry in decoded.entries) {
          final Object? size = entry.value;
          if (entry.key is String && size is int && size >= 0) {
            sizes[entry.key as String] = size;
          }
        }
      }
    } on FormatException {
      sizes.clear();
    }
    sizes[name] = valueBytes;
    await preferences.setString(name, value);
    var totalBytes = 0;
    for (final entry in entries.reversed.toList()) {
      final bytes =
          sizes[entry] ?? await _mapBytes(preferences.getString(entry) ?? '');
      sizes[entry] = bytes;
      totalBytes += bytes;
      if (totalBytes > _maximumBytes) {
        await preferences.remove(entry);
        entries.remove(entry);
        sizes.remove(entry);
      }
    }
    await preferences.setStringList('${_prefix}index', entries);
    sizes.removeWhere((entry, _) => !entries.contains(entry));
    await preferences.setString('${_prefix}sizes', jsonEncode(sizes));
  }
}
