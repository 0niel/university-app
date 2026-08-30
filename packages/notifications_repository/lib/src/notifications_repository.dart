import 'dart:async';
import 'package:notifications_client/notifications_client.dart';
import 'package:notifications_repository/src/notifications_failure.dart';
import 'package:notifications_repository/src/notifications_storage.dart';
import 'package:permission_client/permission_client.dart';

class NotificationsRepository {
  const NotificationsRepository({
    required PermissionClient permissionClient,
    required NotificationsStorage storage,
    required NotificationsClient notificationsClient,
  }) : _permissionClient = permissionClient,
       _storage = storage,
       _notificationsClient = notificationsClient;

  final PermissionClient _permissionClient;
  final NotificationsStorage _storage;
  final NotificationsClient _notificationsClient;

  Future<void> toggleNotifications({required bool enable}) async {
    try {
      if (enable) {
        final permissionStatus = await _permissionClient.notificationsStatus();

        if (permissionStatus.isPermanentlyDenied ||
            permissionStatus.isRestricted) {
          await _permissionClient.openPermissionSettings();
          return;
        }

        if (permissionStatus.isDenied) {
          final updatedPermissionStatus =
              await _permissionClient.requestNotifications();
          if (!updatedPermissionStatus.isGranted) {
            return;
          }
        }
      }

      await _toggleCategoriesPreferencesSubscriptions(enable: enable);
      await _storage.setNotificationsEnabled(enabled: enable);
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(ToggleNotificationsFailure(error), stackTrace);
    }
  }

  Future<bool> fetchNotificationsEnabled() async {
    try {
      final (permissionStatus, notificationsEnabled) =
          await (
            _permissionClient.notificationsStatus(),
            _storage.fetchNotificationsEnabled(),
          ).wait;

      return permissionStatus.isGranted && notificationsEnabled;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchNotificationsEnabledFailure(error),
        stackTrace,
      );
    }
  }

  Future<void> setCategoriesPreferences(Set<String> categories) async {
    try {
      await _toggleCategoriesPreferencesSubscriptions(enable: false);

      await _storage.setCategoriesPreferences(categories: categories);

      if (await fetchNotificationsEnabled()) {
        await _toggleCategoriesPreferencesSubscriptions(enable: true);
      }
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SetCategoriesPreferencesFailure(error),
        stackTrace,
      );
    }
  }

  Future<Set<String>?> fetchCategoriesPreferences() async {
    try {
      return await _storage.fetchCategoriesPreferences();
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchCategoriesPreferencesFailure(error),
        stackTrace,
      );
    }
  }

  Future<void> _toggleCategoriesPreferencesSubscriptions({
    required bool enable,
  }) async {
    final categoriesPreferences =
        await _storage.fetchCategoriesPreferences() ?? {};
    await Future.wait(
      categoriesPreferences.map((category) {
        return enable
            ? _notificationsClient.subscribeToCategory(category)
            : _notificationsClient.unsubscribeFromCategory(category);
      }),
    );
  }
}
