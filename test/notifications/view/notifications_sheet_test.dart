import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/data/notification_inbox_repository.dart';
import 'package:rtu_mirea_app/notifications/model/app_notification.dart';
import 'package:rtu_mirea_app/notifications/view/notifications_sheet.dart';
import 'package:rtu_mirea_app/notifications/view/widgets/notification_row.dart';
import 'package:rtu_mirea_app/notifications/view/widgets/notifications_sheet_header.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/pump_app.dart';

class _InboxRepository extends Mock implements NotificationInboxRepository {}

class _ScheduleRepository extends Mock implements ScheduleRepository {}

void main() {
  late NotificationsCubit cubit;
  final now = DateTime(2026, 9, 2, 12);
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    HydratedBloc.storage = CustomHydratedStorage(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
    cubit = NotificationsCubit(userId: 'student');
  });
  tearDown(() => cubit.close());

  Future<void> pump(WidgetTester tester, {double scale = 1}) async {
    await tester.pumpApp(
      BlocProvider<NotificationsCubit>.value(
        value: cubit,
        child: Scaffold(
          body: SingleChildScrollView(
            child: NotificationsSheet(changes: const [], now: now),
          ),
        ),
      ),
      size: const Size(390, 844),
      textScaler: TextScaler.linear(scale),
    );
    await tester.pump();
  }

  testWidgets('empty history is honest and has no enabled read-all action', (
    tester,
  ) async {
    await pump(tester);
    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.byType(NotificationRow), findsNothing);
    final action = tester.widget<AppPressable>(
      find.descendant(
        of: find.byType(NotificationsSheetHeader),
        matching: find.byType(AppPressable),
      ),
    );
    expect(action.enabled, isFalse);
  });

  testWidgets('empty inbox loads and retries a failed fetch', (tester) async {
    final repository = _InboxRepository();
    final response = Completer<NotificationInboxSnapshot>();
    when(() => repository.load('student')).thenAnswer((_) => response.future);
    await cubit.close();
    cubit = NotificationsCubit(userId: 'student', repository: repository);
    final refresh = cubit.refresh();
    await pump(tester);
    expect(find.byType(AppSpinner), findsOneWidget);
    expect(find.byType(AppEmptyState), findsNothing);
    response.completeError(StateError('offline'), StackTrace.current);
    await refresh;
    await tester.pump();
    expect(find.byType(AppSpinner), findsNothing);
    final retry = tester.widget<AppEmptyState>(find.byType(AppEmptyState));
    expect(retry.onAction, isNotNull);
    when(() => repository.load('student')).thenAnswer(
      (_) async => NotificationInboxSnapshot(
        items: [
          AppNotification(
            id: 'inbox:one',
            title: 'Новый отклик в команду',
            kind: AppNotificationKind.accent,
            createdAt: now,
            route: '/services/teams',
          ),
        ],
      ),
    );
    await tester.tap(find.byType(AppPillButton));
    await tester.pump();
    await tester.pump();
    expect(find.text('Новый отклик в команду'), findsOneWidget);
    expect(find.byType(AppEmptyState), findsNothing);
    verify(() => repository.load('student')).called(2);
  });

  testWidgets('refresh failure preserves cached notifications', (tester) async {
    final repository = _InboxRepository();
    when(() => repository.load('student')).thenThrow(StateError('offline'));
    await cubit.close();
    cubit = NotificationsCubit(userId: 'student', repository: repository)
      ..recordPush(id: 'cached', title: 'Заявка принята', at: now);
    await cubit.refresh();
    await pump(tester);
    expect(cubit.state.loadFailed, isTrue);
    expect(find.text('Заявка принята'), findsOneWidget);
    expect(find.byType(AppEmptyState), findsNothing);
  });

  testWidgets(
    'header and notification geometry follow the sheet '
    'and read-all updates state',
    (tester) async {
      cubit.recordPush(
        id: 'one',
        title: 'Перенос пары',
        body: 'Математика · 13:00',
        at: now.subtract(const Duration(minutes: 5)),
        kind: AppNotificationKind.warn,
      );
      await pump(tester);
      final title = tester.getRect(find.text('Уведомления'));
      final list = tester.getRect(find.byType(AppListGroup));
      expect(list.top - title.bottom, closeTo(14, .01));
      expect(tester.getSize(find.byType(AppIconTile)), const Size(40, 40));
      final action = find.descendant(
        of: find.byType(NotificationsSheetHeader),
        matching: find.byType(AppPressable),
      );
      expect(tester.getSize(action).height, greaterThanOrEqualTo(44));
      expect(
        tester.widget<NotificationRow>(find.byType(NotificationRow)).isUnread,
        isTrue,
      );
      await tester.tap(action);
      await tester.pump();
      expect(cubit.state.isRead('one'), isTrue);
      expect(tester.widget<AppPressable>(action).enabled, isFalse);
      expect(find.text('Перенос пары'), findsOneWidget);
      expect(
        tester.widget<NotificationRow>(find.byType(NotificationRow)).isUnread,
        isFalse,
      );
    },
  );

  testWidgets('long notification text retains metadata at 200 percent scale', (
    tester,
  ) async {
    cubit.recordPush(
      id: 'one',
      title: 'Важное изменение расписания занятий',
      body: 'Пожалуйста, проверьте новое время и аудиторию',
      at: now.subtract(const Duration(days: 3)),
    );
    await pump(tester, scale: 2);
    expect(tester.takeException(), isNull);
    expect(find.text('30 авг.'), findsOneWidget);
    final time = tester.getRect(find.text('30 авг.'));
    final subtitle = tester.getRect(
      find.text('Пожалуйста, проверьте новое время и аудиторию'),
    );
    expect(time.top, greaterThan(subtitle.bottom));
  });

  testWidgets('long inbox mounts only its viewport and reaches the last row', (
    tester,
  ) async {
    final changes = [
      for (var i = 0; i < 200; i++)
        ScheduleChange(
          id: '${i + 1}',
          kind: ScheduleChangeKind.room,
          subject: 'Subject $i',
          lessonDate: now,
          createdAt: now.subtract(Duration(minutes: i)),
        ),
    ];
    await tester.pumpApp(
      BlocProvider.value(
        value: cubit,
        child: Scaffold(
          body: NotificationsSheet(changes: changes, now: now),
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.pump();
    expect(find.byType(NotificationRow).evaluate().length, lessThan(20));
    expect(find.byKey(const ValueKey('change:200')), findsNothing);
    final scroll = Scrollable.of(
      tester.element(find.byType(NotificationRow).first),
    );
    scroll.position.jumpTo(scroll.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('change:200')), findsOneWidget);
    expect(find.byType(NotificationRow).evaluate().length, lessThan(20));
    final action = find.descendant(
      of: find.byType(NotificationsSheetHeader),
      matching: find.byType(AppPressable),
    );
    await tester.tap(action);
    await tester.pump();
    expect(
      changes.every((change) => cubit.state.isRead('change:${change.id}')),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('short inbox keeps a compact height', (tester) async {
    cubit.recordPush(id: 'short', title: 'One notification', at: now);
    await pump(tester);
    expect(
      tester.getSize(find.byType(NotificationsSheet)).height,
      lessThan(300),
    );
    expect(find.byType(AppListGroup), findsOneWidget);
    expect(find.text('One notification'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'notification sheet coordinates list scrolling and drag dismissal',
    (
      tester,
    ) async {
      final repository = _ScheduleRepository();
      when(
        () => repository.getScheduleChanges(
          targetType: ScheduleTargetType.group,
          target: 'A',
        ),
      ).thenAnswer(
        (_) async => [
          for (var i = 0; i < 100; i++)
            ScheduleChange(
              id: '${i + 1}',
              kind: ScheduleChangeKind.room,
              subject: 'Subject $i',
              lessonDate: now,
              createdAt: now.subtract(Duration(minutes: i)),
            ),
        ],
      );
      final changes = ScheduleChangesCubit(scheduleRepository: repository);
      addTearDown(changes.close);
      await changes.load(targetType: ScheduleTargetType.group, target: 'A');
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider.value(value: changes),
          ],
          child: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => unawaited(showNotificationsSheet(context)),
                child: const Text('Open inbox'),
              ),
            ),
          ),
        ),
        size: const Size(390, 844),
      );
      await tester.tap(find.text('Open inbox'));
      await tester.pumpAndSettle();
      expect(find.byType(AppSheet), findsOneWidget);
      expect(find.byType(NotificationRow).evaluate().length, lessThan(20));
      final scroll = Scrollable.of(
        tester.element(find.byType(NotificationRow).first),
      );
      scroll.position.jumpTo(scroll.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('change:100')), findsOneWidget);
      scroll.position.jumpTo(scroll.position.minScrollExtent);
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, 700));
      await tester.pumpAndSettle();
      expect(find.byType(AppSheet), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'compact landscape error sheet keeps retry reachable at 200 percent',
    (
      tester,
    ) async {
      final inbox = _InboxRepository();
      when(() => inbox.load('student')).thenThrow(StateError('offline'));
      await cubit.close();
      cubit = NotificationsCubit(userId: 'student', repository: inbox);
      final changes = ScheduleChangesCubit(
        scheduleRepository: _ScheduleRepository(),
      );
      addTearDown(changes.close);
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider.value(value: changes),
          ],
          child: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => unawaited(showNotificationsSheet(context)),
                child: const Text('Open compact inbox'),
              ),
            ),
          ),
        ),
        size: const Size(390, 320),
        textScaler: const TextScaler.linear(2),
      );
      await tester.tap(find.text('Open compact inbox'));
      await tester.pumpAndSettle();
      expect(find.byType(AppSheet), findsOneWidget);
      expect(tester.takeException(), isNull);
      final retry = find.byType(AppPillButton);
      await tester.ensureVisible(retry);
      await tester.pumpAndSettle();
      expect(retry.hitTestable(), findsOneWidget);
      await tester.tap(retry);
      await tester.pumpAndSettle();
      verify(() => inbox.load('student')).called(2);
      expect(tester.takeException(), isNull);
    },
  );
}
