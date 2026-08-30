import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  BoxDecoration boxOf(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(NinjaCheckbox),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    return box.decoration as BoxDecoration;
  }

  group('NinjaCheckbox', () {
    testWidgets('checked is the ink block with a check', (tester) async {
      await tester.pumpWidget(
        wrap(NinjaCheckbox(value: true, onChanged: (_) {})),
      );

      expect(boxOf(tester).color, colors.ink);
      expect(boxOf(tester).border, isNull);
      expect(find.byType(NinjaCheckMark), findsOneWidget);
      expect(tester.getSize(find.byType(NinjaCheckbox)), const Size.square(24));
    });

    testWidgets('empty is the 1.5 disabledLine outline', (tester) async {
      await tester.pumpWidget(
        wrap(NinjaCheckbox(value: false, onChanged: (_) {})),
      );

      final decoration = boxOf(tester);
      expect(decoration.color, Colors.transparent);
      expect(decoration.border?.top.color, colors.disabledLine);
      expect(decoration.border?.top.width, NinjaMetrics.lineWidth);
      expect(find.byType(NinjaCheckMark), findsNothing);
    });

    testWidgets('indeterminate swaps the check for the bar', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaCheckbox(value: false, indeterminate: true, onChanged: (_) {}),
        ),
      );

      expect(boxOf(tester).color, colors.ink);
      expect(find.byType(NinjaCheckMark), findsNothing);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.width == 11 && widget.height == 3,
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping reports the flipped value', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        wrap(
          NinjaCheckbox(value: false, onChanged: (value) => changed = value),
        ),
      );

      await tester.tap(find.byType(NinjaCheckbox));
      expect(changed, isTrue);
    });

    testWidgets('disabled dims the box and blocks taps', (tester) async {
      await tester.pumpWidget(wrap(const NinjaCheckbox(value: true)));

      expect(
        tester
            .widget<Opacity>(
              find.descendant(
                of: find.byType(NinjaCheckbox),
                matching: find.byType(Opacity),
              ),
            )
            .opacity,
        0.5,
      );

      await tester.tap(find.byType(NinjaCheckbox));
    });
  });
}
