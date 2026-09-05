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
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/pump_app.dart';

class _InboxRepository extends Mock implements NotificationInboxRepository {}

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
    response.completeError(StateError('offline'));
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
}
