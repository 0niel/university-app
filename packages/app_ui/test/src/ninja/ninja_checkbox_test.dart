import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  BoxDecoration boxOf(WidgetTester tester) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(AppCheckbox),
              matching: find.byType(Container),
            )
            .first,
      );

  testWidgets('off state is a 24px transparent box with a muted2 border', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(AppCheckbox(value: false, onChanged: (_) {})),
    );
    await tester.pumpAndSettle();

    final decoration = boxOf(tester);
    expect(decoration.color, Colors.transparent);
    expect(decoration.border, Border.all(color: kitColors.muted2, width: 2));
    expect(decoration.borderRadius, BorderRadius.circular(8));
  });

  testWidgets('on state fills with accent and draws a check', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppCheckbox(value: true, onChanged: (_) {})),
    );
    await tester.pumpAndSettle();

    expect(boxOf(tester).color, kitColors.accent);
    expect(find.byType(AppCheckMark), findsOneWidget);
  });

  testWidgets('indeterminate draws the 10x2.5 bar', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppCheckbox(value: false, indeterminate: true, onChanged: (_) {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(boxOf(tester).color, kitColors.accent);
    expect(find.byType(AppCheckMark), findsNothing);
    final bar = tester.widget<SizedBox>(
      find
          .descendant(
            of: find.byType(AppCheckbox),
            matching: find.byType(SizedBox),
          )
          .last,
    );
    expect(bar.width, 10);
    expect(bar.height, 2.5);
  });

  testWidgets('disabled uses the surface2 border and muted2 label', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(const AppCheckbox(value: false, label: 'Disabled')),
    );
    await tester.pumpAndSettle();

    final border = boxOf(tester).border;
    expect(border, Border.all(color: kitColors.surface2, width: 2));
    expect(kitStyleOf(tester, 'Disabled')?.color, kitColors.muted2);
  });

  testWidgets('tap reports the flipped value', (tester) async {
    bool? received;
    await tester.pumpWidget(
      wrapKit(
        AppCheckbox(value: false, onChanged: (value) => received = value),
      ),
    );

    await tester.tap(find.byType(AppCheckbox));
    expect(received, isTrue);
  });

  testWidgets('label sits 10px away in 13/600', (tester) async {
    await tester.pumpWidget(
      wrapKit(AppCheckbox(value: true, label: 'Выбран', onChanged: (_) {})),
    );

    expect(kitStyleOf(tester, 'Выбран')?.fontSize, 13);
    expect(kitStyleOf(tester, 'Выбран')?.fontWeight, FontWeight.w600);
  });

  testWidgets('NinjaCheckbox delegates to AppCheckbox', (tester) async {
    await tester.pumpWidget(
      wrapKit(NinjaCheckbox(value: true, onChanged: (_) {})),
    );

    expect(find.byType(AppCheckbox), findsOneWidget);
  });
}
