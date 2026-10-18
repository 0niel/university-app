import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart' hide User;

class _Users extends Mock implements UserRepository {}

void main() {
  late _Users users;
  const email = 'student@university.example';

  setUp(() {
    users = _Users();
    ToastManager.debugReset();
    when(
      () => users.sendPasswordResetEmail(email: any(named: 'email')),
    ).thenAnswer((_) async {});
    when(
      () => users.verifyPasswordResetCode(
        email: any(named: 'email'),
        code: any(named: 'code'),
      ),
    ).thenAnswer((_) async => 'verified-owner');
    when(
      () => users.setAccountPassword(
        userId: any(named: 'userId'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(ToastManager.debugReset);

  Finder input(String key) => find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(EditableText),
  );

  Future<void> pump(WidgetTester tester, {double scale = 1}) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      RepositoryProvider<UserRepository>.value(
        value: users,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
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
          home: const Scaffold(body: Text('Previous screen')),
        ),
      ),
    );
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    unawaited(
      navigator.push<void>(
        MaterialPageRoute(builder: (_) => const PasswordResetPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(input('passwordResetPage_emailInput'), email);
    await tester.pump();
  }

  Future<void> tap(WidgetTester tester, String key) async {
    final finder = find.byKey(Key(key));
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> verifyCode(WidgetTester tester, [String code = '123456']) async {
    await tester.enterText(input('passwordResetPage_codeInput'), code);
    await tester.pumpAndSettle();
  }

  Future<void> fillPasswords(WidgetTester tester) async {
    await tester.enterText(
      input('passwordResetPage_passwordInput'),
      'new-password-123',
    );
    await tester.enterText(
      input('passwordResetPage_confirmPasswordInput'),
      'new-password-123',
    );
    await tester.pump();
  }

  testWidgets('sent email stays on recovery and completes code and password', (
    tester,
  ) async {
    await pump(tester);
    await tap(tester, 'passwordResetPage_submitButton');
    expect(find.byType(PasswordResetPage), findsOneWidget);
    expect(input('passwordResetPage_codeInput'), findsOneWidget);
    expect(find.textContaining(email), findsOneWidget);
    expect(
      tester
          .widget<AppButton>(
            find.byKey(const Key('passwordResetPage_resendButton')),
          )
          .onPressed,
      isNull,
    );

    await verifyCode(tester);
    expect(input('passwordResetPage_passwordInput'), findsOneWidget);
    await fillPasswords(tester);
    await tap(tester, 'passwordResetPage_submitButton');
    expect(find.byType(PasswordResetPage), findsNothing);
    expect(find.text('Previous screen'), findsOneWidget);
    verify(() => users.sendPasswordResetEmail(email: email)).called(1);
    verify(
      () => users.verifyPasswordResetCode(email: email, code: '123456'),
    ).called(1);
    verify(
      () => users.setAccountPassword(
        userId: 'verified-owner',
        password: 'new-password-123',
      ),
    ).called(1);
    verifyNever(() => users.sendLoginEmailLink(email: any(named: 'email')));
    expect(tester.takeException(), isNull);
  });

  testWidgets('existing email code can be entered without another request', (
    tester,
  ) async {
    await pump(tester);
    await tap(tester, 'passwordResetPage_haveCodeButton');
    await verifyCode(tester);
    expect(input('passwordResetPage_passwordInput'), findsOneWidget);
    verifyNever(() => users.sendPasswordResetEmail(email: any(named: 'email')));
  });

  testWidgets('email rate limiting does not block an already delivered code', (
    tester,
  ) async {
    when(() => users.sendPasswordResetEmail(email: email)).thenThrow(
      const AuthException(
        'Wait',
        statusCode: '429',
        code: 'over_email_send_rate_limit',
      ),
    );
    await pump(tester);
    await tap(tester, 'passwordResetPage_submitButton');
    expect(input('passwordResetPage_codeInput'), findsOneWidget);
    expect(
      find.textContaining('Письма запрашиваются слишком часто.'),
      findsOneWidget,
    );
    await verifyCode(tester);
    expect(input('passwordResetPage_passwordInput'), findsOneWidget);
    verify(() => users.sendPasswordResetEmail(email: email)).called(1);
  });

  testWidgets('invalid code remains editable and a corrected code advances', (
    tester,
  ) async {
    when(
      () => users.verifyPasswordResetCode(email: email, code: '123456'),
    ).thenThrow(const AuthException('Expired', code: 'otp_expired'));
    await pump(tester);
    await tap(tester, 'passwordResetPage_haveCodeButton');
    await verifyCode(tester);
    final code = tester.widget<EditableText>(
      input('passwordResetPage_codeInput'),
    );
    expect(code.controller.text, '123456');
    expect(code.readOnly, isFalse);
    await verifyCode(tester, '654321');
    expect(input('passwordResetPage_passwordInput'), findsOneWidget);
    verifyNever(() => users.sendPasswordResetEmail(email: any(named: 'email')));
  });

  testWidgets('password save can retry without verifying the consumed code', (
    tester,
  ) async {
    var calls = 0;
    when(
      () => users.setAccountPassword(
        userId: 'verified-owner',
        password: 'new-password-123',
      ),
    ).thenAnswer((_) async {
      if (calls++ == 0) throw Exception('Offline');
    });
    await pump(tester);
    await tap(tester, 'passwordResetPage_haveCodeButton');
    await verifyCode(tester);
    await fillPasswords(tester);
    await tap(tester, 'passwordResetPage_submitButton');
    expect(input('passwordResetPage_passwordInput'), findsOneWidget);
    expect(
      find.textContaining('код повторно вводить не нужно'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<EditableText>(input('passwordResetPage_passwordInput'))
          .controller
          .text,
      'new-password-123',
    );
    await tap(tester, 'passwordResetPage_submitButton');
    expect(find.byType(PasswordResetPage), findsNothing);
    verify(
      () => users.verifyPasswordResetCode(email: email, code: '123456'),
    ).called(1);
  });

  testWidgets('back returns to the saved email without resending it', (
    tester,
  ) async {
    await pump(tester);
    await tap(tester, 'passwordResetPage_submitButton');
    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<EditableText>(input('passwordResetPage_emailInput'))
          .controller
          .text,
      email,
    );
    await tap(tester, 'passwordResetPage_haveCodeButton');
    expect(input('passwordResetPage_codeInput'), findsOneWidget);
    verify(() => users.sendPasswordResetEmail(email: email)).called(1);
  });

  testWidgets('code and new password steps fit at 200 percent text', (
    tester,
  ) async {
    await pump(tester, scale: 2);
    await tap(tester, 'passwordResetPage_haveCodeButton');
    expect(tester.takeException(), isNull);
    await verifyCode(tester);
    expect(tester.takeException(), isNull);
    await fillPasswords(tester);
    await tester.scrollUntilVisible(
      find.byKey(const Key('passwordResetPage_submitButton')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(
      find.byKey(const Key('passwordResetPage_submitButton')).hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('leaving while verifying ignores the late result', (
    tester,
  ) async {
    final request = Completer<String>();
    when(
      () => users.verifyPasswordResetCode(email: email, code: '123456'),
    ).thenAnswer((_) => request.future);
    await pump(tester);
    await tap(tester, 'passwordResetPage_haveCodeButton');
    await tester.enterText(input('passwordResetPage_codeInput'), '123456');
    await tester.pump();
    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();
    request.complete('verified-owner');
    await tester.pumpAndSettle();
    expect(find.byType(PasswordResetPage), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
