import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:notifications_client/notifications_client.dart';
import 'package:permission_client/permission_client.dart';
import 'package:storage/storage.dart';

part 'notifications_storage.dart';

/// {@template notifications_failure}
/// Base exception for notification repository errors.
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
/// Thrown when initializing category preferences fails.
/// {@endtemplate}
class InitializeCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro initialize_categories_preferences_failure}
  const InitializeCategoriesPreferencesFailure(super.error);
}

/// {@template toggle_notifications_failure}
/// Thrown when enabling or disabling notifications fails.
/// {@endtemplate}
class ToggleNotificationsFailure extends NotificationsFailure {
  /// {@macro toggle_notifications_failure}
  const ToggleNotificationsFailure(super.error);
}

/// {@template fetch_notifications_enabled_failure}
/// Thrown when fetching the notifications enabled status fails.
/// {@endtemplate}
class FetchNotificationsEnabledFailure extends NotificationsFailure {
  /// {@macro fetch_notifications_enabled_failure}
  const FetchNotificationsEnabledFailure(super.error);
}

/// {@template set_categories_preferences_failure}
/// Thrown when setting category preferences fails.
/// {@endtemplate}
class SetCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro set_categories_preferences_failure}
  const SetCategoriesPreferencesFailure(super.error);
}

/// {@template fetch_categories_preferences_failure}
/// Thrown when fetching category preferences fails.
/// {@endtemplate}
class FetchCategoriesPreferencesFailure extends NotificationsFailure {
  /// {@macro fetch_categories_preferences_failure}
  const FetchCategoriesPreferencesFailure(super.error);
}

/// {@template notifications_repository}
/// Repository that manages notification permissions and topic subscriptions.
///
/// Device notifications can be enabled or disabled using [toggleNotifications]
/// and retrieved using [fetchNotificationsEnabled].
///
/// Notification settings for topic subscriptions related to categories can be
/// updated using [setCategoriesPreferences]
/// and retrieved using [fetchCategoriesPreferences].
/// {@endtemplate}
class NotificationsRepository {
  /// {@macro notifications_repository}
  NotificationsRepository({
    required PermissionClient permissionClient,
    required NotificationsStorage storage,
    required NotificationsClient notificationsClient,
  }) : _permissionClient = permissionClient,
       _storage = storage,
       _notificationsClient = notificationsClient;

  final PermissionClient _permissionClient;
  final NotificationsStorage _storage;
  final NotificationsClient _notificationsClient;

  /// Enables or disables notifications based on [enable].
  ///
  /// If [enable] is `true`, requests notification permission if not already
  /// granted, and marks the notification setting as enabled in
  /// [NotificationsStorage]. Subscribes the user to notifications for
  /// the selected categories.
  ///
  /// If [enable] is `false`, marks the notification setting as disabled and
  /// unsubscribes the user from notifications for the selected categories.
  Future<void> toggleNotifications({required bool enable}) async {
    try {
      if (enable) {
        final permissionStatus = await _permissionClient.notificationsStatus();

        if (permissionStatus.isPermanentlyDenied || permissionStatus.isRestricted) {
          await _permissionClient.openPermissionSettings();
          return;
        }

        if (permissionStatus.isDenied) {
          final updatedPermissionStatus = await _permissionClient.requestNotifications();
          if (!updatedPermissionStatus.isGranted) {
            return;
          }
        }
      }

      await _toggleCategoriesPreferencesSubscriptions(enable: enable);
      await _storage.setNotificationsEnabled(enabled: enable);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ToggleNotificationsFailure(error), stackTrace);
    }
  }

  /// Returns `true` if notification permission is granted and the notification
  /// setting is enabled.
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
      Error.throwWithStackTrace(FetchNotificationsEnabledFailure(error), stackTrace);
    }
  }

  /// Updates the user's category preferences and subscribes to notifications
  /// for [categories].
  ///
  /// [categories] is a set of category topics the user will receive
  /// notifications for. A topic can be, for example, a student's academic
  /// group or a news category.
  ///
  /// Throws [SetCategoriesPreferencesFailure] if unable to update the
  /// preferences.
  Future<void> setCategoriesPreferences(Set<String> categories) async {
    try {
      await _toggleCategoriesPreferencesSubscriptions(enable: false);

      await _storage.setCategoriesPreferences(categories: categories);

      if (await fetchNotificationsEnabled()) {
        await _toggleCategoriesPreferencesSubscriptions(enable: true);
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SetCategoriesPreferencesFailure(error), stackTrace);
    }
  }

  /// Fetches the user's notification category preferences.
  ///
  /// Returns a set of categories the user is subscribed to for notifications.
  ///
  /// Throws [FetchCategoriesPreferencesFailure] if unable to fetch the preferences.
  Future<Set<String>?> fetchCategoriesPreferences() async {
    try {
      return await _storage.fetchCategoriesPreferences();
    } on StorageException catch (error, stackTrace) {
      Error.throwWithStackTrace(FetchCategoriesPreferencesFailure(error), stackTrace);
    }
  }

  /// Enables or disables notification subscriptions for categories based on
  /// user preferences.
  Future<void> _toggleCategoriesPreferencesSubscriptions({required bool enable}) async {
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
