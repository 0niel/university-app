import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/locale/locale_cubit.dart';
import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/view/app_router_view.dart';
import 'package:rtu_mirea_app/app/widgets/adaptive_theme_wrapper.dart';
import 'package:rtu_mirea_app/app/widgets/app_router.dart';
import 'package:rtu_mirea_app/app/widgets/user_preferences_scope.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/nfc_pass.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/geo_sharing_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/watch/bloc/bloc.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';
import 'package:user_repository/user_repository.dart';

class _Storage extends Mock implements Storage {}

class _Users extends Mock implements UserRepository {}

class _Preferences extends Mock implements PreferencesRepository {}

class _Friends extends Mock implements FriendsRepository {}

class _Gamification extends Mock implements GamificationRepository {}

class _LocalNotifications extends Mock
    implements LocalNotificationsRepository {}

class _Watch extends MockCubit<WatchConnectivityState>
    implements WatchConnectivityCubit {}

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Pass extends MockCubit<NfcPassState> implements NfcPassCubit {}

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
  const user = User(id: 'student-a', isNewUser: false);
  const otherUser = User(id: 'student-b', isNewUser: false);
  late AppBloc app;
  late _Users users;
  late _Preferences preferences;
  late _Friends friends;
  late _Gamification gamification;
  late _LocalNotifications localNotifications;
  late _Watch watch;
  late _Schedule schedule;
  late _Pass pass;
  late ScheduleDisplayCubit display;
  late LessonRemindersCubit reminders;
  late ThemeCubit theme;
  late LocaleCubit locale;
  late HomeCubit home;
  late UiPreferencesCubit ui;
  SharedPreferencesAsyncPlatform? previousAsyncPreferences;

  void initialize() {
    previousAsyncPreferences = SharedPreferencesAsyncPlatform.instance;
    SharedPreferencesAsyncPlatform.instance = _AsyncPreferences();
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    users = _Users();
    when(() => users.user).thenAnswer((_) => const Stream.empty());
    preferences = _Preferences();
    when(() => preferences.get(any())).thenAnswer((_) async => null);
    friends = _Friends();
    gamification = _Gamification();
    when(
      () => gamification.ensureAcademicProfile(any()),
    ).thenAnswer((_) async {});
    when(() => gamification.getProfileOverview(any())).thenThrow(
      Exception('offline fixture'),
    );
    localNotifications = _LocalNotifications();
    when(() => localNotifications.interactions).thenAnswer(
      (_) => const Stream<String>.empty(),
    );
    when(localNotifications.initialize).thenAnswer((_) async {});
    when(localNotifications.takePendingInteraction).thenReturn(null);
    watch = _Watch();
    when(() => watch.state).thenReturn(const WatchConnectivityState());
    schedule = _Schedule();
    when(() => schedule.state).thenReturn(const ScheduleState());
    pass = _Pass();
    when(() => pass.state).thenReturn(const NfcPassState());
    app = AppBloc(
      firebaseMessaging: null,
      userRepository: users,
      user: user,
    );
    display = ScheduleDisplayCubit();
    reminders = LessonRemindersCubit();
    theme = ThemeCubit();
    locale = LocaleCubit();
    home = HomeCubit();
    ui = UiPreferencesCubit();
  }

  tearDown(() async {
    await Future.wait([
      app.close(),
      display.close(),
      reminders.close(),
      theme.close(),
      locale.close(),
      home.close(),
      ui.close(),
      watch.close(),
      schedule.close(),
      pass.close(),
    ]);
    debugDefaultTargetPlatformOverride = null;
    SharedPreferencesAsyncPlatform.instance = previousAsyncPreferences;
  });

  Widget shell(Widget child) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(value: UniversityConfig.fromEnvironment()),
      RepositoryProvider<UserRepository>.value(value: users),
      RepositoryProvider<PreferencesRepository>.value(value: preferences),
      RepositoryProvider<FriendsRepository>.value(value: friends),
      RepositoryProvider<GamificationRepository>.value(value: gamification),
      RepositoryProvider<LocalNotificationsRepository>.value(
        value: localNotifications,
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>.value(value: app),
        BlocProvider<ScheduleDisplayCubit>.value(value: display),
        BlocProvider<LessonRemindersCubit>.value(value: reminders),
        BlocProvider<ThemeCubit>.value(value: theme),
        BlocProvider<LocaleCubit>.value(value: locale),
        BlocProvider<HomeCubit>.value(value: home),
        BlocProvider<UiPreferencesCubit>.value(value: ui),
        BlocProvider<WatchConnectivityCubit>.value(value: watch),
        BlocProvider<ScheduleBloc>.value(value: schedule),
        BlocProvider<NfcPassCubit>.value(value: pass),
      ],
      child: UserPreferencesScope(child: child),
    ),
  );

  testWidgets(
    'push wrappers have localization and navigate once across remounts',
    (
      tester,
    ) async {
      initialize();
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => const Text('Start')),
          GoRoute(path: '/profile', builder: (_, _) => const Text('Profile')),
        ],
      );
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox());
        router.dispose();
      });
      app.add(
        InteractedMessageReceived(
          const RemoteMessage(messageId: 'cold', data: {'route': '/profile'}),
          userId: user.id,
        ),
      );
      await tester.pump();

      Widget view(Key key) => AppRouter(
        key: key,
        router: router,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
      );

      await tester.pumpWidget(shell(view(const ValueKey('first'))));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(router.routeInformationProvider.value.uri.path, '/profile');
      final context = tester.element(find.text('Profile'));
      expect(
        context.read<LocalNotificationsRepository>(),
        same(localNotifications),
      );
      verify(localNotifications.initialize).called(1);
      final notifications = context.read<NotificationsCubit>();
      expect(notifications.state.pushes, hasLength(1));
      expect(
        notifications.state.pushes.single.title,
        context.l10n.notifPushDefaultTitle,
      );

      router.go('/');
      await tester.pumpAndSettle();
      await tester.pumpWidget(shell(view(const ValueKey('remounted'))));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/');
      expect(notifications.state.pushes, hasLength(1));
      expect(app.state.notificationNavigationId, 1);
      expect(tester.takeException(), isNull);

      app.add(
        InteractedMessageReceived(
          const RemoteMessage(messageId: 'live', data: {'route': '/profile'}),
          userId: user.id,
        ),
      );
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/profile');
      expect(notifications.state.pushes, hasLength(2));
      expect(app.state.notificationNavigationId, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('theme sync replaces stale surfaces in both modes', (
    tester,
  ) async {
    initialize();
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('Theme probe')),
      ],
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      router.dispose();
    });
    await tester.pumpWidget(shell(AdaptiveThemeWrapper(router: router)));
    await tester.pumpAndSettle();
    final firstContext = tester.element(find.text('Theme probe'));
    final manager = AdaptiveTheme.of(firstContext);
    final initialNotifications = firstContext.read<NotificationsCubit>()
      ..recordPush(title: 'Keep history');
    final staleDark = AppTheme.generateTheme(
      AppColors.dark.copyWith(
        surface: const Color(0xFF1C1C1C),
        surface2: const Color(0xFF262626),
        muted: const Color(0x99FFFFFF),
      ),
      Brightness.dark,
    );

    void expectPalette(AppColors expected) {
      final context = tester.element(find.text('Theme probe'));
      expect(context.colors, expected);
      expect(context.read<NotificationsCubit>(), same(initialNotifications));
      expect(initialNotifications.state.pushes.single.title, 'Keep history');
      expect(context.read<UiPreferencesCubit>(), same(ui));
      expect(router.routeInformationProvider.value.uri.path, '/');
    }

    manager
      ..setDark()
      ..setTheme(light: theme.getLightTheme(), dark: staleDark);
    await tester.pumpAndSettle();
    expectPalette(AppColors.dark);
    expect(manager.darkTheme.colors, AppColors.dark);

    manager.setLight();
    await tester.pumpAndSettle();
    manager.setTheme(light: theme.getLightTheme(), dark: staleDark);
    await tester.pumpAndSettle();
    expectPalette(AppColors.light);
    expect(manager.darkTheme.colors, AppColors.dark);

    theme
      ..setColorScheme(AppColorScheme.violet)
      ..setAmoled(enabled: true);
    await tester.pumpAndSettle();
    expectPalette(AppColors.light.withAccent(AppAccent.violet));
    final darkColors = AppColors.dark
        .withAccent(AppAccent.violet)
        .copyWith(
          canvas: AppColors.amoledCanvas,
          surface: AppColors.amoledSurface,
          surface2: AppColors.amoledSurface2,
        );
    expect(manager.darkTheme.colors, darkColors);
    manager.setDark();
    await tester.pumpAndSettle();
    expectPalette(darkColors);
    theme.setAmoled(enabled: false);
    await tester.pumpAndSettle();
    expectPalette(AppColors.dark.withAccent(AppAccent.violet));
    expect(tester.takeException(), isNull);
  });

  testWidgets('account changes recreate the router and user cubits only', (
    tester,
  ) async {
    initialize();
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(() => tester.pumpWidget(const SizedBox()));
    await tester.pumpWidget(shell(const AppRouterView()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final firstRouter = tester.widget<AppRouter>(find.byType(AppRouter)).router;
    final firstView = tester.state(find.byType(AppRouterView));
    final firstContext = tester.element(find.byType(AppRouter));
    final firstHistory = firstContext.read<NotificationsCubit>();
    final firstGeo = firstContext.read<GeoSharingCubit>();
    firstHistory.recordPush(title: 'Private A');
    expect(firstContext.read<ScheduleDisplayCubit>(), same(display));
    expect(firstContext.read<LessonRemindersCubit>(), same(reminders));
    await tester.pumpAndSettle();

    app.add(const AppUserChanged(otherUser));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final nextRouter = tester.widget<AppRouter>(find.byType(AppRouter)).router;
    final nextContext = tester.element(find.byType(AppRouter));
    final nextHistory = nextContext.read<NotificationsCubit>();
    final nextGeo = nextContext.read<GeoSharingCubit>();
    expect(nextRouter, isNot(same(firstRouter)));
    expect(firstView.mounted, isFalse);
    expect(firstHistory.isClosed, isTrue);
    expect(firstGeo.isClosed, isTrue);
    expect(nextHistory.state.userId, otherUser.id);
    expect(nextHistory.state.pushes, isEmpty);
    expect(nextGeo, isNot(same(firstGeo)));
    expect(nextContext.read<ScheduleDisplayCubit>(), same(display));
    expect(nextContext.read<LessonRemindersCubit>(), same(reminders));
    await tester.pumpAndSettle();
    expect(nextGeo.state.sharing, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    debugDefaultTargetPlatformOverride = null;
  });
}
