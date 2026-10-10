@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/view/login_page.dart';
import 'package:rtu_mirea_app/login/widgets/entry_campus_preview.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/onboarding/widgets/welcome_step.dart';
import 'package:user_repository/user_repository.dart';

import 'gallery_fonts.dart';

class _UserRepository extends Mock implements UserRepository {}

enum _Scene {
  login,
  password,
  teacherLogin,
  teacherPassword,
  welcome,
  secondStory,
  thirdStory,
}

void main() {
  setUpAll(() async {
    await loadGalleryFonts();
    await EntryCampusPreview.preload();
  });

  for (final dark in [false, true]) {
    for (final scene in _Scene.values) {
      final welcome = [
        _Scene.welcome,
        _Scene.secondStory,
        _Scene.thirdStory,
      ].contains(scene);
      final sceneName = switch (scene) {
        _Scene.login => 'entry_login',
        _Scene.password => 'entry_password',
        _Scene.teacherLogin => 'entry_teacher_login',
        _Scene.teacherPassword => 'entry_teacher_password',
        _Scene.welcome => 'entry_welcome',
        _Scene.secondStory => 'entry_welcome_story_2',
        _Scene.thirdStory => 'entry_welcome_story_3',
      };
      final name =
          '$sceneName'
          '${dark ? '_dark' : ''}';
      testWidgets(name, (tester) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<UserRepository>.value(
                value: _UserRepository(),
              ),
              RepositoryProvider<UniversityConfig>.value(
                value: const UniversityConfig(
                  organizationId: 'test-university',
                  appName: 'Mirea Ninja',
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
              home: welcome
                  ? Builder(
                      builder: (context) => Scaffold(
                        backgroundColor: context.colors.canvas,
                        body: OnboardingWelcomeStep(
                          totalSteps: 4,
                          onStart: () {},
                          onTeacherStart: () {},
                          onHaveAccount: () {},
                        ),
                      ),
                    )
                  : const LoginPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (scene == _Scene.teacherLogin || scene == _Scene.teacherPassword) {
          await tester.tap(find.text('Преподаватель'));
          await tester.pumpAndSettle();
        }
        if (scene == _Scene.password || scene == _Scene.teacherPassword) {
          await tester.ensureVisible(
            find.byKey(const Key('loginPage_startButton')),
          );
          await tester.tap(find.byKey(const Key('loginPage_startButton')));
          await tester.pumpAndSettle();
          expect(find.byKey(const Key('loginPage_emailInput')), findsOneWidget);
          expect(
            find.byKey(const Key('loginPage_passwordInput')),
            findsOneWidget,
          );
        }
        final advances = switch (scene) {
          _Scene.secondStory => 1,
          _Scene.thirdStory => 2,
          _ => 0,
        };
        for (var page = 0; page < advances; page++) {
          await tester.tap(find.byKey(const Key('onboarding_storyNext')));
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
        if (scene == _Scene.secondStory) {
          expect(find.byType(MapFloorCanvas), findsOneWidget);
        }
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/$name.png'),
        );
      });
    }
  }
}
