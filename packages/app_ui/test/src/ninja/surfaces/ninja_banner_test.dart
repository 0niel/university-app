import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  group('NinjaBanner', () {
    testWidgets('info tone paints the tint with an 8px accent dot', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 360,
            child: NinjaBanner(title: 'Расписание обновлено 5 мин назад'),
          ),
        ),
      );

      final banner = kitDecorationOf(tester, NinjaBanner);
      expect(banner.color, kitColors.tint);
      expect(banner.borderRadius, BorderRadius.circular(AppRadius.banner));

      final dot = tester.widget<SizedBox>(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 8,
        ),
      );
      expect(dot.height, 8);
      final style = kitStyleOf(tester, 'Расписание обновлено 5 мин назад');
      expect(style?.fontSize, 13);
      expect(style?.fontWeight, FontWeight.w600);
      expect(style?.color, kitColors.ink);
    });

    testWidgets('danger tone shows the action in danger and fires it', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 360,
            child: NinjaBanner(
              title: 'Пара в 12:40 отменена',
              tone: NinjaBannerTone.danger,
              actionLabel: 'Подробнее',
              onAction: () => taps++,
            ),
          ),
        ),
      );

      expect(kitDecorationOf(tester, NinjaBanner).color, kitColors.examTint);
      final action = kitStyleOf(tester, 'Подробнее');
      expect(action?.fontSize, 12.5);
      expect(action?.fontWeight, FontWeight.w700);
      expect(action?.color, kitColors.danger);

      await tester.tap(find.text('Подробнее'));
      expect(taps, 1);
    });

    testWidgets('warn and success tones map to their tints', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NinjaBanner(title: 'Офлайн', tone: NinjaBannerTone.warn),
                NinjaBanner(title: 'Готово', tone: NinjaBannerTone.success),
              ],
            ),
          ),
        ),
      );

      final fills = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(NinjaBanner),
              matching: find.byType(Container),
            ),
          )
          .map((container) => (container.decoration! as BoxDecoration).color)
          .toList();
      expect(fills, [kitColors.warnTint, kitColors.lectureTint]);
    });
  });

  group('AppBanner', () {
    testWidgets('renders the tone tint, dot and 13/600 message', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 360,
            child: AppBanner(
              message: 'Офлайн · показаны сохранённые данные',
              tone: AppBannerTone.warn,
            ),
          ),
        ),
      );

      expect(kitDecorationOf(tester, AppBanner).color, kitColors.warnTint);
      final dot = tester.widget<AppDot>(find.byType(AppDot));
      expect(dot.size, 8);
      expect(dot.color, kitColors.warn);
      final style = kitStyleOf(tester, 'Офлайн · показаны сохранённые данные');
      expect(style?.fontSize, 13);
      expect(style?.fontWeight, FontWeight.w600);
    });

    testWidgets('action label uses the tone colour and taps through', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 360,
            child: AppBanner(
              message: 'Расписание обновлено',
              actionLabel: 'Что нового',
              onAction: () => taps++,
            ),
          ),
        ),
      );

      final action = kitStyleOf(tester, 'Что нового');
      expect(action?.fontWeight, FontWeight.w700);
      expect(action?.color, kitColors.accent);
      await tester.tap(find.text('Что нового'));
      expect(taps, 1);
    });
  });
}
