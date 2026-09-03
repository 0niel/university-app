import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(
          body: Center(child: SizedBox(width: 64, child: child)),
        ),
      );

  group('AppWeekGridCell', () {
    testWidgets('schedule empty cell retains its plain border and add action', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppWeekGridCell(
            scheduleStyle: true,
            variant: AppWeekGridCellVariant.empty,
            onTap: () => tapped = true,
          ),
        ),
      );
      expect(find.byType(AppDashedBorder), findsNothing);
      expect(find.byType(AppLineIconWidget), findsNothing);
      final surface = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((box) => box.border != null);
      expect(surface.border, Border.all(color: AppColors.light.line));
      expect(tester.getSize(find.byType(AppWeekGridCell)).height, 54);
      await tester.tap(find.byType(AppWeekGridCell));
      expect(tapped, isTrue);
    });

    testWidgets(
        'schedule selected cancellation uses one-pixel border without strike', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppWeekGridCell(
            scheduleStyle: true,
            selected: true,
            variant: AppWeekGridCellVariant.cancelled,
            bottomLabel: 'А-201',
          ),
        ),
      );
      final label = tester.widget<Text>(find.text('А-201'));
      expect(label.style?.decoration, TextDecoration.none);
      expect(label.style?.height, 1.1);
      final surface = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((box) => box.border != null);
      expect(surface.border, Border.all(color: AppColors.light.accent));
    });

    testWidgets('filled shows both labels at 54px height', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppWeekGridCell(
            topLabel: 'ЛЕК',
            bottomLabel: 'А-201',
            tone: AppColors.light.lecture,
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('ЛЕК'), findsOneWidget);
      expect(find.text('А-201'), findsOneWidget);
      expect(tester.getSize(find.byType(AppWeekGridCell)).height, 54);
      expect(
        tester.widget<Text>(find.text('ЛЕК')).style?.fontSize,
        8.5,
      );

      await tester.tap(find.byType(AppWeekGridCell));
      expect(tapped, isTrue);
    });

    testWidgets('cancelled falls back to ОТМ and strikes the labels through', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppWeekGridCell(
            variant: AppWeekGridCellVariant.cancelled,
            bottomLabel: 'А-201',
          ),
        ),
      );

      expect(find.text('ОТМ'), findsOneWidget);
      final label = tester.widget<Text>(find.text('А-201'));
      expect(label.style?.decoration, TextDecoration.lineThrough);
      expect(label.style?.color, AppColors.light.exam);
    });

    testWidgets('busy paints a hatch over a surface2 cell', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppWeekGridCell(
            variant: AppWeekGridCellVariant.busy,
            topLabel: 'ЗАН',
          ),
        ),
      );

      final decorations = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>();
      expect(
        decorations.any((d) => d.color == AppColors.light.surface2),
        isTrue,
      );
      expect(
        find.descendant(
          of: find.byType(AppWeekGridCell),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
    });

    testWidgets('empty draws a dashed border and a plus icon', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppWeekGridCell(variant: AppWeekGridCellVariant.empty),
        ),
      );

      expect(find.byType(AppDashedBorder), findsOneWidget);
      final icon = tester.widget<AppLineIconWidget>(
        find.byType(AppLineIconWidget),
      );
      expect(icon.icon, AppLineIcon.plus);
      expect(icon.size, 14);
    });

    testWidgets('selected adds a 2px accent inset ring', (tester) async {
      await tester.pumpWidget(
        wrap(const AppWeekGridCell(topLabel: 'ЛЕК', selected: true)),
      );

      final ring = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((d) => d.border != null);
      expect(
        ring.border,
        Border.all(color: AppColors.light.accent, width: 2),
      );
    });
  });
}
