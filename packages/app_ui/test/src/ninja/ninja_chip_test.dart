import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  BoxDecoration chipOf(WidgetTester tester) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(AppChip),
              matching: find.byType(Container),
            )
            .first,
      );

  testWidgets('unselected chip is surface2 with muted label', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppChip(label: 'Лекции', onTap: () {})),
    );
    await tester.pumpAndSettle();

    expect(chipOf(tester).color, kitColors.surface2);
    expect(kitStyleOf(tester, 'Лекции')?.color, kitColors.muted);
    expect(kitStyleOf(tester, 'Лекции')?.fontSize, 13);
  });

  testWidgets('selected chip is tinted with accent label', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppChip(label: 'Все', selected: true, onTap: () {})),
    );
    await tester.pumpAndSettle();

    expect(chipOf(tester).color, kitColors.tint);
    expect(kitStyleOf(tester, 'Все')?.color, kitColors.accent);
  });

  testWidgets('disabled chip falls back to canvas / muted2', (tester) async {
    await tester.pumpWidget(
      wrapKit(const AppChip(label: 'Disabled', enabled: false)),
    );
    await tester.pumpAndSettle();

    expect(chipOf(tester).color, kitColors.canvas);
    expect(kitStyleOf(tester, 'Disabled')?.color, kitColors.muted2);
  });

  testWidgets('keeps a 44px minimum height and pill radius', (tester) async {
    await tester.pumpWidget(wrapKit(AppChip(label: 'Лабы', onTap: () {})));
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(AppChip)).height, 44);
    expect(
      chipOf(tester).borderRadius,
      BorderRadius.circular(AppRadius.full),
    );
  });

  testWidgets('count is rendered at 70% opacity', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppChip(label: 'Лекции', count: 12, onTap: () {})),
    );

    expect(find.text('12'), findsOneWidget);
    final opacity = tester.widget<Opacity>(
      find.ancestor(of: find.text('12'), matching: find.byType(Opacity)).first,
    );
    expect(opacity.opacity, 0.7);
  });

  testWidgets('dot and remove affordances render and fire', (tester) async {
    var removed = 0;
    await tester.pumpWidget(
      wrapKit(
        AppChip(
          label: 'Лабы',
          showDot: true,
          onTap: () {},
          onRemove: () => removed++,
        ),
      ),
    );

    expect(find.byType(AppLineIconWidget), findsOneWidget);
    await tester.tap(find.byType(AppLineIconWidget));
    expect(removed, 1);
  });

  testWidgets('filter variant uses surface / accent', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppChip.filter(label: 'Сегодня', onTap: () {})),
    );
    await tester.pumpAndSettle();
    expect(chipOf(tester).color, kitColors.surface);
    expect(kitStyleOf(tester, 'Сегодня')?.color, kitColors.ink);

    await tester.pumpWidget(
      wrapKit(AppChip.filter(label: 'Сегодня', selected: true, onTap: () {})),
    );
    await tester.pumpAndSettle();
    expect(chipOf(tester).color, kitColors.accent);
    expect(kitStyleOf(tester, 'Сегодня')?.color, kitColors.onAccent);
    expect(kitStyleOf(tester, 'Сегодня')?.fontWeight, FontWeight.w700);
  });

  testWidgets('exposes button + selected semantics', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppChip(label: 'Практики', selected: true, onTap: () {})),
    );

    final semantics = tester.getSemantics(find.byType(AppChip));
    expect(semantics.label, 'Практики');
  });

  testWidgets('NinjaChip delegates and NinjaChipRow scrolls', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 300,
          child: NinjaChipRow(
            children: [
              NinjaChip(label: 'Все', selected: true, onTap: () {}),
              NinjaChip(label: 'Лекции', onTap: () {}),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(AppChip), findsNWidgets(2));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
