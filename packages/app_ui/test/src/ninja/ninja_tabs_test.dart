import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  const tabs = [
    NinjaTab(value: 'current', label: 'Текущий'),
    NinjaTab(value: 'all', label: 'Все семестры'),
    NinjaTab(value: 'rating', label: 'Рейтинг', count: 4),
  ];

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  TextStyle? styleOf(WidgetTester tester, String label) {
    final text = tester.widget<Text>(find.text(label));
    if (text.style case final style?) return style;
    return tester
        .widget<AnimatedDefaultTextStyle>(
          find
              .ancestor(
                of: find.text(label),
                matching: find.byType(AnimatedDefaultTextStyle),
              )
              .first,
        )
        .style;
  }

  group('NinjaTabs', () {
    testWidgets('keeps navigation surface free from divider boards', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaTabs<String>(tabs: tabs, value: 'current', onChanged: (_) {}),
        ),
      );

      final decorations = tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(NinjaTabs<String>),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((widget) => widget.decoration)
          .whereType<BoxDecoration>();
      expect(
        decorations.where((decoration) => decoration.border != null),
        isEmpty,
      );
    });

    testWidgets('the active tab is an ink pill', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaTabs<String>(tabs: tabs, value: 'current', onChanged: (_) {}),
        ),
      );

      final pills = tester
          .widgetList<AnimatedContainer>(
            find.descendant(
              of: find.byType(NinjaTabs<String>),
              matching: find.byType(AnimatedContainer),
            ),
          )
          .toList();
      final active = pills.first.decoration! as BoxDecoration;
      expect(active.color, colors.ink);
      expect(active.borderRadius, BorderRadius.circular(NinjaRadius.pill));
      expect(pills.first.constraints?.minHeight, NinjaMetrics.minTouchTarget);
      expect(styleOf(tester, 'Текущий')?.fontWeight, FontWeight.w700);
      expect(styleOf(tester, 'Текущий')?.color, colors.onInk);
    });

    testWidgets('inactive tabs stay quiet pills', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaTabs<String>(tabs: tabs, value: 'current', onChanged: (_) {}),
        ),
      );

      final pills = tester
          .widgetList<AnimatedContainer>(
            find.descendant(
              of: find.byType(NinjaTabs<String>),
              matching: find.byType(AnimatedContainer),
            ),
          )
          .toList();
      final inactive = pills[1].decoration! as BoxDecoration;
      expect(inactive.color, colors.surfaceAlt);
      expect(inactive.borderRadius, BorderRadius.circular(NinjaRadius.pill));
      expect(styleOf(tester, 'Все семестры')?.fontWeight, FontWeight.w600);
      expect(styleOf(tester, 'Все семестры')?.color, colors.mutedDark);
    });

    testWidgets('a count uses the neutral tab language', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaTabs<String>(tabs: tabs, value: 'current', onChanged: (_) {}),
        ),
      );

      expect(find.text('4'), findsOneWidget);
      final badge = tester.widget<DecoratedBox>(
        find
            .ancestor(of: find.text('4'), matching: find.byType(DecoratedBox))
            .first,
      );
      expect((badge.decoration as BoxDecoration).color, colors.surface);
      expect(styleOf(tester, '4')?.color, colors.mutedDark);
    });

    testWidgets('tapping a tab reports its value', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          NinjaTabs<String>(
            tabs: tabs,
            value: 'current',
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('Рейтинг'));
      expect(changed, 'rating');
    });

    testWidgets('reveals the selected tab at 320px and 200 percent text', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: NinjaTheme.light(),
          builder: (context, page) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(2),
              accessibleNavigation: true,
            ),
            child: page!,
          ),
          home: Scaffold(
            body: NinjaTabs<String>(
              tabs: const [
                NinjaTab(value: 'one', label: 'Первый раздел'),
                NinjaTab(value: 'two', label: 'Второй раздел'),
                NinjaTab(value: 'three', label: 'Третий раздел'),
                NinjaTab(value: 'four', label: 'Выбранный раздел'),
              ],
              value: 'four',
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pump();

      final viewport = tester.getRect(find.byType(SingleChildScrollView));
      final selected = tester.getRect(find.text('Выбранный раздел'));
      expect(selected.left, greaterThanOrEqualTo(viewport.left));
      expect(selected.right, lessThanOrEqualTo(viewport.right));
      expect(tester.takeException(), isNull);
    });

    testWidgets('auto reveal never moves an enclosing vertical scroll', (
      tester,
    ) async {
      final outer = ScrollController();
      addTearDown(outer.dispose);

      await tester.pumpWidget(
        wrap(
          SingleChildScrollView(
            controller: outer,
            child: Column(
              children: [
                const SizedBox(height: 500),
                NinjaTabs<String>(
                  tabs: const [
                    NinjaTab(value: 'one', label: 'Первый'),
                    NinjaTab(value: 'two', label: 'Второй'),
                    NinjaTab(value: 'three', label: 'Третий'),
                    NinjaTab(value: 'four', label: 'Четвёртый'),
                  ],
                  value: 'four',
                  onChanged: (_) {},
                ),
                const SizedBox(height: 500),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(outer.offset, 0);
    });
  });
}
