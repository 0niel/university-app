import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  group('AppNinjaRankHero', () {
    testWidgets('shows the rank, overline and a canonical shuriken mark', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppNinjaRankHero(
            xp: 676,
            level: 1,
            badgeCount: 12,
            streakDays: 4,
            shurikens: 1872,
            rankLabel: 'Уровень 1 · Ранг',
            badgesLabel: 'ачивок',
            streakLabel: 'дней стрик',
            shurikensLabel: 'сюрикена',
          ),
        ),
      );
      await tester.pump();

      // 676 XP is below the Chunin threshold → Genin, climbing to Chunin.
      expect(find.text('Genin'), findsOneWidget);
      expect(find.text('Уровень 1 · Ранг'), findsOneWidget);
      expect(find.text('ачивок'), findsOneWidget);

      // The hero decoration reuses the shared mark rather than a bespoke
      // pinwheel painter.
      expect(find.byType(AppNinjaMark), findsOneWidget);
    });
  });
}
