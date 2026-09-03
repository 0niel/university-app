import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppQuestCard', () {
    testWidgets('shows real progress and the reward, without any emoji', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppQuestCard(
            title: 'Поставь 3 реакции',
            progress: 1,
            target: 3,
            xpReward: 20,
          ),
        ),
      );

      expect(find.text('Поставь 3 реакции'), findsOneWidget);
      expect(find.text('1 / 3'), findsOneWidget);
      expect(find.text('+20 XP'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsNothing);

      final ring = tester.widget<AppProgressRing>(find.byType(AppProgressRing));
      expect(ring.value, closeTo(1 / 3, 0.001));
    });

    testWidgets('swaps the ring for a check once completed', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppQuestCard(
            title: 'Готово',
            progress: 3,
            target: 3,
            xpReward: 20,
            isDone: true,
          ),
        ),
      );

      expect(find.byType(AppLineIconWidget), findsOneWidget);
      expect(find.byType(AppProgressRing), findsNothing);
    });
  });

  group('AppBadgeRailCard', () {
    testWidgets('earned badges drop the progress ring', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppBadgeRailCard(
            emoji: '🔥',
            name: 'Огонёк',
            isEarned: true,
          ),
        ),
      );

      expect(find.text('🔥'), findsOneWidget);
      expect(find.text('Огонёк'), findsOneWidget);
      expect(find.byType(AppProgressRing), findsNothing);
    });

    testWidgets('locked badges show the ring and its percentage', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppBadgeRailCard(
            emoji: '📝',
            name: 'Конспектор',
            isEarned: false,
            progress: 0.4,
            progressLabel: '40%',
          ),
        ),
      );

      expect(find.text('40%'), findsOneWidget);
      final ring = tester.widget<AppProgressRing>(find.byType(AppProgressRing));
      expect(ring.value, 0.4);
    });
  });

  group('AppProfileStatsStrip', () {
    testWidgets('renders every stat with its caption', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppProfileStatsStrip(
            stats: [
              AppProfileStat(value: '5', label: 'дней подряд'),
              AppProfileStat(value: '1', label: 'достижений'),
              AppProfileStat(value: '#2', label: 'место в группе'),
            ],
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.text('достижений'), findsOneWidget);
      expect(find.text('#2'), findsOneWidget);
    });
  });

  group('AppXpProgressBar', () {
    testWidgets('clamps the fraction it fills', (tester) async {
      await tester.pumpWidget(
        wrap(const SizedBox(width: 200, child: AppXpProgressBar(value: 1.4))),
      );

      final fill = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fill.widthFactor, 1.0);
    });
  });
}
