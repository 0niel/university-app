import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('renders filter pills and reports the selected value', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppChipRow<String>(
            value: 'news',
            items: const [
              AppChipRowItem(value: 'news', label: 'Новости'),
              AppChipRowItem(value: 'events', label: 'События'),
            ],
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppChip), findsNWidgets(2));
    await tester.tap(find.text('События'));
    expect(selected, 'events');
  });

  testWidgets('the selected pill is accent and the rest surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppChipRow<String>(
            value: 'news',
            items: const [
              AppChipRowItem(value: 'news', label: 'Новости'),
              AppChipRowItem(value: 'events', label: 'События'),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(kitStyleOf(tester, 'Новости')?.color, kitColors.onAccent);
    expect(kitStyleOf(tester, 'События')?.color, kitColors.ink);
  });

  testWidgets('scrolls full-bleed with padding on the scroller', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 200,
          child: AppChipRow<int>(
            value: 0,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            items: const [
              AppChipRowItem(value: 0, label: 'Один'),
              AppChipRowItem(value: 1, label: 'Два'),
              AppChipRowItem(value: 2, label: 'Три'),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final scroller = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );
    expect(scroller.scrollDirection, Axis.horizontal);
    expect(
      scroller.padding,
      const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
    );
  });

  testWidgets('nullable all value and public keys preserve tinted selection', (
    tester,
  ) async {
    String? value = 'campus';
    late StateSetter update;
    await tester.pumpWidget(
      wrapKit(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return SizedBox(
              width: 320,
              child: AppChipRow<String?>(
                value: value,
                style: AppChipStyle.tinted,
                onChanged: (next) => update(() => value = next),
                items: const [
                  AppChipRowItem(
                    key: ValueKey('all'),
                    value: null,
                    label: 'Все',
                  ),
                  AppChipRowItem(
                    key: ValueKey('campus'),
                    value: 'campus',
                    label: 'Кампус',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppChip>(find.byKey(const ValueKey('campus'))).selected,
      isTrue,
    );
    expect(
      tester.widget<AppChip>(find.byKey(const ValueKey('campus'))).style,
      AppChipStyle.tinted,
    );
    await tester.tap(find.byKey(const ValueKey('all')));
    await tester.pumpAndSettle();
    expect(value, isNull);
    expect(
      tester.widget<AppChip>(find.byKey(const ValueKey('all'))).selected,
      isTrue,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Все' &&
            widget.properties.selected == true,
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'reveals external selection only horizontally with reduced motion',
    (
      tester,
    ) async {
      final horizontal = ScrollController();
      final vertical = ScrollController();
      addTearDown(horizontal.dispose);
      addTearDown(vertical.dispose);
      var value = 0;
      late StateSetter update;
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 220,
            height: 300,
            child: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return SingleChildScrollView(
                  controller: vertical,
                  child: Column(
                    children: [
                      const SizedBox(height: 120),
                      AppChipRow<int>(
                        key: const ValueKey('categories'),
                        controller: horizontal,
                        value: value,
                        onChanged: (next) => update(() => value = next),
                        items: [
                          for (var i = 0; i < 8; i++)
                            AppChipRowItem(
                              key: ValueKey('category-$i'),
                              value: i,
                              label: 'Категория $i',
                            ),
                        ],
                      ),
                      const SizedBox(height: 1200),
                    ],
                  ),
                );
              },
            ),
          ),
          accessibleNavigation: true,
          textScale: 2,
        ),
      );
      await tester.pumpAndSettle();
      vertical.jumpTo(80);
      await tester.pump();
      update(() => value = 7);
      await tester.pump();
      await tester.pump();
      expect(horizontal.offset, greaterThan(0));
      expect(horizontal.position.isScrollingNotifier.value, isFalse);
      expect(vertical.offset, 80);
      final selected = find.byKey(const ValueKey('category-7'));
      expect(selected.hitTestable(), findsOneWidget);
      final row = tester.getRect(find.byKey(const ValueKey('categories')));
      expect(tester.getRect(selected).right, lessThanOrEqualTo(row.right + .5));
      update(() => value = 0);
      await tester.pump();
      await tester.pump();
      expect(horizontal.offset, closeTo(0, .5));
      expect(vertical.offset, 80);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('text scaling reveals selection without changing its value', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var scale = 1.0;
    late StateSetter update;
    final row = SizedBox(
      width: 220,
      child: AppChipRow<int>(
        controller: controller,
        value: 3,
        onChanged: (_) {},
        items: const [
          AppChipRowItem(value: 0, label: 'A'),
          AppChipRowItem(value: 1, label: 'B'),
          AppChipRowItem(value: 2, label: 'C'),
          AppChipRowItem(
            key: ValueKey('scaled-selection'),
            value: 3,
            label: 'D',
          ),
        ],
      ),
    );
    await tester.pumpWidget(
      wrapKit(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
              ),
              child: row,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
    update(() => scale = 3);
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(0));
    expect(
      find.byKey(const ValueKey('scaled-selection')).hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('item elements survive reordering by value', (tester) async {
    late StateSetter update;
    var reversed = false;
    await tester.pumpWidget(
      wrapKit(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            final values = reversed ? [2, 1, 0] : [0, 1, 2];
            return SizedBox(
              width: 200,
              child: AppChipRow<int>(
                value: 2,
                onChanged: (_) {},
                items: [
                  for (final value in values)
                    AppChipRowItem(
                      key: ValueKey('item-$value'),
                      value: value,
                      label: 'Item $value',
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    final selected = tester.element(find.byKey(const ValueKey('item-2')));
    update(() => reversed = true);
    await tester.pumpAndSettle();
    expect(
      tester.element(find.byKey(const ValueKey('item-2'))),
      same(selected),
    );
    expect(find.byKey(const ValueKey('item-2')).hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'oversized edge selections retain gutters and interior aligns start',
    (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      int? value;
      late StateSetter update;
      await tester.pumpWidget(
        wrapKit(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return SizedBox(
                width: 320,
                child: AppChipRow<int?>(
                  key: const ValueKey('row'),
                  controller: controller,
                  value: value,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  items: const [
                    AppChipRowItem(
                      key: ValueKey('first'),
                      value: null,
                      label: 'Все сервисы и приложения',
                    ),
                    AppChipRowItem(
                      key: ValueKey('middle'),
                      value: 1,
                      label: 'Очень длинная категория сервисов',
                    ),
                    AppChipRowItem(
                      key: ValueKey('last'),
                      value: 2,
                      label: 'Последняя категория приложений',
                    ),
                  ],
                ),
              );
            },
          ),
          textScale: 2,
          accessibleNavigation: true,
        ),
      );
      await tester.pumpAndSettle();
      final row = tester.getRect(find.byKey(const ValueKey('row')));
      final first = tester.getRect(find.byKey(const ValueKey('first')));
      expect(first.width, greaterThan(row.width - 40));
      expect(controller.offset, controller.position.minScrollExtent);
      expect(first.left, row.left + 20);

      update(() => value = 2);
      await tester.pumpAndSettle();
      expect(controller.offset, controller.position.maxScrollExtent);
      expect(
        tester.getRect(find.byKey(const ValueKey('last'))).right,
        closeTo(row.right - 20, .1),
      );

      update(() => value = 1);
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byKey(const ValueKey('middle'))).left,
        closeTo(row.left + 20, .1),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'nullable first selection keeps its gutter after desktop resize',
    (tester) async {
      tester.view
        ..physicalSize = const Size(1400, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final controller = ScrollController();
      addTearDown(controller.dispose);
      var width = 1280.0;
      int? value = 7;
      late StateSetter update;
      await tester.pumpWidget(
        wrapKit(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return SizedBox(
                width: width,
                child: AppChipRow<int?>(
                  key: const ValueKey('row'),
                  controller: controller,
                  value: value,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  items: [
                    const AppChipRowItem(
                      key: ValueKey('all'),
                      value: null,
                      label: 'Все',
                    ),
                    for (var index = 1; index < 8; index++)
                      AppChipRowItem(value: index, label: 'Категория $index'),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      update(() => width = 390);
      await tester.pump(const Duration(milliseconds: 50));
      update(() => value = null);
      await tester.pumpAndSettle();
      final row = tester.getRect(find.byKey(const ValueKey('row')));
      expect(controller.offset, controller.position.minScrollExtent);
      expect(
        tester.getRect(find.byKey(const ValueKey('all'))).left,
        closeTo(row.left + 20, .1),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
