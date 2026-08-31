import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class ServiceLayoutRepository {
  const ServiceLayoutRepository();

  static const String _storageKey = 'services.layout';

  Future<Map<String, List<String>>?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null) return null;
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (key, value) =>
            MapEntry(key, (value as List).whereType<String>().toList()),
      );
      // JSON decoding and casts can throw Error for corrupt local preferences.
      // ignore: avoid_catches_without_on_clauses
    } catch (e, st) {
      log(
        'Failed to load services layout',
        error: e,
        stackTrace: st,
        name: 'ServiceLayoutRepository',
      );
      return null;
    }
  }

  Future<void> save(Map<String, List<String>> layout) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(layout));
    } on Exception catch (e, st) {
      log(
        'Failed to save services layout',
        error: e,
        stackTrace: st,
        name: 'ServiceLayoutRepository',
      );
    }
  }

  static Map<String, List<String>> merge(
    Map<String, List<String>> defaultLayout,
    Map<String, List<String>>? saved,
    List<String> order,
  ) {
    final placed = <String>{};
    final result = {for (final key in order) key: <String>[]};

    if (saved != null) {
      final known = {for (final ids in defaultLayout.values) ...ids};
      for (final key in order) {
        for (final id in saved[key] ?? const <String>[]) {
          if (known.contains(id) && placed.add(id)) {
            (result[key] ?? <String>[]).add(id);
          }
        }
      }
    }

    for (final key in order) {
      for (final id in defaultLayout[key] ?? const <String>[]) {
        if (placed.add(id)) (result[key] ?? <String>[]).add(id);
      }
    }

    return result;
  }
}
