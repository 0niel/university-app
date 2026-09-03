import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/widgets/local_notification_listener.dart';

import '../../helpers/pump_app.dart';

class _Notifications extends Mock implements LocalNotificationsRepository {}

class _Router extends Mock implements GoRouter {}

void main() {
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
