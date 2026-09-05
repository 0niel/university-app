import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rtu_mirea_app/notifications/data/notification_inbox_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  Map<String, Object?> row({String route = '/services/people'}) => {
    'id': 'ABCDEF12-1111-1111-1111-111111111111',
    'title': 'Заявка в друзья',
    'body': 'Студент хочет добавить тебя',
    'route': route,
    'kind': 'friend_request',
    'createdAt': '2026-09-05T10:00:00+03:00',
    'readAt': '2026-09-05T10:01:00+03:00',
  };

  test('maps the RPC contract and canonical delivery identity', () {
    final snapshot = NotificationInboxSnapshot.fromJson([row()]);
    final notification = snapshot.items.single;
    expect(notification.id, 'inbox:abcdef12-1111-1111-1111-111111111111');
    expect(notification.route, '/services/people');
    expect(notification.subtitle, 'Студент хочет добавить тебя');
    expect(notification.createdAt, DateTime.utc(2026, 9, 5, 7));
    expect(snapshot.readIds, {notification.id});
  });

  test('discards external and unsupported navigation targets', () {
    for (final route in ['https://example.com', '//example.com', '/friends']) {
      final snapshot = NotificationInboxSnapshot.fromJson([row(route: route)]);
      expect(snapshot.items.single.route, isNull);
    }
  });

  test('rejects malformed responses instead of replacing the cache', () {
    for (final response in <Object?>[
      null,
      {},
      [null],
      [
        {...row(), 'id': 'invalid'},
      ],
      [
        {...row(), 'createdAt': 'invalid'},
      ],
      [
        {...row(), 'title': null},
      ],
    ]) {
      expect(
        () => NotificationInboxSnapshot.fromJson(response),
        throwsFormatException,
      );
    }
  });

  test('merges durable change reads without numeric precision loss', () {
    final snapshot = NotificationInboxSnapshot.fromJson(
      [row()],
      scheduleReadIds: ['42', '9223372036854775807'],
    );
    expect(snapshot.readIds, {
      'inbox:abcdef12-1111-1111-1111-111111111111',
      'change:42',
      'change:9223372036854775807',
    });
    expect(snapshot.items, hasLength(1));
  });

  test('accepts only canonical existing bigint-shaped change identities', () {
    expect(isCloudNotificationId('change:1'), isTrue);
    expect(isCloudNotificationId('change:9223372036854775807'), isTrue);
    for (final id in [
      'change:0',
      'change:-1',
      'change:01',
      'change:9223372036854775808',
      'change:100000000000000000000',
      'change:1\n',
      'change:1.0',
      'change:1e2',
      'change:uuid',
      'other:1',
    ]) {
      expect(isCloudNotificationId(id), isFalse, reason: id);
    }
  });

  test(
    'rejects malformed cloud change state without replacing cached reads',
    () {
      for (final ids in <Object?>[
        null,
        {},
        [42],
        ['0'],
        ['01'],
        ['9223372036854775808'],
        ['change:42'],
      ]) {
        expect(
          () => NotificationInboxSnapshot.fromJson([], scheduleReadIds: ids),
          throwsFormatException,
        );
      }
    },
  );

  Future<void> setUser(SupabaseClient client, String id) async {
    final expiresAt = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600;
    final payload = base64Url
        .encode(utf8.encode(jsonEncode({'exp': expiresAt})))
        .replaceAll('=', '');
    await client.auth.setInitialSession(
      jsonEncode({
        'access_token': 'header.$payload.signature',
        'refresh_token': 'test-refresh-token',
        'token_type': 'bearer',
        'expires_in': 3600,
        'expires_at': expiresAt,
        'user': {
          'id': id,
          'aud': 'authenticated',
          'app_metadata': <String, dynamic>{},
          'user_metadata': <String, dynamic>{},
          'created_at': '2026-09-05T10:00:00Z',
        },
      }),
    );
  }

  Future<SupabaseClient> clientWith(
    Future<http.Response> Function(http.Request) handler,
  ) async {
    final client = SupabaseClient(
      'https://inbox-test.supabase.co',
      'test-publishable-key',
      httpClient: MockClient(handler),
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    addTearDown(client.dispose);
    await setUser(client, 'user-a');
    return client;
  }

  test(
    'loads inbox and cross-device schedule reads under the same account',
    () async {
      final calls = <String>[];
      final client = await clientWith((request) async {
        calls.add(request.url.pathSegments.last);
        return http.Response(
          jsonEncode(calls.length == 1 ? [row()] : ['42']),
          200,
          headers: {'content-type': 'application/json'},
          request: request,
        );
      });
      final snapshot = await SupabaseNotificationInboxRepository(
        client,
      ).load('user-a');
      expect(calls, [
        'get_notification_inbox',
        'get_schedule_notification_read_ids',
      ]);
      expect(
        snapshot.readIds,
        containsAll(['change:42', snapshot.items.single.id]),
      );
    },
  );

  test(
    'splits inbox and schedule reads into bounded idempotent RPC batches',
    () async {
      final calls = <String>[];
      final bodies = <Map<String, dynamic>>[];
      final client = await clientWith((request) async {
        calls.add(request.url.pathSegments.last);
        bodies.add(jsonDecode(request.body) as Map<String, dynamic>);
        return http.Response('', 204, request: request);
      });
      await SupabaseNotificationInboxRepository(client).markRead('user-a', {
        'inbox:abcdef12-1111-1111-1111-111111111111',
        for (var id = 1; id <= 201; id++) 'change:$id',
        'change:invalid',
        'quest:local',
      });
      expect(calls, [
        'mark_notification_inbox_read',
        'mark_schedule_notifications_read',
        'mark_schedule_notifications_read',
      ]);
      expect(bodies[0]['p_ids'], ['abcdef12-1111-1111-1111-111111111111']);
      expect(bodies[1]['p_ids'], hasLength(200));
      expect(bodies[2]['p_ids'], ['201']);
    },
  );

  test('account switch between read requests stops the next RPC', () async {
    late SupabaseClient client;
    var calls = 0;
    client = await clientWith((request) async {
      calls++;
      await setUser(client, 'user-b');
      return http.Response('', 204, request: request);
    });
    await expectLater(
      SupabaseNotificationInboxRepository(client).markRead('user-a', {
        'inbox:abcdef12-1111-1111-1111-111111111111',
        'change:42',
      }),
      throwsStateError,
    );
    expect(calls, 1);
  });

  test(
    'offline cloud read state propagates failure for pending retry',
    () async {
      final client = await clientWith((request) async {
        throw http.ClientException('Offline');
      });
      await expectLater(
        SupabaseNotificationInboxRepository(
          client,
        ).markRead('user-a', {'change:42'}),
        throwsA(isA<http.ClientException>()),
      );
    },
  );
}
