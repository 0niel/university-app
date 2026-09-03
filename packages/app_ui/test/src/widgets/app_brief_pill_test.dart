import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppBriefPill', () {
    testWidgets('renders the text on a flat pill', (tester) async {
      await tester.pumpWidget(wrap(const AppBriefPill(text: '3 пары')));

      expect(find.text('3 пары'), findsOneWidget);
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppBriefPill),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.boxShadow, isNull);
      expect(decoration.gradient, isNull);
    });
  });
}
