import 'package:permission_handler/permission_handler.dart';

export 'package:permission_handler/permission_handler.dart' show PermissionStatus, PermissionStatusGetters;

/// {@template permission_client}
/// Клиент для запроса разрешений.
/// {@endtemplate}
class PermissionClient {
  /// {@macro permission_client}
  const PermissionClient();

  /// Запрашивает доступ к уведомлениям устройства,
  /// если доступ ранее не был предоставлен.
  Future<PermissionStatus> requestNotifications() => Permission.notification.request();

  /// Возвращает статус доступа к уведомлениям устройства.
  Future<PermissionStatus> notificationsStatus() => Permission.notification.status;

  /// Открывает настройки приложения.
  ///
  /// Возвращает `true`, если настройки были открыты.
  Future<bool> openPermissionSettings() => openAppSettings();
}
