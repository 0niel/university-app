import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/notifications/data/notification_inbox_repository.dart';

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
}
