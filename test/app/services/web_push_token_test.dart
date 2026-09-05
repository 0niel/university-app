import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/services/web_push_token.dart';

class _Messaging extends Mock implements FirebaseMessaging {}

class _Settings extends Mock implements NotificationSettings {}

void main() {
  for (final status in AuthorizationStatus.values) {
    test('web token respects $status without prompting', () async {
      final messaging = _Messaging();
      final settings = _Settings();
      when(messaging.isSupported).thenAnswer((_) async => true);
      when(messaging.getNotificationSettings).thenAnswer((_) async => settings);
      when(() => settings.authorizationStatus).thenReturn(status);
      when(
        () => messaging.getToken(vapidKey: 'public-key'),
      ).thenAnswer((_) async => 'token');
      expect(
        await getWebPushToken(messaging, vapidKey: 'public-key'),
        status == AuthorizationStatus.authorized ? 'token' : isNull,
      );
      verifyNever(messaging.requestPermission);
      if (status != AuthorizationStatus.authorized) {
        verifyNever(() => messaging.getToken(vapidKey: any(named: 'vapidKey')));
      }
    });
  }
  test('unsupported browser or absent VAPID cannot register', () async {
    final messaging = _Messaging();
    when(messaging.isSupported).thenAnswer((_) async => false);
    expect(await getWebPushToken(messaging, vapidKey: ''), isNull);
    verifyNever(messaging.isSupported);
    expect(await getWebPushToken(messaging, vapidKey: 'public-key'), isNull);
    verifyNever(messaging.getNotificationSettings);
    verifyNever(() => messaging.getToken(vapidKey: any(named: 'vapidKey')));
    verifyNever(messaging.requestPermission);
  });
}
