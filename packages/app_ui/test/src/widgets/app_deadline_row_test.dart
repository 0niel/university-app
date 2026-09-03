import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  Widget host(Widget child) => wrapKit(SizedBox(width: 360, child: child));

  group('AppDeadlineRow', () {
    testWidgets('renders a 44px surface2 check, 14.5/600 title and label', (
      tester,
    ) async {
      var toggles = 0;
      await tester.pumpWidget(
        host(
          AppDeadlineRow(
            title: 'Отчёт по лаб. работе №2',
            meta: 'Физика · сегодня, 23:59',
            left: '5 ч',
            urgent: true,
            onToggle: () => toggles++,
          ),
        ),
      );

      final check = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(check.constraints?.maxWidth, AppControlSize.iconButton);
      expect((check.decoration! as BoxDecoration).color, kitColors.surface2);

      final title = kitStyleOf(tester, 'Отчёт по лаб. работе №2');
      expect(title?.fontSize, 14.5);
      expect(title?.fontWeight, FontWeight.w600);
      expect(title?.decoration, isNot(TextDecoration.lineThrough));
      expect(kitStyleOf(tester, 'Физика · сегодня, 23:59')?.fontSize, 12.5);
      final left = kitStyleOf(tester, '5 ч');
      expect(left?.fontSize, 12);
      expect(left?.fontWeight, FontWeight.w800);
      expect(left?.color, kitColors.danger);
      expect(
        tester
            .widget<AnimatedOpacity>(find.byType(AnimatedOpacity).first)
            .opacity,
        1,
      );

      await tester.tap(find.byType(AppDeadlineCheck));
      expect(toggles, 1);
    });

    testWidgets('done rows strike through, dim to 55% and fill accent', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const AppDeadlineRow(
            title: 'Курсовая',
            meta: 'ООП · 4 сентября',
            left: 'готово',
            done: true,
          ),
        ),
      );

      expect(
        kitStyleOf(tester, 'Курсовая')?.decoration,
        TextDecoration.lineThrough,
      );
      expect(kitStyleOf(tester, 'готово')?.color, kitColors.muted2);
      expect(
        tester
            .widget<AnimatedOpacity>(find.byType(AnimatedOpacity).first)
            .opacity,
        .55,
      );
      final check = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect((check.decoration! as BoxDecoration).color, kitColors.accent);
      expect(
        tester.widget<AppLineIconWidget>(find.byType(AppLineIconWidget)).color,
        kitColors.onAccent,
      );
    });

    testWidgets('non-urgent label is muted and row taps through', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          AppDeadlineRow(
            title: 'Эссе',
            meta: 'Философия · 8 сентября',
            left: '7 дн',
            onTap: () => taps++,
          ),
        ),
      );

      expect(kitStyleOf(tester, '7 дн')?.color, kitColors.muted);
      await tester.tap(find.text('Эссе'));
      expect(taps, 1);
    });
  });

  group('AppDeadlineCard', () {
    testWidgets('wraps the row in a surface card', (tester) async {
      await tester.pumpWidget(
        host(
          const AppDeadlineCard(
            subject: 'Физика',
            task: 'Отчёт',
            due: 'сегодня',
            left: '5 ч',
            progress: .5,
          ),
        ),
      );

      expect(find.byType(AppDeadlineRow), findsOneWidget);
      expect(find.text('Физика · сегодня'), findsOneWidget);
      expect(kitDecorationOf(tester, AppCard).color, kitColors.surface);
    });
  });
}
