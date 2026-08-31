import 'package:permission_handler/permission_handler.dart';

export 'package:permission_handler/permission_handler.dart'
    show PermissionStatus, PermissionStatusGetters;

class PermissionClient {
  const PermissionClient();

  Future<PermissionStatus> requestNotifications() =>
      Permission.notification.request();

  Future<PermissionStatus> notificationsStatus() =>
      Permission.notification.status;

  Future<PermissionStatus> requestLocationWhenInUse() =>
      Permission.locationWhenInUse.request();

  Future<PermissionStatus> locationWhenInUseStatus() =>
      Permission.locationWhenInUse.status;

  Future<PermissionStatus> requestNearbyWifiDevices() =>
      Permission.nearbyWifiDevices.request();

  Future<bool> openPermissionSettings() => openAppSettings();
}
