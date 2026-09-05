import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_body.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_month_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

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

void main() {
  Widget subject({DateTime? fixedNow, ScheduleView view = ScheduleView.day}) {
    final schedule = _Schedule();
    final preferences = _Preferences();
    final display = _Display();
    final changes = _Changes();
    final activities = _Activities();
    final classmates = _Classmates();
    final comparison = ScheduleComparisonCubit();
    addTearDown(comparison.close);
    when(() => schedule.state).thenReturn(
      ScheduleState(
        status: ScheduleStatus.loaded,
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'БСБО-43-24'),
          schedule: [scheduleTestLesson(end: 542)],
        ),
      ),
    );
    when(() => preferences.state).thenReturn(const SchedulePreferencesState());
    when(() => display.state).thenReturn(
      const ScheduleDisplayState(lessonActionsHintShown: true),
    );
    when(() => changes.state).thenReturn(const ScheduleChangesState());
    when(
      () => changes.matchesTarget(ScheduleTargetType.group, 'БСБО-43-24'),
    ).thenReturn(true);
    when(() => activities.state).thenReturn(const UserActivitiesState());
    when(() => classmates.state).thenReturn(const ClassmatesState());
    when(
      () => activities.load(
        from: any(named: 'from'),
        to: any(named: 'to'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => changes.load(
        targetType: ScheduleTargetType.group,
        target: 'БСБО-43-24',
      ),
    ).thenAnswer((_) async {});
    when(() => classmates.load('БСБО-43-24')).thenAnswer((_) async {});
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleBloc>.value(value: schedule),
        BlocProvider<SchedulePreferencesCubit>.value(value: preferences),
        BlocProvider<ScheduleDisplayCubit>.value(value: display),
        BlocProvider<ScheduleChangesCubit>.value(value: changes),
        BlocProvider<UserActivitiesCubit>.value(value: activities),
        BlocProvider<ClassmatesCubit>.value(value: classmates),
        BlocProvider.value(value: comparison),
      ],
      child: Scaffold(
        body: ScheduleBody(now: fixedNow, initialView: view),
      ),
    );
  }

  testWidgets('clock refreshes the visible pager time and lesson status', (
    tester,
  ) async {
    var now = DateTime(2026, 9, 2, 9, 0, 30);
    await withClock(Clock(() => now), () async {
      await tester.pumpApp(subject(), size: const Size(390, 844));
      await tester.pumpAndSettle();
      final marker = find.byType(ScheduleNowLine);
      expect(tester.widget<ScheduleNowLine>(marker).label, '09:00');
      final lesson = find.byType(AppLessonRow);
      expect(tester.widget<AppLessonRow>(lesson).state, LessonRowState.current);
      final line = find.byKey(const ValueKey('schedule-now-line'));
      final initialLineTop = tester.getTopLeft(line).dy;
      now = DateTime(2026, 9, 2, 9, 1);
      await tester.pump(const Duration(seconds: 30));
      await tester.pumpAndSettle();
      expect(tester.widget<ScheduleNowLine>(marker).label, '09:01');
      expect(tester.widget<AppLessonRow>(lesson).progress, .5);
      expect(tester.getTopLeft(line).dy, greaterThan(initialLineTop));
      now = DateTime(2026, 9, 2, 9, 2);
      await tester.pump(const Duration(minutes: 1));
      await tester.pumpAndSettle();
      expect(tester.widget<ScheduleNowLine>(marker).label, '09:02');
      expect(tester.widget<AppLessonRow>(lesson).state, LessonRowState.past);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });
  });

  for (final view in [ScheduleView.week, ScheduleView.month]) {
    testWidgets('${view.name} refreshes time while another date is selected', (
      tester,
    ) async {
      var now = DateTime(2026, 9, 2, 9, 0, 30);
      await withClock(Clock(() => now), () async {
        await tester.pumpApp(subject(view: view), size: const Size(390, 844));
        await tester.pumpAndSettle();
        final otherDay = DateTime(2026, 9, 3);
        if (view == ScheduleView.week) {
          tester
              .widget<ScheduleWeekView>(find.byType(ScheduleWeekView))
              .onDay(otherDay);
        } else {
          tester
              .widget<ScheduleMonthView>(find.byType(ScheduleMonthView))
              .onMonth(otherDay);
        }
        await tester.pumpAndSettle();
        now = DateTime(2026, 9, 2, 9, 1);
        await tester.pump(const Duration(seconds: 30));
        await tester.pumpAndSettle();
        if (view == ScheduleView.week) {
          final page = tester.widget<ScheduleWeekView>(
            find.byType(ScheduleWeekView),
          );
          expect(page.day, otherDay);
          expect(page.now, now);
        } else {
          final page = tester.widget<ScheduleMonthView>(
            find.byType(ScheduleMonthView),
          );
          expect(page.day, otherDay);
          expect(page.now, now);
        }
        await tester.pumpWidget(const SizedBox());
        expect(tester.takeException(), isNull);
      });
    });
  }

  testWidgets('midnight refreshes today without changing the selected day', (
    tester,
  ) async {
    var now = DateTime(2026, 9, 2, 23, 59, 30);
    await withClock(Clock(() => now), () async {
      await tester.pumpApp(subject(), size: const Size(390, 844));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('schedule-today-button')), findsNothing);
      now = DateTime(2026, 9, 3);
      await tester.pump(const Duration(seconds: 30));
      await tester.pumpAndSettle();
      final page = tester.widget<ScheduleDayView>(find.byType(ScheduleDayView));
      expect(page.day, DateTime(2026, 9, 2));
      expect(page.now, now);
      expect(
        find.byKey(const ValueKey('schedule-today-button')),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('explicit time stays fixed while the clock advances', (
    tester,
  ) async {
    var now = DateTime(2026, 9, 2, 9);
    await withClock(Clock(() => now), () async {
      final fixedNow = now;
      await tester.pumpApp(
        subject(fixedNow: fixedNow),
        size: const Size(390, 844),
      );
      await tester.pumpAndSettle();
      now = now.add(const Duration(minutes: 2));
      await tester.pump(const Duration(minutes: 2));
      expect(
        tester.widget<ScheduleDayView>(find.byType(ScheduleDayView)).now,
        fixedNow,
      );
      expect(
        tester.widget<ScheduleNowLine>(find.byType(ScheduleNowLine)).label,
        '09:00',
      );
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });
  });
}
