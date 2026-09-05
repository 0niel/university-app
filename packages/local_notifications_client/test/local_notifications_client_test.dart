import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications_client/local_notifications_client.dart';
import 'package:mocktail/mocktail.dart';

class _Plugin extends Mock implements FlutterLocalNotificationsPlugin {}

class _MacPlugin extends Mock implements MacOSFlutterLocalNotificationsPlugin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => debugDefaultTargetPlatformOverride = null);
  test(
    'push display uses a high-priority channel and iOS foreground presentation',
    () async {
      final plugin = _Plugin();
      registerFallbackValue(const NotificationDetails());
      when(
        () => plugin.show(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
          notificationDetails: any(named: 'notificationDetails'),
        ),
      ).thenAnswer((_) async {});
      await LocalNotificationsClient(
        plugin: plugin,
      ).showPush(id: 42, title: 'Title', body: 'Body', payload: 'route');
      final details =
          verify(
                () => plugin.show(
                  id: 42,
                  title: 'Title',
                  body: 'Body',
                  payload: 'route',
                  notificationDetails: captureAny(named: 'notificationDetails'),
                ),
              ).captured.single
              as NotificationDetails;
      expect(details.android!.channelId, 'app_push');
      expect(details.android!.importance, Importance.high);
      expect(details.android!.priority, Priority.high);
      expect(details.android!.playSound, isTrue);
      expect(details.iOS!.presentBanner, isTrue);
      expect(details.iOS!.presentSound, isTrue);
      expect(details.macOS!.presentBanner, isTrue);
      expect(details.macOS!.presentSound, isTrue);
      expect(details.linux, isNotNull);
      expect(details.windows, isNotNull);
    },
  );
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
        final settings =
            invocation.namedArguments[#settings] as InitializationSettings;
        expect(settings.macOS!.requestAlertPermission, isFalse);
        expect(settings.linux!.defaultActionName, isNotEmpty);
        expect(settings.windows!.appName, isNotEmpty);
        expect(
          settings.windows!.appUserModelId,
          'ninja.mirea.rtu_mirea_mobile',
        );
        expect(settings.windows!.guid, '5be4f1cc-71a0-5903-ab53-88cdf4f30e6d');
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

  test(
    'macOS reads permission without prompting and requests explicitly',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      final plugin = _Plugin();
      final macos = _MacPlugin();
      when(
        () =>
            plugin
                .resolvePlatformSpecificImplementation<
                  MacOSFlutterLocalNotificationsPlugin
                >(),
      ).thenReturn(macos);
      when(macos.checkPermissions).thenAnswer((_) async => null);
      when(
        () => macos.requestPermissions(alert: true, badge: true, sound: true),
      ).thenAnswer((_) async => true);
      final client = LocalNotificationsClient(plugin: plugin);
      expect(await client.hasDesktopPermission(), isFalse);
      verifyNever(
        () => macos.requestPermissions(alert: true, badge: true, sound: true),
      );
      expect(await client.requestPermission(), isTrue);
    },
  );

  for (final platform in [TargetPlatform.windows, TargetPlatform.linux]) {
    test(
      '$platform can attempt native display without a mobile permission API',
      () async {
        debugDefaultTargetPlatformOverride = platform;
        final client = LocalNotificationsClient(plugin: _Plugin());
        expect(await client.hasDesktopPermission(), isTrue);
        expect(await client.requestPermission(), isTrue);
      },
    );
  }
}
