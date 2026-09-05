import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  const items = [
    NinjaBottomBarItem(icon: AppLineIconWidget(AppLineIcon.home), label: 'Дом'),
    NinjaBottomBarItem(
      icon: AppLineIconWidget(AppLineIcon.calendar),
      label: 'Пары',
      hasBadge: true,
    ),
    NinjaBottomBarItem(
      icon: AppLineIconWidget(AppLineIcon.map),
      label: 'Карта',
    ),
    NinjaBottomBarItem(
      icon: AppLineIconWidget(AppLineIcon.services),
      label: 'Сервисы',
    ),
    NinjaBottomBarItem(
      icon: AppLineIconWidget(AppLineIcon.user),
      label: 'Я',
      hasBadge: true,
    ),
  ];

  Widget host(Widget child) => wrapKit(SizedBox(width: 390, child: child));

  List<AnimatedContainer> circles(WidgetTester tester) => tester
      .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
      .toList();

  group('NinjaBottomBar', () {
    testWidgets('paints a 64px surface pill with 46px circles', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          NinjaBottomBar(items: items, currentIndex: 1, onSelected: (_) {}),
        ),
      );

      final pill = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(NinjaBottomBar),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(pill.constraints?.maxHeight, AppControlSize.bottomBar);
      final decoration = pill.decoration! as BoxDecoration;
      expect(decoration.color, kitColors.surface);
      expect(decoration.borderRadius, BorderRadius.circular(AppRadius.full));

      final all = circles(tester);
      expect(all, hasLength(5));
      expect(all.first.constraints?.maxWidth, AppControlSize.navCircle);
      expect(
        (all[1].decoration! as BoxDecoration).color,
        kitColors.accent,
      );
      expect(
        (all[0].decoration! as BoxDecoration).color,
        const Color(0x00000000),
      );
    });

    testWidgets('fades the canvas behind the bar and reserves 84px', (
      tester,
    ) async {
      late BuildContext captured;
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              captured = context;
              return NinjaBottomBar(
                items: items,
                currentIndex: 0,
                onSelected: (_) {},
              );
            },
          ),
        ),
      );

      final fade = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(NinjaBottomBar),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final gradient = (fade.decoration as BoxDecoration).gradient;
      expect(gradient, isA<LinearGradient>());
      expect((gradient! as LinearGradient).colors.first, kitColors.canvas);
      expect(NinjaBottomBar.extentOf(captured), 84);
      expect(tester.getSize(find.byType(NinjaBottomBar)).height, 84);
    });

    testWidgets('badge dots flip to onAccent on the selected item', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          NinjaBottomBar(items: items, currentIndex: 1, onSelected: (_) {}),
        ),
      );

      final dots = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .where(
            (box) =>
                box.child is SizedBox && (box.child! as SizedBox).width == 7,
          )
          .map((box) => (box.decoration as BoxDecoration).color)
          .toList();
      expect(dots, [kitColors.onAccent, kitColors.accent]);
    });

    testWidgets('icons are tinted onAccent / muted and taps select', (
      tester,
    ) async {
      int? picked;
      await tester.pumpWidget(
        host(
          NinjaBottomBar(
            items: items,
            currentIndex: 1,
            onSelected: (index) => picked = index,
          ),
        ),
      );

      final themes = tester
          .widgetList<IconTheme>(
            find.descendant(
              of: find.byType(AnimatedContainer),
              matching: find.byType(IconTheme),
            ),
          )
          .map((theme) => theme.data)
          .toList();
      expect(themes[1].color, kitColors.onAccent);
      expect(themes[0].color, kitColors.muted);
      expect(themes[0].size, 23);

      await tester.tap(find.bySemanticsLabel('Карта'));
      expect(picked, 2);
    });

    testWidgets('viewport reserves the inset in MediaQuery padding', (
      tester,
    ) async {
      late double bottom;
      late double extent;
      await tester.pumpWidget(
        host(
          NinjaBottomBarViewport(
            bottomInset: 102,
            child: Builder(
              builder: (context) {
                bottom = MediaQuery.paddingOf(context).bottom;
                extent = NinjaBottomBar.extentOf(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(bottom, 102);
      expect(extent, 102);
      expect(AppBottomBar, NinjaBottomBar);
      expect(AppBottomBarItem, NinjaBottomBarItem);
    });

    for (final scale in [1.0, 2.0]) {
      testWidgets('outside extent matches the bar with safe area at ${scale}x',
          (
        tester,
      ) async {
        late double extent;
        await tester.pumpWidget(
          host(
            MediaQuery(
              data: MediaQueryData(
                padding: const EdgeInsets.only(bottom: 34),
                viewPadding: const EdgeInsets.only(bottom: 34),
                textScaler: TextScaler.linear(scale),
              ),
              child: Builder(
                builder: (context) {
                  extent = AppBottomBar.extentOf(context);
                  return NinjaBottomBar(
                    items: items,
                    currentIndex: 0,
                    onSelected: (_) {},
                  );
                },
              ),
            ),
          ),
        );
        expect(extent, scale == 1 ? 118 : 130);
        expect(tester.getSize(find.byType(NinjaBottomBar)).height, extent);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('viewport extent updates without adding another bar height', (
      tester,
    ) async {
      late StateSetter update;
      late double extent;
      var inset = 136.0;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return NinjaBottomBarViewport(
                bottomInset: inset,
                child: Builder(
                  builder: (context) {
                    extent = AppBottomBar.extentOf(context);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
      expect(extent, 136);
      update(() => inset = 148);
      await tester.pump();
      expect(extent, 148);
      expect(tester.takeException(), isNull);
    });
  });

  group('NinjaNavigationRail', () {
    testWidgets('lists every label with the selected one in accent', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            height: 500,
            child: NinjaNavigationRail(
              items: items,
              currentIndex: 2,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Карта'), findsOneWidget);
      expect(kitStyleOf(tester, 'Карта')?.color, kitColors.accent);
      expect(kitStyleOf(tester, 'Дом')?.color, kitColors.muted);
    });
  });

  group('NinjaTextBottomBar', () {
    testWidgets('highlights the current label with an accent pill', (
      tester,
    ) async {
      int? picked;
      await tester.pumpWidget(
        host(
          NinjaTextBottomBar(
            labels: const ['День', 'Неделя', 'Месяц'],
            currentIndex: 0,
            onSelected: (index) => picked = index,
          ),
        ),
      );

      final tabs = circles(tester);
      expect((tabs[0].decoration! as BoxDecoration).color, kitColors.accent);
      expect(kitStyleOf(tester, 'День')?.color, kitColors.onAccent);
      expect(kitStyleOf(tester, 'Неделя')?.color, kitColors.muted);
      await tester.tap(find.text('Месяц'));
      expect(picked, 2);
    });
  });
}
