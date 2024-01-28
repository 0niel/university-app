import 'package:nextcloud/dashboard.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:test_api/src/backend/invoker.dart';
import 'package:version/version.dart';

void main() {
  presets(
    'server',
    'dashboard',
    (preset) {
      late DockerContainer container;
      late NextcloudClient client;
      setUpAll(() async {
        container = await DockerContainer.create(preset);
        client = await TestNextcloudClient.create(container);
      });
      tearDownAll(() async {
        if (Invoker.current!.liveTest.errors.isNotEmpty) {
          print(await container.allLogs());
        }
        container.destroy();
      });

      test('Get widgets', () async {
        final response = await client.dashboard.dashboardApi.getWidgets();
        expect(response.statusCode, 200);
        expect(
          response.body.ocs.data.keys,
          equals(['activity', 'notes', 'recommendations', 'spreed', 'user_status']),
        );
      });

      group('Get widget items', () {
        test('v1', () async {
          final response = await client.dashboard.dashboardApi.getWidgetItems();
          expect(response.statusCode, 200);
          expect(response.body.ocs.data.keys, equals(['recommendations', 'spreed']));
        });

        test(
          'v2',
          () async {
            final response = await client.dashboard.dashboardApi.getWidgetItemsV2();
            expect(response.statusCode, 200);
          },
          skip: preset.version < Version(27, 1, 0),
        );
      });
    },
    retry: retryCount,
    timeout: timeout,
  );
}
