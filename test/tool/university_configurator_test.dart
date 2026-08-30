import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

import '../../tool/src/university_configurator.dart';
import '../../tool/src/university_deployment_config.dart';

void main() {
  group('UniversityDeploymentConfig', () {
    test('accepts the documented schema', () {
      final config = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(_validConfiguration()),
      );

      expect(config.organizationId, 'example-university');
      expect(config.appDisplayName, 'University Ninja');
      expect(config.universityShortName, 'ESU');
      expect(config.appWebPathPrefix, '/app');
    });

    test('rejects missing and unknown keys', () {
      final input = _validConfiguration()
        ..remove('APP_SUPPORT_EMAIL')
        ..['EXTRA_KEY'] = 'unexpected';

      expect(
        () => UniversityDeploymentConfig.fromJsonString(jsonEncode(input)),
        throwsA(
          isA<UniversityConfigurationException>()
              .having(
                (error) => error.message,
                'message',
                contains('missing: APP_SUPPORT_EMAIL'),
              )
              .having(
                (error) => error.message,
                'message',
                contains('unknown: EXTRA_KEY'),
              ),
        ),
      );
    });

    test('rejects values that can inject native configuration', () {
      final input = _validConfiguration()
        ..['APP_DISPLAY_NAME'] = r'Bad $(SETTING)';

      expect(
        () => UniversityDeploymentConfig.fromJsonString(jsonEncode(input)),
        throwsA(
          isA<UniversityConfigurationException>().having(
            (error) => error.message,
            'message',
            contains('reserved'),
          ),
        ),
      );
    });

    test('rejects invalid deployment identifiers and endpoints', () {
      final invalidValues = {
        'APP_ORGANIZATION_ID': 'Example University',
        'UNIVERSITY_WEBSITE_URL': 'http://university.example',
        'APP_SUPPORT_EMAIL': 'support-at-university.example',
        'APP_DEEP_LINK_SCHEME': 'https',
        'APP_WEB_HOST': 'https://app.university.example',
        'APP_WEB_PATH_PREFIX': 'app/',
      };

      for (final entry in invalidValues.entries) {
        final input = _validConfiguration()..[entry.key] = entry.value;
        expect(
          () => UniversityDeploymentConfig.fromJsonString(jsonEncode(input)),
          throwsA(isA<UniversityConfigurationException>()),
          reason: entry.key,
        );
      }
    });

    test('accepts a secure optional community chat URL', () {
      final input = _validConfiguration()
        ..['APP_COMMUNITY_CHAT_URL'] = 'https://t.me/example_university';

      final config = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(input),
      );

      expect(config.appCommunityChatUrl, 'https://t.me/example_university');
      expect(
        config.toEnvironmentMap()['APP_COMMUNITY_CHAT_URL'],
        'https://t.me/example_university',
      );
    });

    test('rejects insecure optional community chat URLs', () {
      final input = _validConfiguration()
        ..['APP_COMMUNITY_CHAT_URL'] = 'http://t.me/example_university';

      expect(
        () => UniversityDeploymentConfig.fromJsonString(jsonEncode(input)),
        throwsA(isA<UniversityConfigurationException>()),
      );
    });

    test('accepts a custom calendar event URL', () {
      final config = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(
          _validConfiguration()
            ..['APP_CALENDAR_EVENT_URL'] = 'universityapp://open',
        ),
      );

      expect(
        config.toEnvironmentMap()['APP_CALENDAR_EVENT_URL'],
        'universityapp://open',
      );
    });

    test('rejects insecure calendar event URLs', () {
      expect(
        () => UniversityDeploymentConfig.fromJsonString(
          jsonEncode(
            _validConfiguration()
              ..['APP_CALENDAR_EVENT_URL'] = 'http://university.example/open',
          ),
        ),
        throwsA(isA<UniversityConfigurationException>()),
      );
    });

    test('accepts configurable NFC-pass endpoints', () {
      final config = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(
          _validConfiguration()
            ..['APP_NFC_PASS_OAUTH_URL'] =
                'https://auth.university.example/nfc/login'
            ..['APP_NFC_PASS_REDIRECT_URLS'] =
                'https://app.university.example/nfc/complete'
            ..['APP_NFC_PASS_ACCESS_TOKEN_URL'] =
                'https://api.university.example/nfc/access-token'
            ..['APP_NFC_PASS_SEND_CODE_URL'] =
                'https://api.university.example/nfc/send-code'
            ..['APP_NFC_PASS_GET_PASS_URL'] =
                'https://api.university.example/nfc/get-pass',
        ),
      );

      expect(
        config.toEnvironmentMap()['APP_NFC_PASS_GET_PASS_URL'],
        'https://api.university.example/nfc/get-pass',
      );
    });

    test('rejects insecure NFC-pass endpoints', () {
      expect(
        () => UniversityDeploymentConfig.fromJsonString(
          jsonEncode(
            _validConfiguration()
              ..['APP_NFC_PASS_OAUTH_URL'] =
                  'http://auth.university.example/nfc/login',
          ),
        ),
        throwsA(isA<UniversityConfigurationException>()),
      );
    });

    test('accepts optional university email domains', () {
      final input = _validConfiguration()
        ..['APP_ALLOWED_EMAIL_DOMAINS'] =
            'university.example,students.university.example';

      final config = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(input),
      );

      expect(
        config.appAllowedEmailDomains,
        'university.example,students.university.example',
      );
    });

    test('rejects invalid optional university email domains', () {
      final input = _validConfiguration()
        ..['APP_ALLOWED_EMAIL_DOMAINS'] = 'University.example';

      expect(
        () => UniversityDeploymentConfig.fromJsonString(jsonEncode(input)),
        throwsA(isA<UniversityConfigurationException>()),
      );
    });

    test('validates optional enabled capabilities', () {
      final input = _validConfiguration()
        ..['APP_ENABLED_CAPABILITIES'] = 'campus_map,nfc_pass';

      final config = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(input),
      );

      expect(
        config.toEnvironmentMap()['APP_ENABLED_CAPABILITIES'],
        'campus_map,nfc_pass',
      );
      input['APP_ENABLED_CAPABILITIES'] = 'campus_map,not_real';
      expect(
        () => UniversityDeploymentConfig.fromJsonString(jsonEncode(input)),
        throwsA(isA<UniversityConfigurationException>()),
      );
    });

    test('rejects invalid lesson editor configuration', () {
      final invalidValues = {
        'LESSON_BELL_SLOTS': '09:00-10:30,10:00-11:00',
        'LESSON_COLOR_VALUES': 'not-a-color',
        'LESSON_REMINDER_LEAD_MINUTES': '15,15',
      };

      for (final entry in invalidValues.entries) {
        final input = _validConfiguration()..[entry.key] = entry.value;
        expect(
          () => UniversityDeploymentConfig.fromJsonString(jsonEncode(input)),
          throwsA(isA<UniversityConfigurationException>()),
          reason: entry.key,
        );
      }
    });
  });

  group('UniversityConfigurator', () {
    late Directory projectRoot;
    late UniversityConfigurator configurator;
    late UniversityDeploymentConfig config;

    setUp(() {
      projectRoot = Directory.systemTemp.createTempSync(
        'university_configurator_test_',
      );
      configurator = UniversityConfigurator(projectRoot: projectRoot);
      config = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(_validConfiguration()),
      );
    });

    tearDown(() {
      if (projectRoot.existsSync()) {
        projectRoot.deleteSync(recursive: true);
      }
    });

    test(
      'writes deterministic platform files and skips unchanged files',
      () {
        final firstWrite = configurator.write(config);
        final secondWrite = UniversityConfigurator(
          projectRoot: projectRoot,
        ).write(config);
        final check = configurator.check(config);

        expect(
          firstWrite.writtenPaths,
          containsAll(<String>[
            path.join('android', 'tenant.properties'),
            path.join('ios', 'Flutter', 'Tenant.xcconfig'),
            path.join('web', 'university-config.json'),
          ]),
        );
        expect(secondWrite.writtenPaths, isEmpty);
        expect(secondWrite.unchangedPaths, hasLength(3));
        expect(check.isCurrent, isTrue);

        final androidOutput = File(
          path.join(projectRoot.path, 'android', 'tenant.properties'),
        ).readAsStringSync();
        expect(androidOutput, contains('APP_DISPLAY_NAME=University Ninja'));

        final iosOutput = File(
          path.join(projectRoot.path, 'ios', 'Flutter', 'Tenant.xcconfig'),
        ).readAsStringSync();
        expect(
          iosOutput,
          contains('TENANT_APP_DISPLAY_NAME = University Ninja'),
        );
        expect(iosOutput, isNot(contains('https://')));

        final webOutput =
            jsonDecode(
                  File(
                    path.join(
                      projectRoot.path,
                      'web',
                      'university-config.json',
                    ),
                  ).readAsStringSync(),
                )
                as Map<String, Object?>;
        expect(webOutput['schemaVersion'], 1);
        expect(webOutput['APP_ORGANIZATION_ID'], 'example-university');
      },
    );

    test('keeps the chat URL out of iOS generated configuration', () {
      final chatConfig = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(
          _validConfiguration()
            ..['APP_COMMUNITY_CHAT_URL'] = 'https://t.me/example_university',
        ),
      );

      final output = configurator.render(chatConfig);

      expect(
        output[path.join('android', 'tenant.properties')],
        contains(r'APP_COMMUNITY_CHAT_URL=https\://t.me/example_university'),
      );
      expect(
        output[path.join('ios', 'Flutter', 'Tenant.xcconfig')],
        isNot(contains('APP_COMMUNITY_CHAT_URL')),
      );
      expect(
        output[path.join('web', 'university-config.json')],
        contains('"APP_COMMUNITY_CHAT_URL": "https://t.me/example_university"'),
      );
    });

    test('keeps the forum URL out of iOS generated configuration', () {
      final forumConfig = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(
          _validConfiguration()
            ..['APP_COMMUNITY_FORUM_URL'] = 'https://forum.university.example',
        ),
      );

      final output = configurator.render(forumConfig);

      expect(
        output[path.join('android', 'tenant.properties')],
        contains(
          r'APP_COMMUNITY_FORUM_URL=https\://forum.university.example',
        ),
      );
      expect(
        output[path.join('ios', 'Flutter', 'Tenant.xcconfig')],
        isNot(contains('APP_COMMUNITY_FORUM_URL')),
      );
      expect(
        output[path.join('web', 'university-config.json')],
        contains(
          '"APP_COMMUNITY_FORUM_URL": "https://forum.university.example"',
        ),
      );
    });

    test('keeps NFC provider URLs out of iOS generated configuration', () {
      final nfcConfig = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(
          _validConfiguration()
            ..['APP_NFC_PASS_OAUTH_URL'] =
                'https://auth.university.example/nfc/login'
            ..['APP_NFC_PASS_REDIRECT_URLS'] = 'https://pulse.mirea.ru/services'
            ..['APP_NFC_PASS_ACCESS_TOKEN_URL'] =
                'https://api.university.example/nfc/access-token'
            ..['APP_NFC_PASS_SEND_CODE_URL'] =
                'https://api.university.example/nfc/send-code'
            ..['APP_NFC_PASS_GET_PASS_URL'] =
                'https://api.university.example/nfc/get-pass',
        ),
      );

      final output = configurator.render(nfcConfig);
      final iosOutput = output[path.join('ios', 'Flutter', 'Tenant.xcconfig')]!;

      expect(iosOutput, isNot(contains('APP_NFC_PASS_OAUTH_URL')));
      expect(iosOutput, isNot(contains('APP_NFC_PASS_REDIRECT_URLS')));
      expect(iosOutput, isNot(contains('APP_NFC_PASS_ACCESS_TOKEN_URL')));
      expect(iosOutput, isNot(contains('APP_NFC_PASS_SEND_CODE_URL')));
      expect(iosOutput, isNot(contains('APP_NFC_PASS_GET_PASS_URL')));
      expect(
        output[path.join('android', 'tenant.properties')],
        contains(
          r'APP_NFC_PASS_REDIRECT_URLS=https\://pulse.mirea.ru/services',
        ),
      );
      expect(
        output[path.join('web', 'university-config.json')],
        contains(
          '"APP_NFC_PASS_REDIRECT_URLS": "https://pulse.mirea.ru/services"',
        ),
      );
    });

    test(
      'check reports missing and stale outputs without changing them',
      () {
        configurator.write(config);
        final androidFile = File(
          path.join(projectRoot.path, 'android', 'tenant.properties'),
        );
        final webFile = File(
          path.join(projectRoot.path, 'web', 'university-config.json'),
        );
        androidFile.writeAsStringSync('locally changed\n');
        webFile.deleteSync();

        final result = configurator.check(config);

        expect(
          result.outdatedPaths,
          <String>[path.join('android', 'tenant.properties')],
        );
        expect(
          result.missingPaths,
          <String>[path.join('web', 'university-config.json')],
        );
        expect(androidFile.readAsStringSync(), 'locally changed\n');
        expect(webFile.existsSync(), isFalse);
      },
    );

    test('replaces existing outputs without leaving temporary files', () {
      configurator.write(config);
      final changedInput = _validConfiguration()
        ..['APP_DISPLAY_NAME'] = 'Another University App';
      final changedConfig = UniversityDeploymentConfig.fromJsonString(
        jsonEncode(changedInput),
      );

      configurator.write(changedConfig);

      final files = projectRoot
          .listSync(recursive: true)
          .whereType<File>()
          .map((entity) => entity.path)
          .toList();
      expect(
        files.where(
          (filePath) => filePath.endsWith('.tmp') || filePath.endsWith('.bak'),
        ),
        isEmpty,
      );
      expect(configurator.check(changedConfig).isCurrent, isTrue);
    });

    test('readConfig reports a missing source file', () {
      final missing = File(path.join(projectRoot.path, 'missing.json'));

      expect(
        () => configurator.readConfig(missing),
        throwsA(
          isA<UniversityConfigurationException>().having(
            (error) => error.message,
            'message',
            contains('does not exist'),
          ),
        ),
      );
    });
  });
}

Map<String, Object?> _validConfiguration() => {
  'APP_ORGANIZATION_ID': 'example-university',
  'APP_DISPLAY_NAME': 'University Ninja',
  'UNIVERSITY_NAME': 'Example State University',
  'UNIVERSITY_SHORT_NAME': 'ESU',
  'UNIVERSITY_WEBSITE_URL': 'https://university.example',
  'APP_SUPPORT_EMAIL': 'support@university.example',
  'APP_DEEP_LINK_SCHEME': 'universityapp',
  'APP_WEB_HOST': 'app.university.example',
  'APP_WEB_PATH_PREFIX': '/app',
};
