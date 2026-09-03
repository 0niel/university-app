import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  testWidgets('is a 48px surface2 field with a chevron', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 240,
          child: AppSelectField(value: 'Каждую неделю', onTap: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Каждую неделю'), findsOneWidget);
    expect(tester.getSize(find.byType(AppSelectField)).height, 48);
    final decoration = kitDecorationOf(tester, AppSelectField);
    expect(decoration.color, kitColors.surface2);
    expect(decoration.borderRadius, BorderRadius.circular(AppRadius.field));
    expect(kitStyleOf(tester, 'Каждую неделю')?.color, kitColors.ink);
  });

  testWidgets('placeholder is muted2 when there is no value', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 240,
          child: AppSelectField(placeholder: 'Выберите', onTap: () {}),
        ),
      ),
    );

    expect(kitStyleOf(tester, 'Выберите')?.color, kitColors.muted2);
  });

  testWidgets('fires onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 240,
          child: AppSelectField(
            value: 'Раз в две недели',
            onTap: () => taps++,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AppSelectField));
    expect(taps, 1);
  });

  testWidgets('disabled uses canvas and ignores taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 240,
          child: AppSelectField(
            value: 'Недоступно',
            enabled: false,
            onTap: () => taps++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(kitDecorationOf(tester, AppSelectField).color, kitColors.canvas);
    await tester.tap(find.byType(AppSelectField), warnIfMissed: false);
    expect(taps, 0);
  });
}
