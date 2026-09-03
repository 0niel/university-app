import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  group('NinjaTooltip', () {
    testWidgets('paints an ink r12 bubble with 12.5/600 canvas text', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(const NinjaTooltip(message: 'Тап — отметиться на паре')),
      );

      final bubble = kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(NinjaTooltip),
              matching: find.byType(DecoratedBox),
            )
            .last,
      );
      expect(bubble.color, kitColors.ink);
      expect(bubble.borderRadius, BorderRadius.circular(12));

      final style = kitStyleOf(tester, 'Тап — отметиться на паре');
      expect(style?.fontSize, 12.5);
      expect(style?.fontWeight, FontWeight.w600);
      expect(style?.color, kitColors.canvas);
    });

    testWidgets('has a 10px rotated tail', (tester) async {
      await tester.pumpWidget(
        wrapKit(const NinjaTooltip(message: 'Подсказка')),
      );

      final tail = tester.widget<Container>(
        find.descendant(
          of: find.byType(Transform),
          matching: find.byType(Container),
        ),
      );
      expect(tail.constraints?.maxWidth, 10);
      expect((tail.decoration! as BoxDecoration).color, kitColors.ink);
    });
  });

  group('AppTooltip', () {
    testWidgets('renders the label and tail in both directions', (
      tester,
    ) async {
      await tester.pumpWidget(wrapKit(const AppTooltip(label: 'Вниз')));
      expect(kitStyleOf(tester, 'Вниз')?.color, kitColors.canvas);
      expect(
        find.descendant(
          of: find.byType(AppTooltip),
          matching: find.byType(Transform),
        ),
        findsOneWidget,
      );

      await tester.pumpWidget(
        wrapKit(const AppTooltip(label: 'Вверх', arrow: AppTooltipArrow.up)),
      );
      expect(find.text('Вверх'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppTooltip),
          matching: find.byType(Transform),
        ),
        findsOneWidget,
      );
    });
  });

  group('NinjaFeatureHint', () {
    testWidgets('renders on tint with an action', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 360,
            child: NinjaFeatureHint(
              title: 'Новое',
              body: 'Теперь можно отмечаться на парах',
              actionLabel: 'Понятно',
              onAction: () => taps++,
            ),
          ),
        ),
      );

      expect(kitDecorationOf(tester, NinjaFeatureHint).color, kitColors.tint);
      expect(find.byType(AppIconTile), findsOneWidget);
      await tester.tap(find.text('Понятно'));
      expect(taps, 1);
    });
  });
}
