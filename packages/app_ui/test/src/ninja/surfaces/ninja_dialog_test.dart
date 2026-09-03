import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  group('NinjaDialog', () {
    testWidgets('paints a canvas r28 card with 17/700 title and 13.5 body', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 340,
            child: NinjaDialog(
              title: 'Удалить своё расписание?',
              message: 'Это действие нельзя отменить.',
              cancelLabel: 'Отмена',
              confirmLabel: 'Удалить',
              destructive: true,
            ),
          ),
        ),
      );

      final card = kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(NinjaDialog),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(card.color, kitColors.canvas);
      expect(card.borderRadius, BorderRadius.circular(AppRadius.dialog));

      final title = kitStyleOf(tester, 'Удалить своё расписание?');
      expect(title?.fontSize, 17);
      expect(title?.fontWeight, FontWeight.w700);
      final body = kitStyleOf(tester, 'Это действие нельзя отменить.');
      expect(body?.fontSize, 13.5);
      expect(body?.height, 1.45);
      expect(body?.color, kitColors.muted);

      final buttons = tester
          .widgetList<NinjaPillButton>(find.byType(NinjaPillButton))
          .toList();
      expect(buttons, hasLength(2));
      expect(buttons[0].tone, NinjaPillTone.surface);
      expect(buttons[0].height, AppControlSize.buttonMedium);
      expect(buttons[1].tone, NinjaPillTone.danger);
      expect(kitStyleOf(tester, 'Удалить')?.color, kitColors.white);
      expect(kitStyleOf(tester, 'Удалить')?.fontSize, 14);
      expect(kitDecorationOf(tester, NinjaPillButton).color, kitColors.surface);
    });

    testWidgets('non-destructive confirm is accent and stacks at large text', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 340,
            child: NinjaDialog(
              title: 'Выйти?',
              cancelLabel: 'Отмена',
              confirmLabel: 'Выйти',
            ),
          ),
          textScale: 1.6,
        ),
      );

      final confirm = tester.widget<NinjaPillButton>(
        find.widgetWithText(NinjaPillButton, 'Выйти'),
      );
      expect(confirm.tone, NinjaPillTone.primary);
      expect(
        find.descendant(
          of: find.byType(NinjaDialog),
          matching: find.byType(Row),
        ),
        findsNothing,
      );
    });

    testWidgets('optional icon sits above the title', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 340,
            child: NinjaDialog(
              title: 'Готово',
              icon: AppLineIconWidget(AppLineIcon.check),
            ),
          ),
        ),
      );
      expect(find.byType(AppLineIconWidget), findsOneWidget);
    });
  });

  group('showNinjaConfirmDialog', () {
    Widget host(Future<void> Function(BuildContext) onTap) => wrapKit(
          Builder(
            builder: (context) => AppPressable(
              onTap: () => onTap(context),
              child: const Text('open'),
            ),
          ),
        );

    testWidgets('resolves true on confirm under a scrim barrier', (
      tester,
    ) async {
      bool? result;
      await tester.pumpWidget(
        host(
          (context) async {
            result = await showNinjaConfirmDialog(
              context,
              title: 'Удалить?',
              confirmLabel: 'Удалить',
              cancelLabel: 'Отмена',
              destructive: true,
            );
          },
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(NinjaDialog), findsOneWidget);
      final barrier = tester.widget<ModalBarrier>(
        find.byType(ModalBarrier).last,
      );
      expect(barrier.color, kitColors.scrim);

      await tester.tap(find.text('Удалить'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('resolves false on cancel', (tester) async {
      bool? result;
      await tester.pumpWidget(
        host(
          (context) async {
            result = await showNinjaConfirmDialog(
              context,
              title: 'T',
              confirmLabel: 'Да',
              cancelLabel: 'Нет',
            );
          },
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Нет'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });
  });
}
