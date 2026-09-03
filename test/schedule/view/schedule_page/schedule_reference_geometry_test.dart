import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_view_transition.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_view.dart';

import '../../../gallery/gallery_fonts.dart';
import '../../../gallery/schedule_gallery.dart';
import '../../../helpers/pump_app.dart';

void main() {
  setUpAll(loadGalleryFonts);
  testWidgets('materials add action opens upload without a navigation detour', (
    tester,
  ) async {
    await tester.pumpApp(lessonGalleryScene(), size: const Size(390, 844));
    await tester.pumpAndSettle();
    final add = find.text('добавить').first;
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pumpAndSettle();
    expect(find.byType(AppSheet), findsOneWidget);
    expect(find.byType(AppInputField), findsOneWidget);
    expect(find.byType(LessonMaterialsPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('lesson reference badge and actions retain source geometry', (
    tester,
  ) async {
    await tester.pumpApp(lessonGalleryScene(), size: const Size(390, 844));
    await tester.pumpAndSettle();
    final badge = find.byKey(const ValueKey('lesson-type-badge'));
    final widget = tester.widget<AppBadge>(badge);
    expect(
      widget.padding,
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
    expect(widget.textStyle?.fontSize, 12);
    expect(widget.textStyle?.fontWeight, FontWeight.w700);
    expect(tester.getSize(badge).height, closeTo(27.6, .5));
    final actions = find.byWidgetPredicate(
      (widget) => widget is AppCard && widget.semanticsLabel == 'Напомнить',
    );
    expect(actions, findsOneWidget);
    expect(tester.getSize(actions).height, closeTo(74, .5));
    expect(tester.getSize(actions).width, closeTo(81.5, .5));
    expect(find.text('Вторник, 1 сентября'), findsOneWidget);
    expect(find.text('В-78 · на карте'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'week compare action and legend use source sizes and semantic colors',
    (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ScheduleWeekView(
                day: scheduleGalleryNow,
                now: scheduleGalleryNow,
                schedule: scheduleGalleryLessons(),
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
      final button = find.byWidgetPredicate(
        (widget) => widget is AppButton && widget.label == 'Сравнить с другом',
      );
      expect(tester.getSize(button).height, 44);
      expect(
        tester.widget<AppButton>(button).backgroundColor,
        AppColors.light.surface,
      );
      for (final label in ['Лекция', 'Практика', 'Лаба', 'Отмена']) {
        expect(
          tester.getSize(find.byKey(ValueKey('schedule-legend-$label'))),
          const Size(10, 10),
        );
      }
      final today = tester
          .widgetList<AppDayPill>(find.byType(AppDayPill))
          .where((pill) => pill.day.isToday);
      expect(today.single.day.label, '1');
      final firstCell = find.byType(AppWeekGridCell).first;
      expect(tester.getTopLeft(firstCell).dx, closeTo(72, .1));
      expect(tester.getSize(firstCell).width, closeTo(44 + 1 / 3, .1));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'current time marker stays above lesson text and has a visible line',
    (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ScheduleViewTransition(
                child: ScheduleDayView(
                  day: scheduleGalleryNow,
                  now: scheduleGalleryNow,
                  schedule: scheduleGalleryLessons(),
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
        ),
        size: const Size(390, 1000),
      );
      final marker = find.byKey(const ValueKey('schedule-now-line'));
      expect(
        find.descendant(
          of: find.byType(ScheduleViewTransition),
          matching: find.byType(SizeTransition),
        ),
        findsNothing,
      );
      expect(tester.getSize(marker).width, greaterThan(200));
      expect(tester.getSize(marker).height, 2);
      final markerStacks = tester
          .widgetList<Stack>(
            find.ancestor(of: marker, matching: find.byType(Stack)),
          )
          .take(2);
      expect(
        markerStacks.map((stack) => stack.clipBehavior),
        everyElement(Clip.none),
      );
      final title = find.text('Программирование на Python');
      expect(
        tester.getRect(marker).bottom,
        lessThan(tester.getRect(title).top),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
