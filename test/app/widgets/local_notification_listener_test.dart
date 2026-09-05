import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/widgets/local_notification_listener.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/pump_app.dart';

class _Notifications extends Mock implements LocalNotificationsRepository {}

class _Router extends Mock implements GoRouter {}

class _App extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  testWidgets(
    'push tap opens a safe route only for the owning account',
    (
      tester,
    ) async {
      final repository = _Notifications();
      final router = _Router();
      final app = _App();
      when(() => app.state).thenReturn(
        const AppState(
          status: AppStatus.authenticated,
          user: User(id: 'student-a', isNewUser: false),
        ),
      );
      final interactions = StreamController<String>.broadcast(sync: true);
      when(
        () => repository.interactions,
      ).thenAnswer((_) => interactions.stream);
      when(repository.initialize).thenAnswer((_) async {});
      await tester.pumpApp(
        BlocProvider<AppBloc>.value(
          value: app,
          child: RepositoryProvider<LocalNotificationsRepository>.value(
            value: repository,
            child: LocalNotificationListener(
              router: router,
              child: const SizedBox(),
            ),
          ),
        ),
      );
      await tester.pump();
      interactions.add(
        '{"type":"push","user_id":"student-a","route":"/services/people?tab=friends"}',
      );
      verify(() => router.go('/services/people?tab=friends')).called(1);
      interactions
        ..add('{"type":"push","user_id":"student-b","route":"/profile"}')
        ..add(
          '{"type":"push","user_id":"student-a","route":"https://external.example"}',
        )
        ..add('{"type":"push","user_id":"student-a","route":42}');
      verifyNever(() => router.go(any()));
      await tester.pumpWidget(const SizedBox());
      await interactions.close();
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
    }),
  );
  testWidgets('cold start and live local taps open only the schedule route', (
    tester,
  ) async {
    final repository = _Notifications();
    final router = _Router();
    final interactions = StreamController<String>.broadcast(sync: true);
    when(() => repository.interactions).thenAnswer((_) => interactions.stream);
    when(repository.initialize).thenAnswer((_) async {});
    when(repository.takePendingInteraction).thenReturn('custom-schedules');
    await tester.pumpApp(
      RepositoryProvider<LocalNotificationsRepository>.value(
        value: repository,
        child: LocalNotificationListener(
          router: router,
          child: const SizedBox(),
        ),
      ),
    );
    await tester.pump();
    verify(() => router.go('/schedule')).called(1);
    interactions
      ..add('https://external.example')
      ..add('/profile');
    verifyNever(() => router.go(any()));
    interactions.add('custom-schedules');
    verify(() => router.go('/schedule')).called(1);
    await tester.pumpWidget(const SizedBox());
    await interactions.close();
    expect(tester.takeException(), isNull);
  });
}
