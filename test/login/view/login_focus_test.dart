import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:user_repository/user_repository.dart';

class _UserRepository extends Mock implements UserRepository {}

void main() {
  Future<void> pumpPage(WidgetTester tester, Widget page) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      RepositoryProvider<UserRepository>.value(
        value: _UserRepository(),
        child: MaterialApp(
          theme: AppTheme.darkTheme.copyWith(platform: TargetPlatform.android),
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: page,
        ),
      ),
    );
    await tester.pump();
  }

  Finder input(String key) => find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(EditableText),
  );

  Future<void> typeWithoutRefocusing(
    WidgetTester tester,
    String key,
    String text,
  ) async {
    final field = input(key);
    await tester.ensureVisible(field);
    await tester.tap(field);
    await tester.pump();
    final focus = tester.widget<EditableText>(field).focusNode;
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    await tester.pumpAndSettle();
    expect(focus.hasFocus, isTrue);
    for (var length = 1; length <= text.length; length++) {
      tester.testTextInput.updateEditingValue(
        TextEditingValue(
          text: text.substring(0, length),
          selection: TextSelection.collapsed(offset: length),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<EditableText>(field).focusNode, same(focus));
      expect(focus.hasFocus, isTrue, reason: '$key after character $length');
      expect(tester.testTextInput.isVisible, isTrue);
    }
    expect(tester.takeException(), isNull);
  }

  testWidgets('login keeps focus while typing and the keyboard resizes', (
    tester,
  ) async {
    await pumpPage(tester, const LoginPage());
    await typeWithoutRefocusing(
      tester,
      'loginPage_emailInput',
      'student@example.com',
    );
    await typeWithoutRefocusing(
      tester,
      'loginPage_passwordInput',
      'password123',
    );
  });

  testWidgets(
    'registration keeps focus while typing and the keyboard resizes',
    (
      tester,
    ) async {
      await pumpPage(tester, const SignUpPage());
      await typeWithoutRefocusing(
        tester,
        'signUpPage_emailInput',
        'student@example.com',
      );
      await typeWithoutRefocusing(
        tester,
        'signUpPage_passwordInput',
        'password123',
      );
      await typeWithoutRefocusing(
        tester,
        'signUpPage_confirmPasswordInput',
        'password123',
      );
    },
  );

  for (final email in ['student@example.com', 'invalid']) {
    testWidgets('login next moves from $email directly to the password', (
      tester,
    ) async {
      await pumpPage(tester, const LoginPage());
      await tester.enterText(input('loginPage_emailInput'), email);
      await tester.pumpAndSettle();
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<EditableText>(input('loginPage_passwordInput'))
            .focusNode
            .hasFocus,
        isTrue,
      );
      if (email == 'invalid') {
        tester.testTextInput.enterText('password123');
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<AppButton>(
                find.byKey(const Key('loginPage_submitButton')),
              )
              .onPressed,
          isNull,
        );
      }
    });
  }

  testWidgets('password visibility preserves focus, text and the keyboard', (
    tester,
  ) async {
    await pumpPage(tester, const LoginPage());
    await typeWithoutRefocusing(
      tester,
      'loginPage_passwordInput',
      'password123',
    );
    final field = input('loginPage_passwordInput');
    final focus = tester.widget<EditableText>(field).focusNode;
    for (final show in [true, false]) {
      await tester.tap(
        find.bySemanticsLabel(show ? 'Показать пароль' : 'Скрыть пароль'),
      );
      await tester.pumpAndSettle();
      final editable = tester.widget<EditableText>(field);
      expect(editable.focusNode, same(focus));
      expect(focus.hasFocus, isTrue);
      expect(editable.controller.text, 'password123');
      expect(editable.obscureText, !show);
      expect(tester.testTextInput.isVisible, isTrue);
    }
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('registration next advances through password fields', (
    tester,
  ) async {
    await pumpPage(tester, const SignUpPage());
    await tester.enterText(
      input('signUpPage_emailInput'),
      'student@example.com',
    );
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<EditableText>(input('signUpPage_passwordInput'))
          .focusNode
          .hasFocus,
      isTrue,
    );
    tester.testTextInput.enterText('password123');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<EditableText>(input('signUpPage_confirmPasswordInput'))
          .focusNode
          .hasFocus,
      isTrue,
    );
  });
}
