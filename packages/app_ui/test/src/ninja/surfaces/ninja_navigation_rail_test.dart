import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  const items = [
    NinjaBottomBarItem(icon: Icon(Icons.home_outlined), label: 'Главная'),
    NinjaBottomBarItem(
      icon: Icon(Icons.calendar_month_outlined),
      label: 'Расписание занятий',
      hasBadge: true,
    ),
    NinjaBottomBarItem(icon: Icon(Icons.map_outlined), label: 'Карта'),
    NinjaBottomBarItem(icon: Icon(Icons.apps), label: 'Сервисы'),
    NinjaBottomBarItem(icon: Icon(Icons.person_outline), label: 'Профиль'),
  ];

  testWidgets('short landscape at 200% keeps all destinations reachable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(844, 260);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    int? selected;
    await tester.pumpWidget(
      wrapKit(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(844, 260),
            textScaler: TextScaler.linear(2),
            padding: EdgeInsets.only(left: 32, bottom: 16),
          ),
          child: Row(
            children: [
              NinjaNavigationRail(
                items: items,
                currentIndex: 2,
                extended: true,
                onSelected: (value) => selected = value,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(NinjaNavigationRail)).width, 112);
    expect(find.byType(Tooltip), findsNWidgets(items.length));
    expect(find.text('Расписание занятий'), findsNothing);
    final map = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Карта',
      ),
    );
    expect(map.properties.selected, isTrue);

    final profile = find.bySemanticsLabel('Профиль');
    await tester.ensureVisible(profile);
    await tester.pumpAndSettle();
    expect(profile.hitTestable(), findsOneWidget);
    expect(tester.getRect(profile).height, greaterThanOrEqualTo(48));
    await tester.tap(profile);
    expect(selected, 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets('compact items expose their full label on long press', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        NinjaNavigationRail(items: items, currentIndex: 1, onSelected: (_) {}),
      ),
    );

    await tester.longPress(find.bySemanticsLabel('Расписание занятий'));
    await tester.pumpAndSettle();
    expect(find.text('Расписание занятий'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('extended rail gives labels room and preserves selection', (
    tester,
  ) async {
    int? selected;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          height: 600,
          child: NinjaNavigationRail(
            items: items,
            currentIndex: 2,
            extended: true,
            onSelected: (value) => selected = value,
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(NinjaNavigationRail)).width, 220);
    final surface = tester.getRect(
      find.descendant(
        of: find.byType(NinjaNavigationRail),
        matching: find.byType(ClipRRect),
      ),
    );
    final rail = tester.getRect(find.byType(NinjaNavigationRail));
    expect(surface.height, lessThan(rail.height - 100));
    expect(surface.center.dy, closeTo(rail.center.dy, 0.01));
    expect(find.text('Расписание занятий'), findsOneWidget);
    expect(kitStyleOf(tester, 'Карта')?.color, kitColors.onAccent);
    expect(kitStyleOf(tester, 'Главная')?.color, kitColors.muted);
    await tester.tap(find.text('Профиль'));
    expect(selected, 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets('selection animation respects reduced motion', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        NinjaNavigationRail(items: items, currentIndex: 0, onSelected: (_) {}),
        accessibleNavigation: true,
      ),
    );

    final indicators = tester.widgetList<AnimatedContainer>(
      find.descendant(
        of: find.byType(NinjaNavigationRail),
        matching: find.byType(AnimatedContainer),
      ),
    );
    expect(indicators, hasLength(items.length));
    expect(
      indicators.every((widget) => widget.duration == Duration.zero),
      isTrue,
    );
  });
}
