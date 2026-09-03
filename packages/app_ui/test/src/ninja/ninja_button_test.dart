import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  BoxDecoration decorationOf(WidgetTester tester) =>
      kitDecorationOf(tester, NinjaButton);

  group('NinjaButton', () {
    testWidgets('renders the label and fires onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapKit(
          NinjaButton.primary(
            label: 'Записаться',
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Записаться'), findsOneWidget);
      await tester.tap(find.byType(NinjaButton));
      expect(tapped, isTrue);
    });

    testWidgets('variants map onto the kit palette', (tester) async {
      final expected = <NinjaButtonVariant, Color>{
        NinjaButtonVariant.primary: kitColors.accent,
        NinjaButtonVariant.secondary: kitColors.surface2,
        NinjaButtonVariant.outline: kitColors.surface2,
        NinjaButtonVariant.tonal: kitColors.tint,
        NinjaButtonVariant.text: Colors.transparent,
        NinjaButtonVariant.destructive: kitColors.danger,
        NinjaButtonVariant.destructiveOutline: kitColors.examTint,
      };

      for (final entry in expected.entries) {
        await tester.pumpWidget(
          wrapKit(
            NinjaButton(
              label: 'Кнопка',
              variant: entry.key,
              onPressed: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(decorationOf(tester).color, entry.value);
      }
    });

    testWidgets('standard size stays 48 tall with no border', (tester) async {
      await tester.pumpWidget(
        wrapKit(NinjaButton.primary(label: 'Ок', onPressed: () {})),
      );

      expect(tester.getSize(find.byType(NinjaButton)).height, 48);
      expect(decorationOf(tester).border, isNull);
      expect(decorationOf(tester).boxShadow, isNull);
    });

    testWidgets('disabled uses canvas + muted2', (tester) async {
      await tester.pumpWidget(wrapKit(const NinjaButton(label: 'Нет')));

      expect(decorationOf(tester).color, kitColors.canvas);
      expect(kitStyleOf(tester, 'Нет')?.color, kitColors.muted2);
    });

    testWidgets('loading renders a spinner', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          NinjaButton.primary(
            label: 'Ждём',
            loading: true,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(AppButtonSpinner), findsOneWidget);
    });

    testWidgets('expanded stretches to the parent width', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 260,
            child: NinjaButton.primary(
              label: 'Шире',
              expanded: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(NinjaButton)).width, 260);
    });
  });

  group('NinjaIconButton', () {
    testWidgets('outline uses surface2, filled uses accent', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          NinjaIconButton(
            icon: const AppLineIconWidget(AppLineIcon.settings),
            onPressed: () {},
          ),
        ),
      );
      expect(
        kitDecorationOf(tester, NinjaIconButton).color,
        kitColors.surface2,
      );

      await tester.pumpWidget(
        wrapKit(
          NinjaIconButton(
            icon: const AppLineIconWidget(AppLineIcon.plus),
            variant: NinjaIconButtonVariant.filled,
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(kitDecorationOf(tester, NinjaIconButton).color, kitColors.accent);
    });

    testWidgets('keeps a 44px target', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          NinjaIconButton(
            icon: const AppLineIconWidget(AppLineIcon.settings),
            onPressed: () {},
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(NinjaIconButton)),
        const Size.square(44),
      );
    });
  });

  group('NinjaFab', () {
    testWidgets('is a 56px accent circle that fires', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapKit(
          NinjaFab(
            icon: const AppLineIconWidget(AppLineIcon.plus),
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(tester.getSize(find.byType(NinjaFab)), const Size.square(56));
      expect(kitDecorationOf(tester, NinjaFab).color, kitColors.accent);
      await tester.tap(find.byType(NinjaFab));
      expect(tapped, isTrue);
    });
  });

  group('NinjaSplitButton', () {
    testWidgets('delegates to AppSplitButton', (tester) async {
      var menu = 0;
      await tester.pumpWidget(
        wrapKit(
          NinjaSplitButton(
            label: 'Записаться',
            onPressed: () {},
            onMenuPressed: () => menu++,
          ),
        ),
      );

      expect(find.byType(AppSplitButton), findsOneWidget);
      await tester.tap(find.byType(AppLineIconWidget));
      expect(menu, 1);
    });
  });
}
