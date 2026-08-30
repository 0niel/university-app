import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

String? _required(String? value) =>
    value == null || value.isEmpty ? 'Обязательное поле' : null;

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppInputField', () {
    testWidgets('renders placeholder and forwards onChanged', (tester) async {
      String? changed;
      await tester.pumpWidget(
        wrap(
          AppInputField(
            placeholder: 'student@mirea.ru',
            onChanged: (v) => changed = v,
          ),
        ),
      );

      expect(find.text('student@mirea.ru'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'hi');
      expect(changed, 'hi');
    });

    testWidgets('shows an error message and helper text', (tester) async {
      await tester.pumpWidget(
        wrap(const AppInputField(errorText: 'Неверный пароль')),
      );
      expect(find.text('Неверный пароль'), findsOneWidget);

      await tester.pumpWidget(
        wrap(const AppInputField(helperText: 'минимум 8 символов')),
      );
      expect(find.text('минимум 8 символов'), findsOneWidget);
    });

    testWidgets('renders an uppercased label above the field', (tester) async {
      await tester.pumpWidget(
        wrap(const AppInputField(label: 'Название')),
      );
      expect(find.text('НАЗВАНИЕ'), findsOneWidget);
    });

    testWidgets('multiline constructor allows several lines', (tester) async {
      await tester.pumpWidget(
        wrap(const AppInputField.multiline(maxLines: 5, minLines: 2)),
      );
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.maxLines, 5);
      expect(field.minLines, 2);
    });

    testWidgets('disabled field is not editable', (tester) async {
      await tester.pumpWidget(
        wrap(const AppInputField(enabled: false)),
      );
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.enabled, isFalse);
    });

    testWidgets('password toggle flips obscureText', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppInputField(
            obscureText: true,
            showPasswordToggle: true,
          ),
        ),
      );

      var field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, isTrue);

      await tester.tap(find.byType(AppLineIconWidget));
      await tester.pump();

      field = tester.widget<TextField>(find.byType(TextField));
      expect(field.obscureText, isFalse);
      final toggle = find.bySemanticsLabel('Hide password');
      expect(toggle, findsOneWidget);
      expect(tester.getSize(toggle).width, greaterThanOrEqualTo(44));
      expect(tester.getSize(toggle).height, greaterThanOrEqualTo(44));
    });

    testWidgets('validator participates in the enclosing Form', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        wrap(
          Form(
            key: formKey,
            child: const AppInputField(validator: _required),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Обязательное поле'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Машинное обучение');
      expect(formKey.currentState!.validate(), isTrue);
    });
  });
}
