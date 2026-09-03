import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  const pulse = AlwaysStoppedAnimation<double>(0);
  Finder coachTail() => find.descendant(
        of: find.byType(NinjaCoachCard),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is CustomPaint &&
              widget.painter != null &&
              widget.child == null,
        ),
      );

  group('NinjaSpotlight', () {
    testWidgets('paints a full scrim without a hole', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 300,
            height: 300,
            child: NinjaSpotlight(hole: null, pulse: pulse),
          ),
        ),
      );

      expect(find.byType(IgnorePointer), findsWidgets);
      expect(
        find.descendant(
          of: find.byType(NinjaSpotlight),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
      expect(find.byType(TweenAnimationBuilder<Rect?>), findsNothing);
    });

    testWidgets('animates the hole into place', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const SizedBox(
            width: 300,
            height: 300,
            child: NinjaSpotlight(
              hole: Rect.fromLTWH(20, 20, 120, 48),
              pulse: pulse,
              shape: NinjaSpotlightShape.circle,
            ),
          ),
        ),
      );

      expect(find.byType(TweenAnimationBuilder<Rect?>), findsOneWidget);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('NinjaCoachCard', () {
    testWidgets('renders copy and drives next, back and skip', (
      tester,
    ) async {
      var next = 0;
      var back = 0;
      var skip = 0;
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 340,
            child: NinjaCoachCard(
              title: 'Отмечайтесь на парах',
              body: 'Тап по паре открывает действия',
              progress: '1 / 3',
              nextLabel: 'Далее',
              onNext: () => next++,
              backLabel: 'Назад',
              onBack: () => back++,
              skipLabel: 'Пропустить',
              onSkip: () => skip++,
              arrow: NinjaCoachArrow.up,
            ),
          ),
        ),
      );

      expect(find.text('Отмечайтесь на парах'), findsOneWidget);
      expect(find.text('1 / 3'), findsOneWidget);
      expect(kitStyleOf(tester, '1 / 3')?.color, kitColors.accent);
      final card = kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(NinjaCoachCard),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(card.color, kitColors.surface);
      expect(coachTail(), findsOneWidget);
      expect(tester.getSize(coachTail()), const Size(20, 9));
      expect(
        tester.getBottomLeft(coachTail()).dy,
        tester
            .getTopLeft(
              find
                  .descendant(
                    of: find.byType(NinjaCoachCard),
                    matching: find.byType(DecoratedBox),
                  )
                  .first,
            )
            .dy,
      );

      await tester.tap(find.text('Далее'));
      await tester.tap(find.text('Назад'));
      await tester.tap(find.text('Пропустить'));
      expect(next, 1);
      expect(back, 1);
      expect(skip, 1);
    });

    testWidgets('omits the tail without an arrow', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: 340,
            child: NinjaCoachCard(
              title: 'Готово',
              body: 'Пользуйтесь',
              nextLabel: 'Понятно',
              onNext: () {},
            ),
          ),
        ),
      );

      expect(coachTail(), findsNothing);
    });
  });
}
