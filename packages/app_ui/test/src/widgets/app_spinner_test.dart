import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppSpinner', () {
    testWidgets('renders at the default 22px size', (tester) async {
      await tester.pumpWidget(wrap(const AppSpinner()));

      expect(find.byType(AppSpinner), findsOneWidget);
      expect(tester.getSize(find.byType(AppSpinner)), const Size.square(22));
    });

    testWidgets('honours a custom size and colour', (tester) async {
      await tester.pumpWidget(
        wrap(const AppSpinner(size: 40, color: Color(0xFF112233))),
      );

      expect(tester.getSize(find.byType(AppSpinner)), const Size.square(40));
      expect(tester.takeException(), isNull);
    });
  });
}
