import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  testWidgets('renders six cells 56px tall', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(width: 340, child: SixDigitCodeInput(onCompleted: (_) {})),
      ),
    );

    expect(find.byType(SixDigitCodeCell), findsNWidgets(6));
    expect(tester.getSize(find.byType(SixDigitCodeCell).first).height, 56);
  });

  testWidgets('empty cell is surface2, filled cell is tint', (tester) async {
    final controller = TextEditingController(text: '24');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 340,
          child: AppCodeInput(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final cells = find.byType(SixDigitCodeCell);
    expect(
      kitDecoration(
        tester,
        find.descendant(of: cells.first, matching: find.byType(Container)),
      ).color,
      kitColors.tint,
    );
    expect(
      kitDecoration(
        tester,
        find.descendant(of: cells.last, matching: find.byType(Container)),
      ).color,
      kitColors.surface2,
    );
    expect(find.text('2'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('active cell carries a 2px accent ring', (tester) async {
    final controller = TextEditingController(text: '24');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 340,
          child: AppCodeInput(controller: controller, showKeypad: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final third = find.byType(SixDigitCodeCell).at(2);
    final decoration = kitDecoration(
      tester,
      find.descendant(of: third, matching: find.byType(Container)),
    );
    expect(decoration.border, Border.all(color: kitColors.accent, width: 2));
  });

  testWidgets('keypad appends digits and reports completion', (tester) async {
    final completed = <String>[];
    final controller = TextEditingController(text: '12345');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 360,
          child: AppCodeInput(
            controller: controller,
            showKeypad: true,
            onCompleted: completed.add,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(Container, '6').first);
    await tester.pumpAndSettle();

    expect(controller.text, '123456');
    expect(completed, ['123456']);
  });

  testWidgets('keypad backspace removes the last digit', (tester) async {
    final controller = TextEditingController(text: '123');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 360,
          child: AppCodeInput(controller: controller, showKeypad: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('⌫'));
    await tester.pumpAndSettle();

    expect(controller.text, '12');
  });

  testWidgets('typing into the hidden field completes the code', (
    tester,
  ) async {
    final completed = <String>[];
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 340,
          child: SixDigitCodeInput(
            autofocus: false,
            onCompleted: completed.add,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '135790');
    await tester.pumpAndSettle();

    expect(completed, ['135790']);
  });
}
