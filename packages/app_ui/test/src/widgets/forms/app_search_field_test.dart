import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  testWidgets('is a 50px surface2 pill with a search glyph', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSearchField(
            controller: controller,
            hintText: 'Поиск по всему приложению',
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(AppSearchField)).height, 50);
    final decoration = kitDecorationOf(tester, AppSearchField);
    expect(decoration.color, kitColors.surface2);
    expect(decoration.borderRadius, BorderRadius.circular(AppRadius.full));
    expect(find.text('Поиск по всему приложению'), findsOneWidget);
  });

  testWidgets('onCanvas swaps the fill to surface', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSearchField(controller: controller, onCanvas: true),
        ),
      ),
    );

    expect(kitDecorationOf(tester, AppSearchField).color, kitColors.surface);
  });

  testWidgets('clear button empties the query', (tester) async {
    final controller = TextEditingController(text: 'физика');
    addTearDown(controller.dispose);
    var cleared = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSearchField(
            controller: controller,
            onClear: () => cleared++,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppLineIconWidget).last);
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(cleared, 1);
  });

  testWidgets('trailing icon renders next to the query', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSearchField(
            controller: controller,
            trailingIcon: AppLineIcon.mic,
            onTrailingTap: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppLineIconWidget), findsNWidgets(2));
  });

  testWidgets('AppSearchBar.button is a tappable non-editable pill', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSearchBar.button(hintText: 'Поиск', onTap: () => taps++),
        ),
      ),
    );

    expect(find.byType(TextField), findsNothing);
    await tester.tap(find.byType(AppSearchBar));
    expect(taps, 1);
  });
}
