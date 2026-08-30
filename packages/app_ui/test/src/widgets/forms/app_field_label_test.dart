import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppFieldLabel', () {
    testWidgets('uppercases the text', (tester) async {
      await tester.pumpWidget(wrap(const AppFieldLabel('Название')));
      expect(find.text('НАЗВАНИЕ'), findsOneWidget);
    });
  });
}
