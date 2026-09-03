import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: SizedBox(width: 340, child: child))),
      );

  List<AppHeatmapDay> daysUpTo(DateTime today, Map<int, int> countsByOffset) {
    final start = today.subtract(const Duration(days: 27));
    return [
      for (var i = 0; i <= 27; i++)
        AppHeatmapDay(
          date: start.add(Duration(days: i)),
          count: countsByOffset[27 - i] ?? 0,
        ),
    ];
  }

  group('AppActivityHeatmap', () {
    testWidgets('renders nothing for an empty history', (tester) async {
      await tester.pumpWidget(wrap(const AppActivityHeatmap(days: [])));
      expect(find.byType(AppActivityHeatmap), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppActivityHeatmap),
          matching: find.byType(DecoratedBox),
        ),
        findsNothing,
      );
    });

    testWidgets('scales cell intensity with the busiest day', (tester) async {
      final today = DateTime(2026, 9, 3);
      final days = daysUpTo(today, {0: 8, 1: 4, 2: 1});
      await tester.pumpWidget(
        wrap(AppActivityHeatmap(days: days, today: today)),
      );
      await tester.pumpAndSettle();

      final colors = AppTheme.darkTheme.extension<AppColors>()!;
      final cells = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(AppActivityHeatmap),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration as BoxDecoration)
          .toList();

      expect(
        cells.any((d) => d.color == appHeatmapLevelColor(colors, 4)),
        isTrue,
      );
      expect(
        cells.any((d) => d.color == appHeatmapLevelColor(colors, 0)),
        isTrue,
      );
    });

    testWidgets('outlines the current day with a 2px accent border', (
      tester,
    ) async {
      final today = DateTime(2026, 9, 3);
      final days = daysUpTo(today, {0: 3});
      await tester.pumpWidget(
        wrap(AppActivityHeatmap(days: days, today: today)),
      );
      await tester.pumpAndSettle();

      final colors = AppTheme.darkTheme.extension<AppColors>()!;
      final decorations = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(AppActivityHeatmap),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration as BoxDecoration)
          .toList();
      final outlined = decorations.where(
        (d) => d.border == Border.all(color: colors.accent, width: 2),
      );
      expect(outlined, hasLength(1));
    });

    testWidgets('long-press reveals the tooltip for that day', (
      tester,
    ) async {
      final today = DateTime(2026, 9, 3);
      final days = daysUpTo(today, {0: 3});
      await tester.pumpWidget(
        wrap(
          AppActivityHeatmap(
            days: days,
            today: today,
            tooltipBuilder: (date, count) =>
                '${date.day} сен · $count действия',
          ),
        ),
      );
      await tester.pumpAndSettle();

      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip).last);
      expect(tooltip.message, '3 сен · 3 действия');
      expect(tooltip.triggerMode, TooltipTriggerMode.longPress);
    });

    testWidgets('renders weekday and legend labels when provided', (
      tester,
    ) async {
      final today = DateTime(2026, 9, 3);
      final days = daysUpTo(today, {0: 1});
      await tester.pumpWidget(
        wrap(
          AppActivityHeatmap(
            days: days,
            today: today,
            weekdayLabels: const ['Пн', null, 'Ср', null, 'Пт', null, null],
            legendLessLabel: 'меньше',
            legendMoreLabel: 'больше',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Пн'), findsOneWidget);
      expect(find.text('Ср'), findsOneWidget);
      expect(find.text('Пт'), findsOneWidget);
      expect(find.text('меньше'), findsOneWidget);
      expect(find.text('больше'), findsOneWidget);
    });
  });
}
