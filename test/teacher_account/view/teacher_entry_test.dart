import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/view/login_page.dart';
import 'package:rtu_mirea_app/login/view/sign_up_page.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_entry_intent_cubit.dart';
import 'package:user_repository/user_repository.dart';

class _Users extends Mock implements UserRepository {}

class _Storage extends Mock implements Storage {}

void main() {
  late AccountEntryIntentCubit intent;
  late GoRouter router;

  setUp(() {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    intent = AccountEntryIntentCubit();
    router = GoRouter(
      initialLocation: '/auth',
      routes: [
        GoRoute(path: '/auth', builder: (_, _) => const LoginPage()),
        GoRoute(path: '/sign-up', builder: (_, _) => const SignUpPage()),
      ],
    );
  });

  tearDown(() async {
    router.dispose();
    await intent.close();
  });

  Future<void> pump(WidgetTester tester, {double scale = 1}) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserRepository>.value(value: _Users()),
          RepositoryProvider<UniversityConfig>.value(
            value: const UniversityConfig(
              organizationId: 'test-university',
              appName: 'Campus Hub',
              universityName: 'Test University',
              universityShortName: 'TU',
              websiteUrl: 'https://university.example.edu',
              supportEmail: 'support@example.edu',
              deepLinkScheme: 'campushub',
              webAppHost: 'campus.example.edu',
              webAppPathPrefix: '/app',
            ),
          ),
        ],
        child: BlocProvider.value(
          value: intent,
          child: MaterialApp.router(
            routerConfig: router,
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
                disableAnimations: true,
              ),
              child: child!,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('role choice preserves credentials and applies student intent', (
    tester,
  ) async {
    await pump(tester);
    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('loginPage_emailInput')),
        matching: find.byType(EditableText),
      ),
      'teacher@example.edu',
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('loginPage_passwordInput')),
        matching: find.byType(EditableText),
      ),
      'password123',
    );
    await tester.ensureVisible(find.text('Преподаватель'));
    await tester.tap(find.text('Преподаватель'));
    await tester.pumpAndSettle();
    expect(intent.state, AccountRole.teacher);
    expect(find.text('Вход для преподавателя'), findsOneWidget);
    await tester.tap(find.text('Студент'));
    await tester.pumpAndSettle();
    expect(intent.state, AccountRole.student);
    final email = tester.widget<AppInputField>(
      find.byKey(const Key('loginPage_emailInput')),
    );
    final password = tester.widget<AppInputField>(
      find.byKey(const Key('loginPage_passwordInput')),
    );
    expect(email.controller?.text, 'teacher@example.edu');
    expect(password.controller?.text, 'password123');
    expect(tester.takeException(), isNull);
  });

  testWidgets('teacher intent follows the shared registration route', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Преподаватель'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('loginPage_signUpLink')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('loginPage_signUpLink')));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpPage), findsOneWidget);
    expect(find.textContaining('После подтверждения почты'), findsOneWidget);
    expect(intent.state, AccountRole.teacher);
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Вход для преподавателя'), findsOneWidget);
  });

  testWidgets('teacher entry stays reachable at 320px and 200% text', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pump(tester, scale: 2);
    await tester.ensureVisible(find.text('Преподаватель'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Преподаватель'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('loginPage_guestButton')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(intent.state, AccountRole.teacher);
    expect(tester.takeException(), isNull);
  });
}
