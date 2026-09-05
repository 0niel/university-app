import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/navigation/widgets/schedule_nav_badge.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/notifications/view/notifications_sheet.dart';
import 'package:rtu_mirea_app/notifications/view/schedule_changes_read_scope.dart';
import 'package:rtu_mirea_app/notifications/view/widgets/notification_row.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/schedule_changes_sheet.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/pump_app.dart';

class _Repository extends Mock implements ScheduleRepository {}

void main() {
  late NotificationsCubit notifications;
  late ScheduleChangesCubit changes;
  final day = DateTime(2026, 9, 2);
  ScheduleChange change(String id, DateTime date) => ScheduleChange(
    id: id,
    kind: ScheduleChangeKind.room,
    subject: 'Subject $id',
    lessonDate: date,
    createdAt: day,
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    HydratedBloc.storage = CustomHydratedStorage(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
    notifications = NotificationsCubit(userId: 'student');
    final repository = _Repository();
    when(
      () => repository.getScheduleChanges(
        targetType: ScheduleTargetType.group,
        target: 'A',
      ),
    ).thenAnswer(
      (_) async => [
        change('101', day),
        change('102', day.add(const Duration(days: 7))),
      ],
    );
    changes = ScheduleChangesCubit(scheduleRepository: repository);
    await changes.load(targetType: ScheduleTargetType.group, target: 'A');
  });

  tearDown(() async {
    await notifications.close();
    await changes.close();
  });

  testWidgets('viewing a week marks only displayed changes and updates inbox', (
    tester,
  ) async {
    await tester.pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: notifications),
          BlocProvider.value(value: changes),
        ],
        child: Scaffold(
          body: Builder(
            builder: (context) => Column(
              children: [
                ScheduleNavBadge(
                  builder: (_, {required hasUnread}) =>
                      Text('badge:$hasUnread'),
                ),
                TextButton(
                  onPressed: () =>
                      showScheduleChangesSheet(context, weekOf: day),
                  child: const Text('Open'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(notifications.state.isRead('change:101'), isTrue);
    expect(notifications.state.isRead('change:102'), isFalse);
    await tester.tap(find.text('Понятно'));
    await tester.pumpAndSettle();
    expect(find.text('badge:true'), findsOneWidget);
    notifications.markRead('change:102');
    await tester.pumpAndSettle();
    expect(find.text('badge:false'), findsOneWidget);
    await tester.pumpApp(
      BlocProvider.value(
        value: notifications,
        child: Scaffold(
          body: NotificationsSheet(changes: changes.state.changes),
        ),
      ),
    );
    expect(
      tester
          .widgetList<NotificationRow>(find.byType(NotificationRow))
          .every((row) => !row.isUnread),
      isTrue,
    );
    await changes.load(targetType: ScheduleTargetType.group, target: 'A');
    expect(
      notifications.state.hasUnread(['change:101', 'change:102']),
      isFalse,
    );
  });

  testWidgets('a disposed or covered view cannot acknowledge changes', (
    tester,
  ) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      BlocProvider.value(
        value: notifications,
        child: MaterialApp(navigatorKey: navigator, home: const SizedBox()),
      ),
    );
    unawaited(
      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              navigator.currentState!.pop();
            });
            return ScheduleChangesReadScope(
              changes: [change('101', day)],
              child: const Text('Changes'),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(notifications.state.isRead('change:101'), isFalse);
  });
}
