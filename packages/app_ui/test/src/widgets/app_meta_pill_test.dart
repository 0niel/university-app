import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppMetaPill', () {
    testWidgets('renders the text', (tester) async {
      await tester.pumpWidget(wrap(const AppMetaPill(text: 'А-123')));

      expect(find.text('А-123'), findsOneWidget);
    });

    testWidgets('renders a leading icon', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppMetaPill(
            text: 'Аудитория',
            icon: AppLineIconWidget(AppLineIcon.pin),
            strong: true,
          ),
        ),
      );

      expect(find.byType(AppLineIconWidget), findsOneWidget);
      expect(find.text('Аудитория'), findsOneWidget);
    });
  });
}
