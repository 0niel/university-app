import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppReactionChip', () {
    testWidgets('renders emoji and count', (tester) async {
      await tester.pumpWidget(
        wrap(const AppReactionChip(emoji: '🔥', count: 28)),
      );

      expect(find.text('🔥'), findsOneWidget);
      expect(find.text('28'), findsOneWidget);
    });

    testWidgets('picked uses the accent foreground', (tester) async {
      await tester.pumpWidget(
        wrap(const AppReactionChip(emoji: '🔥', count: 28, picked: true)),
      );

      final count = tester.widget<Text>(find.text('28'));
      expect(count.style?.color, AppColors.dark.primary);
    });
  });
}
