import 'package:built_collection/built_collection.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:test_api/src/backend/invoker.dart';

void main() {
  presets(
    'server',
    'core',
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

      test('Is supported from capabilities', () async {
        final response = await client.core.ocs.getCapabilities();

        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final result = client.core.getVersionCheck(response.body.ocs.data);
        expect(result.versions, isNotNull);
        expect(result.versions, isNotEmpty);
        expect(result.isSupported, isTrue);
      });

      test('Is supported from status', () async {
        final response = await client.core.getStatus();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.versionCheck.isSupported, isTrue);
      });

      test('Get status', () async {
        final response = await client.core.getStatus();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.installed, isTrue);
        expect(response.body.maintenance, isFalse);
        expect(response.body.needsDbUpgrade, isFalse);
        expect(response.body.version, isNotEmpty);
        expect(response.body.versionstring, isNotEmpty);
        expect(response.body.edition, '');
        expect(response.body.productname, 'Nextcloud');
        expect(response.body.extendedSupport, isFalse);
      });

      group('OCS', () {
        test('Get capabilities', () async {
          final response = await client.core.ocs.getCapabilities();
          expect(response.statusCode, 200);
          expect(() => response.headers, isA<void>());

          expect(response.body.ocs.data.capabilities.commentsCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.davCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.filesCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.filesSharingCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.filesTrashbinCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.filesVersionsCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.notesCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.notificationsCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.provisioningApiCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.sharebymailCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.spreedPublicCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.themingPublicCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.userStatusCapabilities, isNotNull);
          expect(response.body.ocs.data.capabilities.weatherStatusCapabilities, isNotNull);
        });
      });

      group('Navigation', () {
        test('Get apps navigation', () async {
          final response = await client.core.navigation.getAppsNavigation();
          expect(response.statusCode, 200);
          expect(() => response.headers, isA<void>());
          expect(response.body.ocs.data, hasLength(7));

          expect(response.body.ocs.data[0].id, 'dashboard');
          expect(response.body.ocs.data[1].id, 'files');
          expect(response.body.ocs.data[2].id, 'photos');
          expect(response.body.ocs.data[3].id, 'activity');
          expect(response.body.ocs.data[4].id, 'spreed');
          expect(response.body.ocs.data[5].id, 'notes');
          expect(response.body.ocs.data[6].id, 'news');
        });
      });

      group('Autocomplete', () {
        test('Get', () async {
          final response = await client.core.autoComplete.$get(
            search: '',
            itemType: 'call',
            itemId: 'new',
            shareTypes: BuiltList([core.ShareType.group.index]),
          );
          expect(response.body.ocs.data, hasLength(1));

          expect(response.body.ocs.data[0].id, 'admin');
          expect(response.body.ocs.data[0].label, 'admin');
          expect(response.body.ocs.data[0].icon, '');
          expect(response.body.ocs.data[0].source, 'groups');
          expect(response.body.ocs.data[0].status.autocompleteResultStatus0, isNull);
          expect(response.body.ocs.data[0].status.string, isEmpty);
          expect(response.body.ocs.data[0].subline, '');
          expect(response.body.ocs.data[0].shareWithDisplayNameUnique, '');
        });
      });

      group('Preview', () {
        test('Get', () async {
          final response = await client.core.preview.getPreview(file: 'Nextcloud.png');
          expect(response.statusCode, 200);
          expect(() => response.headers, isA<void>());

          expect(response.body, isNotEmpty);
        });
      });

      group('Avatar', () {
        test('Get', () async {
          final response = await client.core.avatar.getAvatar(userId: 'admin', size: 32);
          expect(response.body, isNotEmpty);
          expect(response.headers.xNcIscustomavatar?.content, 0);
        });

        test('Get dark', () async {
          final response = await client.core.avatar.getAvatarDark(userId: 'admin', size: 32);
          expect(response.body, isNotEmpty);
          expect(response.headers.xNcIscustomavatar?.content, 0);
        });
      });

      group('App password', () {
        test('Delete', () async {
          // Separate client to not break other tests
          final client = await TestNextcloudClient.create(container);

          await client.core.appPassword.deleteAppPassword();
          await expectLater(
            () => client.core.appPassword.deleteAppPassword(),
            throwsA(predicate((e) => (e! as DynamiteStatusCodeException).statusCode == 401)),
          );
        });
      });

      group('Unified search', () {
        test('Get providers', () async {
          final response = await client.core.unifiedSearch.getProviders();
          expect(response.statusCode, 200);
          expect(() => response.headers, isA<void>());

          expect(response.body.ocs.data, isNotEmpty);
        });

        test('Search', () async {
          final response = await client.core.unifiedSearch.search(
            providerId: 'settings',
            term: 'Personal info',
          );

          expect(response.statusCode, 200);
          expect(() => response.headers, isA<void>());

          expect(response.body.ocs.data.name, 'Settings');
          expect(response.body.ocs.data.isPaginated, isFalse);
          expect(response.body.ocs.data.entries, hasLength(1));
          expect(response.body.ocs.data.entries.single.thumbnailUrl, isEmpty);
          expect(response.body.ocs.data.entries.single.title, 'Personal info');
          expect(response.body.ocs.data.entries.single.subline, isEmpty);
          expect(response.body.ocs.data.entries.single.resourceUrl, isNotEmpty);
          expect(response.body.ocs.data.entries.single.icon, 'icon-settings-dark');
          expect(response.body.ocs.data.entries.single.rounded, isFalse);
          expect(response.body.ocs.data.entries.single.attributes, isEmpty);
        });
      });

      group('Client login flow V2', () {
        test('Init and poll', () async {
          final response = await client.core.clientFlowLoginV2.init();
          expect(response.statusCode, 200);
          expect(() => response.headers, isA<void>());

          expect(response.body.login, startsWith('http://localhost'));
          expect(response.body.poll.endpoint, startsWith('http://localhost'));
          expect(response.body.poll.token, isNotEmpty);

          await expectLater(
            () => client.core.clientFlowLoginV2.poll(token: response.body.poll.token),
            throwsA(predicate<DynamiteStatusCodeException>((e) => e.statusCode == 404)),
          );
        });
      });
    },
    retry: retryCount,
    timeout: timeout,
  );
}
