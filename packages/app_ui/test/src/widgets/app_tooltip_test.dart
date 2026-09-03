import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppTooltip', () {
    testWidgets('renders the label with a rotated tail', (tester) async {
      await tester.pumpWidget(wrap(const AppTooltip(label: 'Свайпни')));

      expect(find.text('Свайпни'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppTooltip),
          matching: find.byType(Transform),
        ),
        findsWidgets,
      );
    });

    testWidgets('the up arrow variant builds', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppTooltip(label: 'Сверху', arrow: AppTooltipArrow.up),
        ),
      );

      expect(find.text('Сверху'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
