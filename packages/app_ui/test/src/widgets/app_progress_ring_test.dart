import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppProgressRing', () {
    testWidgets('renders the center label', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppProgressRing(
            value: 0.42,
            label: '42%',
            sublabel: 'готово',
          ),
        ),
      );
      expect(find.text('42%'), findsOneWidget);
      final semantics = tester.getSemantics(find.byType(AppProgressRing));
      expect(semantics.label, 'готово');
      expect(semantics.value, '42%');
    });

    testWidgets('clamps an out-of-range value without throwing',
        (tester) async {
      await tester.pumpWidget(wrap(const AppProgressRing(value: 1.5)));
      expect(tester.takeException(), isNull);
    });
  });
}
