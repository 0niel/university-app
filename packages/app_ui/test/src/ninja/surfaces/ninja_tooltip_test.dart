import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  group('NinjaTooltip', () {
    testWidgets('renders an ink bubble with an arrow above', (tester) async {
      await tester.pumpWidget(
        wrap(const NinjaTooltip(message: 'Числитель — нечётная неделя')),
      );

      final style =
          tester.widget<Text>(find.text('Числитель — нечётная неделя')).style;
      expect(style?.fontSize, 12);
      expect(style?.fontWeight, FontWeight.w700);
      expect(style?.color, colors.onInk);

      final arrow = tester.widget<PositionedDirectional>(
        find.byType(PositionedDirectional),
      );
      expect(arrow.start, 22);
      expect(arrow.top, -5);
      expect(arrow.bottom, isNull);
    });

    testWidgets('flips the arrow to the bottom edge', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaTooltip(
            message: 'Подсказка',
            arrow: NinjaTooltipArrow.down,
          ),
        ),
      );

      final arrow = tester.widget<PositionedDirectional>(
        find.byType(PositionedDirectional),
      );
      expect(arrow.top, isNull);
      expect(arrow.bottom, -5);
    });
  });

  group('NinjaFeatureHint', () {
    testWidgets('renders a restrained brand surface and accessible action', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          NinjaFeatureHint(
            title: 'Новое: маршруты между парами',
            body: 'Тапните «окно» в расписании — покажем путь.',
            actionLabel: 'Понятно',
            onAction: () => taps++,
          ),
        ),
      );

      final title =
          tester.widget<Text>(find.text('Новое: маршруты между парами')).style;
      expect(title?.fontSize, 12.5);
      expect(title?.fontWeight, FontWeight.w800);
      expect(title?.color, colors.ink);

      final action = tester.widget<Text>(find.text('Понятно')).style;
      expect(action?.color, colors.brandInk);
      expect(action?.fontWeight, FontWeight.w700);
      expect(tester.getSize(find.text('Понятно')).height, lessThan(44));
      expect(
        tester
            .getSize(
              find.ancestor(
                of: find.text('Понятно'),
                matching: find.byType(ConstrainedBox),
              ),
            )
            .height,
        greaterThanOrEqualTo(44),
      );

      await tester.tap(find.text('Понятно'));
      expect(taps, 1);
    });
  });
}
