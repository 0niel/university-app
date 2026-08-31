import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  const days = [
    NinjaWeekDay('ПН'),
    NinjaWeekDay('ВТ'),
    NinjaWeekDay('СР'),
    NinjaWeekDay('СБ', isWeekend: true),
  ];

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: child),
      );

  testWidgets('selected cell becomes a brand block with readable text', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const NinjaWeekStrip(days: days, selectedIndex: 2)),
    );

    expect(tester.widget<Text>(find.text('СР')).style?.color, colors.onBrand);
    expect(tester.widget<Text>(find.text('ПН')).style?.color, colors.mutedDark);
    expect(tester.widget<Text>(find.text('СБ')).style?.color, colors.muted);
    expect(tester.widget<Text>(find.text('ПН')).style?.fontSize, 13.5);
    expect(
      tester.widget<Text>(find.text('ПН')).style?.fontWeight,
      FontWeight.w700,
    );

    final selectedCells = tester
        .widgetList<AnimatedContainer>(
          find.descendant(
            of: find.byType(NinjaWeekStrip),
            matching: find.byType(AnimatedContainer),
          ),
        )
        .where(
          (container) =>
              (container.decoration as BoxDecoration?)?.color == colors.brand,
        );
    expect(selectedCells, hasLength(1));
    expect(tester.getSize(find.text('СР')).height, lessThan(44));
    expect(
      tester
          .getSize(
            find
                .ancestor(of: find.text('СР'), matching: find.byType(SizedBox))
                .first,
          )
          .height,
      greaterThanOrEqualTo(44),
    );
  });

  testWidgets('reports the tapped index', (tester) async {
    var selected = -1;
    await tester.pumpWidget(
      wrap(
        NinjaWeekStrip(
          days: days,
          selectedIndex: 0,
          onSelected: (index) => selected = index,
        ),
      ),
    );

    await tester.tap(find.text('СБ'));
    expect(selected, 3);
  });

  testWidgets('is inert without a callback', (tester) async {
    await tester.pumpWidget(
      wrap(const NinjaWeekStrip(days: days, selectedIndex: 0)),
    );
    await tester.tap(find.text('ВТ'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('stays usable at 320px and 200 percent text', (tester) async {
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: NinjaWeekStrip(days: days, selectedIndex: 1),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
