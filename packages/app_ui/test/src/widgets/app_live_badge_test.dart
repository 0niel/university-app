import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppLiveBadge', () {
    testWidgets('defaults to an accent badge with a dot', (tester) async {
      await tester.pumpWidget(wrap(const AppLiveBadge()));

      expect(find.text('Сейчас'), findsOneWidget);
      final badge = tester.widget<AppBadge>(find.byType(AppBadge));
      expect(badge.tone, AppBadgeTone.accent);
      expect(badge.dot, isTrue);
    });

    testWidgets('accepts a custom label', (tester) async {
      await tester.pumpWidget(wrap(const AppLiveBadge(label: 'LIVE')));

      expect(find.text('LIVE'), findsOneWidget);
    });
  });
}
