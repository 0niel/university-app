import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppContextBanner', () {
    testWidgets('renders title, subtitle and action label', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppContextBanner(
            emoji: '🥷',
            title: 'Маскировка',
            subtitle: 'EXIF стёрт',
            actionLabel: 'Настроить',
          ),
        ),
      );

      expect(find.text('Маскировка'), findsOneWidget);
      expect(find.text('EXIF стёрт'), findsOneWidget);
      expect(find.text('Настроить'), findsOneWidget);
    });

    testWidgets('gradient variant paints a gradient', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppContextBanner.gradient(
            emoji: '💘',
            title: 'Матч',
            subtitle: 'Telegram',
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppContextBanner),
              matching: find.byType(Container),
            )
            .first,
      );
      expect((container.decoration! as BoxDecoration).gradient, isNotNull);
    });
  });
}
