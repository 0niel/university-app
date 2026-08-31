import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppSmartChip', () {
    testWidgets('renders emoji, label and value', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppSmartChip(
            emoji: '🍲',
            label: 'Столовая',
            value: '~8 мин',
            tone: AppColors.dark.warning,
          ),
        ),
      );

      expect(find.text('🍲'), findsOneWidget);
      expect(find.text('Столовая'), findsOneWidget);
      expect(find.text('~8 мин'), findsOneWidget);
    });

    testWidgets('uses tone as a restrained accent rail', (tester) async {
      const tone = Color(0xFF34D399);
      await tester.pumpWidget(
        wrap(
          const AppSmartChip(
            emoji: '🚪',
            label: 'Свободно',
            value: '18',
            tone: tone,
          ),
        ),
      );

      final decorations = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<BoxDecoration>();
      expect(decorations.any((decoration) => decoration.color == tone), isTrue);
      final value = tester.widget<Text>(find.text('18'));
      expect(
        value.style?.color,
        tester.element(find.byType(AppSmartChip)).ninja.ink,
      );
    });

    testWidgets('renders UIKit icon content', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppSmartChip.icon(
            icon: AppLineIconWidget(AppLineIcon.door),
            label: 'Аудитория',
            value: 'А-101',
            tone: Color(0xFF35D49A),
          ),
        ),
      );

      expect(find.byType(AppLineIconWidget), findsOneWidget);
      expect(find.text('Аудитория'), findsOneWidget);
      expect(find.text('А-101'), findsOneWidget);
    });

    testWidgets('stays bounded in a narrow 200 percent layout', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 170,
                  child: AppSmartChip(
                    emoji: '📚',
                    label: 'Библиотека',
                    value: 'до 20:00',
                    tone: Color(0xFF2F7AFF),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
