import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  Widget host(Widget child) => wrapKit(SizedBox(width: 360, child: child));

  Container cellContainer(WidgetTester tester) => tester.widget<Container>(
        find
            .descendant(
              of: find.byType(NinjaListCell),
              matching: find.byType(Container),
            )
            .first,
      );

  group('NinjaListCell', () {
    testWidgets('base cell is 14/500 ink with a muted2 chevron', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(NinjaListCell(title: 'Базовая ячейка', onTap: () {})),
      );

      final style = kitStyleOf(tester, 'Базовая ячейка');
      expect(style?.fontSize, 14);
      expect(style?.fontWeight, FontWeight.w500);
      expect(style?.color, kitColors.ink);
      expect(
        cellContainer(tester).padding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      );

      final chevron = tester.widget<AppLineIconWidget>(
        find.byType(AppLineIconWidget),
      );
      expect(chevron.icon, AppLineIcon.chevronR);
      expect(chevron.size, 14);
      expect(chevron.color, kitColors.muted2);
      expect(chevron.strokeWidth, 2.5);
    });

    testWidgets('subtitle tightens padding and adds a muted meta label', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const NinjaListCell(
            title: 'С подзаголовком',
            subtitle: 'Второй строкой — мета',
            trailingLabel: 'ИКБО-01-24',
          ),
        ),
      );

      expect(
        cellContainer(tester).padding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      );
      final subtitle = kitStyleOf(tester, 'Второй строкой — мета');
      expect(subtitle?.fontSize, 12);
      expect(subtitle?.color, kitColors.muted);
      final meta = kitStyleOf(tester, 'ИКБО-01-24');
      expect(meta?.fontSize, 12.5);
      expect(meta?.color, kitColors.muted);
    });

    testWidgets('destructive cell is danger without a chevron', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          NinjaListCell(
            title: 'Деструктивная ячейка',
            destructive: true,
            leading: const AppLineIconWidget(AppLineIcon.trash, size: 18),
            onTap: () {},
          ),
        ),
      );

      expect(
        kitStyleOf(tester, 'Деструктивная ячейка')?.color,
        kitColors.danger,
      );
      expect(
        tester
            .widgetList<AppLineIconWidget>(find.byType(AppLineIconWidget))
            .map((icon) => icon.icon),
        [AppLineIcon.trash],
      );
    });

    testWidgets('swipe to delete reveals a 72px danger pane and fires', (
      tester,
    ) async {
      var deleted = 0;
      await tester.pumpWidget(
        host(
          Column(
            children: [
              NinjaListCell(
                title: 'Swipe → удалить',
                onDelete: () => deleted++,
              ),
            ],
          ),
        ),
      );

      final dismissible = tester.widget<Dismissible>(find.byType(Dismissible));
      expect(dismissible.direction, DismissDirection.endToStart);
      final pane = dismissible.background! as ColoredBox;
      expect(pane.color, kitColors.danger);

      await tester.drag(find.text('Swipe → удалить'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(deleted, 1);
    });

    testWidgets('subject cell draws a 4px bar with tabular time', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          NinjaListCell.subject(
            title: 'Матанализ',
            time: '09:00',
            meta: 'Лекция · А-318',
            color: kitColors.lecture,
          ),
        ),
      );

      final bar = tester.widget<PositionedDirectional>(
        find.byType(PositionedDirectional),
      );
      expect(bar.width, 4);
      final barColor = kitDecoration(
        tester,
        find.descendant(
          of: find.byType(PositionedDirectional),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(barColor.color, kitColors.lecture);

      final title = kitStyleOf(tester, 'Матанализ');
      expect(title?.fontWeight, FontWeight.w600);
      final time = kitStyleOf(tester, '09:00');
      expect(time?.fontSize, 12);
      expect(time?.color, kitColors.muted);
      expect(time?.fontFeatures, contains(const FontFeature.tabularFigures()));
    });

    testWidgets('taps through', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(NinjaListCell(title: 'Тап', onTap: () => taps++)),
      );
      await tester.tap(find.text('Тап'));
      expect(taps, 1);
    });

    test('AppListCell is the same widget', () {
      expect(AppListCell, NinjaListCell);
    });
  });
}
