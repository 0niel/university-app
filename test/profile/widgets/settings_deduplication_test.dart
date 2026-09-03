import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/locale/locale_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/sync_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/utils/settings_search_filter.dart';
import 'package:rtu_mirea_app/profile/widgets/settings/settings_widgets.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_appearance.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_theme_row.dart';
import 'package:rtu_mirea_app/schedule/cubit/schedule_display/schedule_display_cubit.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:user_repository/user_repository.dart';

class _MockStorage extends Mock implements Storage {}

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    l10n = await AppLocalizations.delegate.load(const Locale('ru'));
  });

  setUp(() {
    final storage = _MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  Widget wrap(Widget child) => MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('the theme picker appears exactly once in appearance', (
    tester,
  ) async {
    final theme = ThemeCubit();
    final preferences = UiPreferencesCubit();
    addTearDown(theme.close);
    addTearDown(preferences.close);

    await tester.pumpWidget(
      wrap(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>.value(value: theme),
            BlocProvider<UiPreferencesCubit>.value(value: preferences),
          ],
          child: const SettingsAppearance(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SettingsThemeRow), findsOneWidget);
  });

  testWidgets(
    'lesson reactions appears exactly once between schedule and home',
    (tester) async {
      final schedule = ScheduleDisplayCubit();
      final ui = UiPreferencesCubit();
      final favorites = FavoriteServicesCubit();
      addTearDown(schedule.close);
      addTearDown(ui.close);
      addTearDown(favorites.close);

      await tester.pumpWidget(
        wrap(
          MultiBlocProvider(
            providers: [
              BlocProvider<ScheduleDisplayCubit>.value(value: schedule),
              BlocProvider<UiPreferencesCubit>.value(value: ui),
              BlocProvider<FavoriteServicesCubit>.value(value: favorites),
            ],
            child: const Column(
              children: [
                SettingsScheduleSection(group: 'ИКБО-09-23'),
                SettingsHomeSection(),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.settingsLessonReactions), findsOneWidget);
    },
  );

  testWidgets(
    'language and calendar export each appear exactly once',
    (tester) async {
      final locale = LocaleCubit();
      final sync = SyncPreferencesCubit();
      final schedule = ScheduleDisplayCubit();
      final ui = UiPreferencesCubit();
      final appBloc = _MockAppBloc();
      when(
        () => appBloc.state,
      ).thenReturn(const AppState(user: User(id: 'u1')));
      addTearDown(locale.close);
      addTearDown(sync.close);
      addTearDown(schedule.close);
      addTearDown(ui.close);

      await tester.pumpWidget(
        wrap(
          MultiBlocProvider(
            providers: [
              BlocProvider<LocaleCubit>.value(value: locale),
              BlocProvider<SyncPreferencesCubit>.value(value: sync),
              BlocProvider<ScheduleDisplayCubit>.value(value: schedule),
              BlocProvider<UiPreferencesCubit>.value(value: ui),
              BlocProvider<AppBloc>.value(value: appBloc),
            ],
            child: const Column(
              children: [
                SettingsAccountSection(),
                SettingsScheduleSection(group: 'ИКБО-09-23'),
                SettingsDataSection(cacheLabel: '12 МБ', onClearCache: null),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(l10n.settingsLanguage), findsOneWidget);
      expect(find.text(l10n.settingsExportScheduleValue), findsOneWidget);
    },
  );

  group('SettingsSearchFilter', () {
    SettingsSearchFilter filterFor(String query) =>
        SettingsSearchFilter(query: query, l10n: l10n);

    test('routes lesson reactions to schedule, not home', () {
      final filter = filterFor(l10n.settingsLessonReactions);
      expect(filter.showSchedule, isTrue);
      expect(filter.showHome, isFalse);
    });

    test('routes calendar export to schedule, not data', () {
      final filter = filterFor(l10n.settingsExportCalendar);
      expect(filter.showSchedule, isTrue);
      expect(filter.showData, isFalse);
    });

    test('routes language to data, not account', () {
      final filter = filterFor(l10n.settingsLanguage);
      expect(filter.showData, isTrue);
      expect(filter.showAccount, isFalse);
    });
  });
}
