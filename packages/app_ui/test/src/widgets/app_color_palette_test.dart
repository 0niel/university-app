import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  Widget host(Widget child) =>
      wrapKit(SingleChildScrollView(child: SizedBox(width: 360, child: child)));

  group('AppColorPalette', () {
    testWidgets('has at least 30 curated swatches grouped in hue order', (
      tester,
    ) async {
      expect(kAppColorPaletteSwatches.length, greaterThanOrEqualTo(30));
      expect(kAppColorPaletteSwatches.length % 3, 0);
      var lastHue = -1.0;
      for (var i = 1; i < kAppColorPaletteSwatches.length; i += 3) {
        final hue = HSVColor.fromColor(Color(kAppColorPaletteSwatches[i])).hue;
        expect(hue, greaterThan(lastHue));
        lastHue = hue;
      }
    });

    testWidgets('tapping a swatch reports the new value', (tester) async {
      int? picked;
      await tester.pumpWidget(
        host(
          AppColorPalette(
            value: kAppColorPaletteSwatches.first,
            onChanged: (value) => picked = value,
            customLabel: 'Свой цвет',
            hexLabel: 'HEX',
            hexInvalidLabel: 'Неверный HEX-код',
          ),
        ),
      );

      final target = kAppColorPaletteSwatches[5];
      await tester.tap(find.byKey(ValueKey('app-color-swatch-$target')));
      await tester.pump();

      expect(picked, target);
    });

    testWidgets('selected swatch shows a check and accent ring', (
      tester,
    ) async {
      final value = kAppColorPaletteSwatches[3];
      await tester.pumpWidget(
        host(
          AppColorPalette(
            value: value,
            onChanged: (_) {},
            customLabel: 'Свой цвет',
            hexLabel: 'HEX',
            hexInvalidLabel: 'Неверный HEX-код',
          ),
        ),
      );

      final swatchFinder = find.byKey(ValueKey('app-color-swatch-$value'));
      expect(
        find.descendant(of: swatchFinder, matching: find.byType(AppCheckMark)),
        findsOneWidget,
      );
      final container = tester.widget<Container>(
        find
            .descendant(of: swatchFinder, matching: find.byType(Container))
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border!.top.color, kitColors.accent);
      expect(decoration.border!.top.width, 2);
    });

    testWidgets('marked default swatches show a dot when unselected', (
      tester,
    ) async {
      final marked = kAppColorPaletteSwatches[10];
      await tester.pumpWidget(
        host(
          AppColorPalette(
            value: kAppColorPaletteSwatches.first,
            onChanged: (_) {},
            customLabel: 'Свой цвет',
            hexLabel: 'HEX',
            hexInvalidLabel: 'Неверный HEX-код',
            markedValues: {marked},
          ),
        ),
      );

      final swatchFinder = find.byKey(ValueKey('app-color-swatch-$marked'));
      expect(
        find.descendant(of: swatchFinder, matching: find.byType(AppCheckMark)),
        findsNothing,
      );
      expect(
        find.descendant(
          of: swatchFinder,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.constraints?.maxWidth == 8 &&
                (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('typing a valid hex reports the parsed color live', (
      tester,
    ) async {
      int? picked;
      await tester.pumpWidget(
        host(
          AppColorPalette(
            value: kAppColorPaletteSwatches.first,
            onChanged: (value) => picked = value,
            customLabel: 'Свой цвет',
            hexLabel: 'HEX',
            hexInvalidLabel: 'Неверный HEX-код',
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const ValueKey('app-color-hex-field')),
        '2F7AFF',
      );
      await tester.pump();

      expect(picked, 0xFF2F7AFF);
      expect(find.text('Неверный HEX-код'), findsNothing);
    });

    testWidgets('invalid hex shows the error and does not call onChanged', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        host(
          AppColorPalette(
            value: kAppColorPaletteSwatches.first,
            onChanged: (_) => calls++,
            customLabel: 'Свой цвет',
            hexLabel: 'HEX',
            hexInvalidLabel: 'Неверный HEX-код',
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const ValueKey('app-color-hex-field')),
        'ZZZ',
      );
      await tester.pump();

      expect(find.text('Неверный HEX-код'), findsOneWidget);
      expect(calls, 0);
    });

    testWidgets('reset restores the default value only when not already set', (
      tester,
    ) async {
      final swatches = [
        for (var i = 0; i < kAppColorPaletteSwatches.length; i++)
          kAppColorPaletteSwatches[i],
      ];
      final defaultValue = swatches[7];
      int? picked;
      await tester.pumpWidget(
        host(
          AppColorPalette(
            value: swatches.first,
            onChanged: (value) => picked = value,
            customLabel: 'Свой цвет',
            hexLabel: 'HEX',
            hexInvalidLabel: 'Неверный HEX-код',
            defaultValue: defaultValue,
            resetLabel: 'Сбросить',
          ),
        ),
      );

      final resetButton = tester.widget<AppButton>(
        find.byKey(const ValueKey('app-color-reset')),
      );
      expect(resetButton.onPressed, isNotNull);
      await tester.tap(find.byKey(const ValueKey('app-color-reset')));
      await tester.pump();

      expect(picked, defaultValue);
    });

    testWidgets('reset is disabled once value matches the default', (
      tester,
    ) async {
      final defaultValue = kAppColorPaletteSwatches[2];
      await tester.pumpWidget(
        host(
          AppColorPalette(
            value: defaultValue,
            onChanged: (_) {},
            customLabel: 'Свой цвет',
            hexLabel: 'HEX',
            hexInvalidLabel: 'Неверный HEX-код',
            defaultValue: defaultValue,
            resetLabel: 'Сбросить',
          ),
        ),
      );

      final resetButton = tester.widget<AppButton>(
        find.byKey(const ValueKey('app-color-reset')),
      );
      expect(resetButton.onPressed, isNull);
    });

    testWidgets('reset row is absent without a default value', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          AppColorPalette(
            value: kAppColorPaletteSwatches.first,
            onChanged: (_) {},
            customLabel: 'Свой цвет',
            hexLabel: 'HEX',
            hexInvalidLabel: 'Неверный HEX-код',
          ),
        ),
      );

      expect(find.byKey(const ValueKey('app-color-reset')), findsNothing);
    });
  });
}
