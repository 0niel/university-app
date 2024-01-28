import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/uppush.dart';
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:test_api/src/backend/invoker.dart';

void main() {
  presets(
    'uppush',
    'uppush',
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

      test('Is installed', () async {
        final response = await client.uppush.check();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.success, isTrue);
      });

      test('Set keepalive', () async {
        final response = await client.uppush.setKeepalive(keepalive: 10);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.success, isTrue);
      });

      test('Create device', () async {
        final response = await client.uppush.createDevice(deviceName: 'Test');
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.success, isTrue);
        expect(response.body.deviceId, isNotEmpty);
      });

      test('Delete device', () async {
        final deviceId = (await client.uppush.createDevice(deviceName: 'Test')).body.deviceId;

        final response = await client.uppush.deleteDevice(deviceId: deviceId);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.success, isTrue);
      });

      test('Create app', () async {
        final deviceId = (await client.uppush.createDevice(deviceName: 'Test')).body.deviceId;

        final response = await client.uppush.createApp(deviceId: deviceId, appName: 'Test');
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.success, isTrue);
        expect(response.body.token, isNotEmpty);
      });

      test('UnifiedPush discovery', () async {
        final response = await client.uppush.unifiedpushDiscovery(token: 'example');
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.unifiedpush.version, 1);
      });

      test('Matrix gateway discovery', () async {
        final response = await client.uppush.gatewayMatrixDiscovery();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.unifiedpush.gateway, 'matrix');
      });

      // Deleting an app, sending a notification (also via matrix gateway) or listening for notifications is not possible because redis is not set up
    },
    retry: retryCount,
    timeout: timeout,
  );
}
