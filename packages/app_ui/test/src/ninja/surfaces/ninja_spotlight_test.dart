import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child, {bool reduceMotion = false}) => MaterialApp(
        theme: NinjaTheme.light(),
        builder: (context, inner) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: reduceMotion,
          ),
          child: inner!,
        ),
        home: Scaffold(body: child),
      );

  group('NinjaSpotlight', () {
    testWidgets('punches the scrim and rings the hole', (tester) async {
      final pulse = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(seconds: 1),
      )..value = 0.5;
      addTearDown(pulse.dispose);

      await tester.pumpWidget(
        wrap(
          NinjaSpotlight(
            hole: const Rect.fromLTWH(40, 80, 120, 48),
            pulse: pulse,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(CustomPaint).first,
        paintsExactlyCountTimes(#drawPath, 3),
      );
    });

    testWidgets('drops the pulsing ring with reduced motion', (tester) async {
      final pulse = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(seconds: 1),
      )..value = 0.5;
      addTearDown(pulse.dispose);

      await tester.pumpWidget(
        wrap(
          NinjaSpotlight(
            hole: const Rect.fromLTWH(40, 80, 120, 48),
            pulse: pulse,
          ),
          reduceMotion: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(CustomPaint).first,
        paintsExactlyCountTimes(#drawPath, 2),
      );
    });

    testWidgets('covers the screen while the target is unknown', (
      tester,
    ) async {
      final pulse = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(seconds: 1),
      );
      addTearDown(pulse.dispose);

      await tester.pumpWidget(wrap(NinjaSpotlight(hole: null, pulse: pulse)));
      await tester.pumpAndSettle();

      expect(
        find.byType(CustomPaint).first,
        paintsExactlyCountTimes(#drawPath, 1),
      );
    });
  });

  group('NinjaCoachCard', () {
    testWidgets('shows the step copy and drives the tour', (tester) async {
      var next = 0;
      var back = 0;
      var skip = 0;

      await tester.pumpWidget(
        wrap(
          NinjaCoachCard(
            title: 'Поиск по всему кампусу',
            body: 'Пары, преподаватели и аудитории.',
            progress: '2 из 9',
            nextLabel: 'Далее',
            onNext: () => next++,
            backLabel: 'Назад',
            onBack: () => back++,
            skipLabel: 'Пропустить',
            onSkip: () => skip++,
          ),
        ),
      );

      expect(find.text('Поиск по всему кампусу'), findsOneWidget);
      expect(find.text('Пары, преподаватели и аудитории.'), findsOneWidget);
      expect(find.text('2 из 9'), findsOneWidget);

      await tester.tap(find.text('Далее'));
      await tester.tap(find.text('Назад'));
      await tester.tap(find.text('Пропустить'));
      await tester.pump();

      expect(next, 1);
      expect(back, 1);
      expect(skip, 1);
    });

    testWidgets('hides back and skip on the closing step', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaCoachCard(
            title: 'Вот и всё',
            body: 'Обучение можно пройти заново.',
            nextLabel: 'Готово',
            onNext: () {},
          ),
        ),
      );

      expect(find.text('Готово'), findsOneWidget);
      expect(find.text('Назад'), findsNothing);
      expect(find.text('Пропустить'), findsNothing);
    });

    testWidgets('grows a tail that points at the highlight', (tester) async {
      await tester.pumpWidget(
        wrap(
          NinjaCoachCard(
            title: 'Пять разделов',
            body: 'Главная, расписание, карта, сервисы и профиль.',
            nextLabel: 'Далее',
            onNext: () {},
            arrow: NinjaCoachArrow.up,
            arrowOffset: 60,
          ),
        ),
      );

      final column = tester.widget<Column>(
        find
            .descendant(
              of: find.byType(NinjaCoachCard),
              matching: find.byType(Column),
            )
            .first,
      );
      expect(column.children.first, isA<Padding>());
      expect(
        find.descendant(
          of: find.byType(NinjaCoachCard),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
    });
  });
}
