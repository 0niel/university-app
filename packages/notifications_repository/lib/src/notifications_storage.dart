import 'dart:convert';

import 'package:notifications_repository/src/notifications_storage_keys.dart';
import 'package:storage/storage.dart';

class NotificationsStorage {
  const NotificationsStorage({required Storage storage}) : _storage = storage;

  final Storage _storage;

  Future<void> setNotificationsEnabled({required bool enabled}) =>
      _storage.write(
        key: NotificationsStorageKeys.notificationsEnabled,
        value: enabled.toString(),
      );

  Future<bool> fetchNotificationsEnabled() async =>
      (await _storage.read(
        key: NotificationsStorageKeys.notificationsEnabled,
      ))?.parseBool() ??
      false;

  Future<void> setCategoriesPreferences({
    required Set<String> categories,
  }) async {
    await _storage.write(
      key: NotificationsStorageKeys.categoriesPreferences,
      value: jsonEncode(categories.toList()),
    );
  }

  Future<Set<String>?> fetchCategoriesPreferences() async {
    final categories = await _storage.read(
      key: NotificationsStorageKeys.categoriesPreferences,
    );
    if (categories == null) return null;

    final decoded = jsonDecode(categories);
    if (decoded is! List) {
      throw const FormatException(
        'Expected a JSON array of notification topics',
      );
    }
    return decoded.cast<String>().toSet();
  }
}

extension _BoolFromStringParsing on String {
  bool parseBool() => toLowerCase() == 'true';
}
