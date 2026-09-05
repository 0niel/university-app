import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';
import 'package:rtu_mirea_app/notifications/view/inbox_notification_tracker.dart';

AppNotification item(int id, {int? minute}) => AppNotification(
  id: 'inbox:00000000-0000-0000-0000-${id.toString().padLeft(12, '0')}',
  kind: AppNotificationKind.accent,
  title: 'Notification $id',
  createdAt: DateTime.utc(2026, 9, 5, 12, minute ?? id),
);

void main() {
  late InboxNotificationTracker tracker;

  setUp(() => tracker = InboxNotificationTracker());

  List<AppNotification> load(
    List<AppNotification> items, {
    String user = 'student-a',
    Set<String> read = const {},
    bool failed = false,
  }) {
    tracker.observe(NotificationsState(userId: user, isLoading: true));
    return tracker.observe(
      NotificationsState(
        userId: user,
        pushes: items,
        readIds: read,
        loadFailed: failed,
      ),
    );
  }

  test('initial history is silent and only later new events are returned', () {
    expect(load([item(1), item(2)]), isEmpty);
    expect(load([item(3), item(2), item(1)]), [item(3)]);
    expect(load([item(3), item(2), item(1)]), isEmpty);
  });

  test('failed startup keeps the first successful snapshot silent', () {
    expect(load([], failed: true), isEmpty);
    expect(load([item(1)]), isEmpty);
    expect(load([item(2), item(1)]), [item(2)]);
  });

  test('account changes create an independent silent baseline', () {
    load([item(1)]);
    expect(load([item(3), item(2)], user: 'student-b'), isEmpty);
    expect(load([item(4), item(3)], user: 'student-b'), [item(4)]);
    expect(load([item(5), item(1)]), isEmpty);
  });

  test('read events and late historical rows never trigger toasts', () {
    load([item(3)]);
    expect(load([item(4), item(3), item(2)], read: {item(4).id}), isEmpty);
    expect(load([item(4), item(3), item(2)]), isEmpty);
  });

  test('same timestamp allows different ids and batches do not flood', () {
    load([item(1)]);
    final items = [for (var id = 2; id <= 8; id++) item(id, minute: 1)];
    expect(load(items), hasLength(3));
    expect(load(items), isEmpty);
  });

  test('optimistic push and read state changes do not complete a snapshot', () {
    load([item(1)]);
    expect(
      tracker.observe(
        NotificationsState(userId: 'student-a', pushes: [item(2)]),
      ),
      isEmpty,
    );
    expect(load([item(2), item(1)]), [item(2)]);
  });
}
