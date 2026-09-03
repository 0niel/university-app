@Tags(['gallery'])
library;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_client/permission_client.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/onboarding/widgets/widgets.dart';
import 'package:rtu_mirea_app/profile/cubit/geo_sharing_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

import 'gallery_fonts.dart';

class _Gamification extends Mock implements GamificationRepository {}

class _Schedule extends Mock implements ScheduleRepository {}

class _Notifications extends Mock implements LocalNotificationsRepository {}

class _Permissions extends Mock implements PermissionClient {}

class _Storage extends Mock implements Storage {}

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

class _Sharing extends Cubit<GeoSharingState> implements GeoSharingCubit {
  _Sharing() : super(const GeoSharingState(loaded: true));

  @override
  Future<void> load() async {}

  @override
  Future<bool> setSharing({required bool enabled}) async => false;
}

enum _Scene { group, groupEmpty, groupFailure, settings }

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
    for (final scene in _Scene.values) {
      testWidgets('onboarding ${scene.name} ${dark ? 'dark' : 'light'}', (
        tester,
      ) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final storage = _Storage();
        when(() => storage.read(any())).thenReturn(null);
        when(
          () => storage.write(any(), any<dynamic>()),
        ).thenAnswer((_) async {});
        when(() => storage.delete(any())).thenAnswer((_) async {});
        HydratedBloc.storage = storage;
        final gamification = _Gamification();
        final schedule = _Schedule();
        final notifications = _Notifications();
        final permissions = _Permissions();
        final sharing = _Sharing();
        addTearDown(sharing.close);
        when(
          gamification.getSettings,
        ).thenAnswer((_) async => const UserSettings());
        when(
          notifications.hasPermission,
        ).thenAnswer((_) async => false);
        when(
          permissions.locationWhenInUseStatus,
        ).thenAnswer((_) async => PermissionStatus.denied);
        when(
          () => schedule.searchGroups(query: any(named: 'query')),
        ).thenAnswer((_) async {
          if (scene == _Scene.groupFailure) throw Exception('offline');
          return SearchGroupsResponse(
            results: scene == _Scene.groupEmpty
                ? const []
                : const [
                    Group(name: 'ИКБО-01-24'),
                    Group(name: 'ИКБО-02-24'),
                    Group(name: 'ИКБО-03-24'),
                    Group(name: 'ИКБО-04-24'),
                  ],
          );
        });
        when(
          () => schedule.searchTeachers(query: any(named: 'query')),
        ).thenAnswer((_) async => const SearchTeachersResponse(results: []));
        when(
          () => schedule.searchClassrooms(query: any(named: 'query')),
        ).thenAnswer((_) async => const SearchClassroomsResponse(results: []));
        await tester.pumpWidget(
          MultiRepositoryProvider(
            providers: [
              RepositoryProvider<GamificationRepository>.value(
                value: gamification,
              ),
              RepositoryProvider<ScheduleRepository>.value(value: schedule),
              RepositoryProvider<LocalNotificationsRepository>.value(
                value: notifications,
              ),
            ],
            child: BlocProvider<GeoSharingCubit>.value(
              value: sharing,
              child: AdaptiveTheme(
                light: AppTheme.lightTheme,
                dark: AppTheme.darkTheme,
                initial: dark
                    ? AdaptiveThemeMode.dark
                    : AdaptiveThemeMode.light,
                builder: (theme, darkTheme) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  darkTheme: darkTheme,
                  locale: const Locale('ru'),
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(disableAnimations: true),
                    child: child!,
                  ),
                  home: Builder(
                    builder: (context) => Scaffold(
                      backgroundColor: context.colors.canvas,
                      body: scene == _Scene.settings
                          ? OnboardingSettingsStep(
                              step: 3,
                              totalSteps: 3,
                              permissionClient: permissions,
                              onBack: () {},
                              onFinish: () {},
                            )
                          : OnboardingGroupStep(
                              step: 2,
                              totalSteps: 3,
                              initialQuery: 'ИКБО',
                              initialSelected: scene == _Scene.group
                                  ? const Group(name: 'ИКБО-01-24')
                                  : null,
                              onQueryChanged: (_) {},
                              onSelected: (_) {},
                              onBack: () {},
                              onNext: () {},
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 700));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/onboarding_${scene.name}_${dark ? 'dark' : 'light'}.png',
          ),
        );
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
