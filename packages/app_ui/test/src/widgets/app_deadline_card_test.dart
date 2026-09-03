import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(body: Center(child: SizedBox(width: 360, child: child))),
      );

  group('AppDeadlineCard', () {
    testWidgets('renders task, subject·due and the left label', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppDeadlineCard(
            subject: 'БД',
            task: 'Лаб 7',
            due: 'завтра',
            left: '1 день',
            progress: 0.7,
          ),
        ),
      );

      expect(find.text('Лаб 7'), findsOneWidget);
      expect(find.text('БД · завтра'), findsOneWidget);
      expect(find.text('1 день'), findsOneWidget);
    });

    testWidgets('urgent paints the left label in danger', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppDeadlineCard(
            subject: 'БД',
            task: 'Лаб 7',
            due: 'завтра',
            left: '1 день',
            progress: 0.7,
            urgent: true,
          ),
        ),
      );

      final label = tester.widget<Text>(find.text('1 день'));
      expect(label.style?.color, AppColors.light.danger);
      expect(label.style?.fontWeight, FontWeight.w800);
    });

    testWidgets('done strikes the title through and dims the row', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppDeadlineCard(
            subject: 'БД',
            task: 'Лаб 7',
            due: 'завтра',
            left: 'сдано',
            progress: 1,
            done: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final title = tester.widget<Text>(find.text('Лаб 7'));
      expect(title.style?.decoration, TextDecoration.lineThrough);

      final opacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity).first,
      );
      expect(opacity.opacity, 0.55);
    });

    testWidgets('the 44px check button toggles', (tester) async {
      var toggled = false;
      await tester.pumpWidget(
        wrap(
          AppDeadlineCard(
            subject: 'БД',
            task: 'Лаб 7',
            due: 'завтра',
            left: '1 день',
            progress: 0.7,
            onToggle: () => toggled = true,
          ),
        ),
      );

      final button = find.byType(AnimatedContainer);
      expect(tester.getSize(button), const Size(44, 44));

      await tester.tap(button);
      expect(toggled, isTrue);
    });
  });
}
