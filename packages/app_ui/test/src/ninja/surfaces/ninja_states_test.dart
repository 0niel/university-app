import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: SizedBox(width: 320, child: child))),
      );

  group('NinjaEmptyState', () {
    testWidgets('draws a soft circle with a question mark by default', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          NinjaEmptyState(
            title: 'Пока пусто',
            message: 'Заявки на справки появятся здесь',
            actionLabel: 'Заказать справку',
            onAction: () => taps++,
          ),
        ),
      );

      expect(find.byType(AppDashedBorder), findsNothing);
      expect(find.text('?'), findsOneWidget);

      final title = tester.widget<Text>(find.text('Пока пусто')).style;
      expect(title?.fontSize, 15);
      expect(title?.fontWeight, FontWeight.w600);

      final message = tester
          .widget<Text>(find.text('Заявки на справки появятся здесь'))
          .style;
      expect(message?.fontSize, 12.5);
      expect(message?.color, colors.muted);

      final surface = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(NinjaEmptyState),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final decoration = surface.decoration as BoxDecoration;
      expect(decoration.color, colors.surface);
      expect(decoration.borderRadius, BorderRadius.circular(NinjaRadius.card));

      final cta = tester.widget<NinjaButton>(find.byType(NinjaButton));
      expect(cta.variant, NinjaButtonVariant.primary);
      expect(cta.size, NinjaButtonSize.small);
      expect(
        tester.getSize(find.byType(NinjaButton)).height,
        greaterThanOrEqualTo(NinjaMetrics.minTouchTarget),
      );
      expect(
        tester.getSemantics(find.byType(NinjaButton)).flagsCollection.isButton,
        isTrue,
      );

      await tester.tap(find.text('Заказать справку'));
      expect(taps, 1);
    });

    testWidgets('screen variant drops the frame and steps the type up', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaEmptyState.screen(
            title: 'Отдыхайте',
            message: 'ближайшая пара — пн 8:30',
            actionLabel: 'Посмотреть понедельник',
            onAction: () {},
            outlinedAction: true,
          ),
        ),
      );

      final surface = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(NinjaEmptyState),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect((surface.decoration as BoxDecoration).color, Colors.transparent);

      final title = tester.widget<Text>(find.text('Отдыхайте')).style;
      expect(title?.fontSize, 19);
      expect(title?.fontWeight, FontWeight.w700);

      final message =
          tester.widget<Text>(find.text('ближайшая пара — пн 8:30')).style;
      expect(message?.fontSize, 12.5);

      final circle = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(NinjaEmptyState),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is SizedBox &&
                    widget.width == 72 &&
                    widget.height == 72,
              ),
            )
            .first,
      );
      expect(circle.width, 72);
      expect(circle.height, 72);

      final cta = tester.widget<NinjaButton>(find.byType(NinjaButton));
      expect(cta.variant, NinjaButtonVariant.secondary);
      expect(cta.size.radius, NinjaRadius.button);
    });

    testWidgets('icon variant fills the circle and can go outline', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          NinjaEmptyState(
            title: 'Ничего не нашлось',
            icon: const NinjaGlyphIcon(NinjaGlyph.search),
            actionLabel: 'Сбросить',
            onAction: () {},
            outlinedAction: true,
          ),
        ),
      );

      expect(find.byType(AppDashedBorder), findsNothing);
      expect(find.byType(NinjaGlyphIcon), findsOneWidget);
      expect(
        IconTheme.of(tester.element(find.byType(NinjaGlyphIcon))).size,
        24,
      );
      expect(
        tester.widget<NinjaButton>(find.byType(NinjaButton)).variant,
        NinjaButtonVariant.secondary,
      );
    });
  });

  group('NinjaErrorState', () {
    testWidgets('renders the tint circle, copy and two actions', (
      tester,
    ) async {
      var retried = 0;
      var offline = 0;
      await tester.pumpWidget(
        wrap(
          NinjaErrorState(
            title: 'Нет соединения',
            message: 'Показываем данные на 9:40.',
            retryLabel: 'Повторить',
            onRetry: () => retried++,
            secondaryLabel: 'Оффлайн-режим',
            onSecondary: () => offline++,
          ),
        ),
      );

      final circles =
          tester.widgetList<Container>(find.byType(Container)).where(
                (container) =>
                    (container.decoration as BoxDecoration?)?.color ==
                    colors.dangerTint,
              );
      expect(circles, hasLength(1));

      final glyph = tester.widget<NinjaGlyphIcon>(find.byType(NinjaGlyphIcon));
      expect(glyph.glyph, NinjaGlyph.warning);
      expect(glyph.color, colors.scarlet);

      final title = tester.widget<Text>(find.text('Нет соединения')).style;
      expect(title?.fontSize, 15);
      expect(title?.fontWeight, FontWeight.w600);

      final surface = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(NinjaErrorState),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = surface.decoration! as BoxDecoration;
      expect(decoration.color, colors.surface);
      expect(decoration.border, isNull);

      expect(find.byType(NinjaActionButton), findsNWidgets(2));
      await tester.tap(find.text('Повторить'));
      await tester.tap(find.text('Оффлайн-режим'));
      expect(retried, 1);
      expect(offline, 1);
    });

    testWidgets('warn tone repaints the circle and glyph', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaErrorState(
            title: 'Нет доступа',
            tone: NinjaErrorTone.warn,
          ),
        ),
      );

      final glyph = tester.widget<NinjaGlyphIcon>(find.byType(NinjaGlyphIcon));
      expect(glyph.glyph, NinjaGlyph.info);
      expect(glyph.color, colors.amberInk);
      expect(find.byType(NinjaActionButton), findsNothing);
    });
  });

  group('NinjaErrorCard', () {
    testWidgets('uses one accent marker and a full-size retry action', (
      tester,
    ) async {
      var retried = 0;
      await tester.pumpWidget(
        wrap(
          NinjaErrorCard(
            title: 'Ошибка 500',
            message: 'Не смогли загрузить оценки',
            actionLabel: 'повторить',
            onAction: () => retried++,
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('Ошибка 500')).style?.color,
        colors.ink,
      );
      expect(find.text('повторить'), findsOneWidget);
      expect(
        tester.getSize(find.byType(NinjaActionButton)).height,
        greaterThanOrEqualTo(NinjaMetrics.minTouchTarget),
      );

      final surface = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(NinjaErrorCard),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = surface.decoration! as BoxDecoration;
      expect(decoration.color, colors.surface);
      expect(decoration.border, isNull);

      await tester.tap(find.text('повторить'));
      expect(retried, 1);
    });

    testWidgets('warn tone keeps body copy readable', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaErrorCard(
            title: 'Нет доступа',
            message: 'Сессия истекла',
            tone: NinjaErrorTone.warn,
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('Нет доступа')).style?.color,
        colors.ink,
      );
    });
  });
}
