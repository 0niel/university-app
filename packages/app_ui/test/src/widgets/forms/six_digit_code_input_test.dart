import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('SixDigitCodeInput', () {
    testWidgets('renders six fields', (tester) async {
      await tester.pumpWidget(
        wrap(SixDigitCodeInput(onCompleted: (_) {})),
      );

      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('reports the full code only once every cell is filled',
        (tester) async {
      String? completed;
      await tester.pumpWidget(
        wrap(SixDigitCodeInput(onCompleted: (code) => completed = code)),
      );

      final fields = find.byType(TextField);
      for (var i = 0; i < 6; i++) {
        await tester.enterText(fields.at(i), '${i + 1}');
        await tester.pump();
      }

      expect(completed, '123456');
    });

    testWidgets('only accepts digits', (tester) async {
      String? completed;
      await tester.pumpWidget(
        wrap(SixDigitCodeInput(onCompleted: (code) => completed = code)),
      );

      // Letters are stripped by the digits-only formatter, so the code never
      // completes from non-numeric input.
      await tester.enterText(find.byType(TextField).first, 'a');
      await tester.pump();

      expect(find.text('a'), findsNothing);
      expect(completed, isNull);
    });

    testWidgets('backspace on an empty cell clears and focuses the previous',
        (tester) async {
      await tester.pumpWidget(
        wrap(SixDigitCodeInput(onCompleted: (_) {})),
      );

      final fields = find.byType(TextField);
      await tester.enterText(fields.first, '7');
      await tester.pump();

      // Focus auto-advanced to the second (empty) cell; backspace steps back.
      await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
      await tester.pump();

      expect(find.text('7'), findsNothing);
    });
  });
}
