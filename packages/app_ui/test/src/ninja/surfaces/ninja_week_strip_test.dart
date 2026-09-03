import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  final days = [
    const NinjaWeekDay('31', short: 'ПН', isPast: true),
    NinjaWeekDay('1', short: 'ВТ', isToday: true, dots: [kitColors.accent]),
    NinjaWeekDay('2', short: 'СР', dots: [kitColors.accent]),
    NinjaWeekDay('3', short: 'ЧТ', dots: [kitColors.accent]),
    NinjaWeekDay(
      '4',
      short: 'ПТ',
      dots: [kitColors.accent, kitColors.warn],
    ),
    NinjaWeekDay('5', short: 'СБ', isWeekend: true, dots: [kitColors.accent]),
    const NinjaWeekDay('6', short: 'ВС', isWeekend: true),
  ];

  AnimatedContainer pillOf(WidgetTester tester, String label) =>
      tester.widget<AnimatedContainer>(
        find.ancestor(
          of: find.text(label),
          matching: find.byType(AnimatedContainer),
        ),
      );

  group('NinjaWeekStrip', () {
    testWidgets('selected pill is accent on onAccent, 64px high', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(NinjaWeekStrip(days: days, selectedIndex: 2)),
      );

      final selected = pillOf(tester, '2');
      expect(selected.constraints?.minHeight, AppControlSize.dayPill);
      final decoration = selected.decoration! as BoxDecoration;
      expect(decoration.color, kitColors.accent);
      expect(decoration.borderRadius, BorderRadius.circular(AppRadius.lg));
      expect(kitStyleOf(tester, '2')?.color, kitColors.onAccent);
      expect(kitStyleOf(tester, '2')?.fontSize, 16);
      expect(kitStyleOf(tester, 'СР')?.fontSize, 10.5);
    });

    testWidgets('today keeps a 2px accent ring when not selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(NinjaWeekStrip(days: days, selectedIndex: 2)),
      );

      final today = pillOf(tester, '1').decoration! as BoxDecoration;
      expect(today.color, kitColors.surface);
      expect(today.border, Border.all(color: kitColors.accent, width: 2));
      expect(kitStyleOf(tester, '1')?.color, kitColors.ink);
    });

    testWidgets('past and weekend days read muted2', (tester) async {
      await tester.pumpWidget(
        wrapKit(NinjaWeekStrip(days: days, selectedIndex: 2)),
      );

      expect(kitStyleOf(tester, '31')?.color, kitColors.muted2);
      expect(kitStyleOf(tester, '5')?.color, kitColors.muted2);
      expect(kitStyleOf(tester, '3')?.color, kitColors.ink);
    });

    testWidgets('dots are 4px and retain their type colour when selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(NinjaWeekStrip(days: days, selectedIndex: 2)),
      );

      final dots = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .where(
            (box) =>
                box.child is SizedBox && (box.child! as SizedBox).width == 4,
          )
          .map((box) => (box.decoration as BoxDecoration).color)
          .toList();
      expect(dots, hasLength(6));
      expect(dots, contains(kitColors.accent));
      expect(dots, isNot(contains(kitColors.onAccent)));
      expect(dots, contains(kitColors.warn));
    });

    testWidgets('all lesson dots wrap inside a narrow selected pill', (
      tester,
    ) async {
      final marks = [
        kitColors.lecture,
        kitColors.practice,
        kitColors.lab,
        kitColors.exam,
        kitColors.ink,
        kitColors.lecture,
        kitColors.lab,
        kitColors.practice,
      ];
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 44,
            child: NinjaDayPill(
              selected: true,
              day: NinjaWeekDay('2', short: 'СР', dots: marks),
            ),
          ),
        ),
      );
      for (final (index, color) in marks.indexed) {
        final dot = tester.widget<DecoratedBox>(
          find.byKey(ValueKey('day-mark-$index')),
        );
        final decoration = dot.decoration as BoxDecoration;
        expect(decoration.color, color);
        expect(decoration.border, isNotNull);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('reports taps with the index', (tester) async {
      int? picked;
      await tester.pumpWidget(
        wrapKit(
          NinjaWeekStrip(
            days: days,
            selectedIndex: 2,
            onSelected: (index) => picked = index,
          ),
        ),
      );

      await tester.tap(find.text('4'));
      expect(picked, 4);
    });

    testWidgets('dense pills use r12 and 14px numbers', (tester) async {
      await tester.pumpWidget(
        wrapKit(NinjaWeekStrip(days: days, selectedIndex: 0, dense: true)),
      );

      final pill = pillOf(tester, '3').decoration! as BoxDecoration;
      expect(pill.borderRadius, BorderRadius.circular(12));
      expect(kitStyleOf(tester, '3')?.fontSize, 14);
      expect(kitStyleOf(tester, 'ЧТ')?.fontSize, 9.5);
    });

    test('App aliases point at the Ninja widgets', () {
      expect(AppWeekStrip, NinjaWeekStrip);
      expect(AppDayPill, NinjaDayPill);
      expect(AppWeekDay, NinjaWeekDay);
    });
  });

  group('NinjaNowLine', () {
    testWidgets('renders a danger 10.5/800 label, 2px line and 8px dot', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(width: 320, child: NinjaNowLine(label: '11:22')),
        ),
      );

      final style = kitStyleOf(tester, '11:22');
      expect(style?.fontSize, 10.5);
      expect(style?.fontWeight, FontWeight.w800);
      expect(style?.color, kitColors.danger);
      expect(style?.fontFeatures, contains(const FontFeature.tabularFigures()));

      final line = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(NinjaNowLine),
          matching: find.byWidgetPredicate(
            (widget) => widget is SizedBox && widget.height == 2,
          ),
        ),
      );
      expect((line.child! as ColoredBox).color, kitColors.danger);
      final lineSize = tester.getSize(find.byWidget(line));
      expect(lineSize.width, greaterThan(200));
      expect(lineSize.height, 2);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.width == 8 && widget.height == 8,
        ),
        findsOneWidget,
      );
    });

    testWidgets('onCanvas pads the label on a canvas chip', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 320,
            child: NinjaNowLine(label: '11:22', onCanvas: true),
          ),
        ),
      );

      final chip = kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(NinjaNowLine),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(chip.color, kitColors.canvas);
      expect(AppNowLine, NinjaNowLine);
    });
  });

  group('NinjaGapRow', () {
    testWidgets('prints 12/600 muted2 copy between two 1px rules', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 320,
            child: NinjaGapRow(text: 'перерыв 30 мин'),
          ),
        ),
      );

      final style = kitStyleOf(tester, 'перерыв 30 мин');
      expect(style?.fontSize, 12);
      expect(style?.fontWeight, FontWeight.w600);
      expect(style?.color, kitColors.muted2);
      final rules = tester.widgetList<SizedBox>(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 1,
        ),
      );
      expect(rules, hasLength(2));
      expect(AppGapRow, NinjaGapRow);
    });
  });

  group('NinjaDisplayHeader', () {
    testWidgets('renders a serif display title with muted summary', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 360,
            child: NinjaDisplayHeader(
              title: 'Среда, 13 августа',
              summary: '4 пары · 2 корпуса',
              overline: 'расписание',
            ),
          ),
        ),
      );

      final title = kitStyleOf(tester, 'Среда, 13 августа');
      expect(title?.fontSize, 34);
      expect(title?.fontFamily, AppText.serifFamily);
      final summary = kitStyleOf(tester, '4 пары · 2 корпуса');
      expect(summary?.fontSize, 13);
      expect(summary?.color, kitColors.muted);
      expect(find.text('РАСПИСАНИЕ'), findsOneWidget);
    });
  });
}
