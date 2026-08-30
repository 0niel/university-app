import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: SizedBox(width: 200, child: child))),
      );

  Widget wrapLoose(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  group('NinjaProgressBar', () {
    testWidgets('fills the track by the value', (tester) async {
      await tester.pumpWidget(wrap(const NinjaProgressBar(value: 0.62)));

      final fill = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fill.widthFactor, 0.62);
      expect(tester.getSize(find.byType(NinjaProgressBar)).height, 5);
    });

    testWidgets('clamps out-of-range values', (tester) async {
      await tester.pumpWidget(wrap(const NinjaProgressBar(value: 1.8)));
      expect(
        tester
            .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
            .widthFactor,
        1.0,
      );

      await tester.pumpWidget(wrap(const NinjaProgressBar(value: -3)));
      expect(
        tester
            .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
            .widthFactor,
        0.0,
      );
    });

    testWidgets('scarlet and ink tones swap the fill color', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaProgressBar(
            value: 0.5,
            tone: NinjaProgressTone.scarlet,
          ),
        ),
      );

      final fill = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(FractionallySizedBox),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(
        (fill.decoration as BoxDecoration).color,
        NinjaColors.light().scarlet,
      );
    });
  });

  group('NinjaProgressRing', () {
    testWidgets('labels the ring with the rounded percentage', (tester) async {
      await tester.pumpWidget(wrapLoose(const NinjaProgressRing(value: 0.68)));

      expect(find.text('68%'), findsOneWidget);
      expect(
        tester.getSize(find.byType(NinjaProgressRing)),
        const Size(56, 56),
      );
    });

    testWidgets('honours an explicit label', (tester) async {
      await tester.pumpWidget(
        wrapLoose(const NinjaProgressRing(value: 0.4, label: '80 БРС')),
      );
      expect(find.text('80 БРС'), findsOneWidget);
    });
  });

  group('NinjaSpinner', () {
    testWidgets('paints a 24px ring', (tester) async {
      await tester.pumpWidget(wrapLoose(const NinjaSpinner()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.getSize(find.byType(NinjaSpinner)), const Size(24, 24));
      expect(
        find.descendant(
          of: find.byType(NinjaSpinner),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('freezes under reduced motion', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          home: const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(body: Center(child: NinjaSpinner())),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(NinjaSpinner), findsOneWidget);
    });
  });
}
