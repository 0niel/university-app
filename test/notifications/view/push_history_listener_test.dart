import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/widgets/local_notification_listener.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';
import 'package:rtu_mirea_app/notifications/view/push_history_listener.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/pump_app.dart';

class _UserRepository extends Mock implements UserRepository {}

class _Messaging extends Mock implements FirebaseMessaging {}

class _Storage extends Mock implements Storage {}

class _Preferences extends Mock implements GamificationRepository {}

class _Router extends Mock implements GoRouter {}

class _LocalNotifications extends Mock
    implements LocalNotificationsRepository {}

class _RefreshingNotificationsCubit extends NotificationsCubit {
  _RefreshingNotificationsCubit({required super.userId});

  int refreshCalls = 0;

  @override
  bool get hasInbox => true;

  @override
  Future<void> refresh() async {
    refreshCalls++;
  }

  void snapshot(List<AppNotification> items) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(pushes: items, isLoading: false));
  }
}

void main() {
  const user = User(id: 'student-a', isNewUser: false);
  const otherUser = User(id: 'student-b', isNewUser: false);
  late AppBloc app;
  late _RefreshingNotificationsCubit notifications;
  late _Messaging messaging;
  late StreamController<RemoteMessage> foreground;

  void initialize() {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    final repository = _UserRepository();
    when(() => repository.user).thenAnswer((_) => const Stream.empty());
    messaging = _Messaging();
    when(messaging.getInitialMessage).thenAnswer((_) async => null);
    app = AppBloc(
      firebaseMessaging: messaging,
      userRepository: repository,
      user: user,
    );
    notifications = _RefreshingNotificationsCubit(userId: user.id);
    foreground = StreamController<RemoteMessage>.broadcast();
  }

  tearDown(() async {
    debugDefaultTargetPlatformOverride = null;
    await foreground.close();
    await notifications.close();
    await app.close();
  });

  Future<void> pump(
    WidgetTester tester, {
    Key? key,
    LocalNotificationsRepository? local,
    GamificationRepository? preferences,
    Widget child = const SizedBox(),
  }) async {
    addTearDown(() => tester.pumpWidget(const SizedBox()));
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>.value(value: app),
          BlocProvider<NotificationsCubit>.value(value: notifications),
        ],
        child: RepositoryProvider<GamificationRepository?>.value(
          value: preferences,
          child: RepositoryProvider<LocalNotificationsRepository?>.value(
            value: local,
            child: PushHistoryListener(
              key: key,
              messages: foreground.stream,
              child: child,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  _LocalNotifications localNotifications() {
    final local = _LocalNotifications();
    when(local.initialize).thenAnswer((_) async {});
    when(local.hasPermission).thenAnswer((_) async => true);
    when(
      () => local.showPush(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});
    return local;
  }

  AppNotification inbox(int id) => AppNotification(
    id: 'inbox:00000000-0000-0000-0000-${id.toString().padLeft(12, '0')}',
    kind: AppNotificationKind.accent,
    title: 'Notification $id',
    createdAt: DateTime.utc(2026, 9, 5, 12, id),
    route: '/services/people?tab=friends',
  );

  testWidgets('foreground Discourse notification tap opens its post', (
    tester,
  ) async {
    initialize();
    final local = localNotifications();
    final router = _Router();
    final interactions = StreamController<String>.broadcast(sync: true);
    when(() => local.interactions).thenAnswer((_) => interactions.stream);
    addTearDown(interactions.close);
    await pump(
      tester,
      local: local,
      child: RepositoryProvider<LocalNotificationsRepository>.value(
        value: local,
        child: LocalNotificationListener(
          router: router,
          child: const SizedBox(),
        ),
      ),
    );
    foreground.add(
      const RemoteMessage(
        messageId: 'discourse',
        data: {'discourse_post_id': '42'},
        notification: RemoteNotification(title: 'New post'),
      ),
    );
    await tester.pumpAndSettle();
    final payload =
        verify(
              () => local.showPush(
                id: any(named: 'id'),
                title: 'New post',
                body: any(named: 'body'),
                payload: captureAny(named: 'payload'),
              ),
            ).captured.single
            as String;
    interactions.add(payload);
    verify(() => router.go('/services/discourse-post-overview/42')).called(1);
  });

  for (final platform in [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ]) {
    testWidgets('$platform toasts new inbox once and deduplicates FCM', (
      tester,
    ) async {
      initialize();
      debugDefaultTargetPlatformOverride = platform;
      final local = localNotifications();
      await pump(tester, local: local);
      notifications.snapshot([inbox(1)]);
      await tester.pumpAndSettle();
      verifyNever(
        () => local.showPush(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      );
      notifications.snapshot([inbox(2), inbox(1)]);
      await tester.pumpAndSettle();
      verify(
        () => local.showPush(
          id: any(named: 'id'),
          title: 'Notification 2',
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      ).called(1);
      foreground.add(
        RemoteMessage(
          messageId: 'same-delivery',
          data: {
            'notification_id': inbox(2).id.substring(6),
            'title': 'Notification 2',
          },
        ),
      );
      await tester.pumpAndSettle();
      notifications.snapshot([inbox(2), inbox(1)]);
      await tester.pumpAndSettle();
      verifyNever(
        () => local.showPush(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      );
      debugDefaultTargetPlatformOverride = null;
    });
  }

  testWidgets(
    'desktop respects disabled preferences and account changes during load',
    (tester) async {
      initialize();
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      final local = localNotifications();
      final preferences = _Preferences();
      when(preferences.getSettings).thenAnswer(
        (_) async => const UserSettings(notificationsEnabled: false),
      );
      await pump(tester, local: local, preferences: preferences);
      notifications.snapshot([inbox(1)]);
      await tester.pumpAndSettle();
      notifications.snapshot([inbox(2), inbox(1)]);
      await tester.pumpAndSettle();
      verifyNever(
        () => local.showPush(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      );
      final settings = Completer<UserSettings>();
      when(preferences.getSettings).thenAnswer((_) => settings.future);
      notifications.snapshot([inbox(3), inbox(2)]);
      await tester.pump();
      app.add(const AppUserChanged(otherUser));
      await tester.pump();
      settings.complete(const UserSettings());
      await tester.pumpAndSettle();
      verifyNever(
        () => local.showPush(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      );
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets('foreground displays once; opened push only records inbox', (
    tester,
  ) async {
    initialize();
    final local = _LocalNotifications();
    when(local.initialize).thenAnswer((_) async {});
    when(local.hasPermission).thenAnswer((_) async => true);
    when(
      () => local.showPush(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});
    await pump(tester, local: local);
    const message = RemoteMessage(
      messageId: 'visible',
      data: {'route': '/profile'},
      notification: RemoteNotification(title: 'Hello', body: 'Message'),
    );
    foreground.add(message);
    await tester.pumpAndSettle();
    foreground.add(message);
    await tester.pumpAndSettle();
    verify(
      () => local.showPush(
        id: any(named: 'id'),
        title: 'Hello',
        body: 'Message',
        payload: '{"type":"push","user_id":"student-a","route":"/profile"}',
      ),
    ).called(1);
    expect(notifications.state.pushes, hasLength(1));
    app.add(
      const InteractedMessageReceived(
        RemoteMessage(
          messageId: 'opened',
          notification: RemoteNotification(title: 'Already shown'),
        ),
        userId: 'student-a',
      ),
    );
    await tester.pumpAndSettle();
    verifyNever(
      () => local.showPush(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        payload: any(named: 'payload'),
      ),
    );
    expect(notifications.state.pushes, hasLength(2));
  });

  testWidgets(
    'permission denial records inbox without displaying or prompting',
    (tester) async {
      initialize();
      final local = _LocalNotifications();
      when(local.initialize).thenAnswer((_) async {});
      when(local.hasPermission).thenAnswer((_) async => false);
      await pump(tester, local: local);
      foreground.add(
        const RemoteMessage(
          messageId: 'denied',
          notification: RemoteNotification(title: 'Hello'),
        ),
      );
      await tester.pumpAndSettle();
      expect(notifications.state.pushes, hasLength(1));
      verifyNever(local.ensurePermission);
      verifyNever(
        () => local.showPush(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          payload: any(named: 'payload'),
        ),
      );
    },
  );

  testWidgets(
    'records an initial push once after the history listener mounts',
    (
      tester,
    ) async {
      initialize();
      const message = RemoteMessage(
        messageId: 'initial',
        data: {'route': '/profile'},
        notification: RemoteNotification(
          title: 'Profile updated',
          body: 'Open it',
        ),
      );
      when(messaging.getInitialMessage).thenAnswer((_) async => message);
      await app.setupInteractedMessage();
      await tester.pump();
      expect(notifications.state.pushes, isEmpty);

      await pump(tester);
      expect(notifications.state.pushes, hasLength(1));
      final push = notifications.state.pushes.single;
      expect(push.id, 'push:initial');
      expect(push.title, 'Profile updated');
      expect(push.subtitle, 'Open it');
      expect(push.route, '/profile');
      await pump(tester, key: const ValueKey('remounted'));
      expect(notifications.state.pushes, hasLength(1));
      expect(app.takePendingPushMessages(user.id), isEmpty);
      expect(app.state.notificationNavigationId, 1);
      verify(messaging.getInitialMessage).called(1);
    },
  );

  testWidgets(
    'records an initial push that arrives after mount without rerouting',
    (
      tester,
    ) async {
      initialize();
      final initial = Completer<RemoteMessage?>();
      when(messaging.getInitialMessage).thenAnswer((_) => initial.future);
      await pump(tester);
      final setup = app.setupInteractedMessage();
      initial.complete(
        const RemoteMessage(messageId: 'delayed', data: {'route': '/profile'}),
      );
      await setup;
      await tester.pumpAndSettle();

      expect(app.state.notificationNavigationId, 1);
      expect(app.takePendingPushMessages(user.id), isEmpty);
      expect(notifications.state.pushes.single.id, 'push:delayed');
      expect(notifications.state.pushes.single.title, isNotEmpty);
      expect(app.state.notificationNavigationId, 1);
    },
  );

  testWidgets('foreground pushes are recorded without a navigation event', (
    tester,
  ) async {
    initialize();
    await pump(tester);
    foreground.add(
      const RemoteMessage(
        messageId: 'foreground',
        data: {'title': 'New lecture', 'route': '/profile'},
      ),
    );
    await tester.pump();

    expect(notifications.state.pushes.single.id, 'push:foreground');
    expect(app.state.notificationNavigationId, 0);
  });

  testWidgets(
    'server push ids deduplicate delivery and legacy friends open people',
    (
      tester,
    ) async {
      initialize();
      await pump(tester);
      for (final id in ['delivery-one', 'delivery-two']) {
        foreground.add(
          RemoteMessage(
            messageId: id,
            data: const {
              'notification_id': 'CA8E65C8-8545-4A49-A047-3797C733BD63',
              'type': 'friend_request',
              'title': 'Новая заявка в друзья',
            },
          ),
        );
        await tester.pump();
      }
      expect(notifications.state.pushes, hasLength(1));
      expect(
        notifications.state.pushes.single.id,
        'inbox:ca8e65c8-8545-4a49-a047-3797c733bd63',
      );
      expect(
        notifications.state.pushes.single.route,
        '/services/people?tab=friends',
      );
      expect(notifications.refreshCalls, 3);
    },
  );

  testWidgets('invalid server ids retain the delivery id', (tester) async {
    initialize();
    await pump(tester);
    foreground.add(
      const RemoteMessage(
        messageId: 'fallback',
        data: {'notification_id': 'invalid', 'route': 'https://example.com'},
      ),
    );
    await tester.pump();
    expect(notifications.state.pushes.single.id, 'push:fallback');
    expect(notifications.state.pushes.single.route, isNull);
  });

  testWidgets('refreshes on resume and polls only while foreground', (
    tester,
  ) async {
    initialize();
    tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
    await pump(tester);
    expect(notifications.refreshCalls, 1);
    await tester.pump(const Duration(minutes: 1));
    expect(notifications.refreshCalls, 2);
    tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.paused,
    );
    await tester.pump(const Duration(minutes: 2));
    expect(notifications.refreshCalls, 2);
    tester.binding.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
    expect(notifications.refreshCalls, 3);
    app.add(const AppUserChanged(otherUser));
    await tester.pump();
    await tester.pump(const Duration(minutes: 1));
    expect(notifications.refreshCalls, 3);
  });

  testWidgets(
    'does not deliver pending or live messages to a changed account',
    (
      tester,
    ) async {
      initialize();
      app.add(
        InteractedMessageReceived(
          const RemoteMessage(messageId: 'old-user'),
          userId: user.id,
        ),
      );
      await tester.pump();
      app.add(const AppUserChanged(otherUser));
      await tester.pump();
      notifications.selectUser(otherUser.id);
      await pump(tester);
      expect(notifications.state.pushes, isEmpty);

      app.add(const AppUserChanged(user));
      await tester.pump();
      foreground.add(const RemoteMessage(messageId: 'stale-scope'));
      await tester.pump();
      expect(notifications.state.pushes, isEmpty);
    },
  );
}
