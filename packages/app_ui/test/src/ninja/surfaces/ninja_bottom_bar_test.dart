import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

const _transparent = Color(0x00000000);

Finder _tab(String label) => find.byWidgetPredicate(
      (widget) => widget is Semantics && widget.properties.label == label,
    );

Finder _pill(Color surfaceAlt) => find.descendant(
      of: find.byType(NinjaBottomBar),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            (widget.decoration as BoxDecoration?)?.color == surfaceAlt,
      ),
    );

final Finder _dot = find.descendant(
  of: find.byType(NinjaBottomBar),
  matching: find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        widget.constraints ==
            const BoxConstraints.tightFor(width: 7, height: 7),
  ),
);

List<AnimatedContainer> _circles(WidgetTester tester) => tester
    .widgetList<AnimatedContainer>(
      find.descendant(
        of: find.byType(NinjaBottomBar),
        matching: find.byType(AnimatedContainer),
      ),
    )
    .toList();

List<BoxDecoration> _circleFills(WidgetTester tester) => _circles(tester)
    .map((container) => container.decoration)
    .whereType<BoxDecoration>()
    .toList();

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(
          body: Align(alignment: Alignment.bottomCenter, child: child),
        ),
      );

  List<NinjaBottomBarItem> buildItems() => const [
        NinjaBottomBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Главная',
        ),
        NinjaBottomBarItem(icon: Icon(Icons.calendar_today), label: 'Пары'),
        NinjaBottomBarItem(
          icon: Icon(Icons.feed_outlined),
          label: 'Лента',
          hasBadge: true,
        ),
      ];

  group('NinjaBottomBar', () {
    testWidgets('fills the selected tab circle with brand and reports taps', (
      tester,
    ) async {
      var selected = -1;
      await tester.pumpWidget(
        wrap(
          NinjaBottomBar(
            items: buildItems(),
            currentIndex: 0,
            onSelected: (index) => selected = index,
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsNothing);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Главная' &&
              widget.properties.selected == true,
        ),
        findsOneWidget,
      );

      final fills = _circleFills(tester);
      expect(fills, hasLength(3));
      expect(fills.every((fill) => fill.shape == BoxShape.circle), isTrue);
      expect(fills.first.color, colors.brand);
      expect(
        fills.skip(1).map((fill) => fill.color),
        everyElement(_transparent),
      );
      expect(
        tester.getSize(find.byType(AnimatedContainer).first),
        const Size(46, 46),
      );
      expect(
        IconTheme.of(tester.element(find.byIcon(Icons.home))).color,
        colors.onBrand,
      );

      await tester.tap(find.byIcon(Icons.feed_outlined));
      expect(selected, 2);
    });

    testWidgets('sizes and tints icons through IconTheme', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaBottomBar(
            items: buildItems(),
            currentIndex: 0,
            onSelected: (_) {},
          ),
        ),
      );

      final active = IconTheme.of(tester.element(find.byIcon(Icons.home)));
      expect(active.size, 23);
      expect(active.color, colors.onBrand);
      final idle = IconTheme.of(
        tester.element(find.byIcon(Icons.calendar_today)),
      );
      expect(idle.size, 23);
      expect(idle.color, colors.mutedDark);
    });

    testWidgets('draws one 7px badge dot inside the tab circle', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaBottomBar(
            items: buildItems(),
            currentIndex: 0,
            onSelected: (_) {},
          ),
        ),
      );

      expect(_dot, findsOneWidget);
      final decoration =
          tester.widget<Container>(_dot).decoration! as BoxDecoration;
      expect(decoration.color, colors.brand);
      expect(decoration.shape, BoxShape.circle);
      expect(tester.getSize(_dot), const Size(7, 7));

      final circle = tester.getRect(
        find.ancestor(of: _dot, matching: find.byType(AnimatedContainer)).first,
      );
      final dotRect = tester.getRect(_dot);
      expect(circle.contains(dotRect.center), isTrue);
      expect(dotRect.center.dx, greaterThan(circle.center.dx));
      expect(dotRect.center.dy, lessThan(circle.center.dy));

      await tester.pumpWidget(
        wrap(
          NinjaBottomBar(
            items: buildItems(),
            currentIndex: 2,
            onSelected: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        (tester.widget<Container>(_dot).decoration! as BoxDecoration).color,
        colors.onBrand,
      );
    });

    testWidgets('floats one surfaceAlt pill on a transparent backdrop', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaBottomBar(
            items: buildItems(),
            currentIndex: 1,
            onSelected: (_) {},
          ),
        ),
      );

      final bar = find.byType(NinjaBottomBar);
      final pill = _pill(colors.surfaceAlt);
      expect(pill, findsOneWidget);

      final decoration =
          tester.widget<Container>(pill).decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(NinjaRadius.pill));
      expect(decoration.border, isNull);
      expect(decoration.boxShadow, isNull);
      expect(tester.getSize(pill).height, 64);

      final backdrops = tester
          .widgetList<ColoredBox>(
            find.descendant(of: bar, matching: find.byType(ColoredBox)),
          )
          .where((box) => box.color == colors.canvas);
      expect(backdrops, isEmpty);

      expect(
        find.descendant(
          of: bar,
          matching: find.byType(AnimatedPositionedDirectional),
        ),
        findsNothing,
      );

      final filled = _circleFills(
        tester,
      ).where((fill) => fill.color != _transparent).toList();
      expect(filled, hasLength(1));
      expect(filled.single.color, colors.brand);
    });

    testWidgets('keeps idle icons legible in AMOLED', (tester) async {
      final darkColors = NinjaColors.dark();
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.dark(),
          home: Scaffold(
            body: NinjaBottomBar(
              items: buildItems(),
              currentIndex: 0,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      final idle = IconTheme.of(
        tester.element(find.byIcon(Icons.calendar_today)),
      ).color!;
      final lighter = idle.computeLuminance() + 0.05;
      final darker = darkColors.surfaceAlt.computeLuminance() + 0.05;
      expect(lighter / darker, greaterThan(3));
    });

    testWidgets('disables selection transitions for reduced motion', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              accessibleNavigation: true,
              disableAnimations: true,
            ),
            child: child ?? const SizedBox.shrink(),
          ),
          home: Scaffold(
            body: NinjaBottomBar(
              items: buildItems(),
              currentIndex: 0,
              onSelected: (_) {},
            ),
          ),
        ),
      );

      final circles = _circles(tester);
      expect(circles, hasLength(3));
      expect(
        circles.every((widget) => widget.duration == Duration.zero),
        isTrue,
      );
      expect(
        find.descendant(
          of: find.byType(NinjaBottomBar),
          matching: find.byType(AnimatedScale),
        ),
        findsNothing,
      );
    });

    testWidgets('exposes each tab as an activatable selected-state button', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      var selected = -1;
      await tester.pumpWidget(
        wrap(
          NinjaBottomBar(
            items: buildItems(),
            currentIndex: 0,
            onSelected: (index) => selected = index,
          ),
        ),
      );

      expect(
        tester.getSemantics(_tab('Главная')),
        isSemantics(
          label: 'Главная',
          isButton: true,
          isSelected: true,
          hasTapAction: true,
        ),
      );
      expect(
        tester.getSemantics(_tab('Пары')),
        isSemantics(
          label: 'Пары',
          isButton: true,
          isSelected: false,
          hasTapAction: true,
        ),
      );

      tester.semantics.performAction(
        find.semantics.byLabel('Лента'),
        SemanticsAction.tap,
      );
      await tester.pump();
      expect(selected, 2);
      handle.dispose();
    });

    testWidgets('supports large text without overflowing', (tester) async {
      const items = [
        NinjaBottomBarItem(icon: Icon(Icons.home_outlined), label: 'Главная'),
        NinjaBottomBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Расписание',
        ),
        NinjaBottomBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'Карта кампуса',
        ),
        NinjaBottomBarItem(
          icon: Icon(Icons.apps_outlined),
          label: 'Все сервисы',
        ),
        NinjaBottomBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Мой профиль',
        ),
      ];
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 640),
              textScaler: TextScaler.linear(2),
            ),
            child: Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 320,
                  child: NinjaBottomBar(
                    items: items,
                    currentIndex: 0,
                    onSelected: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final circles = _circles(tester);
      expect(circles, hasLength(5));
      for (var index = 0; index < items.length; index++) {
        expect(
          tester.getSize(find.byType(AnimatedContainer).at(index)),
          const Size(52, 52),
        );
      }
      for (final item in items) {
        expect(find.text(item.label), findsNothing);
        expect(_tab(item.label), findsOneWidget);
      }
      expect(tester.getSize(_pill(colors.surfaceAlt)).height, 76);
      expect(
        tester.getSize(find.byType(NinjaBottomBar)).height,
        lessThanOrEqualTo(100),
      );
    });

    testWidgets('rail uses the same item semantics and a single marker', (
      tester,
    ) async {
      var selected = -1;
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          home: Scaffold(
            body: NinjaNavigationRail(
              items: buildItems(),
              currentIndex: 1,
              onSelected: (index) => selected = index,
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Пары' &&
              widget.properties.selected == true,
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(NinjaNavigationRail),
          matching: find.byType(AnimatedPositionedDirectional),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Лента'));
      expect(selected, 2);
    });

    testWidgets('rail keeps five destinations reachable in short landscape', (
      tester,
    ) async {
      const items = [
        NinjaBottomBarItem(icon: Icon(Icons.home_outlined), label: 'Главная'),
        NinjaBottomBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Расписание',
        ),
        NinjaBottomBarItem(icon: Icon(Icons.map_outlined), label: 'Карта'),
        NinjaBottomBarItem(icon: Icon(Icons.apps_outlined), label: 'Сервисы'),
        NinjaBottomBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Профиль',
        ),
      ];
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(720, 320),
              textScaler: TextScaler.linear(2),
              padding: EdgeInsets.symmetric(vertical: 12),
              viewPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 720,
                height: 320,
                child: NinjaNavigationRail(
                  items: items,
                  currentIndex: 4,
                  onSelected: (_) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final railRect = tester.getRect(find.byType(NinjaNavigationRail));
      final selectedRect = tester.getRect(find.text('Профиль'));
      expect(selectedRect.top, greaterThanOrEqualTo(railRect.top));
      expect(selectedRect.bottom, lessThanOrEqualTo(railRect.bottom));
      expect(find.text('Профиль'), findsOneWidget);
    });

    testWidgets('rail supports 200 percent text without overflowing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(900, 700),
              textScaler: TextScaler.linear(2),
            ),
            child: Scaffold(
              body: NinjaNavigationRail(
                items: buildItems(),
                currentIndex: 0,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(NinjaNavigationRail)).width, 176);
    });

    testWidgets('nested scaffold keeps its FAB above the adaptive floating bar',
        (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: const TextScaler.linear(2),
                padding: mediaQuery.padding.copyWith(bottom: 24),
                viewPadding: mediaQuery.viewPadding.copyWith(bottom: 24),
              ),
              child: child!,
            );
          },
          home: Builder(
            builder: (context) {
              final bottomInset = NinjaBottomBar.extentOf(context);
              return Scaffold(
                extendBody: true,
                body: NinjaBottomBarViewport(
                  bottomInset: bottomInset,
                  child: Scaffold(
                    floatingActionButton: NinjaFab(
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ),
                ),
                bottomNavigationBar: NinjaBottomBar(
                  items: buildItems(),
                  currentIndex: 0,
                  onSelected: (_) {},
                ),
              );
            },
          ),
        ),
      );

      final fab = tester.getRect(find.byType(NinjaFab));
      final bar = tester.getRect(find.byType(NinjaBottomBar));
      expect(bar.top - fab.bottom, 16);
    });
  });

  group('NinjaTextBottomBar', () {
    testWidgets('uses a soft active surface without dividers', (tester) async {
      var selected = -1;
      await tester.pumpWidget(
        wrap(
          NinjaTextBottomBar(
            labels: const ['Главная', 'Пары', 'Профиль'],
            currentIndex: 1,
            onSelected: (index) => selected = index,
          ),
        ),
      );

      final active = tester.widget<Text>(find.text('Пары')).style;
      expect(active?.fontWeight, FontWeight.w700);
      expect(active?.color, colors.brandInk);

      final idle = tester.widget<Text>(find.text('Профиль')).style;
      expect(idle?.fontWeight, FontWeight.w500);
      expect(idle?.color, colors.mutedDark);

      final decorated = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .where(
            (container) =>
                (container.decoration as BoxDecoration?)?.color ==
                colors.indigo.withValues(alpha: 0.1),
          );
      expect(decorated, hasLength(1));
      final borders = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .where((decoration) => decoration.border != null);
      expect(borders, isEmpty);

      await tester.tap(find.text('Профиль'));
      expect(selected, 2);
    });
  });
}
