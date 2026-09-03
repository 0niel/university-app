import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_calendar_notice.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_month_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

void main() {
  final day = DateTime(2026, 9, 2);
  final activity = UserActivity(
    id: 'own',
    type: UserActivityType.personal,
    title: 'Утренняя встреча',
    startsAt: day.add(const Duration(hours: 6)),
    endsAt: day.add(const Duration(hours: 7)),
  );
  final event = CalendarSchedulePart(
    title: 'Поздний семинар',
    dates: [day],
    startsAt: day.add(const Duration(hours: 22)),
    endsAt: day.add(const Duration(hours: 23)),
  );
  final holiday = HolidaySchedulePart(title: 'День университета', dates: [day]);

  testWidgets('calendar retains transferred workdays and coverage warnings', (
    tester,
  ) async {
    final transferred = DateTime(2025, 11);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: ScheduleMonthView(
            day: transferred,
            now: transferred,
            schedule: const [],
            preferences: const SchedulePreferencesState(),
            onDay: (_) {},
            onMonth: (_) {},
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    final cell = find.byKey(const ValueKey('schedule-month-day-1'));
    expect(
      tester.getSemantics(cell).getSemanticsData().label,
      contains('Рабочий день по переносу'),
    );
    await tester.pumpApp(
      Scaffold(body: ScheduleCalendarNotice(day: DateTime(2099, 9, 2))),
    );
    expect(find.byType(AppBanner), findsOneWidget);
    expect(find.textContaining('2099'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('overnight activity retains the Sunday column and midnight row', (
    tester,
  ) async {
    final overnight = activity.copyWith(
      startsAt: DateTime(2026, 9, 5, 23),
      endsAt: DateTime(2026, 9, 6, 1),
    );
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: ScheduleWeekView(
            day: day,
            now: day,
            schedule: const [],
            changes: const [],
            preferences: const SchedulePreferencesState(),
            display: const ScheduleDisplayState(),
            activities: [overnight],
            onDay: (_) {},
          ),
        ),
      ),
      size: const Size(390, 1400),
    );
    expect(find.byType(AppDayPill), findsNWidgets(7));
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('23:00'), findsOneWidget);
    expect(find.text(activity.title), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'month retains ongoing and all-day events without explicit ends',
    (tester) async {
      final active = event.copyWith(
        startsAt: day.add(const Duration(hours: 10)),
        endsAt: null,
      );
      final allDay = event.copyWith(
        title: 'Выставка',
        startsAt: day,
        endsAt: null,
        isAllDay: true,
      );
      await tester.pumpApp(
        Scaffold(
          body: SingleChildScrollView(
            child: ScheduleMonthView(
              day: day,
              now: day.add(const Duration(hours: 10, minutes: 15)),
              schedule: [active, allDay],
              preferences: const SchedulePreferencesState(),
              display: const ScheduleDisplayState(showPast: false),
              onDay: (_) {},
              onMonth: (_) {},
            ),
          ),
        ),
        size: const Size(390, 844),
      );
      final cell = find.byKey(const ValueKey('schedule-month-day-2'));
      expect(
        find.descendant(of: cell, matching: find.byType(AppDot)),
        findsNWidgets(2),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('week keeps out-of-grid lessons, events and holidays', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: 350,
            child: ScheduleWeekView(
              day: day,
              now: day,
              schedule: [
                scheduleTestLesson(day: day, start: 420, end: 500),
                scheduleTestLesson(day: day, start: 631, end: 639),
                scheduleTestLesson(day: day, start: 1290, end: 1350),
                event,
                holiday,
              ],
              changes: const [],
              preferences: const SchedulePreferencesState(),
              display: const ScheduleDisplayState(),
              activities: [activity],
              onDay: (_) {},
            ),
          ),
        ),
      ),
      size: const Size(390, 1600),
    );
    expect(
      tester
          .widgetList<AppWeekGridCell>(find.byType(AppWeekGridCell))
          .where((cell) => cell.bottomLabel == 'А-101'),
      hasLength(3),
    );
    expect(find.text(activity.title), findsOneWidget);
    expect(find.text(event.title), findsWidgets);
    expect(find.textContaining(holiday.title), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('week uses configured bells, not default university times', (
    tester,
  ) async {
    const config = UniversityConfig(
      organizationId: 'test',
      appName: 'University',
      universityName: 'University',
      universityShortName: 'University',
      websiteUrl: 'https://example.test',
      supportEmail: 'support@example.test',
      deepLinkScheme: 'university',
      webAppHost: 'example.test',
      webAppPathPrefix: '/',
      lessonBellSlots: [
        LessonBellSlotConfig(startMinutes: 480, endMinutes: 550),
      ],
    );
    await tester.pumpApp(
      RepositoryProvider<UniversityConfig>.value(
        value: config,
        child: Scaffold(
          body: SingleChildScrollView(
            child: ScheduleWeekView(
              day: day,
              now: day,
              schedule: const [],
              changes: const [],
              preferences: const SchedulePreferencesState(),
              display: const ScheduleDisplayState(),
              activities: const [],
              onDay: (_) {},
            ),
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    expect(find.text('08:00'), findsOneWidget);
    expect(find.text('09:00'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('month marks events and keeps holidays in date semantics', (
    tester,
  ) async {
    DateTime? selected;
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: ScheduleMonthView(
            day: day,
            now: day,
            schedule: [event, holiday],
            activities: [activity],
            preferences: const SchedulePreferencesState(),
            onDay: (date) => selected = date,
            onMonth: (_) {},
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    final cell = find.byKey(const ValueKey('schedule-month-day-2'));
    expect(
      find.descendant(of: cell, matching: find.byType(AppDot)),
      findsNWidgets(2),
    );
    final semantics = tester.getSemantics(cell).getSemanticsData();
    expect(semantics.label, contains(activity.title));
    expect(semantics.label, contains(event.title));
    expect(semantics.label, contains(holiday.title));
    await tester.tap(cell);
    expect(selected, day);
    expect(tester.takeException(), isNull);
  });
}
