import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  Widget host(Widget child) => wrapKit(SizedBox(width: 320, child: child));

  Container tileOf(WidgetTester tester) => tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.constraints?.maxWidth == 56,
        ),
      );

  group('NinjaEmptyState', () {
    testWidgets('card variant: surface r24, tint tile, serif 19, tonal pill', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          NinjaEmptyState(
            title: 'Пока пусто',
            message: 'Добавьте первый дедлайн',
            icon: const AppLineIconWidget(AppLineIcon.inbox),
            actionLabel: 'Добавить',
            onAction: () => taps++,
          ),
        ),
      );

      final card = kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(NinjaEmptyState),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(card.color, kitColors.surface);
      expect(card.borderRadius, BorderRadius.circular(AppRadius.card));

      final tile = tileOf(tester).decoration! as BoxDecoration;
      expect(tile.color, kitColors.tint);
      expect(tile.borderRadius, BorderRadius.circular(AppRadius.lg));

      final title = kitStyleOf(tester, 'Пока пусто');
      expect(title?.fontSize, 19);
      expect(title?.fontFamily, AppText.serifFamily);
      final message = kitStyleOf(tester, 'Добавьте первый дедлайн');
      expect(message?.fontSize, 12.5);
      expect(message?.color, kitColors.muted);

      final pill = tester.widget<NinjaPillButton>(find.byType(NinjaPillButton));
      expect(pill.tone, NinjaPillTone.tonal);
      expect(pill.height, AppControlSize.buttonSmall);
      expect(kitStyleOf(tester, 'Добавить')?.color, kitColors.accent);
      await tester.tap(find.text('Добавить'));
      expect(taps, 1);
    });

    testWidgets('compact variant is centred 14 muted copy', (tester) async {
      await tester.pumpWidget(
        host(const NinjaEmptyState.compact(title: 'Ничего нет')),
      );

      final style = kitStyleOf(tester, 'Ничего нет');
      expect(style?.fontSize, 14);
      expect(style?.color, kitColors.muted);
      expect(find.byType(DecoratedBox), findsNothing);
    });
  });

  group('NinjaErrorState', () {
    testWidgets('uses the exam tint tile and a secondary retry', (
      tester,
    ) async {
      var retries = 0;
      await tester.pumpWidget(
        host(
          NinjaErrorState(
            title: 'Не загрузилось',
            message: 'Проверьте сеть',
            retryLabel: 'Повторить',
            onRetry: () => retries++,
          ),
        ),
      );

      final tile = tileOf(tester).decoration! as BoxDecoration;
      expect(tile.color, kitColors.examTint);
      final icon = tester.widget<AppLineIconWidget>(
        find.byType(AppLineIconWidget),
      );
      expect(icon.icon, AppLineIcon.cloudOff);
      expect(icon.color, kitColors.danger);

      final retry =
          tester.widget<NinjaPillButton>(find.byType(NinjaPillButton));
      expect(retry.tone, NinjaPillTone.secondary);
      expect(
        kitDecorationOf(tester, NinjaPillButton).color,
        kitColors.surface2,
      );
      await tester.tap(find.text('Повторить'));
      expect(retries, 1);
    });

    testWidgets('warn tone swaps the tint and icon', (tester) async {
      await tester.pumpWidget(
        host(
          const NinjaErrorState(title: 'Офлайн', tone: NinjaErrorTone.warn),
        ),
      );

      expect(
        (tileOf(tester).decoration! as BoxDecoration).color,
        kitColors.warnTint,
      );
      expect(
        tester.widget<AppLineIconWidget>(find.byType(AppLineIconWidget)).icon,
        AppLineIcon.alert,
      );
    });
  });

  group('NinjaErrorCard', () {
    testWidgets('renders the tint banner with an action', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          NinjaErrorCard(
            title: 'Ошибка',
            message: 'Не удалось синхронизировать',
            actionLabel: 'Повторить',
            onAction: () => taps++,
          ),
        ),
      );

      expect(kitDecorationOf(tester, NinjaErrorCard).color, kitColors.examTint);
      await tester.tap(find.text('Повторить'));
      expect(taps, 1);
    });
  });

  group('AppEmptyState', () {
    testWidgets('renders card, tile, title, subtitle and tint action', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          AppEmptyState(
            title: 'Пока пусто',
            subtitle: 'Добавьте первый дедлайн — и он появится на Главной',
            actionLabel: 'Добавить',
            onAction: () => taps++,
          ),
        ),
      );

      expect(kitDecorationOf(tester, AppEmptyState).color, kitColors.surface);
      expect(
        (tileOf(tester).decoration! as BoxDecoration).color,
        kitColors.tint,
      );
      expect(kitStyleOf(tester, 'Пока пусто')?.fontSize, 19);
      final action = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Добавить'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        tester.getSize(find.byWidget(action)).height,
        AppControlSize.buttonSmall,
      );
      expect((action.decoration! as BoxDecoration).color, kitColors.tint);
      expect(kitStyleOf(tester, 'Добавить')?.fontWeight, FontWeight.w700);
      await tester.tap(find.text('Добавить'));
      expect(taps, 1);
    });

    testWidgets('compact variant skips the card', (tester) async {
      await tester.pumpWidget(
        host(const AppEmptyState.compact(title: 'Ничего нет')),
      );
      expect(find.byType(AppCard), findsNothing);
      expect(kitStyleOf(tester, 'Ничего нет')?.color, kitColors.muted);
    });
  });

  group('AppErrorState', () {
    testWidgets('renders exam tile, surface2 retry and footnote', (
      tester,
    ) async {
      var retries = 0;
      await tester.pumpWidget(
        host(AppErrorState(onPrimary: () => retries++)),
      );

      expect(
        (tileOf(tester).decoration! as BoxDecoration).color,
        kitColors.examTint,
      );
      final retry = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Повторить'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect((retry.decoration! as BoxDecoration).color, kitColors.surface2);
      expect(find.text('Синхронизируем, когда сеть вернётся'), findsOneWidget);
      await tester.tap(find.text('Повторить'));
      expect(retries, 1);
    });

    testWidgets('compact variant is plain muted text', (tester) async {
      await tester.pumpWidget(
        host(const AppErrorState.compact(title: 'Не загрузилось')),
      );
      expect(find.byType(AppCard), findsNothing);
      expect(kitStyleOf(tester, 'Не загрузилось')?.color, kitColors.muted);
    });
  });

  group('FailureScreen', () {
    testWidgets('shows the title and fires the button', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrapKit(
          FailureScreen(
            title: 'Ошибка',
            description: 'Что-то пошло не так',
            buttonText: 'Назад',
            onButtonPressed: () => taps++,
          ),
        ),
      );

      expect(find.text('Ошибка'), findsOneWidget);
      expect(find.text('Что-то пошло не так'), findsOneWidget);
      await tester.tap(find.text('Назад'));
      expect(taps, 1);
    });
  });
}
