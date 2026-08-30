import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';

void main() {
  group('MiniAppDailyStat.fromJson', () {
    test('parses a stat row', () {
      final stat = MiniAppDailyStat.fromJson(const {
        'day': '2026-06-10',
        'launches': 12,
        'uniqueUsers': 5,
      });
      expect(stat.day, DateTime(2026, 6, 10));
      expect(stat.launches, 12);
      expect(stat.uniqueUsers, 5);
    });
  });

  group('MiniAppRevision.fromJson', () {
    test('parses screens and exposes paths', () {
      final revision = MiniAppRevision.fromJson(const {
        'version': 4,
        'createdAt': '2026-06-12T08:00:00Z',
        'screens': [
          {
            'path': '/',
            'json': <String, dynamic>{'type': 'scaffold'},
          },
          {
            'path': '/about',
            'json': <String, dynamic>{'type': 'text'},
          },
        ],
      });
      expect(revision.version, 4);
      expect(revision.paths, ['/', '/about']);
      expect(revision.screens.firstOrNull?.json, {'type': 'scaffold'});
    });
  });

  group('MiniAppValidation.fromJson', () {
    test('reports unknown discriminators', () {
      final validation = MiniAppValidation.fromJson(const {
        'unknownWidgets': ['colum'],
        'unknownActions': <String>[],
      });
      expect(validation.isClean, isFalse);
      expect(validation.unknownWidgets, ['colum']);
    });

    test('isClean when both lists are empty', () {
      expect(const MiniAppValidation().isClean, isTrue);
    });
  });

  group('MiniAppDeployToken.fromJson', () {
    test('parses metadata with nullable usage timestamp', () {
      final token = MiniAppDeployToken.fromJson(const {
        'id': 't1',
        'name': 'ci',
        'createdAt': '2026-06-12T08:00:00Z',
        'lastUsedAt': null,
      });
      expect(token.id, 't1');
      expect(token.lastUsedAt, isNull);
    });
  });

  group('MiniAppSigningSecretInfo.fromJson', () {
    test('parses metadata without ever exposing a plaintext', () {
      final info = MiniAppSigningSecretInfo.fromJson(const {
        'hasSecret': true,
        'fingerprint': 'a1b2c3',
        'createdAt': '2026-06-12T08:00:00Z',
        'rotatedAt': '2026-06-17T09:00:00Z',
        'previousActive': true,
        'previousExpiresAt': '2026-06-18T09:00:00Z',
      });
      expect(info.hasSecret, isTrue);
      expect(info.fingerprint, 'a1b2c3');
      expect(info.previousActive, isTrue);
      expect(info.previousExpiresAt, isNotNull);
    });

    test('defaults to no secret on an empty payload', () {
      final info = MiniAppSigningSecretInfo.fromJson(const {});
      expect(info.hasSecret, isFalse);
      expect(info.fingerprint, isNull);
      expect(info.previousActive, isFalse);
    });
  });

  group('CreatedMiniAppSigningSecret', () {
    test('carries the one-time plaintext and its fingerprint', () {
      const created = CreatedMiniAppSigningSecret(
        secret: 'mns_deadbeef',
        fingerprint: 'deadbe',
      );
      expect(created.secret, 'mns_deadbeef');
      expect(created.fingerprint, 'deadbe');
    });
  });

  group('MiniAppPermission.listFromJson', () {
    test('drops unknown scopes for forward compatibility', () {
      expect(
        MiniAppPermission.listFromJson(const ['email', 'galaxy', 'group']),
        const [MiniAppPermission.email, MiniAppPermission.group],
      );
    });

    test('returns empty for non-list payloads', () {
      expect(MiniAppPermission.listFromJson('email'), isEmpty);
      expect(MiniAppPermission.listFromJson(null), isEmpty);
    });
  });
}
