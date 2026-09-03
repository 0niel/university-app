import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  BoxDecoration ringOf(WidgetTester tester) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(AppRadio<String>),
              matching: find.byType(Container),
            )
            .first,
      );

  BoxDecoration dotOf(WidgetTester tester) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(AppRadio<String>),
              matching: find.byType(Container),
            )
            .last,
      );

  testWidgets('unselected ring is muted2 with a transparent dot', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        AppRadio<String>(value: 'a', groupValue: 'b', onChanged: (_) {}),
      ),
    );
    await tester.pumpAndSettle();

    final border = ringOf(tester).border;
    expect(border, Border.all(color: kitColors.muted2, width: 2));
    expect(dotOf(tester).color, Colors.transparent);
  });

  testWidgets('selected ring and dot are accent', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppRadio<String>(value: 'a', groupValue: 'a', onChanged: (_) {}),
      ),
    );
    await tester.pumpAndSettle();

    final border = ringOf(tester).border;
    expect(border, Border.all(color: kitColors.accent, width: 2));
    expect(dotOf(tester).color, kitColors.accent);
  });

  testWidgets('tapping reports the value', (tester) async {
    String? picked;
    await tester.pumpWidget(
      wrapKit(
        AppRadio<String>(
          value: 'teacher',
          groupValue: 'group',
          label: 'Преподаватель',
          onChanged: (value) => picked = value,
        ),
      ),
    );

    await tester.tap(find.byType(AppRadio<String>));
    expect(picked, 'teacher');
  });

  testWidgets('keeps a 44px target', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppRadio<String>(value: 'a', groupValue: 'a', onChanged: (_) {}),
      ),
    );

    expect(tester.getSize(find.byType(AppRadio<String>)).height, 44);
  });

  testWidgets('NinjaRadio delegates to AppRadio', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        NinjaRadio<String>(value: 'a', groupValue: 'a', onChanged: (_) {}),
      ),
    );

    expect(find.byType(AppRadio<String>), findsOneWidget);
  });
}
