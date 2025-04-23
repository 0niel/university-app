part of 'notifications_repository.dart';

/// Keys for [NotificationsStorage].
abstract class NotificationsStorageKeys {
  /// Key for storing notifications enabled status.
  static const notificationsEnabled = '__notifications_enabled_storage_key__';

  /// Key for storing category preferences.
  static const categoriesPreferences = '__categories_preferences_storage_key__';
}

/// {@template notifications_storage}
/// Storage for [NotificationsRepository].
/// {@endtemplate}
class NotificationsStorage {
  /// {@macro notifications_storage}
  const NotificationsStorage({required Storage storage}) : _storage = storage;

  final Storage _storage;

  /// Sets the notifications enabled status ([enabled]) in storage.
  Future<void> setNotificationsEnabled({required bool enabled}) =>
      _storage.write(key: NotificationsStorageKeys.notificationsEnabled, value: enabled.toString());

  /// Fetches the notifications enabled status from storage.
  Future<bool> fetchNotificationsEnabled() async =>
      (await _storage.read(key: NotificationsStorageKeys.notificationsEnabled))?.parseBool() ?? false;

  /// Sets category preferences ([categories]) in storage.
  Future<void> setCategoriesPreferences({required Set<String> categories}) async {
    final categoriesEncoded = json.encode(categories.map((category) => category).toList());
    await _storage.write(key: NotificationsStorageKeys.categoriesPreferences, value: categoriesEncoded);
  }

  /// Fetches category preferences from storage.
  Future<Set<String>?> fetchCategoriesPreferences() async {
    final categories = await _storage.read(key: NotificationsStorageKeys.categoriesPreferences);
    if (categories == null) {
      return null;
    }
    return List<String>.from(json.decode(categories) as List<dynamic>).toSet();
  }
}

extension _BoolFromStringParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
