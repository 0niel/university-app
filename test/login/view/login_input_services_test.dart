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
  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    for (final (name, page, keys) in [
      (
        'login',
        const LoginPage(),
        ['loginPage_emailInput', 'loginPage_passwordInput'],
      ),
      (
        'registration',
        const SignUpPage(),
        [
          'signUpPage_emailInput',
          'signUpPage_passwordInput',
          'signUpPage_confirmPasswordInput',
        ],
      ),
      (
        'email code login',
        const LoginWithEmailPage(),
        ['loginWithEmailForm_emailInput_textField'],
      ),
      (
        'password reset',
        const PasswordResetPage(),
        ['passwordResetPage_emailInput'],
      ),
    ]) {
      testWidgets(
        '$name disables autofill and suggestions on ${platform.name}',
        (
          tester,
        ) async {
          tester.view
            ..devicePixelRatio = 1
            ..physicalSize = const Size(390, 844);
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            RepositoryProvider<UserRepository>(
              create: (_) => _UserRepository(),
              child: MaterialApp(
                theme: AppTheme.darkTheme.copyWith(platform: platform),
                locale: const Locale('ru'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: page,
              ),
            ),
          );
          await tester.pumpAndSettle();
          final start = find.byKey(const Key('loginPage_startButton'));
          if (start.evaluate().isNotEmpty) {
            await tester.tap(start);
            await tester.pumpAndSettle();
          }

          void expectInputServicesDisabled() {
            final configuration = tester.testTextInput.setClientArgs!;
            expect(configuration['autofill'], isNull);
            expect(configuration['autocorrect'], isFalse);
            expect(configuration['enableSuggestions'], isFalse);
            expect(
              tester.testTextInput.log.where(
                (call) => call.method == 'TextInput.requestAutofill',
              ),
              isEmpty,
            );
          }

          for (final key in keys) {
            final container = find.byKey(Key(key));
            final input = find.descendant(
              of: container,
              matching: find.byType(EditableText),
            );
            await tester.ensureVisible(input);
            tester.testTextInput.log.clear();
            await tester.tap(input);
            await tester.pumpAndSettle();
            expectInputServicesDisabled();
            final focus = tester.widget<EditableText>(input).focusNode;
            final isPassword = key.toLowerCase().contains('passwordinput');
            final text = isPassword ? 'password123' : 'student@example.com';
            tester.testTextInput.enterText(text);
            await tester.pumpAndSettle();
            expect(focus.hasFocus, isTrue);
            expect(tester.testTextInput.isVisible, isTrue);

            if (isPassword) {
              for (final show in [true, false]) {
                await tester.tap(
                  find.descendant(
                    of: container,
                    matching: find.bySemanticsLabel(
                      show ? 'Показать пароль' : 'Скрыть пароль',
                    ),
                  ),
                );
                await tester.pumpAndSettle();
                expectInputServicesDisabled();
                final editable = tester.widget<EditableText>(input);
                expect(editable.focusNode, same(focus));
                expect(focus.hasFocus, isTrue);
                expect(editable.controller.text, text);
                expect(editable.obscureText, !show);
                expect(tester.testTextInput.isVisible, isTrue);
              }
            }
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
