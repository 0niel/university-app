import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

class _TestAuthenticationFailure extends AuthenticationException {
  const _TestAuthenticationFailure(super.error);
}

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
  late _MockUserRepository userRepository;

  setUp(() {
    userRepository = _MockUserRepository();
  });

  Future<void> pumpLogin(WidgetTester tester, Exception failure) async {
    when(
      () => userRepository.logInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(failure);

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserRepository>.value(value: userRepository),
          RepositoryProvider<UniversityConfig>.value(value: _config),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => NinjaToastHost(child: child!),
          home: const LoginPage(),
        ),
      ),
    );

    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('loginPage_emailInput')),
        matching: find.byType(EditableText),
      ),
      'student@mirea.ru',
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('loginPage_passwordInput')),
        matching: find.byType(EditableText),
      ),
      'password123',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('loginPage_submitButton')));
    await tester.pump();
    await tester.pump();
  }

  testWidgets('invalid credentials use the Russian localized message', (
    tester,
  ) async {
    await pumpLogin(
      tester,
      const _TestAuthenticationFailure(
        AuthException(
          'Invalid login credentials',
          statusCode: '400',
          code: 'invalid_credentials',
        ),
      ),
    );

    expect(find.text('Неверный email или пароль.'), findsOneWidget);
    expect(find.text('Invalid login credentials'), findsNothing);
  });

  testWidgets('transport failures use the localized generic message', (
    tester,
  ) async {
    await pumpLogin(tester, Exception('backend transport details'));

    expect(
      find.text('Не удалось войти. Проверьте данные и попробуйте снова.'),
      findsOneWidget,
    );
    expect(find.text('backend transport details'), findsNothing);
  });
}
