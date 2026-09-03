import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('renders the requested number of cells', (tester) async {
    await tester.pumpWidget(
      wrapKit(const SizedBox(width: 320, child: NinjaCodeInput(length: 4))),
    );

    expect(find.byType(AppCodeInput), findsOneWidget);
    expect(find.byType(SixDigitCodeCell), findsNWidgets(4));
  });

  testWidgets('reports changes and completion', (tester) async {
    final changes = <String>[];
    final completed = <String>[];
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: NinjaCodeInput(
            length: 4,
            onChanged: changes.add,
            onCompleted: completed.add,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '13');
    await tester.pumpAndSettle();
    expect(changes.last, '13');
    expect(completed, isEmpty);

    await tester.enterText(find.byType(TextField), '1357');
    await tester.pumpAndSettle();
    expect(completed, ['1357']);
  });

  testWidgets('non-digits are filtered out', (tester) async {
    final changes = <String>[];
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: NinjaCodeInput(length: 4, onChanged: changes.add),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'a1b2');
    await tester.pumpAndSettle();
    expect(changes.last, '12');
  });
}
