import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('renders emoji, label and value on a surface2 pill', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        AppSmartChip(
          emoji: '🔥',
          label: 'Стрик',
          value: '12 дней',
          tone: kitColors.accent,
        ),
      ),
    );

    expect(find.text('🔥'), findsOneWidget);
    expect(find.text('Стрик'), findsOneWidget);
    expect(find.text('12 дней'), findsOneWidget);
    expect(kitDecorationOf(tester, AppSmartChip).color, kitColors.surface2);
    expect(kitStyleOf(tester, 'Стрик')?.color, kitColors.muted);
    expect(kitStyleOf(tester, '12 дней')?.color, kitColors.ink);
  });

  testWidgets('icon variant swaps the emoji for a widget', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppSmartChip.icon(
          icon: const AppLineIconWidget(AppLineIcon.bolt),
          label: 'XP',
          value: '1 240',
          tone: kitColors.lab,
        ),
      ),
    );

    expect(find.byType(AppLineIconWidget), findsOneWidget);
  });

  testWidgets('merges its parts into one semantics node', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppSmartChip(
          emoji: '🔥',
          label: 'Стрик',
          value: '12 дней',
          tone: kitColors.accent,
        ),
      ),
    );

    final semantics = tester.getSemantics(find.byType(AppSmartChip));
    expect(semantics.label, 'Стрик, 12 дней');
  });
}
