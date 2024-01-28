import 'dart:convert';

import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/settings.dart';
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:test_api/src/backend/invoker.dart';

void main() {
  presets(
    'server',
    'settings',
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

      group('Logs', () {
        test('Download', () async {
          final response = await client.settings.logSettings.download();
          final logs = utf8.decode(response.body);
          expect(logs, await container.nextcloudLogs());
        });
      });
    },
    retry: retryCount,
    timeout: timeout,
  );
}
