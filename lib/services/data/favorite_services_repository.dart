import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class FavoriteServicesRepository {
  const FavoriteServicesRepository();

  static const String _storageKey = 'services.favorites';

  static String? idOf({String? routePath, String? url}) {
    if (routePath != null && routePath.isNotEmpty) return routePath;
    if (url != null && url.isNotEmpty) return url;
    return null;
  }

  Future<Set<String>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_storageKey)?.toSet() ?? {};
    } on Exception catch (e, st) {
      log(
        'Failed to load favorite services',
        error: e,
        stackTrace: st,
        name: 'FavoriteServicesRepository',
      );
      return {};
    }
  }

  Future<void> save(Set<String> ids) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, ids.toList());
    } on Exception catch (e, st) {
      log(
        'Failed to save favorite services',
        error: e,
        stackTrace: st,
        name: 'FavoriteServicesRepository',
      );
    }
  }
}
