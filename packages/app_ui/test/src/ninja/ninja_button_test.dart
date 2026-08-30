import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(
    Widget child, {
    bool dark = false,
    bool accessibleNavigation = false,
  }) =>
      MaterialApp(
        theme: dark ? NinjaTheme.dark() : NinjaTheme.light(),
        builder: (context, page) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(accessibleNavigation: accessibleNavigation),
          child: page!,
        ),
        home: Scaffold(body: Center(child: child)),
      );

  BoxDecoration decorationOf(WidgetTester tester, Type type) {
    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(type),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    return box.decoration as BoxDecoration;
  }

  Color? labelColorOf(WidgetTester tester, String label) =>
      tester.widget<Text>(find.text(label)).style?.color;

  group('NinjaButton', () {
    testWidgets('renders the label and fires onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
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

    testWidgets('primary uses the accent fill with a readable label', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(NinjaButton.primary(label: 'Ок', onPressed: () {})),
      );

      expect(decorationOf(tester, NinjaButton).color, colors.brand);
      expect(labelColorOf(tester, 'Ок'), colors.onBrand);
    });

    testWidgets('press fill stops animating for accessible navigation', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaButton.primary(label: 'Ок', onPressed: () {}),
          accessibleNavigation: true,
        ),
      );

      final animation = tester.widget<TweenAnimationBuilder<Color?>>(
        find.descendant(
          of: find.byType(NinjaButton),
          matching: find.byType(TweenAnimationBuilder<Color?>),
        ),
      );
      expect(animation.duration, Duration.zero);
    });

    testWidgets('disabled uses the surface fill and blocks taps', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const NinjaButton(label: 'Недоступна')));

      expect(decorationOf(tester, NinjaButton).color, colors.surface);
      expect(labelColorOf(tester, 'Недоступна'), colors.disabled);
      await tester.tap(find.byType(NinjaButton));
    });

    testWidgets('loading shows the ring, keeps the fill and blocks taps', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          NinjaButton.primary(
            label: 'Загрузка',
            loading: true,
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(decorationOf(tester, NinjaButton).color, colors.indigo);

      await tester.tap(find.byType(NinjaButton));
      expect(tapped, isFalse);
    });

    testWidgets('sizes map to the spec heights and stay pills', (tester) async {
      const expected = {
        NinjaButtonSize.small: (44.0, NinjaRadius.button),
        NinjaButtonSize.medium: (48.0, NinjaRadius.button),
        NinjaButtonSize.large: (52.0, NinjaRadius.button),
        NinjaButtonSize.standard: (48.0, NinjaRadius.button),
      };

      for (final entry in expected.entries) {
        await tester.pumpWidget(
          wrap(
            NinjaButton.primary(
              label: 'X',
              size: entry.key,
              onPressed: () {},
            ),
          ),
        );

        final constrained = tester.widget<ConstrainedBox>(
          find
              .descendant(
                of: find.byType(NinjaButton),
                matching: find.byType(ConstrainedBox),
              )
              .first,
        );
        expect(
          constrained.constraints.minHeight,
          entry.value.$1,
          reason: '${entry.key} height',
        );
        expect(
          decorationOf(tester, NinjaButton).borderRadius,
          BorderRadius.circular(entry.value.$2),
          reason: '${entry.key} radius',
        );
      }
    });

    testWidgets('outline stays quiet and destructive uses scarlet', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(NinjaButton.outline(label: 'Обводка', onPressed: () {})),
      );
      final outline = decorationOf(tester, NinjaButton);
      expect(outline.color, colors.surfaceAlt);
      expect(outline.border, isNull);
      expect(labelColorOf(tester, 'Обводка'), colors.ink);

      await tester.pumpWidget(
        wrap(NinjaButton.destructive(label: 'Удалить', onPressed: () {})),
      );
      await tester.pumpAndSettle();
      expect(decorationOf(tester, NinjaButton).color, colors.scarlet);
      expect(labelColorOf(tester, 'Удалить'), Colors.white);
    });

    testWidgets('expanded stretches to the available width', (tester) async {
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 300,
            child: NinjaButton.primary(
              label: 'Во всю ширину',
              expanded: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(NinjaButton)).width, 300);
    });

    testWidgets('a leading icon is rendered before the label', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaButton.secondary(
            label: 'Маршрут',
            icon: const Icon(Icons.map_outlined),
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.map_outlined), findsOneWidget);
      expect(decorationOf(tester, NinjaButton).color, colors.surfaceAlt);
    });
  });

  group('NinjaIconButton', () {
    testWidgets('outline uses a quiet fill and fires onPressed', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          NinjaIconButton(
            icon: const Icon(Icons.add),
            onPressed: () => tapped = true,
          ),
        ),
      );

      final decoration = decorationOf(tester, NinjaIconButton);
      expect(decoration.color, colors.surfaceAlt);
      expect(decoration.border, isNull);
      expect(
        tester.getSize(find.byType(NinjaIconButton)),
        const Size.square(NinjaMetrics.minTouchTarget),
      );

      await tester.tap(find.byType(NinjaIconButton));
      expect(tapped, isTrue);
    });

    testWidgets('filled is the accent block without a border', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaIconButton(
            icon: const Icon(Icons.search),
            variant: NinjaIconButtonVariant.filled,
            onPressed: () {},
          ),
        ),
      );

      final decoration = decorationOf(tester, NinjaIconButton);
      expect(decoration.color, colors.indigo);
      expect(decoration.border, isNull);
    });

    testWidgets('disabled blocks taps', (tester) async {
      await tester.pumpWidget(
        wrap(const NinjaIconButton(icon: Icon(Icons.add))),
      );

      expect(decorationOf(tester, NinjaIconButton).color, colors.surface);
      await tester.tap(find.byType(NinjaIconButton));
    });
  });

  group('NinjaFab', () {
    testWidgets('is a flat 56 accent circle that fires onPressed',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          NinjaFab(
            icon: const Icon(Icons.add),
            onPressed: () => tapped = true,
          ),
        ),
      );

      final decoration = decorationOf(tester, NinjaFab);
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, colors.indigo);
      expect(decoration.boxShadow, isNull);
      expect(tester.getSize(find.byType(NinjaFab)), const Size.square(56));

      await tester.tap(find.byType(NinjaFab));
      expect(tapped, isTrue);
    });

    testWidgets('drops the shadow in dark mode', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaFab(icon: const Icon(Icons.add), onPressed: () {}),
          dark: true,
        ),
      );

      expect(decorationOf(tester, NinjaFab).boxShadow, isNull);
    });
  });

  group('NinjaSplitButton', () {
    testWidgets('routes the label and the chevron to different handlers', (
      tester,
    ) async {
      var main = 0;
      var menu = 0;
      await tester.pumpWidget(
        wrap(
          NinjaSplitButton(
            label: 'Маршрут',
            onPressed: () => main++,
            onMenuPressed: () => menu++,
          ),
        ),
      );

      await tester.tap(find.text('Маршрут'));
      expect((main, menu), (1, 0));

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
      expect((main, menu), (1, 1));
    });

    testWidgets('the chevron segment darkens the accent behind a divider', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaSplitButton(
            label: 'Маршрут',
            onPressed: () {},
            onMenuPressed: () {},
          ),
        ),
      );

      final decoration = decorationOf(tester, NinjaSplitButton);
      final divider = (decoration.border as Border?)?.left;
      expect(decoration.color, colors.brand.withValues(alpha: 0.82));
      expect(divider?.width, NinjaMetrics.lineWidth);
      expect(divider?.color, colors.onBrand.withValues(alpha: 0.15));
    });
  });
}
