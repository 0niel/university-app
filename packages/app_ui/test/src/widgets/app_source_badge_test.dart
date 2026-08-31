import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppSourceBadge', () {
    testWidgets('renders the source label', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppSourceBadge(
            type: SourceType.telegram,
            source: '@mirea_news',
          ),
        ),
      );

      expect(find.text('@mirea_news'), findsOneWidget);
    });

    testWidgets('md size renders a tinted pill', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppSourceBadge(
            type: SourceType.official,
            source: 'Деканат',
            size: SourceBadgeSize.md,
          ),
        ),
      );

      expect(find.text('Деканат'), findsOneWidget);
    });
  });
}
