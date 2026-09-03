import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  BoxDecoration decorationOf(WidgetTester tester, Type type) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(type),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );

  group('NinjaBadge', () {
    testWidgets('lime tone is accent on onAccent with 11.5/600 text', (
      tester,
    ) async {
      await tester.pumpWidget(wrapKit(const NinjaBadge('Следующая')));

      final decoration = decorationOf(tester, NinjaBadge);
      expect(decoration.color, kitColors.accent);
      expect(decoration.borderRadius, BorderRadius.circular(AppRadius.full));

      final style = kitStyleOf(tester, 'Следующая');
      expect(style?.fontSize, 11.5);
      expect(style?.fontWeight, FontWeight.w600);
      expect(style?.color, kitColors.onAccent);
    });

    testWidgets('tinted tones carry a 6px dot in the tone colour', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const NinjaBadge('Отменена', tone: NinjaBadgeTone.dangerOutline),
        ),
      );

      expect(decorationOf(tester, NinjaBadge).color, kitColors.examTint);
      final dot = tester.widget<SizedBox>(
        find.byWidgetPredicate(
          (widget) =>
              widget is SizedBox && widget.width == 6 && widget.height == 6,
        ),
      );
      expect(dot.height, 6);
      final dots = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
      expect(
        dots.any(
          (box) => (box.decoration as BoxDecoration).color == kitColors.danger,
        ),
        isTrue,
      );
    });

    testWidgets('neutral tone is surface2 on muted', (tester) async {
      await tester.pumpWidget(
        wrapKit(const NinjaBadge('Тег', tone: NinjaBadgeTone.neutral)),
      );

      expect(decorationOf(tester, NinjaBadge).color, kitColors.surface2);
      expect(kitStyleOf(tester, 'Тег')?.color, kitColors.muted);
    });
  });

  group('NinjaCountBadge', () {
    testWidgets('renders a 22px danger pill and caps at 99+', (tester) async {
      await tester.pumpWidget(wrapKit(const NinjaCountBadge(3)));
      final pill = kitDecorationOf(tester, NinjaCountBadge);
      expect(pill.color, kitColors.danger);
      expect(find.text('3'), findsOneWidget);

      await tester.pumpWidget(wrapKit(const NinjaCountBadge(120)));
      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('dot variant is a 10px danger circle', (tester) async {
      await tester.pumpWidget(wrapKit(const NinjaCountBadge.dot()));
      final dot = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(NinjaCountBadge),
          matching: find.byType(SizedBox),
        ),
      );
      expect(dot.width, 10);
      expect(decorationOf(tester, NinjaCountBadge).shape, BoxShape.circle);
    });
  });

  group('AppBadge', () {
    testWidgets('accent and ink tones paint solid fills', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBadge(label: 'Следующая', tone: AppBadgeTone.accent),
              AppBadge(label: 'Новое', tone: AppBadgeTone.ink),
            ],
          ),
        ),
      );

      final fills = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(AppBadge),
              matching: find.byType(Container),
            ),
          )
          .map((container) => (container.decoration! as BoxDecoration).color)
          .toList();
      expect(fills, [kitColors.accent, kitColors.ink]);
      expect(kitStyleOf(tester, 'Новое')?.color, kitColors.canvas);
    });

    testWidgets('tinted dot badges use tint fill, ink text and tone dot', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const AppBadge(label: 'Перенос', tone: AppBadgeTone.warn, dot: true),
        ),
      );

      expect(kitDecorationOf(tester, AppBadge).color, kitColors.warnTint);
      expect(kitStyleOf(tester, 'Перенос')?.color, kitColors.ink);
      final dot = tester.widget<AppDot>(find.byType(AppDot));
      expect(dot.size, 6);
      expect(dot.color, kitColors.warn);
    });
  });

  group('AppCountBadge / AppDot / AppTypeTag', () {
    testWidgets('count badge caps at max with a danger fill', (tester) async {
      await tester.pumpWidget(wrapKit(const AppCountBadge(120)));
      expect(find.text('99+'), findsOneWidget);
      expect(kitDecorationOf(tester, AppCountBadge).color, kitColors.danger);
    });

    testWidgets('dot defaults to 10px danger', (tester) async {
      await tester.pumpWidget(wrapKit(const AppDot()));
      final box = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AppDot),
          matching: find.byType(SizedBox),
        ),
      );
      expect(box.width, 10);
      expect(decorationOf(tester, AppDot).color, kitColors.danger);
    });

    testWidgets('type tag is 11/800 on the tone tint with r8', (tester) async {
      await tester.pumpWidget(
        wrapKit(AppTypeTag('ЛАБ', color: kitColors.lab)),
      );

      final tag = kitDecorationOf(tester, AppTypeTag);
      expect(tag.color, kitColors.tintOf(kitColors.lab));
      expect(tag.borderRadius, BorderRadius.circular(8));
      final style = kitStyleOf(tester, 'ЛАБ');
      expect(style?.fontSize, 11);
      expect(style?.fontWeight, FontWeight.w800);
      expect(style?.color, kitColors.lab);
    });
  });
}
