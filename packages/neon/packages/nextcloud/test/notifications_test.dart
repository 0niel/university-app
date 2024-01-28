import 'dart:async';

import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notifications.dart';
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:test_api/src/backend/invoker.dart';

void main() {
  presets(
    'server',
    'notifications',
    (preset) {
      late DockerContainer container;
      late NextcloudClient client;
      setUpAll(() async {
        container = await DockerContainer.create(preset);
        client = await TestNextcloudClient.create(
          container,
          username: 'admin',
        );
      });
      tearDownAll(() async {
        if (Invoker.current!.liveTest.errors.isNotEmpty) {
          print(await container.allLogs());
        }
        container.destroy();
      });

      Future<void> sendTestNotification() async {
        await client.notifications.api.generateNotification(
          userId: 'admin',
          shortMessage: '123',
          longMessage: '456',
        );
      }

      group('API', () {
        test('Send admin notification', () async {
          await sendTestNotification();
        });
      });

      group('Endpoint', () {
        setUp(() async {
          await client.notifications.endpoint.deleteAllNotifications();
        });

        test('List notifications', () async {
          await sendTestNotification();

          final startTime = DateTime.now().toUtc();
          final response = await client.notifications.endpoint.listNotifications();
          expect(response.body.ocs.data, hasLength(1));
          expect(response.body.ocs.data[0].notificationId, isPositive);
          expect(response.body.ocs.data[0].app, 'admin_notifications');
          expect(response.body.ocs.data[0].user, 'admin');
          expect(
            DateTime.parse(response.body.ocs.data[0].datetime).millisecondsSinceEpoch,
            closeTo(startTime.millisecondsSinceEpoch, 10E3),
          );
          expect(response.body.ocs.data[0].objectType, 'admin_notifications');
          expect(response.body.ocs.data[0].objectId, isNotNull);
          expect(response.body.ocs.data[0].subject, '123');
          expect(response.body.ocs.data[0].message, '456');
          expect(response.body.ocs.data[0].link, '');
          expect(response.body.ocs.data[0].subjectRich, '');
          expect(response.body.ocs.data[0].subjectRichParameters, isEmpty);
          expect(response.body.ocs.data[0].messageRich, '');
          expect(response.body.ocs.data[0].messageRichParameters, isEmpty);
          expect(response.body.ocs.data[0].icon, isNotEmpty);
          expect(response.body.ocs.data[0].actions, hasLength(0));
        });

        test('Get notification', () async {
          await sendTestNotification();
          final listResponse = await client.notifications.endpoint.listNotifications();
          expect(listResponse.body.ocs.data, hasLength(1));

          final startTime = DateTime.now().toUtc();
          final response = await client.notifications.endpoint.getNotification(
            id: listResponse.body.ocs.data.first.notificationId,
          );
          expect(response.statusCode, 200);
          expect(() => response.headers, isA<void>());

          expect(response.body.ocs.data.notificationId, isPositive);
          expect(response.body.ocs.data.app, 'admin_notifications');
          expect(response.body.ocs.data.user, 'admin');
          expect(
            DateTime.parse(response.body.ocs.data.datetime).millisecondsSinceEpoch,
            closeTo(startTime.millisecondsSinceEpoch, 10E3),
          );
          expect(response.body.ocs.data.objectType, 'admin_notifications');
          expect(response.body.ocs.data.objectId, isNotNull);
          expect(response.body.ocs.data.subject, '123');
          expect(response.body.ocs.data.message, '456');
          expect(response.body.ocs.data.link, '');
          expect(response.body.ocs.data.subjectRich, '');
          expect(response.body.ocs.data.subjectRichParameters, isEmpty);
          expect(response.body.ocs.data.messageRich, '');
          expect(response.body.ocs.data.messageRichParameters, isEmpty);
          expect(response.body.ocs.data.icon, isNotEmpty);
          expect(response.body.ocs.data.actions, hasLength(0));
        });

        test('Delete notification', () async {
          await sendTestNotification();
          final listResponse = await client.notifications.endpoint.listNotifications();
          expect(listResponse.body.ocs.data, hasLength(1));
          await client.notifications.endpoint.deleteNotification(id: listResponse.body.ocs.data.first.notificationId);

          final response = await client.notifications.endpoint.listNotifications();
          expect(response.body.ocs.data, hasLength(0));
        });

        test('Delete all notifications', () async {
          await sendTestNotification();
          await sendTestNotification();
          await client.notifications.endpoint.deleteAllNotifications();

          final response = await client.notifications.endpoint.listNotifications();
          expect(response.body.ocs.data, hasLength(0));
        });
      });

      group('Push', () {
        // The key size has to be 2048, other sizes are not accepted by Nextcloud (at the moment at least)
        // ignore: avoid_redundant_argument_values
        RSAKeypair generateKeypair() => RSAKeypair.fromRandom(keySize: 2048);

        test('Register and remove push device', () async {
          const pushToken = '789';
          final keypair = generateKeypair();

          final subscription = (await client.notifications.push.registerDevice(
            pushTokenHash: generatePushTokenHash(pushToken),
            devicePublicKey: keypair.publicKey.toFormattedPEM(),
            proxyServer: 'https://example.com/',
          ))
              .body
              .ocs
              .data;
          expect(subscription.publicKey, hasLength(451));
          RSAPublicKey.fromPEM(subscription.publicKey);
          expect(subscription.deviceIdentifier, isNotEmpty);
          expect(subscription.signature, isNotEmpty);

          await client.notifications.push.removeDevice();
        });
      });
    },
    retry: retryCount,
    timeout: timeout,
  );
}
