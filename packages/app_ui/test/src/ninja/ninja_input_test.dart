import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  BoxDecoration fieldDecoration(WidgetTester tester) {
    final box = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(NinjaInput),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    return box.decoration as BoxDecoration;
  }

  group('NinjaInput', () {
    testWidgets('renders the label and the placeholder', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaInput(
            label: 'Тема обращения',
            placeholder: 'Продлить студенческий',
          ),
        ),
      );

      expect(find.text('Тема обращения'), findsOneWidget);
      expect(find.text('Продлить студенческий'), findsOneWidget);
      expect(fieldDecoration(tester).color, colors.surfaceAlt);
      expect(fieldDecoration(tester).border, isNull);
      expect(
        fieldDecoration(tester).borderRadius,
        BorderRadius.circular(NinjaRadius.button),
      );
    });

    testWidgets('focus uses a soft accent tint', (tester) async {
      await tester.pumpWidget(wrap(const NinjaInput(placeholder: 'Тема')));

      await tester.tap(find.byType(TextField));
      await tester.pump();

      final decoration = fieldDecoration(tester);
      expect(decoration.color, colors.infoTint);
      expect(decoration.border, isNull);
      expect(decoration.boxShadow, isNull);
    });

    testWidgets('typing reports the value and offers the clear ×', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? changed;

      await tester.pumpWidget(
        wrap(
          NinjaInput(
            controller: controller,
            onChanged: (value) => changed = value,
          ),
        ),
      );

      expect(find.bySemanticsLabel('Clear field'), findsNothing);

      await tester.enterText(find.byType(TextField), 'Наушники TWS');
      await tester.pump();

      expect(changed, 'Наушники TWS');
      expect(find.bySemanticsLabel('Clear field'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Clear field'));
      await tester.pump();

      expect(controller.text, isEmpty);
      expect(find.bySemanticsLabel('Clear field'), findsNothing);
    });

    testWidgets('error paints scarlet and shows the helper row', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const NinjaInput(errorText: 'Похоже, адрес не дописан')),
      );

      final decoration = fieldDecoration(tester);
      expect(decoration.color, colors.dangerTint);
      expect(decoration.border, isNull);
      expect(find.text('Похоже, адрес не дописан'), findsOneWidget);
      expect(find.byType(AppLineIconWidget), findsOneWidget);
      expect(
        tester.widget<Text>(find.text('Похоже, адрес не дописан')).style?.color,
        colors.scarlet,
      );
    });

    testWidgets('helper text renders muted while there is no error', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const NinjaInput(helperText: 'Как в зачётке')),
      );

      expect(find.byType(AppLineIconWidget), findsNothing);
      expect(
        tester.widget<Text>(find.text('Как в зачётке')).style?.color,
        colors.muted,
      );
    });

    testWidgets('success uses a soft green fill and the check', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const NinjaInput(success: true)));

      expect(fieldDecoration(tester).color, colors.successTint);
      expect(fieldDecoration(tester).border, isNull);
      expect(find.byType(NinjaCheckMark), findsOneWidget);
    });

    testWidgets('disabled fills with surfaceAlt and refuses input', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const NinjaInput(enabled: false)));

      final decoration = fieldDecoration(tester);
      expect(decoration.color, colors.surface);
      expect(decoration.border, isNull);
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    });

    testWidgets('password mode obscures the value and toggles the eye', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const NinjaInput(obscureText: true)));

      expect(
        tester.widget<TextField>(find.byType(TextField)).obscureText,
        isTrue,
      );

      await tester.tap(find.bySemanticsLabel('Show password'));
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField)).obscureText,
        isFalse,
      );
      expect(find.bySemanticsLabel('Hide password'), findsOneWidget);
      expect(
        tester.getSize(find.bySemanticsLabel('Hide password')),
        const Size(44, 44),
      );
    });

    testWidgets('clear action keeps a 44px semantic target', (tester) async {
      final controller = TextEditingController(text: 'Поиск');
      addTearDown(controller.dispose);
      await tester.pumpWidget(wrap(NinjaInput(controller: controller)));

      final clear = find.bySemanticsLabel('Clear field');
      expect(clear, findsOneWidget);
      expect(tester.getSize(clear).width, greaterThanOrEqualTo(44));
      expect(tester.getSize(clear).height, greaterThanOrEqualTo(44));
      await tester.tap(clear);
      await tester.pump();
      expect(controller.text, isEmpty);
    });

    testWidgets('multiline grows to 84 and counts characters', (tester) async {
      await tester.pumpWidget(
        wrap(const NinjaInput.multiline(maxLength: 300)),
      );

      expect(find.text('0 / 300'), findsOneWidget);
      expect(
        tester.getSize(find.byType(NinjaInput)).height,
        greaterThanOrEqualTo(84),
      );
      expect(
        fieldDecoration(tester).borderRadius,
        BorderRadius.circular(NinjaRadius.control),
      );

      await tester.enterText(find.byType(TextField), 'Потерял наушники');
      await tester.pump();

      expect(find.text('16 / 300'), findsOneWidget);
    });

    testWidgets('a leading icon sits before the value', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaInput(
            leadingIcon: Icon(Icons.search),
            placeholder: 'Поиск по кампусу',
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
