import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: SizedBox(width: 400, child: child)),
      );

  group('NinjaListCell', () {
    testWidgets('renders title, trailing label and chevron without borders', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          NinjaListCell(
            title: 'Справка об обучении',
            trailingLabel: '1 день',
            onTap: () => taps++,
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('Справка об обучении')).style;
      expect(title?.fontSize, 13.5);
      expect(title?.fontWeight, FontWeight.w500);

      final trailing = tester.widget<Text>(find.text('1 день')).style;
      expect(trailing?.fontSize, 12.5);
      expect(trailing?.color, colors.muted);

      expect(find.byType(NinjaGlyphIcon), findsOneWidget);

      expect(
        find.descendant(
          of: find.byType(NinjaListCell),
          matching: find.byType(DecoratedBox),
        ),
        findsNothing,
      );

      await tester.tap(find.text('Справка об обучении'));
      expect(taps, 1);
    });

    testWidgets('hides the divider when asked', (tester) async {
      await tester.pumpWidget(
        wrap(const NinjaListCell(title: 'Без разделителя', showDivider: false)),
      );

      expect(
        find.descendant(
          of: find.byType(NinjaListCell),
          matching: find.byType(DecoratedBox),
        ),
        findsNothing,
      );
    });

    testWidgets('subject variant stacks title, time and meta', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaListCell.subject(
            title: 'Матанализ',
            time: '10:15–11:45',
            meta: 'лекция · 314 Б',
            color: Color(0xFF4F46E5),
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('Матанализ')).style;
      expect(title?.fontSize, 14);
      expect(title?.fontWeight, FontWeight.w600);
      expect(
        tester.widget<Text>(find.text('10:15–11:45')).style?.fontSize,
        12,
      );
      expect(
        tester.widget<Text>(find.text('лекция · 314 Б')).style?.color,
        colors.muted,
      );

      final bar = tester.widget<PositionedDirectional>(
        find.byType(PositionedDirectional),
      );
      expect(bar.width, NinjaMetrics.subjectBarWidthCompact);
    });

    testWidgets('swipe from the end deletes the cell', (tester) async {
      var deleted = 0;
      await tester.pumpWidget(
        wrap(
          NinjaListCell(
            title: 'Напоминание за 30 мин',
            onDelete: () => deleted++,
          ),
        ),
      );

      expect(find.byType(Dismissible), findsOneWidget);
      await tester.drag(
        find.text('Напоминание за 30 мин'),
        const Offset(-400, 0),
      );
      await tester.pumpAndSettle();
      expect(deleted, 1);
    });

    testWidgets('is not dismissible without a delete handler', (tester) async {
      await tester.pumpWidget(wrap(const NinjaListCell(title: 'Обычная')));
      expect(find.byType(Dismissible), findsNothing);
    });
  });
}
