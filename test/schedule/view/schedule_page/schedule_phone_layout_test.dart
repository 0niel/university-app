import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_header.dart';

import '../../../gallery/gallery_fonts.dart';
import '../../../helpers/pump_app.dart';

void main() {
  setUpAll(loadGalleryFonts);

  for (final width in [320.0, 360.0, 390.0, 430.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('group stays on one line at $width and $scale text', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        await tester.pumpApp(
          Scaffold(
            body: ScheduleHeader(
              day: DateTime(2026, 9, 4),
              name: 'БСБО-43-24',
              nameSemanticsLabel: 'Расписание группы БСБО-43-24',
            ),
          ),
          size: Size(width, 844),
          textScaler: TextScaler.linear(scale),
        );

        final group = find.text('БСБО-43-24');
        final paragraph = tester.renderObject<RenderParagraph>(group);
        final lines = paragraph.getBoxesForSelection(
          const TextSelection(baseOffset: 0, extentOffset: 10),
        );
        expect(lines.map((line) => line.top).toSet(), hasLength(1));
        expect(paragraph.didExceedMaxLines, isFalse);
        final fitted = find.ancestor(
          of: group,
          matching: find.byType(FittedBox),
        );
        final button = find.ancestor(
          of: group,
          matching: find.byType(AppPressable),
        );
        expect(
          tester.getRect(button).contains(tester.getRect(fitted).center),
          isTrue,
        );
        expect(tester.getSize(button).height, greaterThanOrEqualTo(44));
        expect(
          find.bySemanticsLabel('Расписание группы БСБО-43-24'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        semantics.dispose();
      });

      testWidgets('day navigation stays compact at $width and $scale text', (
        tester,
      ) async {
        final day = DateTime(2026, 9, 4);
        final now = DateTime(2026, 9, 5);
        final selected = <DateTime>[];
        await tester.pumpApp(
          Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ScheduleDayView(
                  day: day,
                  now: now,
                  schedule: const [],
                  changes: const [],
                  preferences: const SchedulePreferencesState(),
                  display: const ScheduleDisplayState(),
                  activities: const [],
                  comparing: false,
                  showDayStrip: false,
                  onDay: selected.add,
                ),
              ),
            ),
          ),
          size: Size(width, 844),
          textScaler: TextScaler.linear(scale),
        );

        final buttons = [
          for (final label in ['← нед', 'сегодня', 'нед →'])
            find.byWidgetPredicate(
              (widget) =>
                  widget is AppPressable && widget.semanticsLabel == label,
            ),
        ];
        final rects = buttons.map(tester.getRect).toList();
        for (final rect in rects) {
          expect(rect.height, greaterThanOrEqualTo(44));
          expect(rect.width, greaterThanOrEqualTo(44));
          expect(rect.width, lessThan((width - 40) / 2));
          expect(rect.left, greaterThanOrEqualTo(20));
          expect(rect.right, lessThanOrEqualTo(width - 20));
        }
        expect(rects[0].top, rects[1].top);
        if (scale == 1) expect(rects[0].top, rects[2].top);
        expect(rects.last.bottom - rects.first.top, lessThanOrEqualTo(88));
        for (final button in buttons) {
          await tester.tap(button);
          await tester.pumpAndSettle();
        }
        expect(selected, [
          day.subtract(const Duration(days: 7)),
          now,
          day.add(const Duration(days: 7)),
        ]);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
