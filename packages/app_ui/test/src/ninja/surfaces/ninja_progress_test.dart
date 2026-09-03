import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  group('NinjaProgressBar', () {
    testWidgets('fills a fraction of a 6px surface2 track', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(width: 200, child: NinjaProgressBar(value: .25)),
        ),
      );

      final track = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(NinjaProgressBar),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(track.height, 6);
      final fill = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fill.widthFactor, .25);
      expect(
        tester.getSize(
          find.descendant(
            of: find.byType(FractionallySizedBox),
            matching: find.byType(DecoratedBox),
          ),
        ),
        const Size(50, 6),
      );
      final trackColor = tester.widget<ColoredBox>(
        find.descendant(
          of: find.byType(NinjaProgressBar),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(trackColor.color, kitColors.surface2);
      final fillColor = kitDecoration(
        tester,
        find.descendant(
          of: find.byType(FractionallySizedBox),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(fillColor.color, kitColors.accent);
    });

    testWidgets('accepts a custom fill and track colour', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 200,
            child: NinjaProgressBar(
              value: .9,
              color: kitColors.danger,
              trackColor: kitColors.surface,
            ),
          ),
        ),
      );

      expect(
        tester
            .widget<ColoredBox>(
              find.descendant(
                of: find.byType(NinjaProgressBar),
                matching: find.byType(ColoredBox),
              ),
            )
            .color,
        kitColors.surface,
      );
      final fill = kitDecoration(
        tester,
        find.descendant(
          of: find.byType(FractionallySizedBox),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(fill.color, kitColors.danger);
    });

    test('AppProgressBar is the same widget', () {
      expect(AppProgressBar, NinjaProgressBar);
    });
  });

  group('AppSegmentedBar', () {
    testWidgets('lays out flex segments with a 3px gap and a rest part', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 300,
            child: AppSegmentedBar(
              restFlex: 3,
              segments: [
                AppSegmentedBarPart(flex: 2, color: kitColors.lecture),
                AppSegmentedBarPart(flex: 1, color: kitColors.practice),
                AppSegmentedBarPart(flex: 1, color: kitColors.lab),
              ],
            ),
          ),
        ),
      );

      final parts = tester.widgetList<Expanded>(find.byType(Expanded)).toList();
      expect(parts.map((part) => part.flex), [2, 1, 1, 3]);
      final gaps = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .where((box) => box.width == 3);
      expect(gaps, hasLength(3));
      final rest = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .last
          .decoration as BoxDecoration;
      expect(rest.color, kitColors.surface2);
    });
  });

  group('rings and spinners', () {
    testWidgets('NinjaProgressRing prints the rounded percent at 14/800', (
      tester,
    ) async {
      await tester.pumpWidget(wrapKit(const NinjaProgressRing(value: .66)));

      expect(find.text('66%'), findsOneWidget);
      final style = kitStyleOf(tester, '66%');
      expect(style?.fontSize, 14);
      expect(style?.fontWeight, FontWeight.w800);
      final box = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(NinjaProgressRing),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(box.width, 64);
    });

    testWidgets('AppProgressRing exposes the value to semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(const AppProgressRing(value: .5, label: '50%')),
      );
      expect(find.text('50%'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('NinjaSpinner is a 28px rotating ring', (tester) async {
      await tester.pumpWidget(wrapKit(const NinjaSpinner()));

      final box = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(NinjaSpinner),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(box.width, 28);
      expect(
        find.descendant(
          of: find.byType(NinjaSpinner),
          matching: find.byType(RotationTransition),
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpWidget(const SizedBox());
    });

    test('AppSpinner is the same widget', () {
      expect(AppSpinner, NinjaSpinner);
    });

    testWidgets('AppPulseDot collapses to a single dot under reduced motion', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: AppPulseDot(),
          ),
        ),
      );

      expect(
        find.descendant(
          of: find.byType(AppPulseDot),
          matching: find.byType(Stack),
        ),
        findsNothing,
      );
      final dot = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AppPulseDot),
          matching: find.byType(SizedBox),
        ),
      );
      expect(dot.width, 12);
    });

    testWidgets('AppPulseDot animates a halo otherwise', (tester) async {
      await tester.pumpWidget(wrapKit(const AppPulseDot()));
      expect(
        find.descendant(
          of: find.byType(AppPulseDot),
          matching: find.byType(Stack),
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpWidget(const SizedBox());
    });
  });
}
