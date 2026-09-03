import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  late _MockUserRepository userRepository;

  setUp(() {
    userRepository = _MockUserRepository();
    when(
      () => userRepository.incomingEmailLinks,
    ).thenAnswer((_) => const Stream<Uri>.empty());
    when(
      () => userRepository.user,
    ).thenAnswer((_) => Stream<User>.value(User.anonymous));
    when(
      () => userRepository.logInWithEmailCode(
        email: any(named: 'email'),
        code: any(named: 'code'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider<UserRepository>.value(
        value: userRepository,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              accessibleNavigation: true,
              disableAnimations: true,
            ),
            child: child ?? const SizedBox.shrink(),
          ),
          home: const LoginEmailConfirmationPage(
            email: 'student@mirea.ru',
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> enterCode(WidgetTester tester, String code) async {
    await tester.enterText(
      find.descendant(
        of: find.byType(AppCodeInput),
        matching: find.byType(EditableText),
      ),
      code,
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('renders the serif title, accent word, progress and cells', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('Код из письма'), findsOneWidget);
    expect(find.byType(AppCodeInput), findsOneWidget);
    expect(find.bySemanticsLabel('Шаг 2 из 2'), findsOneWidget);
    expect(find.byType(AppBackButton), findsOneWidget);

    final colors = tester
        .element(find.byType(LoginEmailConfirmationPage))
        .colors;
    final rich = tester.widget<RichText>(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText() == 'Проверьте почту',
      ),
    );
    TextSpan? accent;
    rich.text.visitChildren((span) {
      if (span is TextSpan && span.text == 'почту') accent = span;
      return true;
    });
    expect(accent?.style?.color, colors.accent);
    expect(accent?.style?.fontStyle, FontStyle.italic);
  });

  testWidgets('a complete code is submitted to the repository', (
    tester,
  ) async {
    await pumpPage(tester);
    await enterCode(tester, '123456');

    verify(
      () => userRepository.logInWithEmailCode(
        email: 'student@mirea.ru',
        code: '123456',
      ),
    ).called(1);
  });

  testWidgets('a rejected code shows the error state and retry resets it', (
    tester,
  ) async {
    when(
      () => userRepository.logInWithEmailCode(
        email: any(named: 'email'),
        code: any(named: 'code'),
      ),
    ).thenThrow(Exception('invalid'));

    await pumpPage(tester);
    await enterCode(tester, '654321');
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.text(
        'Неверный или просроченный код. Проверьте и попробуйте ещё '
        'раз.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Повторить'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final field = tester.widget<EditableText>(
      find.descendant(
        of: find.byType(AppCodeInput),
        matching: find.byType(EditableText),
      ),
    );
    expect(field.controller.text, isEmpty);
    expect(
      find.byKey(const ValueKey('loginEmailConfirmation_failure')),
      findsNothing,
    );
  });

  testWidgets('code input is locked while the entered code is being checked', (
    tester,
  ) async {
    final pending = Completer<void>();
    addTearDown(() {
      if (!pending.isCompleted) pending.complete();
    });
    when(
      () => userRepository.logInWithEmailCode(
        email: any(named: 'email'),
        code: any(named: 'code'),
      ),
    ).thenAnswer((_) => pending.future);
    await pumpPage(tester);
    await enterCode(tester, '123456');
    expect(
      tester.widget<AppCodeInput>(find.byType(AppCodeInput)).readOnly,
      isTrue,
    );
    expect(
      find.byKey(const ValueKey('loginEmailConfirmation_checking')),
      findsOneWidget,
    );
    pending.complete();
    await tester.pump();
    await tester.pump();
    expect(
      find.byKey(const ValueKey('loginEmailConfirmation_checking')),
      findsNothing,
    );
    expect(
      tester.widget<AppCodeInput>(find.byType(AppCodeInput)).readOnly,
      isTrue,
    );
  });
}
