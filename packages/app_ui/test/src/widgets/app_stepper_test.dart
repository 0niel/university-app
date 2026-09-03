import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('is a 48px surface2 pill showing the value', (tester) async {
    await tester.pumpWidget(wrapKit(const AppStepper(value: 5)));

    expect(find.text('5'), findsOneWidget);
    expect(tester.getSize(find.byType(AppStepper)).height, 48);
    final decoration = kitDecorationOf(tester, AppStepper);
    expect(decoration.color, kitColors.surface2);
    expect(decoration.borderRadius, BorderRadius.circular(AppRadius.full));
  });

  testWidgets('+ increments and − decrements', (tester) async {
    var value = 5;
    await tester.pumpWidget(
      wrapKit(
        StatefulBuilder(
          builder: (context, setState) => AppStepper(
            value: value,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppLineIconWidget).last);
    await tester.pump();
    expect(find.text('6'), findsOneWidget);

    await tester.tap(find.byType(AppLineIconWidget).first);
    await tester.pump();
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('minus is muted2 and inert at min', (tester) async {
    var value = 0;
    await tester.pumpWidget(
      wrapKit(
        StatefulBuilder(
          builder: (context, setState) => AppStepper(
            value: value,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ),
    );

    final minus = tester.widget<AppLineIconWidget>(
      find.byType(AppLineIconWidget).first,
    );
    expect(minus.color, kitColors.muted2);

    await tester.tap(find.byType(AppLineIconWidget).first);
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('value uses tabular 15/700', (tester) async {
    await tester.pumpWidget(wrapKit(const AppStepper(value: 2)));

    final style = kitStyleOf(tester, '2');
    expect(style?.fontSize, 15);
    expect(style?.fontWeight, FontWeight.w700);
    expect(style?.fontFeatures, isNotNull);
  });
}
