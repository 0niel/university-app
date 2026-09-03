import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/view/push_history_listener.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/pump_app.dart';

class _UserRepository extends Mock implements UserRepository {}

class _Messaging extends Mock implements FirebaseMessaging {}

class _Storage extends Mock implements Storage {}

void main() {
  const user = User(id: 'student-a', isNewUser: false);
  const otherUser = User(id: 'student-b', isNewUser: false);
  late AppBloc app;
  late NotificationsCubit notifications;
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
    notifications = NotificationsCubit(userId: user.id);
    foreground = StreamController<RemoteMessage>.broadcast();
  }

  tearDown(() async {
    await foreground.close();
    await notifications.close();
    await app.close();
  });

  Future<void> pump(WidgetTester tester, {Key? key}) async {
    addTearDown(() => tester.pumpWidget(const SizedBox()));
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>.value(value: app),
          BlocProvider<NotificationsCubit>.value(value: notifications),
        ],
        child: PushHistoryListener(
          key: key,
          messages: foreground.stream,
          child: const SizedBox(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

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
