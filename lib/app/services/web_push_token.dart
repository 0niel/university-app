import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getWebPushToken(
  FirebaseMessaging messaging, {
  required String vapidKey,
}) async {
  if (vapidKey.isEmpty || !await messaging.isSupported()) return null;
  final settings = await messaging.getNotificationSettings();
  if (settings.authorizationStatus != AuthorizationStatus.authorized) {
    return null;
  }
  return messaging.getToken(vapidKey: vapidKey);
}
