@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/login.dart';
import 'package:rtu_mirea_app/onboarding/widgets/identity_step.dart';
import 'package:user_repository/user_repository.dart';

import 'gallery_fonts.dart';

class _Repository extends Mock implements UserRepository {}

enum _Scene {
  signUp,
  signUpInvalid,
  reset,
  email,
  confirm,
  confirmInvalid,
  identity,
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
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    for (final scene in _Scene.values) {
      final name = 'entry_${scene.name}_${dark ? 'dark' : 'light'}';
      testWidgets(name, (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final repository = _Repository();
        when(() => repository.user).thenAnswer(
          (_) => Stream<User>.value(User.anonymous),
        );
        when(
          () => repository.incomingEmailLinks,
        ).thenAnswer((_) => const Stream<Uri>.empty());
        when(
          () => repository.logInWithEmailCode(
            email: any(named: 'email'),
            code: any(named: 'code'),
          ),
        ).thenThrow(Exception('invalid'));
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<UserRepository>.value(value: repository),
              RepositoryProvider<UniversityConfig>.value(value: _config),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: child!,
              ),
              home: switch (scene) {
                _Scene.signUp || _Scene.signUpInvalid => const SignUpPage(),
                _Scene.reset => const PasswordResetPage(),
                _Scene.email => const LoginWithEmailPage(),
                _Scene.confirm || _Scene.confirmInvalid =>
                  const LoginEmailConfirmationPage(email: 'student@mirea.ru'),
                _Scene.identity => Builder(
                  builder: (context) => Scaffold(
                    backgroundColor: context.colors.canvas,
                    body: OnboardingIdentityStep(
                      step: 3,
                      totalSteps: 4,
                      initialName: 'Иван',
                      initialHandle: 'student_1',
                      onBack: () {},
                      onNext: (_, _) {},
                    ),
                  ),
                ),
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (scene == _Scene.signUpInvalid) {
          await tester.enterText(
            find.descendant(
              of: find.byKey(const Key('signUpPage_emailInput')),
              matching: find.byType(EditableText),
            ),
            'student@example.com',
          );
          await tester.enterText(
            find.descendant(
              of: find.byKey(const Key('signUpPage_passwordInput')),
              matching: find.byType(EditableText),
            ),
            'password123',
          );
          await tester.enterText(
            find.descendant(
              of: find.byKey(const Key('signUpPage_confirmPasswordInput')),
              matching: find.byType(EditableText),
            ),
            'different123',
          );
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle();
        } else if (scene == _Scene.confirmInvalid) {
          await tester.enterText(
            find.descendant(
              of: find.byType(AppCodeInput),
              matching: find.byType(EditableText),
            ),
            '654321',
          );
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/$name.png'),
        );
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
