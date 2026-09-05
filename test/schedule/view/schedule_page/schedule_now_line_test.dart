import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';

import '../../../gallery/gallery_fonts.dart';
import '../../../gallery/schedule_gallery.dart';
import '../../../helpers/pump_app.dart';

void main() {
  setUpAll(loadGalleryFonts);

  Widget subject(DateTime now) => Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ScheduleDayView(
          day: DateTime(2026, 9),
          now: now,
          schedule: scheduleGalleryLessons(),
          changes: const [],
          preferences: const SchedulePreferencesState(),
          display: const ScheduleDisplayState(),
          activities: const [],
          comparing: false,
          showDayStrip: false,
          onDay: (_) {},
        ),
      ),
    ),
  );

  testWidgets('time marker moves through the current lesson as time passes', (
    tester,
  ) async {
    final marker = find.byKey(const ValueKey('schedule-now-line'));
    final lesson = find.byWidgetPredicate(
      (widget) =>
          widget is AppLessonRow &&
          widget.title == 'Программирование на Python',
    );
    await tester.pumpApp(
      subject(DateTime(2026, 9, 1, 11)),
      size: const Size(390, 1000),
    );
    await tester.pumpAndSettle();
    final first = tester.getCenter(marker).dy;
    final bounds = tester.getRect(lesson);
    expect(find.text('11:00'), findsOneWidget);
    expect(first, greaterThan(bounds.top));
    expect(first, lessThan(bounds.bottom));

    await tester.pumpApp(
      subject(DateTime(2026, 9, 1, 11, 30)),
      size: const Size(390, 1000),
    );
    await tester.pumpAndSettle();
    final second = tester.getCenter(marker).dy;
    expect(find.text('11:30'), findsOneWidget);
    expect(find.text('11:00'), findsNothing);
    expect(second, greaterThan(first + 20));
    expect(second, lessThan(tester.getRect(lesson).bottom));
    expect(
      find.ancestor(of: marker, matching: find.byType(IgnorePointer)),
      findsWidgets,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('time marker advances after a lesson and hides on other days', (
    tester,
  ) async {
    final marker = find.byKey(const ValueKey('schedule-now-line'));
    await tester.pumpApp(
      subject(DateTime(2026, 9, 1, 12, 10)),
      size: const Size(390, 1000),
    );
    await tester.pumpAndSettle();
    final finished = find.byWidgetPredicate(
      (widget) =>
          widget is AppLessonRow &&
          widget.title == 'Программирование на Python',
    );
    expect(
      tester.getCenter(marker).dy,
      greaterThan(tester.getRect(finished).bottom),
    );
    await tester.pumpApp(
      subject(DateTime(2026, 9, 2, 12)),
      size: const Size(390, 1000),
    );
    await tester.pumpAndSettle();
    expect(marker, findsNothing);
    expect(tester.takeException(), isNull);
  });
}
