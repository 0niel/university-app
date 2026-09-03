import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_overlap_switcher.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

void main() {
  final day = DateTime(2030, 9, 2);
  final config = UniversityConfig(
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
      for (var hour = 9; hour <= 14; hour++)
        LessonBellSlotConfig(
          startMinutes: hour * 60,
          endMinutes: (hour + 1) * 60,
        ),
    ],
  );

  CalendarSchedulePart event(String title, int start, int end) =>
      CalendarSchedulePart(
        title: title,
        dates: [day],
        startsAt: day.add(Duration(minutes: start)),
        endsAt: day.add(Duration(minutes: end)),
      );

  UserActivity activity(String title, int start, int end) => UserActivity(
    id: title,
    type: UserActivityType.personal,
    title: title,
    startsAt: day.add(Duration(minutes: start)),
    endsAt: day.add(Duration(minutes: end)),
  );

  Future<void> open(
    WidgetTester tester, {
    List<SchedulePart> mine = const [],
    List<UserActivity> mineActivities = const [],
    List<SchedulePart> friend = const [],
    List<UserActivity> friendActivities = const [],
  }) => tester.pumpApp(
    RepositoryProvider<UniversityConfig>.value(
      value: config,
      child: Scaffold(
        body: SingleChildScrollView(
          child: ScheduleWeekView(
            day: day,
            now: day,
            schedule: mine,
            changes: const [],
            preferences: const SchedulePreferencesState(),
            display: const ScheduleDisplayState(),
            activities: mineActivities,
            friend: SelectedGroupSchedule(
              group: const Group(name: 'FRIEND'),
              schedule: friend,
            ),
            friendActivities: friendActivities,
            onDay: (_) {},
          ),
        ),
      ),
    ),
    size: const Size(900, 2200),
  );

  Finder cell(DateTime date, int start) => find.byKey(
    ValueKey('week-cell-${date.toIso8601String()}-$start'),
  );

  Iterable<AppWeekGridCell> contents(
    WidgetTester tester,
    DateTime date,
    int start,
  ) => tester.widgetList<AppWeekGridCell>(
    find.descendant(
      of: cell(date, start),
      matching: find.byType(AppWeekGridCell),
    ),
  );

  testWidgets(
    'mixed friend occupancy suppresses false checks and keeps overlaps',
    (
      tester,
    ) async {
      await open(
        tester,
        mine: [
          scheduleTestLesson(
            day: day,
            end: 600,
            subject: 'PE',
            type: .physicalEducation,
          ),
          scheduleTestLesson(
            day: day,
            end: 600,
            subject: 'Credit',
            type: .credit,
          ),
          scheduleTestLesson(day: day, start: 600, end: 660),
          scheduleTestLesson(day: day, start: 660, end: 720),
          event('Own event', 720, 780),
        ],
        mineActivities: [activity('Own activity', 780, 840)],
        friend: [
          event('Friend event', 555, 585),
          event('Friend event overlap', 735, 765),
          scheduleTestLesson(
            day: day,
            start: 840,
            end: 900,
            type: .consultation,
          ),
        ],
        friendActivities: [
          activity('Friend personal', 615, 645),
          activity('Friend personal overlap', 795, 825),
        ],
      );
      for (final start in [540, 600, 720, 780]) {
        expect(
          contents(
            tester,
            day,
            start,
          ).any((entry) => entry.bottomLabel?.contains('✓') ?? false),
          isFalse,
        );
      }
      expect(contents(tester, day, 660).single.bottomLabel, contains('✓'));
      expect(
        contents(tester, day, 840).single.variant,
        AppWeekGridCellVariant.busy,
      );
      final overlap = tester.widget<ScheduleOverlapSwitcher>(
        find.descendant(
          of: cell(day, 540),
          matching: find.byType(ScheduleOverlapSwitcher),
        ),
      );
      expect(overlap.labels, ['PE', 'Credit']);
      await tester.tap(
        find.descendant(
          of: cell(day, 540),
          matching: find.byKey(const ValueKey('schedule-overlap-next')),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        contents(tester, day, 540).single.bottomLabel,
        isNot(contains('✓')),
      );
      expect(find.text('Own event'), findsOneWidget);
      expect(find.text('Own activity'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'friend overnight events and activities retain Sunday and extra rows',
    (
      tester,
    ) async {
      final saturday = day.add(const Duration(days: 5));
      final sunday = day.add(const Duration(days: 6));
      await open(
        tester,
        friend: [
          CalendarSchedulePart(
            title: 'Overnight',
            dates: [saturday],
            startsAt: saturday.add(const Duration(hours: 23)),
            endsAt: sunday.add(const Duration(hours: 1)),
          ),
        ],
        friendActivities: [
          UserActivity(
            id: 'early',
            type: .retake,
            title: 'Early retake',
            startsAt: sunday.add(const Duration(hours: 6)),
            endsAt: sunday.add(const Duration(hours: 7)),
          ),
        ],
      );
      expect(find.byType(AppDayPill), findsNWidgets(7));
      expect(
        contents(tester, saturday, 1380).single.variant,
        AppWeekGridCellVariant.busy,
      );
      expect(
        contents(tester, sunday, 0).single.variant,
        AppWeekGridCellVariant.busy,
      );
      expect(
        contents(tester, sunday, 360).single.variant,
        AppWeekGridCellVariant.busy,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'incomplete times stay visible without invented rows or free checks',
    (
      tester,
    ) async {
      await open(
        tester,
        mine: [
          scheduleTestLesson(day: day, end: 600),
          scheduleTestLesson(day: day, start: 1140, end: 1200),
          CalendarSchedulePart(
            title: 'Own start only',
            dates: [day],
            startsAt: day.add(const Duration(hours: 22)),
          ),
        ],
        mineActivities: [
          UserActivity(
            id: 'unknown',
            type: .personal,
            title: 'Own early start only',
            startsAt: day.add(const Duration(hours: 6)),
          ),
        ],
        friend: [
          CalendarSchedulePart(
            title: 'Friend start only',
            dates: [day],
            startsAt: day.add(const Duration(hours: 18)),
          ),
        ],
      );
      expect(contents(tester, day, 540).single.bottomLabel, contains('✓'));
      expect(
        contents(tester, day, 1140).single.bottomLabel,
        isNot(contains('✓')),
      );
      expect(find.textContaining('Friend start only'), findsOneWidget);
      expect(find.textContaining('Own start only'), findsOneWidget);
      expect(find.textContaining('Own early start only'), findsOneWidget);
      expect(cell(day, 360), findsNothing);
      expect(cell(day, 1080), findsNothing);
      expect(cell(day, 1320), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
