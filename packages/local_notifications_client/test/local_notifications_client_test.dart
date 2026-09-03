import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications_client/local_notifications_client.dart';
import 'package:mocktail/mocktail.dart';

class _Plugin extends Mock implements FlutterLocalNotificationsPlugin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('PendingReminder', () {
    test('has value equality', () {
      expect(
        const PendingReminder(id: 1, payload: 'lesson'),
        equals(const PendingReminder(id: 1, payload: 'lesson')),
      );
    });
  });

  test(
    'launch payload and foreground taps survive separate client initialization',
    () async {
      final plugin = _Plugin();
      final client = LocalNotificationsClient(plugin: plugin);
      void Function(NotificationResponse)? callback;
      registerFallbackValue(const InitializationSettings());
      when(
        () => plugin.initialize(
          settings: any(named: 'settings'),
          onDidReceiveNotificationResponse: any(
            named: 'onDidReceiveNotificationResponse',
          ),
        ),
      ).thenAnswer((invocation) async {
        callback =
            invocation.namedArguments[#onDidReceiveNotificationResponse]
                as void Function(NotificationResponse)?;
        return true;
      });
      when(plugin.getNotificationAppLaunchDetails).thenAnswer(
        (_) async => const NotificationAppLaunchDetails(
          true,
          notificationResponse: NotificationResponse(
            notificationResponseType:
                NotificationResponseType.selectedNotification,
            payload: 'custom-schedules',
          ),
        ),
      );
      await client.init();
      expect(client.takePendingInteraction(), 'custom-schedules');
      expect(client.takePendingInteraction(), isNull);
      final values = <String>[];
      final subscription = client.interactions.listen(values.add);
      await LocalNotificationsClient(plugin: plugin).init();
      expect(values, isEmpty);
      callback!(
        const NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          payload: 'custom-schedules',
        ),
      );
      expect(values, ['custom-schedules']);
      await subscription.cancel();
    },
  );
}
