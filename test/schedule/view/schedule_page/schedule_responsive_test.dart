import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_month_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Preferences extends MockCubit<SchedulePreferencesState>
    implements SchedulePreferencesCubit {}

class _Display extends MockCubit<ScheduleDisplayState>
    implements ScheduleDisplayCubit {}

class _Changes extends MockCubit<ScheduleChangesState>
    implements ScheduleChangesCubit {}

class _Activities extends MockCubit<UserActivitiesState>
    implements UserActivitiesCubit {}

class _Classmates extends MockCubit<ClassmatesState>
    implements ClassmatesCubit {}

class _Reminders extends MockCubit<Map<String, int>>
    implements LessonRemindersCubit {}

void main() {
  late _Schedule schedule;
  late _Preferences preferences;
  late _Display display;
  late _Changes changes;
  late _Activities activities;
  late _Classmates classmates;
  late _Reminders reminders;
  late ScheduleComparisonCubit comparison;

  setUp(() {
    schedule = _Schedule();
    preferences = _Preferences();
    display = _Display();
    changes = _Changes();
    activities = _Activities();
    classmates = _Classmates();
    reminders = _Reminders();
    comparison = ScheduleComparisonCubit();
    when(() => schedule.state).thenReturn(
      ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'ИКБО-01-24'),
          schedule: [scheduleTestLesson(day: DateTime.now())],
        ),
      ),
    );
    when(() => preferences.state).thenReturn(const SchedulePreferencesState());
    when(() => display.state).thenReturn(const ScheduleDisplayState());
    when(() => changes.state).thenReturn(const ScheduleChangesState());
    when(
      () => changes.matchesTarget(ScheduleTargetType.group, 'ИКБО-01-24'),
    ).thenReturn(true);
    when(() => activities.state).thenReturn(const UserActivitiesState());
    when(() => classmates.state).thenReturn(const ClassmatesState());
    when(() => reminders.state).thenReturn({});
    when(
      () => activities.load(
        from: any(named: 'from'),
        to: any(named: 'to'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => changes.load(
        targetType: ScheduleTargetType.group,
        target: any(named: 'target'),
      ),
    ).thenAnswer((_) async {});
    when(() => classmates.load(any())).thenAnswer((_) async {});
    addTearDown(comparison.close);
  });

  Widget subject({bool reduceMotion = false}) => MultiBlocProvider(
    providers: [
      BlocProvider<ScheduleBloc>.value(value: schedule),
      BlocProvider<SchedulePreferencesCubit>.value(value: preferences),
      BlocProvider<ScheduleDisplayCubit>.value(value: display),
      BlocProvider<ScheduleChangesCubit>.value(value: changes),
      BlocProvider<UserActivitiesCubit>.value(value: activities),
      BlocProvider<ClassmatesCubit>.value(value: classmates),
      BlocProvider<LessonRemindersCubit>.value(value: reminders),
      BlocProvider.value(value: comparison),
    ],
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
        child: const Scaffold(body: SchedulePage()),
      ),
    ),
  );

  testWidgets(
    'day week and month stay overflow free at 320px and 200 percent',
    (tester) async {
      await tester.pumpApp(
        subject(),
        size: const Size(320, 900),
        textScaler: const TextScaler.linear(2),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ScheduleDayView), findsOneWidget);
      expect(tester.takeException(), isNull);
      for (final label in ['Неделя', 'Месяц', 'День']) {
        await tester.ensureVisible(find.text(label).first);
        await tester.pumpAndSettle();
        expect(find.text(label).first.hitTestable(), findsOneWidget);
        await tester.tap(find.text(label).first);
        await tester.pumpAndSettle();
        expect(
          find.byType(switch (label) {
            'Неделя' => ScheduleWeekView,
            'Месяц' => ScheduleMonthView,
            _ => ScheduleDayView,
          }),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull, reason: label);
      }
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('reading a change removes the calendar banner and action dot', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    HydratedBloc.storage = CustomHydratedStorage(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
    final notifications = NotificationsCubit(userId: 'student');
    addTearDown(notifications.close);
    when(() => changes.state).thenReturn(
      ScheduleChangesState(
        changes: [
          ScheduleChange(
            id: '101',
            kind: ScheduleChangeKind.cancel,
            subject: 'Математика',
            lessonDate: DateTime.now(),
            createdAt: DateTime.now(),
          ),
        ],
      ),
    );
    await tester.pumpApp(
      BlocProvider.value(value: notifications, child: subject()),
      size: const Size(420, 900),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('изменение на этой неделе'), findsOneWidget);
    notifications.markRead('change:101');
    await tester.pumpAndSettle();
    expect(find.textContaining('изменение на этой неделе'), findsNothing);
    expect(changes.state.changes.single.kind, ScheduleChangeKind.cancel);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'view transitions preserve selected day and disable outgoing input',
    (tester) async {
      await tester.pumpApp(subject(), size: const Size(420, 900));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Месяц').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(find.byType(ScheduleMonthView), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byType(ScheduleDayView),
          matching: find.byType(IgnorePointer),
        ),
        findsWidgets,
      );
      await tester.tap(find.text('Неделя').first);
      await tester.pumpAndSettle();
      expect(find.byType(ScheduleWeekView), findsOneWidget);
      expect(find.byType(ScheduleDayView), findsNothing);
      expect(find.byType(ScheduleMonthView), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('reduced motion switches immediately', (tester) async {
    await tester.pumpApp(
      subject(reduceMotion: true),
      size: const Size(420, 900),
    );
    await tester.pump();
    await tester.tap(find.text('Месяц').first);
    await tester.pump();
    expect(find.byType(ScheduleMonthView), findsOneWidget);
    expect(find.byType(ScheduleDayView), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('filter sheet exposes toggles and retained type filters', (
    tester,
  ) async {
    await tester.pumpApp(subject(), size: const Size(420, 900));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Фильтры'));
    await tester.pumpAndSettle();
    expect(find.text('Показывать'), findsOneWidget);
    expect(find.byType(AppSwitch), findsNWidgets(3));
    expect(find.text('Лекция'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('teacher schedule header uses surname and initials', (
    tester,
  ) async {
    when(
      () => changes.matchesTarget(
        ScheduleTargetType.teacher,
        'Акатъев Ярослав Алексеевич',
      ),
    ).thenReturn(true);
    when(
      () => changes.load(
        targetType: ScheduleTargetType.teacher,
        target: 'Акатъев Ярослав Алексеевич',
      ),
    ).thenAnswer((_) async {});
    when(() => schedule.state).thenReturn(
      const ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: SelectedTeacherSchedule(
          teacher: Teacher(name: 'Акатъев Ярослав Алексеевич'),
          schedule: [],
        ),
      ),
    );

    await tester.pumpApp(subject(), size: const Size(390, 844));
    await tester.pumpAndSettle();

    expect(find.text('Акатъев Я. А.'), findsOneWidget);
    expect(find.text('Акатъев Ярослав Алексеевич'), findsNothing);
    expect(
      find.bySemanticsLabel('Акатъев Ярослав Алексеевич'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('loading keeps navigation chrome and shows skeleton rows', (
    tester,
  ) async {
    when(
      () => schedule.state,
    ).thenReturn(const ScheduleState(status: ScheduleStatus.loading));
    await tester.pumpApp(subject(), size: const Size(320, 900));
    await tester.pump();
    expect(find.text('День'), findsOneWidget);
    expect(find.text('Неделя'), findsOneWidget);
    expect(find.text('Месяц'), findsOneWidget);
    expect(find.byType(AppSkeletonRow), findsNWidgets(3));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('cold failure offers retry instead of a free day', (
    tester,
  ) async {
    when(
      () => schedule.state,
    ).thenReturn(const ScheduleState(status: ScheduleStatus.failure));
    await tester.pumpApp(subject(), size: const Size(420, 900));
    await tester.pump();
    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.text('Свободный день'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
