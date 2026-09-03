import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  BoxDecoration fillOf(WidgetTester tester) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(NinjaInput),
              matching: find.byType(Container),
            )
            .first,
      );

  testWidgets('delegates to AppInputField with the surface2 fill', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(const NinjaInput(placeholder: 'Как к вам обращаться')),
    );

    expect(find.byType(AppInputField), findsOneWidget);
    expect(fillOf(tester).color, kitColors.surface2);
  });

  testWidgets('reports typed text', (tester) async {
    var value = '';
    await tester.pumpWidget(
      wrapKit(NinjaInput(onChanged: (next) => value = next)),
    );

    await tester.enterText(find.byType(TextField), 'ИКБО-01-24');
    expect(value, 'ИКБО-01-24');
  });

  testWidgets('error switches the fill to examTint', (tester) async {
    await tester.pumpWidget(
      wrapKit(const NinjaInput(errorText: 'Такой группы нет')),
    );

    expect(fillOf(tester).color, kitColors.examTint);
    expect(find.text('Такой группы нет'), findsOneWidget);
  });

  testWidgets('success switches the fill to lectureTint', (tester) async {
    await tester.pumpWidget(wrapKit(const NinjaInput(success: true)));

    expect(fillOf(tester).color, kitColors.lectureTint);
  });

  testWidgets('disabled switches the fill to canvas', (tester) async {
    await tester.pumpWidget(wrapKit(const NinjaInput(enabled: false)));

    expect(fillOf(tester).color, kitColors.canvas);
  });

  testWidgets('password mode renders the eye toggle', (tester) async {
    await tester.pumpWidget(wrapKit(const NinjaInput(obscureText: true)));

    expect(find.byType(AppLineIconWidget), findsOneWidget);
    await tester.tap(find.byType(AppLineIconWidget));
    await tester.pump();
    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isFalse,
    );
  });

  testWidgets('multiline shows the counter', (tester) async {
    final controller = TextEditingController(text: 'Заметка');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: NinjaInput.multiline(controller: controller, maxLength: 280),
        ),
      ),
    );

    expect(find.text('7 / 280'), findsOneWidget);
  });
}
