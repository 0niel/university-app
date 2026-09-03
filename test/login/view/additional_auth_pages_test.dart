import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:user_repository/user_repository.dart';

class _Repository extends Mock implements UserRepository {}

const _config = UniversityConfig(
  organizationId: 'test',
  appName: 'Test',
  universityName: 'Test University',
  universityShortName: 'TU',
  websiteUrl: 'https://example.com',
  supportEmail: 'support@example.com',
  deepLinkScheme: 'test',
  webAppHost: 'example.com',
  webAppPathPrefix: '/',
  allowedEmailDomains: ['mirea.ru'],
);

void main() {
  late _Repository repository;
  setUp(() {
    repository = _Repository();
    ToastManager.debugReset();
  });
  tearDown(ToastManager.debugReset);

  Future<void> pump(
    WidgetTester tester,
    Widget page, {
    double scale = 1,
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserRepository>.value(value: repository),
          RepositoryProvider<UniversityConfig>.value(value: _config),
        ],
        child: MaterialApp(
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scale),
              disableAnimations: true,
            ),
            child: NinjaToastHost(child: child!),
          ),
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

  Future<void> fillSignUp(WidgetTester tester) async {
    await tester.enterText(input('signUpPage_emailInput'), 'student@mirea.ru');
    await tester.enterText(input('signUpPage_passwordInput'), 'password123');
    await tester.enterText(
      input('signUpPage_confirmPasswordInput'),
      'password123',
    );
    await tester.pump();
  }

  for (final dark in [false, true]) {
    testWidgets(
      'sign-up labels and validation use the kit in ${dark ? 'dark' : 'light'}',
      (tester) async {
        await pump(tester, const SignUpPage(), dark: dark);
        expect(find.text('Ваш email'), findsOneWidget);
        expect(find.text('Пароль'), findsOneWidget);
        expect(find.text('Повторите пароль'), findsOneWidget);
        final button = find.byKey(const Key('signUpPage_submitButton'));
        expect(tester.widget<AppButton>(button).onPressed, isNull);
        await tester.enterText(
          input('signUpPage_emailInput'),
          'student@example.com',
        );
        await tester.enterText(
          input('signUpPage_passwordInput'),
          'password123',
        );
        await tester.enterText(
          input('signUpPage_confirmPasswordInput'),
          'different123',
        );
        await tester.pump();
        expect(find.text('Пароли не совпадают'), findsOneWidget);
        expect(
          find.textContaining('Используйте адрес одного из доменов:'),
          findsNothing,
        );
        expect(tester.widget<AppButton>(button).onPressed, isNull);
        await tester.enterText(
          input('signUpPage_confirmPasswordInput'),
          'password123',
        );
        await tester.pump();
        expect(tester.widget<AppButton>(button).onPressed, isNotNull);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'sign-up IME submits once and blocks editing during the request',
    (tester) async {
      final request = Completer<void>();
      addTearDown(() {
        if (!request.isCompleted) request.completeError(Exception('cancelled'));
      });
      when(
        () => repository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => request.future);
      await pump(tester, const SignUpPage());
      await fillSignUp(tester);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.pump();
      expect(
        tester
            .widget<AppButton>(find.byKey(const Key('signUpPage_submitButton')))
            .loading,
        isTrue,
      );
      for (final field in tester.widgetList<AppInputField>(
        find.byType(AppInputField),
      )) {
        expect(field.enabled, isFalse);
      }
      verify(
        () => repository.signUp(
          email: 'student@mirea.ru',
          password: 'password123',
        ),
      ).called(1);
      request.completeError(Exception('unavailable'));
      await tester.pump();
      await tester.pump();
      expect(
        tester
            .widget<AppButton>(find.byKey(const Key('signUpPage_submitButton')))
            .loading,
        isFalse,
      );
      expect(
        find.text('Не удалось зарегистрироваться. Попробуйте ещё раз.'),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets(
    'reset displays a label and retains the address after a failed request',
    (tester) async {
      when(
        () => repository.sendPasswordResetEmail(email: any(named: 'email')),
      ).thenThrow(Exception('unavailable'));
      await pump(tester, const PasswordResetPage());
      expect(find.text('Ваш email'), findsOneWidget);
      await tester.enterText(
        input('passwordResetPage_emailInput'),
        'student@mirea.ru',
      );
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.pump();
      expect(
        find.text('Не удалось отправить письмо. Попробуйте ещё раз.'),
        findsOneWidget,
      );
      expect(
        tester
            .widget<EditableText>(input('passwordResetPage_emailInput'))
            .controller
            .text,
        'student@mirea.ru',
      );
      verify(
        () => repository.sendPasswordResetEmail(email: 'student@mirea.ru'),
      ).called(1);
      await tester.pump(const Duration(seconds: 4));
    },
  );

  for (final page in [
    const SignUpPage(),
    const PasswordResetPage(),
    const LoginWithEmailPage(),
  ]) {
    testWidgets('${page.runtimeType} remains scrollable at 200 percent text', (
      tester,
    ) async {
      await pump(tester, page, scale: 2);
      expect(tester.takeException(), isNull);
      final action = find.byKey(
        Key(switch (page) {
          SignUpPage() => 'signUpPage_submitButton',
          PasswordResetPage() => 'passwordResetPage_submitButton',
          _ => 'loginWithEmailForm_nextButton',
        }),
      );
      await tester.scrollUntilVisible(
        action,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();
      expect(action.hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
