part of 'notifications_repository.dart';

/// Ключи для [NotificationsStorage].
abstract class NotificationsStorageKeys {
  /// Ключ для хранения статуса включенности уведомлений.
  static const notificationsEnabled = '__notifications_enabled_storage_key__';

  /// Ключ для хранения предпочтений категорий.
  static const categoriesPreferences = '__categories_preferences_storage_key__';
}

/// {@template notifications_storage}
/// Хранилище для [NotificationsRepository].
/// {@endtemplate}
class NotificationsStorage {
  /// {@macro notifications_storage}
  const NotificationsStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  /// Устанавливает статус включенности уведомлений ([enabled]) в хранилище.
  Future<void> setNotificationsEnabled({required bool enabled}) => _storage.write(
        key: NotificationsStorageKeys.notificationsEnabled,
        value: enabled.toString(),
      );

  /// Получает статус включенности уведомлений из хранилища.
  Future<bool> fetchNotificationsEnabled() async =>
      (await _storage.read(key: NotificationsStorageKeys.notificationsEnabled))?.parseBool() ?? false;

  /// Устанавливает предпочтения категорий в [categories] в хранилище.
  Future<void> setCategoriesPreferences({
    required Set<String> categories,
  }) async {
    final categoriesEncoded = json.encode(
      categories.map((category) => category).toList(),
    );
    await _storage.write(
      key: NotificationsStorageKeys.categoriesPreferences,
      value: categoriesEncoded,
    );
  }

  /// Получает значение предпочтений категорий из хранилища.
  Future<Set<String>?> fetchCategoriesPreferences() async {
    final categories = await _storage.read(
      key: NotificationsStorageKeys.categoriesPreferences,
    );
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
