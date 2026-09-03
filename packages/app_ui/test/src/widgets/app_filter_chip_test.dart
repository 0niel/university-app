import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('selected filter chip is accent with onAccent text', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(
        AppFilterChip(
          label: 'Сегодня',
          isSelected: true,
          onTap: () => taps++,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      kitDecorationOf(tester, AppFilterChip).color,
      kitColors.accent,
    );
    expect(kitStyleOf(tester, 'Сегодня')?.color, kitColors.onAccent);

    await tester.tap(find.byType(AppFilterChip));
    expect(taps, 1);
  });

  testWidgets('unselected filter chip sits on surface', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppFilterChip(label: 'Завтра', onTap: () {})),
    );
    await tester.pumpAndSettle();

    expect(kitDecorationOf(tester, AppFilterChip).color, kitColors.surface);
    expect(kitStyleOf(tester, 'Завтра')?.color, kitColors.ink);
  });

  testWidgets('AppChipGroup wraps its chips', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppChipGroup(
          chips: [
            AppFilterChip(label: 'A', onTap: () {}),
            AppFilterChip(label: 'B', onTap: () {}),
          ],
        ),
      ),
    );

    expect(find.byType(Wrap), findsOneWidget);
    expect(find.byType(AppFilterChip), findsNWidgets(2));
  });
}
