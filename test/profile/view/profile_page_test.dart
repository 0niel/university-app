import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/view/profile_page.dart';
import 'package:rtu_mirea_app/profile/view/profile_settings_page.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_view.dart';
import 'package:rtu_mirea_app/profile/widgets/profile/profile_widgets.dart';
import 'package:rtu_mirea_app/profile/widgets/profile_activity_card.dart';
import 'package:user_repository/user_repository.dart';

import '../helpers/profile_test_environment.dart';

class _MockGamificationRepository extends Mock
    implements GamificationRepository {}

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

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

  const profile = UserGamificationProfile(
    userId: 'me',
    xp: 2400,
    level: 3,
    shurikens: 120,
    streakDays: 5,
  );
  const overview = ProfileOverview(
    academic: AcademicProfile(
      fullName: 'Иван Иванов',
      handle: 'ivan',
      group: 'ИКБО-09-23',
    ),
    groupRank: 2,
    groupSize: 28,
    earnedBadges: 1,
    totalBadges: 17,
  );
  const earnedBadge = GamificationBadge(
    id: 'b1',
    category: 'Активность',
    name: 'Огонёк',
    description: 'Серия из 7 дней',
    emoji: '🔥',
    isEarned: true,
    progress: 1,
  );
  const lockedBadge = GamificationBadge(
    id: 'b2',
    category: 'Учёба',
    name: 'Конспектор',
    description: 'Оставь 10 заметок',
    emoji: '📝',
    progress: 0.4,
  );
  const fartherBadge = GamificationBadge(
    id: 'b3',
    category: 'Учёба',
    name: 'Исследователь',
    description: 'Открой 20 материалов',
    emoji: '🔎',
    progress: 0.2,
  );
  const quest = GamificationQuest(
    id: 'q1',
    period: 'daily',
    emoji: '🎯',
    title: 'Поставь реакцию на паре',
    target: 3,
    xpReward: 20,
    progress: 1,
  );
  const entry = LeaderboardEntry(
    userId: 'me',
    displayName: 'Иван Иванов',
    xp: 2400,
    level: 3,
    streakDays: 5,
    isCurrentUser: true,
  );
  final activityCalendar = [
    ActivityDay(day: DateTime(2026, 8, 29), count: 2),
    ActivityDay(day: DateTime(2026, 8, 30)),
    ActivityDay(day: DateTime(2026, 8, 31), count: 3),
  ];

  late GamificationRepository repository;
  late AppBloc appBloc;
  late ProfileTestEnvironment environment;

  tearDown(ToastManager.debugReset);

  setUp(() {
    environment = ProfileTestEnvironment();
    repository = _MockGamificationRepository();
    when(
      () => repository.ensureAcademicProfile(any()),
    ).thenAnswer((_) async {});
    appBloc = _MockAppBloc();
    when(() => appBloc.state).thenReturn(
      const AppState(
        status: AppStatus.authenticated,
        user: User(id: 'me'),
      ),
    );
    when(
      () => repository.syncGamification(),
    ).thenAnswer((_) async => const <GamificationBadge>[]);
    when(() => repository.recordActiveDay()).thenAnswer((_) async {});
    when(
      () => repository.ensureProfile(any()),
    ).thenAnswer((_) async => profile);
    when(
      () => repository.getProfileOverview(any()),
    ).thenAnswer((_) async => overview);
    when(() => repository.getQuests()).thenAnswer((_) async => [quest]);
    when(
      () => repository.getLeaderboard(any(), limit: any(named: 'limit')),
    ).thenAnswer((_) async => [entry]);
    when(
      () => repository.getBadges(),
    ).thenAnswer((_) async => [earnedBadge, lockedBadge, fartherBadge]);
    when(
      () => repository.getSettings(),
    ).thenAnswer((_) async => const UserSettings());
    when(
      () => repository.getActivityCalendar(days: any(named: 'days')),
    ).thenAnswer((_) async => activityCalendar);
  });

  Widget subject({
    TextScaler textScaler = TextScaler.noScaling,
    bool light = false,
  }) {
    return RepositoryProvider<GamificationRepository>.value(
      value: repository,
      child: RepositoryProvider<UniversityConfig>.value(
        value: config,
        child: BlocProvider<AppBloc>.value(
          value: appBloc,
          child: MaterialApp(
            theme: light ? AppTheme.lightTheme : AppTheme.darkTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: child!,
            ),
            home: const ProfilePage(),
          ),
        ),
      ),
    );
  }

  Future<void> pumpProfile(
    WidgetTester tester, {
    Size size = const Size(420, 1400),
    TextScaler textScaler = TextScaler.noScaling,
    bool light = false,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      environment.wrap(
        child: subject(textScaler: textScaler, light: light),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder getProfileList() => find
      .descendant(
        of: find.byType(ProfileView),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is ListView && widget.scrollDirection == Axis.vertical,
        ),
      )
      .first;

  testWidgets('presents identity, real progress and quests in one flow', (
    tester,
  ) async {
    await pumpProfile(tester);
    expect(find.byType(AppAvatar), findsWidgets);
    expect(find.text('Иван Иванов'), findsOneWidget);
    expect(find.text('ИКБО-09-23 · @ivan'), findsOneWidget);
    expect(find.byType(ProfileLevelCard), findsOneWidget);
    expect(find.textContaining('2 400 XP'), findsOneWidget);
    expect(find.text('#2 в группе'), findsOneWidget);
    expect(find.text('все 17'), findsOneWidget);
    expect(find.text('Огонёк'), findsOneWidget);
    expect(find.text('Скоро · 40%'), findsOneWidget);
    expect(find.text('Поставь реакцию на паре'), findsOneWidget);
    expect(find.byType(TabBar), findsNothing);
    await tester.tap(find.text('все 17'));
    await tester.pumpAndSettle();
    expect(find.byType(NinjaPathView), findsOneWidget);
    expect(find.byType(AppSegmentedControl<int>), findsOneWidget);
    await tester.tap(find.text('Квесты'));
    await tester.pumpAndSettle();
    expect(find.text('Поставь реакцию на паре'), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('settings action has an accessible 44 px target', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpProfile(tester, size: const Size(360, 699));
    expect(find.byType(AppScreenHeader), findsOneWidget);
    final action = find.byType(AppHeaderCircleButton);
    expect(action, findsOneWidget);
    expect(tester.getSize(action).height, greaterThanOrEqualTo(44));
    expect(
      tester.widget<AppHeaderCircleButton>(action).action.semanticsLabel,
      'Настройки',
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppLineIconWidget && widget.icon == AppLineIcon.share,
      ),
      findsNothing,
    );
    semantics.dispose();
  });

  testWidgets('level card uses the shared tint without shadow or gradient', (
    tester,
  ) async {
    await pumpProfile(tester);
    final card = tester.widget<AppCard>(
      find.descendant(
        of: find.byType(ProfileLevelCard),
        matching: find.byType(AppCard),
      ),
    );
    expect(card.tinted, isTrue);
    expect(card.radius, AppRadius.lg);
    expect(card.onTap, isNotNull);
  });

  testWidgets('level progress is a 4 px bar derived from real XP', (
    tester,
  ) async {
    await pumpProfile(tester);
    final bar = tester.widget<NinjaProgressBar>(
      find.descendant(
        of: find.byType(ProfileLevelCard),
        matching: find.byType(NinjaProgressBar),
      ),
    );
    expect(bar.height, 4);
    expect(bar.value, greaterThanOrEqualTo(0));
    expect(bar.value, lessThanOrEqualTo(1));
    expect(find.textContaining('стрик 5 дн.'), findsOneWidget);
  });

  testWidgets('settings pinned search keeps its declared phone extent', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(360, 699)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    Future<void> pumpSearch(double textScale) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 170)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SettingsSearchDelegate(
                    controller: controller,
                    hint: 'Поиск',
                    textScale: textScale,
                    onChanged: (_) {},
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 900)),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(AppSearchField)).height,
        textScale == 1 ? 54 : 76,
      );
    }

    await pumpSearch(1);
    await pumpSearch(2);
  });

  testWidgets('activity header reflects the real server streak count', (
    tester,
  ) async {
    await pumpProfile(tester);
    expect(find.textContaining('стрик 5 дн.'), findsOneWidget);
  });

  testWidgets(
    'a full activity calendar does not override the server streak count',
    (tester) async {
      when(
        () => repository.getActivityCalendar(days: any(named: 'days')),
      ).thenAnswer(
        (_) async => [
          for (var i = 0; i < 140; i++)
            ActivityDay(
              day: DateTime(2026, 4, 15).add(Duration(days: i)),
              count: i.isEven ? 2 : 0,
            ),
        ],
      );
      await pumpProfile(tester);
      expect(find.textContaining('стрик 5 дн.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('celebrates every badge the sync just unlocked', (tester) async {
    when(
      () => repository.syncGamification(),
    ).thenAnswer((_) async => [earnedBadge]);
    await pumpProfile(tester);
    expect(find.byType(AppToast), findsOneWidget);
    expect(find.text('Новое достижение'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text('Новое достижение'), findsNothing);
  });

  testWidgets('offers an inline retry for achievements that failed', (
    tester,
  ) async {
    when(() => repository.getBadges()).thenThrow(Exception('badges'));
    await pumpProfile(tester);
    expect(find.text('Не удалось загрузить раздел'), findsOneWidget);
    when(
      () => repository.getBadges(),
    ).thenAnswer((_) async => [earnedBadge, lockedBadge]);
    final retry = find.text(
      tester.element(find.byType(ProfileView)).l10n.retry,
    );
    await tester.ensureVisible(retry);
    await tester.tap(retry);
    await tester.pumpAndSettle();
    expect(find.text('Не удалось загрузить раздел'), findsNothing);
    expect(find.text('Огонёк'), findsOneWidget);
  });

  for (final light in [false, true]) {
    testWidgets(
      'profile supports 320 px and 200 percent text in '
      '${light ? "light" : "dark"} mode',
      (tester) async {
        await pumpProfile(
          tester,
          size: const Size(320, 568),
          textScaler: const TextScaler.linear(2),
          light: light,
        );
        expect(tester.takeException(), isNull);
        expect(find.byType(ProfileLevelCard), findsOneWidget);
        await tester.drag(getProfileList(), const Offset(0, -420));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(TabBar), findsNothing);
      },
    );
  }

  testWidgets('profile reselect returns the active page to top', (
    tester,
  ) async {
    await pumpProfile(tester, size: const Size(390, 700));
    await tester.drag(getProfileList(), const Offset(0, -700));
    await tester.pumpAndSettle();
    final position = tester
        .widget<ListView>(getProfileList())
        .controller!
        .position;
    expect(position.pixels, greaterThan(1));
    TabReselectNotifier.instance.reselect(4);
    await tester.pumpAndSettle();
    expect(position.pixels, position.minScrollExtent);
  });

  testWidgets('profile reselect is safe during a fresh scroll attach', (
    tester,
  ) async {
    await tester.pumpWidget(environment.wrap(child: subject()));
    TabReselectNotifier.instance.reselect(4);
    await tester.pump();
    TabReselectNotifier.instance.reselect(4);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('achievement rail stays valid when its data shrinks', (
    tester,
  ) async {
    var badges = <GamificationBadge>[earnedBadge, lockedBadge, fartherBadge];
    when(() => repository.getBadges()).thenAnswer((_) async => badges);
    await pumpProfile(tester, size: const Size(320, 1400));
    final rail = find.descendant(
      of: find.byType(ProfileBadgesRail),
      matching: find.byType(ListView),
    );
    await tester.drag(rail, const Offset(-300, 0));
    await tester.pumpAndSettle();
    badges = <GamificationBadge>[earnedBadge];
    final cubit = tester.element(rail).read<ProfileCubit>();
    await cubit.reloadSection(ProfileSection.badges);
    await tester.pumpAndSettle();
    expect(find.text('Огонёк'), findsOneWidget);
    expect(find.text('Конспектор'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('achievement semantics describe earned and locked status', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpProfile(tester);
    expect(find.bySemanticsLabel(RegExp('Огонёк, Получено')), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('Конспектор, Пока закрыто, Скоро · 40%')),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('does not display unsupported classroom check-in quests', (
    tester,
  ) async {
    when(() => repository.getQuests()).thenAnswer(
      (_) async => [
        quest,
        quest.copyWith(id: 'check_in', title: 'Отметься на паре'),
      ],
    );
    await pumpProfile(tester);
    expect(find.text('Отметься на паре'), findsNothing);
    expect(find.text('Поставь реакцию на паре'), findsOneWidget);
  });

  testWidgets('unsupported personal academic metrics are removed', (
    tester,
  ) async {
    await pumpProfile(tester);
    expect(find.byType(ProfileMetricCards), findsNothing);
    expect(find.text('GPA'), findsNothing);
    expect(find.text('Посещаемость'), findsNothing);
    expect(find.text('4.8'), findsNothing);
  });

  testWidgets(
    'level sheet preserves the real streak history and profile sharing',
    (tester) async {
      when(
        () => repository.ensureProfile(any()),
      ).thenAnswer((_) async => profile.copyWith(longestStreak: 9));
      String? copied;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData') {
              copied = (call.arguments as Map)['text'] as String;
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );
      await pumpProfile(tester);
      await tester.tap(find.byType(ProfileLevelCard));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileActivityCard), findsNWidgets(2));
      final activity = tester.widget<ProfileActivityCard>(
        find.byType(ProfileActivityCard).last,
      );
      expect(activity.streakDays, 5);
      expect(activity.longestStreak, 9);
      expect(activity.days, activityCalendar);
      await tester.ensureVisible(find.byKey(const ValueKey('profile-share')));
      await tester.tap(find.byKey(const ValueKey('profile-share')));
      await tester.pump();
      expect(copied, endsWith('/profile'));
      await tester.pump(const Duration(seconds: 5));
    },
  );

  for (final section in [ProfileSection.profile, ProfileSection.overview]) {
    testWidgets('partial ${section.name} failure retains its inline retry', (
      tester,
    ) async {
      await pumpProfile(tester);
      final cubit = tester
          .element(find.byType(ProfileView))
          .read<ProfileCubit>();
      if (section == ProfileSection.profile) {
        when(
          () => repository.ensureProfile(any()),
        ).thenThrow(Exception('profile'));
      } else {
        when(
          () => repository.getProfileOverview(any()),
        ).thenThrow(Exception('overview'));
      }
      await cubit.reloadSection(section);
      await tester.pumpAndSettle();
      expect(find.text('Не удалось загрузить раздел'), findsOneWidget);
      when(
        () => repository.ensureProfile(any()),
      ).thenAnswer((_) async => profile);
      when(
        () => repository.getProfileOverview(any()),
      ).thenAnswer((_) async => overview);
      final retry = find.text(
        tester.element(find.byType(ProfileView)).l10n.retry,
      );
      await tester.ensureVisible(retry);
      await tester.tap(retry);
      await tester.pumpAndSettle();
      expect(find.text('Не удалось загрузить раздел'), findsNothing);
    });
  }
}
