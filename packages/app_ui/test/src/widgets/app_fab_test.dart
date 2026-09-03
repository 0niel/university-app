import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  BoxDecoration decorationOf(WidgetTester tester) =>
      kitDecorationOf(tester, AppFab);

  testWidgets('is a 56px accent circle with a 24px icon', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(AppFab(icon: AppLineIcon.plus, onPressed: () => taps++)),
    );

    expect(tester.getSize(find.byType(AppFab)), const Size.square(56));
    expect(decorationOf(tester).color, kitColors.accent);
    expect(decorationOf(tester).boxShadow, isNull);
    expect(find.byType(FloatingActionButton), findsNothing);
    final icon = tester.widget<AppLineIconWidget>(
      find.byType(AppLineIconWidget),
    );
    expect(icon.size, 24);
    expect(icon.strokeWidth, 2.4);
    expect(icon.color, kitColors.onAccent);

    await tester.tap(find.byType(AppFab));
    expect(taps, 1);
  });

  testWidgets('extended variant renders the label in a 56px pill', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        AppFab.extended(
          icon: AppLineIcon.plus,
          label: 'Создать',
          onPressed: () {},
        ),
      ),
    );

    expect(find.text('Создать'), findsOneWidget);
    expect(tester.getSize(find.byType(AppFab)).height, 56);
    expect(kitStyleOf(tester, 'Создать')?.color, kitColors.onAccent);
    expect(kitStyleOf(tester, 'Создать')?.fontSize, 15);
  });

  testWidgets('disabled falls back to canvas and muted2', (tester) async {
    await tester.pumpWidget(
      wrapKit(const AppFab(icon: AppLineIcon.plus, onPressed: null)),
    );

    expect(decorationOf(tester).color, kitColors.canvas);
    expect(
      tester.widget<AppLineIconWidget>(find.byType(AppLineIconWidget)).color,
      kitColors.muted2,
    );
  });

  testWidgets('NinjaFab delegates to the same accent circle', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        NinjaFab(
          icon: const AppLineIconWidget(AppLineIcon.plus),
          onPressed: () {},
        ),
      ),
    );

    expect(tester.getSize(find.byType(NinjaFab)), const Size.square(56));
    expect(kitDecorationOf(tester, NinjaFab).color, kitColors.accent);
  });
}
