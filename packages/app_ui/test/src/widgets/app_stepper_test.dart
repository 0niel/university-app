import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppStepper', () {
    testWidgets('renders the value', (tester) async {
      await tester.pumpWidget(wrap(const AppStepper(value: 5)));
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('+ increments and − decrements', (tester) async {
      var value = 5;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => AppStepper(
              value: value,
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      expect(find.text('6'), findsOneWidget);

      await tester.tap(find.byType(AppPressable).first);
      await tester.pump();
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('does not go below min', (tester) async {
      var value = 0;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => AppStepper(
              value: value,
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppPressable).first);
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });
  });
}
