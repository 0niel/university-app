import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/locale/locale_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/geo_sharing_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/view/about_app_page.dart';
import 'package:rtu_mirea_app/profile/view/profile_settings_page.dart';
import 'package:rtu_mirea_app/schedule/cubit/schedule_display/schedule_display_cubit.dart';
import 'package:user_repository/user_repository.dart';

import '../helpers/profile_test_environment.dart';

class _Profile extends MockCubit<ProfileState> implements ProfileCubit {}

class _App extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _Pass extends MockCubit<PassSecurityState> implements PassSecurityCubit {}

class _Nfc extends MockCubit<NfcHceState> implements NfcHceCubit {}

class _Geo extends MockCubit<GeoSharingState> implements GeoSharingCubit {}

class _Community extends Mock implements CommunityRepository {}

void main() {
  const config = UniversityConfig(
    organizationId: 'test-university',
    appName: 'Campus App',
    universityName: 'Test University',
    universityShortName: 'TU',
    websiteUrl: 'https://example.edu',
    supportEmail: 'support@example.edu',
    deepLinkScheme: 'campus',
    webAppHost: 'example.edu',
    webAppPathPrefix: '/app',
  );

  Widget mediaQueryOverride({required Widget child, required double bottom}) {
    return Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(padding: EdgeInsets.only(bottom: bottom)),
        child: child,
      ),
    );
  }

  testWidgets(
    'settings page reserves the shell bottom inset below its last section',
    (tester) async {
      final environment = ProfileTestEnvironment();
      final profile = _Profile();
      final app = _App();
      final pass = _Pass();
      final nfc = _Nfc();
      final geo = _Geo();
      final theme = ThemeCubit();
      final locale = LocaleCubit();
      final preferences = UiPreferencesCubit();
      final display = ScheduleDisplayCubit();
      [
        profile.close,
        app.close,
        pass.close,
        nfc.close,
        geo.close,
        theme.close,
        locale.close,
        preferences.close,
        display.close,
      ].forEach(addTearDown);
      when(() => profile.state).thenReturn(
        const ProfileState(
          status: ProfileStatus.loaded,
          overview: ProfileOverview(
            academic: AcademicProfile(group: 'ИКБО-01-24'),
          ),
          gamificationProfile: UserGamificationProfile(
            userId: 'me',
            xp: 2340,
            level: 3,
          ),
        ),
      );
      when(() => app.state).thenReturn(
        const AppState(
          status: AppStatus.authenticated,
          user: User(id: 'me', email: 'kuznetsov.o@edu.mirea.ru'),
        ),
      );
      when(() => pass.state).thenReturn(const PassSecurityState());
      when(pass.refreshCapability).thenAnswer((_) async {});
      when(() => nfc.state).thenReturn(const NfcHceState(loaded: true));
      when(nfc.refresh).thenAnswer((_) async {});
      when(() => geo.state).thenReturn(const GeoSharingState(loaded: true));

      await tester.pumpWidget(
        environment.wrap(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: profile),
              BlocProvider<AppBloc>.value(value: app),
              BlocProvider<PassSecurityCubit>.value(value: pass),
              BlocProvider<NfcHceCubit>.value(value: nfc),
              BlocProvider<GeoSharingCubit>.value(value: geo),
              BlocProvider.value(value: theme),
              BlocProvider.value(value: locale),
              BlocProvider.value(value: preferences),
              BlocProvider.value(value: display),
            ],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: mediaQueryOverride(
                bottom: 40,
                child: const ProfileSettingsPage(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('settings-bottom-inset')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      final gap = tester.widget<SizedBox>(
        find.byKey(const ValueKey('settings-bottom-inset')),
      );
      expect(gap.height, 40 + AppSpacing.lg);
    },
  );

  testWidgets('about page reserves the shell bottom inset below the list', (
    tester,
  ) async {
    final community = _Community();
    when(
      community.getContributors,
    ).thenAnswer((_) async => const ContributorsResponse(contributors: []));

    await tester.pumpWidget(
      RepositoryProvider<UniversityConfig>.value(
        value: config,
        child: RepositoryProvider<CommunityRepository>.value(
          value: community,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: mediaQueryOverride(
              bottom: 40,
              child: const AboutAppPage(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final gap = tester.widget<SizedBox>(
      find.byKey(const ValueKey('about-bottom-inset')),
    );
    expect(gap.height, 40 + AppSpacing.lg);
  });
}
