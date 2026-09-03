import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  BoxDecoration fillOf(WidgetTester tester) => kitDecoration(
        tester,
        find
            .descendant(
              of: find.byType(AppInputField),
              matching: find.byType(Container),
            )
            .first,
      );

  testWidgets('default fill is surface2 with an 18px radius and 48 height', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(const AppInputField(placeholder: 'Как к вам обращаться')),
    );

    final decoration = fillOf(tester);
    expect(decoration.color, kitColors.surface2);
    expect(decoration.borderRadius, BorderRadius.circular(AppRadius.field));
    expect(decoration.border, isNull);
    expect(
      tester
          .widget<Container>(
            find
                .descendant(
                  of: find.byType(AppInputField),
                  matching: find.byType(Container),
                )
                .first,
          )
          .constraints
          ?.maxHeight,
      AppControlSize.field,
    );
  });

  testWidgets('focus switches the fill to tint', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      wrapKit(AppInputField(focusNode: focusNode, placeholder: 'Почта')),
    );

    focusNode.requestFocus();
    await tester.pumpAndSettle();

    expect(fillOf(tester).color, kitColors.tint);
  });

  testWidgets('error fill is examTint and renders the alert row', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        const AppInputField(
          label: 'Группа',
          errorText: 'Такой группы нет в этом семестре',
        ),
      ),
    );

    expect(fillOf(tester).color, kitColors.examTint);
    expect(find.text('Такой группы нет в этом семестре'), findsOneWidget);
    expect(
      kitStyleOf(tester, 'Такой группы нет в этом семестре')?.color,
      kitColors.danger,
    );
    expect(find.byType(AppLineIconWidget), findsOneWidget);
  });

  testWidgets('success fill is lectureTint with a check', (tester) async {
    await tester.pumpWidget(wrapKit(const AppInputField(success: true)));

    expect(fillOf(tester).color, kitColors.lectureTint);
    expect(find.byType(AppLineIconWidget), findsOneWidget);
  });

  testWidgets('disabled fill is canvas and text is muted2', (tester) async {
    final controller = TextEditingController(text: 'Недоступно');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(AppInputField(controller: controller, enabled: false)),
    );

    expect(fillOf(tester).color, kitColors.canvas);
    expect(
      tester.widget<TextField>(find.byType(TextField)).style?.color,
      kitColors.muted2,
    );
  });

  testWidgets('clear button empties the controller', (tester) async {
    final controller = TextEditingController(text: 'abc');
    addTearDown(controller.dispose);
    var changed = '';
    await tester.pumpWidget(
      wrapKit(
        AppInputField(
          controller: controller,
          onChanged: (value) => changed = value,
        ),
      ),
    );

    await tester.tap(find.byType(AppLineIconWidget));
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(changed, isEmpty);
  });

  testWidgets('password toggle flips obscureText', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const AppInputField(obscureText: true, showPasswordToggle: true),
      ),
    );

    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, true);
    await tester.tap(find.byType(AppLineIconWidget));
    await tester.pump();
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, false);
  });

  testWidgets('multiline grows to 84 and shows the counter', (tester) async {
    final controller = TextEditingController(text: 'Заметка');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppInputField.multiline(
            controller: controller,
            maxLength: 280,
          ),
        ),
      ),
    );

    expect(find.text('7 / 280'), findsOneWidget);
    expect(
      tester.getSize(find.byType(AppInputField)).height,
      greaterThanOrEqualTo(84),
    );
  });

  testWidgets('label renders above the field in muted caption', (
    tester,
  ) async {
    await tester.pumpWidget(wrapKit(const AppInputField(label: 'Почта')));

    expect(find.text('Почта'), findsOneWidget);
    expect(kitStyleOf(tester, 'Почта')?.color, kitColors.muted);
    expect(kitStyleOf(tester, 'Почта')?.fontSize, 12);
  });
}
