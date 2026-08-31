import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';

void main() {
  group('MiniApp.fromJson', () {
    test('parses a full backend row', () {
      final app = MiniApp.fromJson(const {
        'id': 'app-1',
        'slug': 'poll',
        'name': 'Опросы',
        'description': 'Голосуй',
        'iconEmoji': '🗳',
        'accentColor': '#112233',
        'category': 'social',
        'tags': ['t1', 't2'],
        'sourceKind': 'remote',
        'originUrl': 'https://poll.example.com',
        'entryPath': '/home',
        'status': 'pending_review',
        'version': 3,
        'launchCount': 42,
        'ratingAvg': '4.50',
        'ratingCount': 7,
        'isOwner': true,
        'isFeatured': true,
        'myRating': 5,
        'isHidden': true,
        'hasMyOpenReport': true,
        'openReportCount': 2,
        'requestedPermissions': ['email', 'group', 'notifications'],
        'grantedPermissions': ['email'],
        'createdAt': '2026-06-12T10:00:00Z',
      });

      expect(app.slug, 'poll');
      expect(app.category, MiniAppCategory.social);
      expect(app.sourceKind, MiniAppSourceKind.remote);
      expect(app.status, MiniAppStatus.pendingReview);
      expect(app.ratingAvg, 4.5);
      expect(app.isFeatured, isTrue);
      expect(app.requestedPermissions, const [
        MiniAppPermission.email,
        MiniAppPermission.group,
        MiniAppPermission.notifications,
      ]);
      expect(app.grantedPermissions, const [MiniAppPermission.email]);
    });

    test('defaults missing fields and drops unknown enum values', () {
      final app = MiniApp.fromJson(const {
        'id': 'x',
        'slug': 's',
        'name': 'n',
        'category': 'spaceships',
        'status': 'banana',
        'requestedPermissions': ['email', 'galaxy'],
      });

      expect(app.category, MiniAppCategory.other);
      expect(app.status, MiniAppStatus.draft);
      expect(app.requestedPermissions, const [MiniAppPermission.email]);
      expect(app.grantedPermissions, isNull);
      expect(app.isFeatured, isFalse);
    });

    test('parses the first-party service source kind without consent', () {
      final app = MiniApp.fromJson(const {
        'id': 'free-rooms',
        'slug': 'free-rooms',
        'name': 'Свободные аудитории',
        'sourceKind': 'service',
        'requestedPermissions': <String>[],
      });

      expect(app.sourceKind, MiniAppSourceKind.service);
      expect(app.needsConsent, isFalse);
    });
  });

  group('needsConsent', () {
    const base = MiniApp(
      id: 'a',
      slug: 's',
      name: 'n',
      sourceKind: MiniAppSourceKind.remote,
      requestedPermissions: [MiniAppPermission.email],
    );

    test('true for an undecided remote app with requested scopes', () {
      expect(base.needsConsent, isTrue);
    });

    test('false once a decision exists, even an empty one', () {
      expect(
        base.copyWith(grantedPermissions: const []).needsConsent,
        isFalse,
      );
    });

    test('false for hosted apps and apps without requests', () {
      expect(
        MiniApp.fromJson(const {
          'id': 'a',
          'slug': 's',
          'name': 'n',
          'sourceKind': 'hosted',
          'requestedPermissions': ['email'],
        }).needsConsent,
        isFalse,
      );
      expect(
        MiniApp.fromJson(const {
          'id': 'a',
          'slug': 's',
          'name': 'n',
          'sourceKind': 'remote',
        }).needsConsent,
        isFalse,
      );
    });
  });

  group('MiniAppStatus', () {
    test('round-trips the pending_review wire name', () {
      expect(
          MiniAppStatus.fromName('pending_review').wireName, 'pending_review',);
      expect(MiniAppStatus.published.wireName, 'published');
    });
  });

  group('MiniAppSort', () {
    test('maps to backend wire names', () {
      expect(MiniAppSort.popular.wireName, 'popular');
      expect(MiniAppSort.newest.wireName, 'new');
      expect(MiniAppSort.top.wireName, 'top');
    });
  });
}
