import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  Widget host(Widget child) => wrapKit(SizedBox(width: 390, child: child));

  group('AppScreenHeader', () {
    testWidgets('renders display title, overline, subtitle and 42px circles', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          AppScreenHeader(
            title: 'Главная',
            overline: 'среда',
            subtitle: '4 пары',
            actions: [
              AppHeaderAction(
                icon: AppLineIcon.bell,
                badge: true,
                onTap: () => taps++,
              ),
            ],
          ),
        ),
      );

      final title = kitStyleOf(tester, 'Главная');
      expect(title?.fontSize, 34);
      expect(title?.fontFamily, AppText.serifFamily);
      expect(find.text('СРЕДА'), findsOneWidget);
      expect(kitStyleOf(tester, '4 пары')?.color, kitColors.muted);

      final top = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(AppScreenHeader),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(top.padding.resolve(TextDirection.ltr).top, AppSpacing.screenTop);

      final circle = kitDecorationOf(tester, AppHeaderCircleButton);
      expect(circle.color, kitColors.surface);
      expect(circle.shape, BoxShape.circle);
      expect(
        tester.getSize(find.byType(AppHeaderCircleButton)).width,
        AppControlSize.touchTarget,
      );
      expect(
        tester.getSize(
          find
              .descendant(
                of: find.byType(AppHeaderCircleButton),
                matching: find.byType(Container),
              )
              .first,
        ),
        const Size.square(AppControlSize.iconButtonCompact),
      );
      await tester.tap(find.byType(AppHeaderCircleButton));
      expect(taps, 1);
    });

    testWidgets('pill button shows label with a chevron', (tester) async {
      await tester.pumpWidget(
        host(AppHeaderPillButton(label: 'Неделя 3', onTap: () {})),
      );

      expect(
        kitDecorationOf(tester, AppHeaderPillButton).color,
        kitColors.surface,
      );
      expect(kitStyleOf(tester, 'Неделя 3')?.fontWeight, FontWeight.w700);
      expect(
        tester.widget<AppLineIconWidget>(find.byType(AppLineIconWidget)).icon,
        AppLineIcon.chevronD,
      );
    });

    testWidgets('text action keeps reference layout with a 44px touch target', (
      tester,
    ) async {
      var taps = 0;
      const actionKey = ValueKey('header-text-action');
      await tester.pumpWidget(
        host(
          AppScreenHeader(
            title: 'Сервисы',
            textAction: AppHeaderTextAction(
              key: actionKey,
              label: 'Настроить',
              onTap: () => taps++,
            ),
          ),
        ),
      );

      final header = tester.getRect(find.byType(AppScreenHeader));
      final title = tester.getRect(find.text('Сервисы'));
      final action = tester.getRect(find.byKey(actionKey));
      final label = tester.getRect(find.text('Настроить'));
      expect(title.left - header.left, AppSpacing.screen);
      expect(title.top - header.top, AppSpacing.screenTop);
      expect(header.bottom, title.bottom);
      expect(action.height, AppControlSize.touchTarget);
      expect(action.width, greaterThanOrEqualTo(AppControlSize.touchTarget));
      expect(label.right, header.right - AppSpacing.screen);
      expect(label.bottom, header.bottom - AppSpacing.sm);
      expect(kitStyleOf(tester, 'Настроить')?.color, kitColors.accent);
      await tester.tapAt(action.topCenter + const Offset(0, 1));
      expect(taps, 1);
    });

    testWidgets('text action remains bounded at 200 percent and in RTL', (
      tester,
    ) async {
      for (final direction in TextDirection.values) {
        await tester.pumpWidget(
          wrapKit(
            Directionality(
              textDirection: direction,
              child: SizedBox(
                width: 320,
                child: AppScreenHeader(
                  title: 'Сервисы',
                  textAction: AppHeaderTextAction(
                    key: const ValueKey('header-text-action'),
                    label: 'Настроить',
                    onTap: () {},
                  ),
                ),
              ),
            ),
            textScale: 2,
          ),
        );

        final header = tester.getRect(find.byType(AppScreenHeader));
        final action = tester.getRect(
          find.byKey(const ValueKey('header-text-action')),
        );
        expect(action.height, greaterThanOrEqualTo(AppControlSize.touchTarget));
        expect(action.width, greaterThanOrEqualTo(AppControlSize.touchTarget));
        expect(header.contains(action.topLeft), isTrue);
        expect(
          header.contains(action.bottomRight - const Offset(1, 1)),
          isTrue,
        );
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('AppInnerHeader', () {
    testWidgets('renders a 44px back circle, 28px title and muted trailing', (
      tester,
    ) async {
      var backs = 0;
      await tester.pumpWidget(
        host(
          AppInnerHeader(
            title: 'Дедлайны',
            subtitle: '3 активных',
            onBack: () => backs++,
            trailingLabel: 'Изменить',
          ),
        ),
      );

      final title = kitStyleOf(tester, 'Дедлайны');
      expect(title?.fontSize, 28);
      expect(title?.fontFamily, AppText.serifFamily);
      final back = tester.widget<Container>(
        find
            .ancestor(
              of: find.byType(AppLineIconWidget),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(back.constraints?.maxWidth, AppControlSize.iconButton);
      final trailing = kitStyleOf(tester, 'Изменить');
      expect(trailing?.fontSize, 13);
      expect(trailing?.color, kitColors.muted);

      await tester.tap(find.byType(AppLineIconWidget));
      expect(backs, 1);
    });
  });

  group('AppSectionTitle / AppOverline', () {
    testWidgets('section title pairs serif 22 with an accent action', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          AppSectionTitle(
            title: 'Дедлайны',
            action: 'все',
            onActionTap: () => taps++,
          ),
        ),
      );

      expect(kitStyleOf(tester, 'Дедлайны')?.fontSize, 22);
      final action = kitStyleOf(tester, 'все');
      expect(action?.fontSize, 13);
      expect(action?.fontWeight, FontWeight.w600);
      expect(action?.color, kitColors.accent);
      await tester.tap(find.text('все'));
      expect(taps, 1);
    });

    testWidgets('meta variant is 13/500 muted', (tester) async {
      await tester.pumpWidget(
        host(const AppSectionTitle(title: 'Сегодня', meta: '4 пары')),
      );

      final meta = kitStyleOf(tester, '4 пары');
      expect(meta?.fontWeight, FontWeight.w500);
      expect(meta?.color, kitColors.muted);
    });

    testWidgets('overline is uppercase 11.5/700 muted', (tester) async {
      await tester.pumpWidget(host(const AppOverline('сегодня')));

      final style = kitStyleOf(tester, 'СЕГОДНЯ');
      expect(style?.fontSize, 11.5);
      expect(style?.fontWeight, FontWeight.w700);
      expect(style?.color, kitColors.muted);
    });
  });
}
