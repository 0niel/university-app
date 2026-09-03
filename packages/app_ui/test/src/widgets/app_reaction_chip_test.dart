import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  BoxDecoration pillOf(WidgetTester tester) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(AppReactionChip),
              matching: find.byType(Container),
            )
            .first,
      );

  testWidgets('renders emoji and count', (tester) async {
    await tester.pumpWidget(
      wrapKit(const AppReactionChip(emoji: '🔥', count: 28)),
    );

    expect(find.text('🔥'), findsOneWidget);
    expect(find.text('28'), findsOneWidget);
  });

  testWidgets('idle is surface2 with a muted count', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppReactionChip(emoji: '🔥', count: 28, onTap: () {})),
    );
    await tester.pumpAndSettle();

    expect(pillOf(tester).color, kitColors.surface2);
    expect(kitStyleOf(tester, '28')?.color, kitColors.muted);
  });

  testWidgets('picked is tinted with an accent count', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppReactionChip(emoji: '🔥', count: 28, picked: true, onTap: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(pillOf(tester).color, kitColors.tint);
    expect(kitStyleOf(tester, '28')?.color, kitColors.accent);
  });

  testWidgets('keeps a 44px tap target and fires', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(AppReactionChip(emoji: '🔥', count: 1, onTap: () => taps++)),
    );

    expect(tester.getSize(find.byType(AppReactionChip)).height, 44);
    await tester.tap(find.byType(AppReactionChip));
    expect(taps, 1);
  });
}
