@Tags(['gallery'])
library;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/locale/locale_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/geo_sharing_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/view/profile_settings_page.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/schedule_display/schedule_display_cubit.dart';
import 'package:rtu_mirea_app/schedule/models/selected_schedule.dart';
import 'package:schedule_repository/schedule_repository.dart' as schedule;
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';
import 'package:user_repository/user_repository.dart';

import '../profile/helpers/profile_test_environment.dart';
import 'gallery_fonts.dart';

class _Profile extends MockCubit<ProfileState> implements ProfileCubit {}

class _App extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _Pass extends MockCubit<PassSecurityState> implements PassSecurityCubit {}

class _Nfc extends MockCubit<NfcHceState> implements NfcHceCubit {}

class _Geo extends MockCubit<GeoSharingState> implements GeoSharingCubit {}

final class _AsyncPreferences extends SharedPreferencesAsyncPlatform {
  final _values = <String, String>{};

  @override
  Future<String?> getString(
    String key,
    SharedPreferencesOptions options,
  ) async => _values[key];

  @override
  Future<void> setString(
    String key,
    String value,
    SharedPreferencesOptions options,
  ) async {
    _values[key] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(loadGalleryFonts);
  SharedPreferencesAsyncPlatform? previousPreferences;
  setUp(() {
    previousPreferences = SharedPreferencesAsyncPlatform.instance;
    SharedPreferencesAsyncPlatform.instance = _AsyncPreferences();
  });
  tearDown(() {
    SharedPreferencesAsyncPlatform.instance = previousPreferences;
  });

  for (final dark in [false, true]) {
    testWidgets('settings reference ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
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
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      when(() => environment.schedule.state).thenReturn(
        ScheduleState(
          selectedSchedule: SelectedSchedule.custom(
            id: 'reference',
            name: 'ИКБО-01-24',
            schedule: [
              schedule.LessonSchedulePart(
                subject: 'Физика',
                lessonType: schedule.LessonType.practice,
                lessonBells: schedule.LessonBells(
                  startTime: const schedule.TimeOfDay(hour: 12, minute: 40),
                  endTime: const schedule.TimeOfDay(hour: 14, minute: 10),
                ),
                dates: [tomorrow],
                teachers: const [],
                classrooms: const [schedule.Classroom(name: 'Б-112')],
              ),
            ],
          ),
        ),
      );
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
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
            child: AdaptiveTheme(
              light: AppTheme.lightTheme,
              dark: AppTheme.darkTheme,
              initial: dark ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light,
              builder: (theme, darkTheme) => MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: theme,
                darkTheme: darkTheme,
                locale: const Locale('ru'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: const ProfileSettingsPage(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/settings${dark ? '_dark' : ''}.png'),
      );
    });
  }
}
