import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:notifications_client/notifications_client.dart';
import 'package:permission_client/permission_client.dart';
import 'package:storage/storage.dart';

part 'notifications_storage.dart';

/// {@template notifications_failure}
/// Базовое исключение для ошибок репозитория уведомлений.
/// {@endtemplate}
abstract class NotificationsFailure with EquatableMixin implements Exception {
  /// {@macro notifications_failure}
  const NotificationsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template initialize_categories_preferences_failure}
/// Возникает при ошибке инициализации настроек категорий.
/// {@endtemplate}
class InitializeCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro initialize_categories_preferences_failure}
  const InitializeCategoriesPreferencesFailure(super.error);
}

/// {@template toggle_notifications_failure}
/// Возникает при ошибке включения или отключения уведомлений.
/// {@endtemplate}
class ToggleNotificationsFailure extends NotificationsFailure {
  /// {@macro toggle_notifications_failure}
  const ToggleNotificationsFailure(super.error);
}

/// {@template fetch_notifications_enabled_failure}
/// Возникает при ошибке получения статуса включенности уведомлений.
/// {@endtemplate}
class FetchNotificationsEnabledFailure extends NotificationsFailure {
  /// {@macro fetch_notifications_enabled_failure}
  const FetchNotificationsEnabledFailure(super.error);
}

/// {@template set_categories_preferences_failure}
/// Возникает при ошибке установки настроек категорий.
/// {@endtemplate}
class SetCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro set_categories_preferences_failure}
  const SetCategoriesPreferencesFailure(super.error);
}

/// {@template fetch_categories_preferences_failure}
/// Возникает при ошибке получения настроек категорий.
/// {@endtemplate}
class FetchCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro fetch_categories_preferences_failure}
  const FetchCategoriesPreferencesFailure(super.error);
}

/// {@template notifications_repository}
/// Репозиторий, управляющий разрешениями на уведомления и подписками на топики.
///
/// Доступ к уведомлениям устройства может быть включен или отключен с помощью
/// [toggleNotifications] и получен с помощью [fetchNotificationsEnabled].
///
/// Настройки уведомлений для подписок на топики, связанные с категориями
/// новостей, могут быть обновлены с помощью [setCategoriesPreferences] и
/// получены с помощью [fetchCategoriesPreferences].
/// {@endtemplate}
class NotificationsRepository {
  /// {@macro notifications_repository}
  NotificationsRepository({
    required PermissionClient permissionClient,
    required NotificationsStorage storage,
    required NotificationsClient notificationsClient,
  })  : _permissionClient = permissionClient,
        _storage = storage,
        _notificationsClient = notificationsClient;

  final PermissionClient _permissionClient;
  final NotificationsStorage _storage;
  final NotificationsClient _notificationsClient;

  /// Включает или отключает уведомления в зависимости от значения [enable].
  ///
  /// Если [enable] равно `true`, то запрашивает разрешение на уведомления, если
  /// оно ещё не предоставлено, и помечает настройку уведомлений как включенную
  /// в [NotificationsStorage].
  /// Подписывает пользователя на уведомления, связанные выбранными категориями.
  ///
  /// Если [enable] равно `false`, помечает настройку уведомлений как
  /// отключенную и отписывает пользователя от уведомлений, связанных выбранными
  /// категориями.
  Future<void> toggleNotifications({required bool enable}) async {
    try {
      // Запрашивает разрешение на уведомления, если оно ещё не предоставлено.
      if (enable) {
        // Получение текущего статуса разрешения на уведомления.
        final permissionStatus = await _permissionClient.notificationsStatus();

        // Открывает настройки разрешений, если разрешение на уведомления
        // запрещено или ограничено.
        if (permissionStatus.isPermanentlyDenied || permissionStatus.isRestricted) {
          await _permissionClient.openPermissionSettings();
          return;
        }

        // Запрашивает разрешение, если уведомления запрещены.
        if (permissionStatus.isDenied) {
          final updatedPermissionStatus = await _permissionClient.requestNotifications();
          if (!updatedPermissionStatus.isGranted) {
            return;
          }
        }
      }

      // Подписывает пользователя на уведомления, связанные выбранными
      // категориями.
      await _toggleCategoriesPreferencesSubscriptions(enable: enable);

      // Обновляет настройку уведомлений в Storage.
      await _storage.setNotificationsEnabled(enabled: enable);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ToggleNotificationsFailure(error), stackTrace);
    }
  }

  /// Возвращает `true`, если разрешение на уведомления предоставлено и
  /// настройка уведомлений включена.
  Future<bool> fetchNotificationsEnabled() async {
    try {
      final results = await Future.wait([
        _permissionClient.notificationsStatus(),
        _storage.fetchNotificationsEnabled(),
      ]);

      final permissionStatus = results.first as PermissionStatus;
      final notificationsEnabled = results.last as bool;

      return permissionStatus.isGranted && notificationsEnabled;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchNotificationsEnabledFailure(error),
        stackTrace,
      );
    }
  }

  /// Обновляет настройки пользователя по уведомлениям и подписывает
  /// пользователя на получение уведомлений, связанных с [categories].
  ///
  /// [categories] представляет собой набор категорий (топиков), по которым
  /// пользователь будет получать уведомления. Топиком может быть, например,
  /// академическая группа студента или группа новостей.
  ///
  /// Выбрасывает [SetCategoriesPreferencesFailure], когда не удалось обновить
  /// данные.
  Future<void> setCategoriesPreferences(Set<String> categories) async {
    try {
      // Выключает подписки на уведомления для предыдущих настроек категорий.
      await _toggleCategoriesPreferencesSubscriptions(enable: false);

      // Обновляет настройки категорий в Storage.
      await _storage.setCategoriesPreferences(categories: categories);

      // Подписывает пользователя на уведомления для обновленных настроек
      // категорий.
      if (await fetchNotificationsEnabled()) {
        await _toggleCategoriesPreferencesSubscriptions(enable: true);
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SetCategoriesPreferencesFailure(error),
        stackTrace,
      );
    }
  }

  /// Получает настройки пользователя по уведомлениям для категорий.
  ///
  /// Результат представляет собой набор категорий, на которые пользователь
  /// подписался для уведомлений.
  ///
  /// Выбрасывает [FetchCategoriesPreferencesFailure], когда не удалось получить
  /// данные.
  Future<Set<String>?> fetchCategoriesPreferences() async {
    try {
      return await _storage.fetchCategoriesPreferences();
    } on StorageException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchCategoriesPreferencesFailure(error),
        stackTrace,
      );
    }
  }

  /// Включает или отключает подписки на уведомления в зависимости от
  /// настроек пользователя.
  Future<void> _toggleCategoriesPreferencesSubscriptions({
    required bool enable,
  }) async {
    final categoriesPreferences = await _storage.fetchCategoriesPreferences() ?? {};
    await Future.wait(
      categoriesPreferences.map((category) {
        return enable
            ? _notificationsClient.subscribeToCategory(category)
            : _notificationsClient.unsubscribeFromCategory(category);
      }),
    );
  }
}
