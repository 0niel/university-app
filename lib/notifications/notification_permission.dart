import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:rtu_mirea_app/config/config.dart';

Future<bool> hasNotificationPermission(
  LocalNotificationsRepository repository,
) async {
  if (!kIsWeb) return repository.hasPermission();
  if (!FirebaseRuntime.messagingAvailable) return false;
  final messaging = FirebaseMessaging.instance;
  if (!await messaging.isSupported()) return false;
  final settings = await messaging.getNotificationSettings();
  return settings.authorizationStatus == AuthorizationStatus.authorized;
}

Future<bool> requestNotificationPermission(
  LocalNotificationsRepository repository,
) async {
  if (!kIsWeb) return repository.ensurePermission();
  if (!FirebaseRuntime.messagingAvailable) return false;
  final messaging = FirebaseMessaging.instance;
  if (!await messaging.isSupported()) return false;
  final settings = await messaging.requestPermission();
  return settings.authorizationStatus == AuthorizationStatus.authorized;
}
