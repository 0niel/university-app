import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/data/notification_inbox_repository.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

const firstId = 'inbox:11111111-1111-1111-1111-111111111111';
const secondId = 'inbox:22222222-2222-2222-2222-222222222222';

AppNotification notice(String id) => AppNotification(
  id: id,
  title: 'Отклик в команду',
  kind: AppNotificationKind.accent,
  route: '/services/team-finder',
  createdAt: DateTime.utc(2026, 9, 5),
);

class Inbox extends Fake implements NotificationInboxRepository {
  Future<NotificationInboxSnapshot> Function(String) onLoad = (_) async =>
      const NotificationInboxSnapshot(items: []);
  Future<void> Function(String, Set<String>) onRead = (_, _) async {};
  int loads = 0;
  final reads = <Set<String>>[];

  @override
  Future<NotificationInboxSnapshot> load(String userId) {
    loads++;
    return onLoad(userId);
  }

  @override
  Future<void> markRead(String userId, Set<String> ids) {
    reads.add({...ids});
    return onRead(userId, ids);
  }
}

void main() {
  late Inbox inbox;
  late NotificationsCubit cubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    HydratedBloc.storage = CustomHydratedStorage(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
    inbox = Inbox();
    cubit = NotificationsCubit(userId: 'student-a', repository: inbox);
  });

  tearDown(() async => cubit.close());

  test(
    'loads service events without a push and deduplicates delivery',
    () async {
      inbox.onLoad = (_) async =>
          NotificationInboxSnapshot(items: [notice(firstId)]);
      await cubit.refresh();
      expect(cubit.state.pushes.single.route, '/services/team-finder');
      expect(cubit.state.hasUnread([firstId]), isTrue);
      cubit.recordPush(id: firstId, title: 'Push copy');
      await cubit.refresh();
      expect(cubit.state.pushes, [notice(firstId)]);
    },
  );

  test(
    'coalesces overlapping loads and discards obsolete account responses',
    () async {
      final oldResponse = Completer<NotificationInboxSnapshot>();
      inbox.onLoad = (user) => user == 'student-a'
          ? oldResponse.future
          : Future.value(NotificationInboxSnapshot(items: [notice(secondId)]));
      final first = cubit.refresh();
      final duplicate = cubit.refresh();
      expect(inbox.loads, 1);
      cubit.selectUser('student-b');
      await cubit.refresh();
      oldResponse.complete(NotificationInboxSnapshot(items: [notice(firstId)]));
      await Future.wait([first, duplicate]);
      expect(cubit.state.pushes.single.id, secondId);
      expect(cubit.state.isLoading, isFalse);
    },
  );

  test(
    'authoritative inbox drops events no longer visible in organization',
    () async {
      inbox.onLoad = (_) async =>
          NotificationInboxSnapshot(items: [notice(firstId)]);
      await cubit.refresh();
      cubit.recordPush(id: 'push:legacy', title: 'Legacy');
      inbox.onLoad = (_) async => const NotificationInboxSnapshot(items: []);
      await cubit.refresh();
      expect(cubit.state.pushes.single.id, 'push:legacy');
    },
  );

  test('failed refresh retains usable cached notifications', () async {
    inbox.onLoad = (_) async =>
        NotificationInboxSnapshot(items: [notice(firstId)]);
    await cubit.refresh();
    inbox.onLoad = (_) async => throw StateError('Offline');
    await cubit.refresh();
    expect(cubit.state.pushes.single.id, firstId);
    expect(cubit.state.loadFailed, isTrue);
    expect(cubit.state.isLoading, isFalse);
  });

  test('offline read queue persists and retries after refresh', () async {
    inbox.onRead = (_, _) async => throw StateError('Offline');
    cubit.markAllRead([firstId, 'schedule:local', 'inbox:invalid']);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.isRead(firstId), isTrue);
    expect(cubit.state.pendingReadIds, {firstId});
    final restored = NotificationsState.fromJson(cubit.state.toJson());
    expect(restored.pendingReadIds, {firstId});
    inbox.onRead = (_, _) async {};
    await cubit.refresh();
    expect(inbox.reads, [
      {firstId},
      {firstId},
    ]);
    expect(cubit.state.pendingReadIds, isEmpty);
  });

  test(
    'reads made during sync are retained and acknowledged independently',
    () async {
      final acknowledgement = Completer<void>();
      inbox.onRead = (_, ids) =>
          ids.contains(firstId) ? acknowledgement.future : Future<void>.value();
      cubit
        ..markRead(firstId)
        ..markRead(secondId);
      acknowledgement.complete();
      await Future<void>.delayed(Duration.zero);
      expect(inbox.reads, [
        {firstId},
        {secondId},
      ]);
      expect(cubit.state.pendingReadIds, isEmpty);
      expect(cubit.state.readIds, containsAll([firstId, secondId]));
    },
  );

  test(
    'server read state synchronizes without sending another write',
    () async {
      inbox.onLoad = (_) async => NotificationInboxSnapshot(
        items: [notice(firstId)],
        readIds: {firstId},
      );
      await cubit.refresh();
      expect(cubit.state.isRead(firstId), isTrue);
      expect(inbox.reads, isEmpty);
    },
  );

  test('late read acknowledgement cannot affect next account queue', () async {
    final acknowledgement = Completer<void>();
    inbox.onRead = (user, _) => user == 'student-a'
        ? acknowledgement.future
        : Future<void>.error(StateError('Offline'));
    cubit
      ..markRead(firstId)
      ..selectUser('student-b')
      ..markRead(secondId);
    acknowledgement.complete();
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.pendingReadIds, {secondId});
    expect(cubit.state.readIds, {secondId});
  });

  test('signed out cubit never loads private inbox', () async {
    cubit.selectUser(null);
    await cubit.refresh();
    expect(inbox.loads, 0);
  });

  test(
    'push arriving during a load invalidates stale snapshot and reloads',
    () async {
      final oldSnapshot = Completer<NotificationInboxSnapshot>();
      final newSnapshot = Completer<NotificationInboxSnapshot>();
      inbox.onLoad = (_) =>
          inbox.loads == 1 ? oldSnapshot.future : newSnapshot.future;
      final sync = cubit.refresh();
      cubit.recordPush(id: firstId, title: 'New event');
      oldSnapshot.complete(const NotificationInboxSnapshot(items: []));
      await Future<void>.delayed(Duration.zero);
      expect(inbox.loads, 2);
      expect(cubit.state.pushes.single.id, firstId);
      newSnapshot.complete(NotificationInboxSnapshot(items: [notice(firstId)]));
      await sync;
      expect(cubit.state.pushes, [notice(firstId)]);
      expect(cubit.state.isLoading, isFalse);
    },
  );
}
