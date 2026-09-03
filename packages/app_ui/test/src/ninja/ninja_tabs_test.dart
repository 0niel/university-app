import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  const tabs = [
    NinjaTab(value: 0, label: 'Материалы', count: 4),
    NinjaTab(value: 1, label: 'Заметки', count: 1),
    NinjaTab(value: 2, label: 'Оценки'),
  ];

  Widget build({int value = 0, ValueChanged<int>? onChanged}) => wrapKit(
        SizedBox(
          width: 340,
          child: NinjaTabs<int>(
            tabs: tabs,
            value: value,
            onChanged: onChanged,
          ),
        ),
      );

  testWidgets('renders every label and its count pill', (tester) async {
    await tester.pumpWidget(build(onChanged: (_) {}));
    await tester.pumpAndSettle();

    expect(find.text('Материалы'), findsOneWidget);
    expect(find.text('Заметки'), findsOneWidget);
    expect(find.text('Оценки'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('selected tab is ink with an accent underline', (tester) async {
    await tester.pumpWidget(build(value: 1, onChanged: (_) {}));
    await tester.pumpAndSettle();

    expect(kitStyleOf(tester, 'Заметки')?.color, kitColors.ink);
    expect(kitStyleOf(tester, 'Материалы')?.color, kitColors.muted);
    expect(kitStyleOf(tester, 'Заметки')?.fontSize, 14);
    expect(kitStyleOf(tester, 'Заметки')?.fontWeight, FontWeight.w700);

    final decoration = kitDecoration(
      tester,
      find
          .ancestor(of: find.text('Заметки'), matching: find.byType(Container))
          .first,
    );
    expect(
      decoration.border,
      Border(bottom: BorderSide(color: kitColors.accent, width: 2)),
    );
  });

  testWidgets('the strip carries a 1px bottom line', (tester) async {
    await tester.pumpWidget(build(onChanged: (_) {}));
    await tester.pumpAndSettle();

    final decorated = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(NinjaTabs<int>),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect(
      (decorated.decoration as BoxDecoration).border,
      Border(bottom: BorderSide(color: kitColors.line)),
    );
  });

  testWidgets('tapping a tab reports its value', (tester) async {
    int? picked;
    await tester.pumpWidget(build(onChanged: (value) => picked = value));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Оценки'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Оценки'));
    expect(picked, 2);
  });
}
