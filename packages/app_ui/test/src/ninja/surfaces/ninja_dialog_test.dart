import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_easy/liquid_glass_easy.dart';

import '../../kit_harness.dart';

void main() {
  Finder action(String label) => find
      .ancestor(of: find.text(label), matching: find.byType(AppPressable))
      .first;

  BoxDecoration actionDecoration(WidgetTester tester, String label) =>
      tester
              .widget<AnimatedContainer>(
                find
                    .ancestor(
                      of: find.text(label),
                      matching: find.byType(AnimatedContainer),
                    )
                    .first,
              )
              .decoration!
          as BoxDecoration;

  group('NinjaDialog', () {
    testWidgets('paints a glass r28 card with 17/700 title and 13.5 body', (
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

      final card = tester.widget<AppGlassSurface>(
        find.descendant(
          of: find.byType(NinjaDialog),
          matching: find.byType(AppGlassSurface),
        ),
      );
      expect(card.borderRadius, AppRadius.dialog);
      expect(card.tone, AppGlassTone.regular);
      final lens = tester.widget<LiquidGlassLens>(find.byType(LiquidGlassLens));
      expect(lens.style.color.withValues(alpha: 1), kitColors.surface);
      expect(lens.style.color.a, greaterThan(.9));
      expect(card.role, AppGlassRole.overlay);
      expect(lens.style.specular, AppGlassStyle.rim);

      final title = kitStyleOf(tester, 'Удалить своё расписание?');
      expect(title?.fontSize, 17);
      expect(title?.fontWeight, FontWeight.w700);
      final body = kitStyleOf(tester, 'Это действие нельзя отменить.');
      expect(body?.fontSize, 13.5);
      expect(body?.height, 1.45);
      expect(body?.color, kitColors.muted);

      expect(
        tester.getSize(action('Отмена')).height,
        AppControlSize.buttonMedium,
      );
      expect(
        tester.getSize(action('Удалить')).height,
        AppControlSize.buttonMedium,
      );
      expect(actionDecoration(tester, 'Отмена').color, kitColors.surface);
      expect(actionDecoration(tester, 'Удалить').color, kitColors.danger);
      expect(
        tester.getCenter(action('Отмена')).dy,
        tester.getCenter(action('Удалить')).dy,
      );
      expect(kitStyleOf(tester, 'Удалить')?.color, kitColors.white);
      expect(kitStyleOf(tester, 'Удалить')?.fontSize, 14);
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

      expect(actionDecoration(tester, 'Выйти').color, kitColors.accent);
      expect(kitStyleOf(tester, 'Выйти')?.color, kitColors.onAccent);
      expect(
        tester.getRect(action('Выйти')).bottom,
        lessThan(tester.getRect(action('Отмена')).top),
      );
      expect(
        tester.getSize(action('Выйти')).height,
        greaterThanOrEqualTo(AppControlSize.buttonMedium),
      );
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
