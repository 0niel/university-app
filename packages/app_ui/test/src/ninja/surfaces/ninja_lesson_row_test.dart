import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  Widget host(Widget child) => wrapKit(SizedBox(width: 390, child: child));

  Color? barColorOf(WidgetTester tester) {
    final boxes = tester.widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(NinjaLessonRow),
        matching: find.byType(DecoratedBox),
      ),
    );
    for (final box in boxes) {
      final decoration = box.decoration as BoxDecoration;
      if (decoration.borderRadius == BorderRadius.circular(2) &&
          box.child is SizedBox &&
          (box.child! as SizedBox).width == 4) {
        return decoration.color;
      }
    }
    return null;
  }

  group('NinjaLessonRow', () {
    testWidgets('renders time column, subject and meta on a r22 card', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const NinjaLessonRow(
            title: 'Математический анализ',
            time: '09:00',
            endTime: '10:30',
            typeLabel: 'ЛЕК',
            meta: 'А-318 · Смирнова Е. В.',
          ),
        ),
      );

      final card = kitDecorationOf(tester, NinjaLessonRow);
      expect(card.color, kitColors.surface);
      expect(card.borderRadius, BorderRadius.circular(AppRadius.row));

      final time = kitStyleOf(tester, '09:00');
      expect(time?.fontSize, 14);
      expect(time?.fontWeight, FontWeight.w700);
      expect(time?.fontFeatures, contains(const FontFeature.tabularFigures()));
      final end = kitStyleOf(tester, '10:30');
      expect(end?.fontSize, 12);
      expect(end?.fontWeight, FontWeight.w500);

      final subject = kitStyleOf(tester, 'Математический анализ');
      expect(subject?.fontSize, 15);
      expect(subject?.fontWeight, FontWeight.w600);
      final type = kitStyleOf(tester, 'ЛЕК');
      expect(type?.fontSize, 10.5);
      expect(type?.fontWeight, FontWeight.w800);
      expect(type?.color, kitColors.accent);
      expect(kitStyleOf(tester, 'А-318 · Смирнова Е. В.')?.fontSize, 12.5);
      expect(barColorOf(tester), kitColors.accent);
    });

    testWidgets('past state mutes everything and greys the bar', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const NinjaLessonRow(
            title: 'История',
            time: '08:30',
            meta: 'А-1',
            state: LessonRowState.past,
            stateLabel: 'past',
          ),
        ),
      );

      expect(kitStyleOf(tester, 'История')?.color, kitColors.muted2);
      expect(kitStyleOf(tester, 'А-1')?.color, kitColors.muted2);
      expect(barColorOf(tester), kitColors.surface2);
      final state = kitStyleOf(tester, 'past');
      expect(state?.fontSize, 11);
      expect(state?.fontWeight, FontWeight.w700);
      expect(state?.color, kitColors.muted2);
    });

    testWidgets('current state tints the card and shows progress', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          NinjaLessonRow(
            title: 'Python',
            time: '10:40',
            color: kitColors.practice,
            chipLabel: '· идёт, ещё 48 мин',
            chipColor: kitColors.accent,
            state: LessonRowState.current,
            progress: .47,
          ),
        ),
      );

      expect(kitDecorationOf(tester, NinjaLessonRow).color, kitColors.tint);
      final bar =
          tester.widget<NinjaProgressBar>(find.byType(NinjaProgressBar));
      expect(bar.value, .47);
      expect(bar.height, 4);
      expect(bar.trackColor, kitColors.surface);
      final chip = kitStyleOf(tester, '· идёт, ещё 48 мин');
      expect(chip?.fontSize, 11);
      expect(chip?.color, kitColors.accent);
    });

    testWidgets('moved, cancelled, exam and custom states map colours', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const NinjaLessonRow(
            title: 'Английский',
            time: '14:20',
            meta: 'А-105 → А-401',
            state: LessonRowState.moved,
          ),
        ),
      );
      expect(barColorOf(tester), kitColors.warn);
      expect(kitStyleOf(tester, 'А-105 → А-401')?.color, kitColors.warn);

      await tester.pumpWidget(
        host(
          const NinjaLessonRow(
            title: 'Философия',
            time: '16:20',
            meta: 'отменена',
            state: LessonRowState.cancelled,
          ),
        ),
      );
      final cancelled = kitStyleOf(tester, 'Философия');
      expect(cancelled?.decoration, TextDecoration.lineThrough);
      expect(cancelled?.color, kitColors.muted);
      expect(kitStyleOf(tester, 'отменена')?.color, kitColors.danger);
      expect(barColorOf(tester), kitColors.exam);

      await tester.pumpWidget(
        host(
          const NinjaLessonRow(
            title: 'Базы данных',
            time: '18:00',
            state: LessonRowState.exam,
          ),
        ),
      );
      expect(kitDecorationOf(tester, NinjaLessonRow).color, kitColors.examTint);

      await tester.pumpWidget(
        host(
          const NinjaLessonRow(
            title: 'Волейбол',
            time: '19:40',
            state: LessonRowState.custom,
          ),
        ),
      );
      expect(barColorOf(tester), kitColors.ink);
      expect(LessonRowState.custom, LessonRowState.own);
    });

    testWidgets('more button is a 36px surface2 circle', (tester) async {
      var more = 0;
      await tester.pumpWidget(
        host(
          NinjaLessonRow(title: 'Физика', time: '12:40', onMore: () => more++),
        ),
      );

      final circle = tester.widget<Container>(
        find
            .ancestor(
              of: find.byType(AppLineIconWidget),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(circle.constraints?.maxWidth, 36);
      expect((circle.decoration! as BoxDecoration).color, kitColors.surface2);
      await tester.tap(find.byType(AppLineIconWidget));
      expect(more, 1);
    });

    testWidgets('legacy past/current flags and onTap still work', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        host(
          NinjaLessonRow(
            title: 'Физика',
            time: '12:40',
            current: true,
            onTap: () => taps++,
          ),
        ),
      );

      expect(kitDecorationOf(tester, NinjaLessonRow).color, kitColors.tint);
      await tester.tap(find.text('Физика'));
      expect(taps, 1);
    });

    testWidgets('survives 320px at 200 percent text', (tester) async {
      tester.view
        ..physicalSize = const Size(320, 568)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        wrapKit(
          const SingleChildScrollView(
            child: NinjaLessonRow(
              title: 'Проектирование информационных систем',
              time: '10:40',
              endTime: '12:10',
              meta: 'лекция · А-123 · Иванов Иван Иванович',
              stateLabel: 'next',
            ),
          ),
          textScale: 2,
        ),
      );
      expect(tester.takeException(), isNull);
    });

    test('AppLessonRow aliases the Ninja row', () {
      expect(AppLessonRow, NinjaLessonRow);
      expect(AppLessonAction, NinjaLessonAction);
    });
  });
}
