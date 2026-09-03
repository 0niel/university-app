import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  group('NinjaToast', () {
    testWidgets('paints the ink pill with a 32px accent check tile', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 360,
            child: NinjaToast(message: 'Напомню за 15 минут'),
          ),
        ),
      );

      final toast = kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(NinjaToast),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(toast.color, kitColors.ink);
      expect(toast.borderRadius, BorderRadius.circular(18));

      final tile = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.constraints?.maxWidth == 32,
        ),
      );
      expect((tile.decoration! as BoxDecoration).color, kitColors.accent);
      expect(
        (tile.decoration! as BoxDecoration).borderRadius,
        BorderRadius.circular(10),
      );
      final icon = tester.widget<AppLineIconWidget>(
        find.byType(AppLineIconWidget),
      );
      expect(icon.icon, AppLineIcon.check);
      expect(icon.size, 17);
      expect(icon.strokeWidth, 2.5);

      final style = kitStyleOf(tester, 'Напомню за 15 минут');
      expect(style?.fontSize, 13.5);
      expect(style?.fontWeight, FontWeight.w600);
      expect(style?.color, kitColors.canvas);
    });

    testWidgets('hides the tile and shows a 40px accent action', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 360,
            child: NinjaToast(
              message: 'Дедлайн скрыт',
              showCheck: false,
              actionLabel: 'Вернуть',
              onAction: () => taps++,
            ),
          ),
        ),
      );

      expect(find.byType(AppLineIconWidget), findsNothing);
      final action = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Вернуть'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        tester
            .getSize(
              find
                  .ancestor(
                    of: find.text('Вернуть'),
                    matching: find.byType(Container),
                  )
                  .first,
            )
            .height,
        40,
      );
      expect((action.decoration! as BoxDecoration).color, kitColors.accent);
      expect(
        (action.decoration! as BoxDecoration).borderRadius,
        BorderRadius.circular(14),
      );

      await tester.tap(find.text('Вернуть'));
      expect(taps, 1);
    });
  });

  group('NinjaToastHost', () {
    testWidgets('shows a toast above the bottom inset and auto-dismisses', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          NinjaToastHost(
            bottomInset: 104,
            child: Builder(
              builder: (context) => AppPressable(
                onTap: () => showNinjaToast(context, message: 'Готово'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Готово'), findsOneWidget);
      final positioned = tester.widget<Positioned>(
        find.ancestor(
          of: find.byType(NinjaToast),
          matching: find.byType(Positioned),
        ),
      );
      expect(positioned.bottom, 104);
      expect(positioned.left, 16);
      expect(positioned.right, 16);

      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Готово'), findsNothing);
    });

    testWidgets('queues toasts one after another', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          NinjaToastHost(
            child: Builder(
              builder: (context) => AppPressable(
                onTap: () {
                  showNinjaToast(context, message: 'Первый');
                  showNinjaToast(context, message: 'Второй');
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Первый'), findsOneWidget);
      expect(find.text('Второй'), findsNothing);

      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Второй'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Второй'), findsNothing);
    });
  });

  group('AppToast', () {
    testWidgets('renders message, tile and action', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 360,
            child: AppToast(
              message: 'Скрыто',
              actionLabel: 'Вернуть',
              onAction: () => taps++,
            ),
          ),
        ),
      );

      expect(find.byType(AppIconTile), findsOneWidget);
      expect(kitStyleOf(tester, 'Скрыто')?.color, kitColors.canvas);
      await tester.tap(find.text('Вернуть'));
      expect(taps, 1);
    });
  });
}
