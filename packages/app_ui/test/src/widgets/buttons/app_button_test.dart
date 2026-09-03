import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  BoxDecoration decorationOf(WidgetTester tester) =>
      kitDecorationOf(tester, AppButton);

  group('AppButton', () {
    testWidgets('renders the label and fires onPressed', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapKit(
          AppButton.primary(label: 'Записаться', onPressed: () => taps++),
        ),
      );

      expect(find.text('Записаться'), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      expect(taps, 1);
    });

    testWidgets('primary paints the accent fill with onAccent label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(AppButton.primary(label: 'Ок', onPressed: () {})),
      );

      expect(decorationOf(tester).color, kitColors.accent);
      expect(kitStyleOf(tester, 'Ок')?.color, kitColors.onAccent);
      expect(kitStyleOf(tester, 'Ок')?.fontSize, 13.5);
    });

    testWidgets('secondary uses surface2 and ink', (tester) async {
      await tester.pumpWidget(
        wrapKit(AppButton.secondary(label: 'Отмена', onPressed: () {})),
      );

      expect(decorationOf(tester).color, kitColors.surface2);
      expect(kitStyleOf(tester, 'Отмена')?.color, kitColors.ink);
    });

    testWidgets('text style override retains size, palette and interaction', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapKit(
          AppButton.secondary(
            label: 'Маршрут',
            size: AppButtonSize.small,
            textStyle: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
            onPressed: () => taps++,
          ),
        ),
      );
      final style = kitStyleOf(tester, 'Маршрут');
      expect(style?.fontSize, 13.5);
      expect(style?.fontWeight, FontWeight.w700);
      expect(style?.fontFamily, AppText.sansFamily);
      expect(style?.color, kitColors.ink);
      expect(tester.getSize(find.byType(AppButton)).height, 44);
      await tester.tap(find.byType(AppButton));
      expect(taps, 1);
    });

    testWidgets('tonal uses tint over accent text', (tester) async {
      await tester.pumpWidget(
        wrapKit(AppButton.tonal(label: 'Tonal', onPressed: () {})),
      );

      expect(decorationOf(tester).color, kitColors.tint);
      expect(kitStyleOf(tester, 'Tonal')?.color, kitColors.accent);
    });

    testWidgets('text variant is transparent with accent label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(AppButton.text(label: 'Text', onPressed: () {})),
      );

      expect(decorationOf(tester).color, Colors.transparent);
      expect(kitStyleOf(tester, 'Text')?.color, kitColors.accent);
    });

    testWidgets('destructive variants use danger and its tint', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(AppButton.destructive(label: 'Удалить', onPressed: () {})),
      );
      expect(decorationOf(tester).color, kitColors.danger);
      expect(kitStyleOf(tester, 'Удалить')?.color, kitColors.white);

      await tester.pumpWidget(
        wrapKit(
          AppButton.destructiveOutline(label: 'Выйти', onPressed: () {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(decorationOf(tester).color, kitColors.examTint);
      expect(kitStyleOf(tester, 'Выйти')?.color, kitColors.danger);
    });

    testWidgets('disabled falls back to canvas and muted2', (tester) async {
      await tester.pumpWidget(
        wrapKit(const AppButton.primary(label: 'Нельзя')),
      );

      expect(decorationOf(tester).color, kitColors.canvas);
      expect(kitStyleOf(tester, 'Нельзя')?.color, kitColors.muted2);
    });

    testWidgets('loading shows a 16px spinner and blocks taps', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapKit(
          AppButton.primary(
            label: 'Ждём',
            loading: true,
            onPressed: () => taps++,
          ),
        ),
      );

      expect(find.byType(AppButtonSpinner), findsOneWidget);
      expect(
        tester.getSize(find.byType(AppButtonSpinner)),
        const Size.square(16),
      );
      await tester.tap(find.byType(AppButton));
      expect(taps, 0);
    });

    testWidgets('sizes map to 44 / 48 / 52 / 56 pill heights', (tester) async {
      const expected = {
        AppButtonSize.small: 44.0,
        AppButtonSize.medium: 48.0,
        AppButtonSize.large: 52.0,
        AppButtonSize.hero: 56.0,
      };
      for (final entry in expected.entries) {
        await tester.pumpWidget(
          wrapKit(
            AppButton.primary(
              label: 'Размер',
              size: entry.key,
              onPressed: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.getSize(find.byType(AppButton)).height, entry.value);
      }
    });

    testWidgets('expanded fills the available width', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 300,
            child: AppButton.primary(
              label: 'Во всю ширину',
              expanded: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(AppButton)).width, 300);
    });

    testWidgets('pill radius comes from AppRadius.full', (tester) async {
      await tester.pumpWidget(
        wrapKit(AppButton.primary(label: 'Пилюля', onPressed: () {})),
      );

      expect(
        decorationOf(tester).borderRadius,
        BorderRadius.circular(AppRadius.full),
      );
    });

    testWidgets('has no shadow or border', (tester) async {
      await tester.pumpWidget(
        wrapKit(AppButton.primary(label: 'Плоско', onPressed: () {})),
      );

      final decoration = decorationOf(tester);
      expect(decoration.boxShadow, isNull);
      expect(decoration.border, isNull);
      expect(decoration.gradient, isNull);
    });
  });

  group('AppSplitButton', () {
    testWidgets('fires both halves independently', (tester) async {
      var main = 0;
      var menu = 0;
      await tester.pumpWidget(
        wrapKit(
          AppSplitButton(
            label: 'Записаться',
            onPressed: () => main++,
            onMenuPressed: () => menu++,
          ),
        ),
      );

      await tester.tap(find.text('Записаться'));
      expect(main, 1);
      expect(menu, 0);

      await tester.tap(find.byType(AppLineIconWidget));
      expect(menu, 1);
      expect(main, 1);
    });

    testWidgets('trailing half uses the pressed accent', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          AppSplitButton(
            label: 'Записаться',
            onPressed: () {},
            onMenuPressed: () {},
          ),
        ),
      );

      final containers = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(AppSplitButton),
              matching: find.byType(Container),
            ),
          )
          .toList();
      final trailing = containers.last.decoration! as BoxDecoration;
      expect(trailing.color, kitColors.accentPressed);
    });
  });
}
