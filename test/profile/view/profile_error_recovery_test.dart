import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/locale/locale_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/geo_sharing_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/view/profile_page.dart';
import 'package:rtu_mirea_app/profile/view/profile_settings_page.dart';
import 'package:rtu_mirea_app/profile/widgets/edit_profile_sheet.dart';
import 'package:rtu_mirea_app/profile/widgets/guest_upgrade_sheet.dart';
import 'package:rtu_mirea_app/profile/widgets/profile/profile_widgets.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_appearance.dart';
import 'package:rtu_mirea_app/schedule/cubit/schedule_display/schedule_display_cubit.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';
import 'package:user_repository/user_repository.dart';

import '../helpers/profile_test_environment.dart';

class _App extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _Users extends Mock implements UserRepository {}

class _Gamification extends Mock implements GamificationRepository {}

class _Pass extends MockCubit<PassSecurityState> implements PassSecurityCubit {}

class _Nfc extends MockCubit<NfcHceState> implements NfcHceCubit {}

class _Geo extends MockCubit<GeoSharingState> implements GeoSharingCubit {}

final class _AsyncPreferences extends SharedPreferencesAsyncPlatform {
  @override
  Future<String?> getString(
    String key,
    SharedPreferencesOptions options,
  ) async => null;

  @override
  Future<void> setString(
    String key,
    String value,
    SharedPreferencesOptions options,
  ) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final guest in [false, true]) {
    testWidgets(
      'profile error retains identity, settings and back navigation '
      'guest=$guest',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final previousPreferences = SharedPreferencesAsyncPlatform.instance;
        SharedPreferencesAsyncPlatform.instance = _AsyncPreferences();
        addTearDown(
          () => SharedPreferencesAsyncPlatform.instance = previousPreferences,
        );
        final environment = ProfileTestEnvironment();
        final app = _App();
        final users = _Users();
        final gamification = _Gamification();
        final pass = _Pass();
        final nfc = _Nfc();
        final geo = _Geo();
        final theme = ThemeCubit();
        final locale = LocaleCubit();
        final ui = UiPreferencesCubit();
        final display = ScheduleDisplayCubit();
        when(() => app.state).thenReturn(
          AppState(
            status: AppStatus.authenticated,
            user: User(id: 'fresh', isGuest: guest),
          ),
        );
        when(
          () => gamification.ensureAcademicProfile(any()),
        ).thenThrow(Exception('offline'));
        when(() => pass.state).thenReturn(const PassSecurityState());
        when(pass.refreshCapability).thenAnswer((_) async {});
        when(() => nfc.state).thenReturn(const NfcHceState(loaded: true));
        when(nfc.refresh).thenAnswer((_) async {});
        when(() => geo.state).thenReturn(const GeoSharingState(loaded: true));
        final router = GoRouter(
          initialLocation: '/profile',
          routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfilePage()),
            GoRoute(
              path: '/profile/settings',
              builder: (context, state) =>
                  const ProfileSettingsRoute().build(context, state),
            ),
          ],
        );
        addTearDown(() async {
          await tester.pumpWidget(const SizedBox());
          router.dispose();
          await Future.wait([
            app.close(),
            pass.close(),
            nfc.close(),
            geo.close(),
            theme.close(),
            locale.close(),
            ui.close(),
            display.close(),
          ]);
          ToastManager.debugReset();
        });
        await tester.pumpWidget(
          environment.wrap(
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider<UserRepository>.value(value: users),
                RepositoryProvider<GamificationRepository>.value(
                  value: gamification,
                ),
                RepositoryProvider<UniversityConfig>.value(
                  value: UniversityConfig.current,
                ),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<AppBloc>.value(value: app),
                  BlocProvider<PassSecurityCubit>.value(value: pass),
                  BlocProvider<NfcHceCubit>.value(value: nfc),
                  BlocProvider<GeoSharingCubit>.value(value: geo),
                  BlocProvider.value(value: theme),
                  BlocProvider.value(value: locale),
                  BlocProvider.value(value: ui),
                  BlocProvider.value(value: display),
                ],
                child: AdaptiveTheme(
                  light: AppTheme.lightTheme,
                  dark: AppTheme.darkTheme,
                  initial: AdaptiveThemeMode.light,
                  builder: (theme, darkTheme) => MaterialApp.router(
                    routerConfig: router,
                    theme: theme,
                    darkTheme: darkTheme,
                    locale: const Locale('ru'),
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final l10n = tester.element(find.byType(ProfileView)).l10n;
        expect(find.byKey(const ValueKey('profile-error')), findsOneWidget);
        expect(
          tester
              .element(find.byType(ProfileView))
              .read<ProfileCubit>()
              .state
              .user
              .id,
          'fresh',
        );
        if (guest) {
          await tester.tap(find.text(l10n.authGuestUpgradeTitle));
          await tester.pumpAndSettle();
          expect(find.byType(GuestUpgradeSheet), findsOneWidget);
          expect(
            find.byKey(const ValueKey('guest-upgrade-email')),
            findsOneWidget,
          );
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
          expect(find.byType(GuestUpgradeSheet), findsNothing);
        }
        await tester.tap(find.byType(ProfileIdentityRow));
        await tester.pumpAndSettle();
        expect(find.byType(EditProfileSheet), findsOneWidget);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        await tester.tap(find.bySemanticsLabel(l10n.settingsTitle));
        await tester.pumpAndSettle();
        expect(find.byType(ProfileSettingsPage), findsOneWidget);
        expect(find.byType(SettingsAppearance), findsOneWidget);
        expect(
          tester
              .element(find.byType(ProfileSettingsPage))
              .read<ProfileCubit>()
              .state
              .status,
          ProfileStatus.error,
        );
        await tester.tap(find.bySemanticsLabel(l10n.back));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('profile-error')), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
