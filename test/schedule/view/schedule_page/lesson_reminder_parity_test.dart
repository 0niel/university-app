import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/lesson_remind_sheet.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

class _Repository extends Mock implements ScheduleRepository {}

class _Notifications extends Mock implements LocalNotificationsRepository {}

class _Reminders extends MockCubit<Map<String, int>>
    implements LessonRemindersCubit {}

void main() {
  tearDown(ToastManager.debugReset);

  final day = DateTime(2099, 9, 2);
  final lesson = scheduleTestLesson(day: day);
  late _Repository repository;
  late _Reminders reminders;
  late _Notifications notifications;

  setUpAll(() {
    registerFallbackValue(day);
  });

  setUp(() {
    repository = _Repository();
    reminders = _Reminders();
    notifications = _Notifications();
    when(notifications.ensurePermission).thenAnswer((_) async => true);
    when(() => reminders.state).thenReturn({});
    when(() => reminders.isClosed).thenReturn(false);
    when(() => reminders.minutesFor(lesson, day)).thenReturn(null);
    when(
      () => repository.createReminder(
        fireAt: any(named: 'fireAt'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        route: any(named: 'route'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> open(WidgetTester tester) async {
    await tester.pumpApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ScheduleRepository>.value(value: repository),
          RepositoryProvider<LocalNotificationsRepository>.value(
            value: notifications,
          ),
        ],
        child: BlocProvider<LessonRemindersCubit>.value(
          value: reminders,
          child: Scaffold(
            body: Builder(
              builder: (context) => AppButton.primary(
                label: 'Open',
                onPressed: () => showLessonRemindSheet(
                  context,
                  lesson: lesson,
                  day: day,
                  timePicker: (_) async => (hour: 7, minute: 25),
                ),
              ),
            ),
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  Future<void> advanced(WidgetTester tester) async {
    final more = find.byKey(const ValueKey('lesson-reminder-advanced'));
    await tester.ensureVisible(more);
    await tester.tap(more);
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    final l10n = tester.element(find.byType(AppSheet)).l10n;
    final button = find.text(l10n.done);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
  }

  testWidgets('fixed lead still creates a real reminder and caches success', (
    tester,
  ) async {
    await open(tester);
    await save(tester);
    verify(
      () => repository.createReminder(
        fireAt: DateTime(2099, 9, 2, 8, 45),
        title: lesson.subject,
        body: any(named: 'body'),
        route: '/services/map',
      ),
    ).called(1);
    verify(() => reminders.set(lesson, day, 15)).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'denied permission preserves the form without creating server state',
    (tester) async {
      when(notifications.ensurePermission).thenAnswer((_) async => false);
      await open(tester);
      await save(tester);
      expect(find.byType(AppSheet), findsOneWidget);
      expect(
        find.text(
          tester.element(find.byType(AppSheet)).l10n.onboardingPushDenied,
        ),
        findsOneWidget,
      );
      verifyNever(
        () => repository.createReminder(
          fireAt: any(named: 'fireAt'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          route: any(named: 'route'),
        ),
      );
      verifyNever(() => reminders.set(lesson, day, 15));
    },
  );

  testWidgets('morning reminder retains 08:00 and map navigation', (
    tester,
  ) async {
    await open(tester);
    await advanced(tester);
    final morning = find.byKey(const ValueKey('lesson-reminder-morning'));
    await tester.ensureVisible(morning);
    await tester.tap(morning);
    await tester.pumpAndSettle();
    await save(tester);
    verify(
      () => repository.createReminder(
        fireAt: DateTime(2099, 9, 2, 8),
        title: lesson.subject,
        body: any(named: 'body'),
        route: '/services/map',
      ),
    ).called(1);
    verify(() => reminders.set(lesson, day, 60)).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('custom time and disabling map route reach the repository', (
    tester,
  ) async {
    await open(tester);
    await advanced(tester);
    final custom = find.byKey(const ValueKey('lesson-reminder-custom'));
    await tester.ensureVisible(custom);
    await tester.tap(custom);
    await tester.pumpAndSettle();
    final route = find.byKey(const ValueKey('lesson-reminder-route'));
    await tester.ensureVisible(route);
    await tester.tap(route);
    await tester.pumpAndSettle();
    await save(tester);
    verify(
      () => repository.createReminder(
        fireAt: DateTime(2099, 9, 2, 7, 25),
        title: lesson.subject,
        body: any(named: 'body'),
        route: '/schedule',
      ),
    ).called(1);
    verify(() => reminders.set(lesson, day, 95)).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed reminder keeps editable settings and permits retry', (
    tester,
  ) async {
    var requests = 0;
    when(
      () => repository.createReminder(
        fireAt: any(named: 'fireAt'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        route: any(named: 'route'),
      ),
    ).thenAnswer((_) async {
      if (++requests == 1) throw Exception('offline');
    });
    await open(tester);
    await save(tester);
    expect(find.byType(AppSheet), findsOneWidget);
    expect(find.byType(AppBanner), findsOneWidget);
    verifyNever(() => reminders.set(lesson, day, 15));
    await save(tester);
    expect(requests, 2);
    verify(() => reminders.set(lesson, day, 15)).called(1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pending reminder prevents duplicate submission', (tester) async {
    final pending = Completer<void>();
    when(
      () => repository.createReminder(
        fireAt: any(named: 'fireAt'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        route: any(named: 'route'),
      ),
    ).thenAnswer((_) => pending.future);
    await open(tester);
    final done = find.text(tester.element(find.byType(AppSheet)).l10n.done);
    await tester.ensureVisible(done);
    await tester.tap(done);
    await tester.pump();
    await tester.tap(done);
    await tester.pump();
    verify(
      () => repository.createReminder(
        fireAt: any(named: 'fireAt'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        route: any(named: 'route'),
      ),
    ).called(1);
    pending.complete();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    expect(tester.takeException(), isNull);
  });
}
