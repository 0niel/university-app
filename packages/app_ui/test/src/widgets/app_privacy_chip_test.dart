import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppPrivacyChip', () {
    testWidgets('renders the emoji+label and a line check icon',
        (tester) async {
      await tester.pumpWidget(
        wrap(const AppPrivacyChip(icon: '📍', label: 'геолокация')),
      );

      expect(find.text('📍 геолокация'), findsOneWidget);
      final icon = tester.widget<AppLineIconWidget>(
        find.byType(AppLineIconWidget),
      );
      expect(icon.icon, AppLineIcon.check);
    });
  });
}
