@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/view/login_page.dart';
import 'package:rtu_mirea_app/onboarding/widgets/welcome_step.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_entry_intent_cubit.dart';
import 'package:user_repository/user_repository.dart';

import 'gallery_fonts.dart';

class _UserRepository extends Mock implements UserRepository {}

class _Storage extends Mock implements Storage {}

void main() {
  setUpAll(loadGalleryFonts);

  for (final dark in [false, true]) {
    for (final screen in ['login', 'teacher_login', 'welcome']) {
      final welcome = screen == 'welcome';
      final name = 'entry_$screen${dark ? '_dark' : ''}';
      testWidgets(name, (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final storage = _Storage();
        when(() => storage.read(any())).thenReturn(null);
        when(
          () => storage.write(any(), any<dynamic>()),
        ).thenAnswer((_) async {});
        HydratedBloc.storage = storage;
        final intent = AccountEntryIntentCubit();
        if (screen == 'teacher_login') intent.select(AccountRole.teacher);
        addTearDown(intent.close);
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<UserRepository>.value(
                value: _UserRepository(),
              ),
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
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
                locale: const Locale('ru'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(disableAnimations: true),
                  child: child!,
                ),
                home: welcome
                    ? Builder(
                        builder: (context) => Scaffold(
                          backgroundColor: context.colors.canvas,
                          body: OnboardingWelcomeStep(
                            totalSteps: 4,
                            onStart: () {},
                            onHaveAccount: () {},
                            onTeacherStart: () {},
                          ),
                        ),
                      )
                    : const LoginPage(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/$name.png'),
        );
      });
    }
  }
}
