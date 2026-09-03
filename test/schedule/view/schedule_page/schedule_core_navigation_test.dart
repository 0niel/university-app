import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_date_pager.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_strip.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_month_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_paging.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../gallery/schedule_gallery.dart';
import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

void main() {
  for (final topInset in [0.0, 43.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'day strip keeps reference gap and safe pinning at $topInset / $scale',
        (tester) async {
          tester.view.padding = FakeViewPadding(top: topInset);
          await tester.pumpApp(
            scheduleGalleryScene(),
            size: const Size(390, 844),
            textScaler: TextScaler.linear(scale),
          );
          await tester.pumpAndSettle();
          final strip = find.byKey(const ValueKey('schedule-day-strip'));
          final modes = find.byType(AppSegmentedControl<ScheduleView>);
          expect(
            tester.getTopLeft(strip).dy - tester.getBottomLeft(modes).dy,
            closeTo(AppSpacing.lg, 1),
          );
          await tester.drag(
            find.byType(NestedScrollView),
            const Offset(0, -1000),
          );
          await tester.pumpAndSettle();
          expect(
            tester
                .getTopLeft(
                  find.byKey(const ValueKey('schedule-pinned-days')),
                )
                .dy,
            closeTo(topInset, 1),
          );
        },
      );
    }
  }

  testWidgets('landscape notch stays outside day and month controls', (
    tester,
  ) async {
    tester.view.padding = const FakeViewPadding(left: 43);
    await tester.pumpApp(
      scheduleGalleryScene(),
      size: const Size(844, 390),
    );
    await tester.pumpAndSettle();
    final modes = find.byType(AppSegmentedControl<ScheduleView>);
    expect(tester.getTopLeft(modes).dx, closeTo(43 + AppSpacing.screen, 1));
    expect(
      tester.getBottomRight(modes).dx,
      closeTo(844 - AppSpacing.screen, 1),
    );
    await tester.drag(find.byType(NestedScrollView), const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.ensureVisible(modes);
    await tester.tap(find.text('Месяц').first);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(NestedScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('schedule-pinned-days')), findsNothing);
    expect(
      tester.widget<ScheduleMonthView>(find.byType(ScheduleMonthView)).day,
      DateUtils.dateOnly(scheduleGalleryNow),
    );
    expect(tester.takeException(), isNull);
  });

  for (final view in ScheduleView.values) {
    testWidgets('${view.name} uses a draggable page viewport', (tester) async {
      final anchor = DateTime(2026, 1, 31);
      var selected = anchor;
      late VoidCallback rebuild;
      await tester.pumpApp(
        Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              rebuild = () => setState(() {});
              return ScheduleDatePager(
                day: selected,
                anchor: anchor,
                view: view,
                onDay: (day) => setState(() => selected = day),
                builder: (_, day) => SizedBox(
                  height: 400,
                  child: Text(day.toIso8601String()),
                ),
              );
            },
          ),
        ),
        size: const Size(390, 844),
      );
      final pager = find.byType(PageView);
      final controller = tester.widget<PageView>(pager).controller!;
      final initial = controller.page!;
      final gesture = await tester.startGesture(tester.getCenter(pager));
      await gesture.moveBy(const Offset(-30, 0));
      await tester.pump();
      await gesture.moveBy(const Offset(-150, 0));
      await tester.pump();
      expect(controller.page, greaterThan(initial));
      expect(controller.page, lessThan(initial + 1));
      await gesture.moveBy(const Offset(-180, 0));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(selected, switch (view) {
        ScheduleView.day => DateTime(2026, 2),
        ScheduleView.week => DateTime(2026, 2, 7),
        ScheduleView.month => DateTime(2026, 2, 28),
      });
      if (view == ScheduleView.month) {
        rebuild();
        await tester.pumpAndSettle();
        await tester.drag(pager, const Offset(-330, 0));
        await tester.pumpAndSettle();
        expect(selected, DateTime(2026, 3, 31));
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'interrupting a programmatic page move restores the actual date',
    (
      tester,
    ) async {
      final anchor = DateTime(2026);
      var selected = anchor;
      late ValueChanged<DateTime> select;
      await tester.pumpApp(
        Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              select = (day) => setState(() => selected = day);
              return ScheduleDatePager(
                day: selected,
                anchor: anchor,
                view: ScheduleView.day,
                onDay: select,
                builder: (_, day) => SizedBox(
                  height: 400,
                  child: Text(day.toIso8601String()),
                ),
              );
            },
          ),
        ),
        size: const Size(390, 844),
      );
      final pager = find.byType(PageView);
      final controller = tester.widget<PageView>(pager).controller!;
      select(anchor.add(const Duration(days: 3)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));
      final gesture = await tester.startGesture(tester.getCenter(pager));
      await gesture.moveBy(const Offset(30, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(
        selected,
        SchedulePaging(today: anchor).dayOfPage(controller.page!.round()),
      );
      expect(selected, isNot(anchor.add(const Duration(days: 3))));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('switching views ignores the outgoing pager settlement', (
    tester,
  ) async {
    await tester.pumpApp(scheduleGalleryScene(), size: const Size(390, 844));
    await tester.pumpAndSettle();
    final pager = tester.widget<PageView>(find.byType(PageView));
    final controller = pager.controller!;
    final animation = controller.animateToPage(
      controller.page!.round() + 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Месяц').first);
    await tester.pumpAndSettle();
    await animation;
    expect(
      tester.widget<ScheduleMonthView>(find.byType(ScheduleMonthView)).day,
      DateUtils.dateOnly(scheduleGalleryNow),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the day strip pins while screen chrome scrolls away', (
    tester,
  ) async {
    await tester.pumpApp(scheduleGalleryScene(), size: const Size(390, 844));
    await tester.pumpAndSettle();
    final strip = find.byKey(const ValueKey('schedule-pinned-days'));
    final initialTop = tester.getTopLeft(strip).dy;
    await tester.drag(find.byType(PageView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(strip).dy, lessThan(initialTop));
    expect(tester.getTopLeft(strip).dy, closeTo(0, 1));
    expect(find.byKey(const ValueKey('schedule-more')), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is AppFab && widget.icon == AppLineIcon.plus,
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'settings contains retained tools without direct-action duplicates',
    (
      tester,
    ) async {
      await tester.pumpApp(scheduleGalleryScene(), size: const Size(390, 844));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Фильтры'));
      await tester.pumpAndSettle();
      for (final action in [
        'addLesson',
        'customSchedules',
        'session',
        'compare',
        'analytics',
      ]) {
        expect(find.byKey(ValueKey('schedule-action-$action')), findsOneWidget);
      }
      for (final action in [
        'search',
        'schedules',
        'changes',
        'export',
        'filters',
      ]) {
        expect(find.byKey(ValueKey('schedule-action-$action')), findsNothing);
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'pills show every visible type and no holiday or hidden lesson dot',
    (tester) async {
      final day = DateTime(2026, 9, 2);
      final lessons = [
        for (final type in LessonType.values)
          scheduleTestLesson(day: day, subject: type.name, type: type),
      ];
      await tester.pumpApp(
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: ScheduleDayStrip(
              day: day,
              now: day,
              schedule: [
                ...lessons,
                HolidaySchedulePart(
                  title: 'Holiday',
                  dates: [day.add(const Duration(days: 1))],
                ),
              ],
              preferences: const SchedulePreferencesState(showLectures: false),
              display: const ScheduleDisplayState(),
              changes: const [],
              onDay: (_) {},
            ),
          ),
        ),
        size: const Size(320, 844),
        textScaler: const TextScaler.linear(2),
      );
      final strip = tester.widget<AppWeekStrip>(find.byType(AppWeekStrip));
      final marks = strip.days[day.weekday - 1].dots;
      expect(marks, hasLength(LessonType.values.length - 1));
      expect(strip.days[day.weekday].dots, isEmpty);
      expect(marks.toSet().length, greaterThan(3));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'simultaneous lessons can be switched without hiding their types',
    (tester) async {
      final day = DateTime(2026, 9, 2);
      await tester.pumpApp(
        Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ScheduleDayView(
                day: day,
                now: day,
                schedule: [
                  scheduleTestLesson(subject: 'Лекция A'),
                  scheduleTestLesson(
                    subject: 'Практика B',
                    type: LessonType.practice,
                  ),
                ],
                changes: const [],
                preferences: const SchedulePreferencesState(),
                display: const ScheduleDisplayState(),
                activities: const [],
                comparing: false,
                onDay: (_) {},
              ),
            ),
          ),
        ),
        size: const Size(390, 844),
      );
      expect(find.text('Лекция A'), findsOneWidget);
      expect(find.text('Практика B'), findsNothing);
      final next = find.byKey(const ValueKey('schedule-overlap-next'));
      expect(tester.getSize(next).height, greaterThanOrEqualTo(44));
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(find.text('Практика B'), findsOneWidget);
      expect(find.text('ПРАК'), findsOneWidget);
      expect(find.text('2/2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'month chart includes every lesson type and unknown never means own',
    (tester) async {
      final lessons = [
        for (final type in LessonType.values) scheduleTestLesson(type: type),
      ];
      await tester.pumpApp(
        Scaffold(body: ScheduleMonthTypeChart(lessons: lessons)),
        size: const Size(320, 844),
        textScaler: const TextScaler.linear(2),
      );
      final chart = tester.widget<AppSegmentedBar>(
        find.byKey(const ValueKey('schedule-month-type-chart')),
      );
      expect(chart.segments, hasLength(LessonType.values.length));
      expect(chart.segments.map((part) => part.flex), everyElement(1));
      final context = tester.element(find.byType(ScheduleMonthTypeChart));
      for (final type in LessonType.values) {
        expect(lessonShortLabel(context.l10n, type), isNot('СВОЁ'));
        expect(
          find.byKey(ValueKey('schedule-month-type-${type.name}')),
          findsOneWidget,
        );
      }
      expect(tester.takeException(), isNull);
    },
  );
}
