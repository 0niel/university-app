import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(
          body: Padding(padding: const EdgeInsets.all(20), child: child),
        ),
      );

  Finder boxes() => find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox && widget.width == 48 && widget.height == 56,
      );

  group('NinjaCodeInput', () {
    testWidgets('draws one 48×56 box per digit', (tester) async {
      await tester.pumpWidget(wrap(const NinjaCodeInput()));

      expect(boxes(), findsNWidgets(6));
    });

    testWidgets('respects a custom length', (tester) async {
      await tester.pumpWidget(wrap(const NinjaCodeInput(length: 4)));

      expect(boxes(), findsNWidgets(4));
    });

    testWidgets('shrinks the boxes instead of overflowing a narrow row', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const SizedBox(width: 280, child: NinjaCodeInput())),
      );

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(NinjaCodeInput)).width,
        lessThanOrEqualTo(280),
      );
    });

    testWidgets('renders typed digits and completes at full length', (
      tester,
    ) async {
      String? completed;
      final changes = <String>[];

      await tester.pumpWidget(
        wrap(
          NinjaCodeInput(
            onChanged: changes.add,
            onCompleted: (code) => completed = code,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '731');
      await tester.pump();

      expect(find.text('7'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(changes.last, '731');
      expect(completed, isNull);

      await tester.enterText(find.byType(TextField), '731284');
      await tester.pump();

      expect(completed, '731284');
    });

    testWidgets('the active box uses a flat high-contrast border', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const NinjaCodeInput(autofocus: true)));
      await tester.pump();

      final decorations = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(NinjaCodeInput),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration as BoxDecoration)
          .where(
            (decoration) =>
                decoration.borderRadius ==
                BorderRadius.circular(NinjaRadius.button),
          )
          .toList();

      expect(decorations.first.border?.top.color, colors.ink);
      expect(decorations.first.boxShadow, isNull);
      expect(decorations.last.border?.top.color, colors.line);
      expect(decorations.last.boxShadow, isNull);
    });
  });
}
