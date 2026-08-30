import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppDeadlineCard', () {
    testWidgets('renders task, subject·due and the left pill', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppDeadlineCard(
            subject: 'БД',
            task: 'Лаб 7',
            due: 'завтра',
            left: '1 день',
            progress: 0.7,
          ),
        ),
      );

      expect(find.text('Лаб 7'), findsOneWidget);
      expect(find.text('БД · завтра'), findsOneWidget);
      expect(find.text('1 день'), findsOneWidget);
      expect(find.text('📋'), findsOneWidget);
    });

    testWidgets('urgent shows the fire emoji', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppDeadlineCard(
            subject: 'БД',
            task: 'Лаб 7',
            due: 'завтра',
            left: '1 день',
            progress: 0.7,
            urgent: true,
          ),
        ),
      );

      expect(find.text('🔥'), findsOneWidget);
    });
  });
}
