import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
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
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_hero.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/ninja_path_view.dart';
import 'package:rtu_mirea_app/profile/widgets/profile_progress_bar.dart';
import 'package:user_repository/user_repository.dart';

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

  late GamificationRepository repository;
  late AppBloc appBloc;

  tearDown(ToastManager.debugReset);

  setUp(() {
    repository = _MockGamificationRepository();
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
    await tester.pumpWidget(subject(textScaler: textScaler, light: light));
    await tester.pumpAndSettle();
  }

  testWidgets('presents identity, progress and path as one clear flow', (
    tester,
  ) async {
    await pumpProfile(tester);

    expect(find.byType(NinjaAvatar), findsOneWidget);
    expect(find.text('Иван Иванов'), findsWidgets);
    expect(find.text('ИКБО-09-23 · @ivan'), findsOneWidget);
    expect(find.text('Уровень 3'), findsOneWidget);
    expect(find.text('Genin'), findsOneWidget);
    expect(find.text('XP'), findsOneWidget);
    expect(find.text('2 400'), findsOneWidget);
    expect(find.text('6600 до Chunin'), findsOneWidget);
    expect(find.text('1 / 17'), findsOneWidget);
    expect(find.text('Огонёк'), findsOneWidget);
    expect(find.text('Конспектор'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(TabBar), findsNothing);
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.text('Поставь реакцию на паре'), findsNothing);

    await tester.tap(find.text('Путь ниндзя'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Путь ниндзя'), findsWidgets);
    expect(find.byType(NinjaTabs<int>), findsOneWidget);

    await tester.tap(find.text('Квесты'));
    await tester.pump();
    expect(find.text('Поставь реакцию на паре'), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('settings and sharing are direct profile actions', (
    tester,
  ) async {
    await pumpProfile(tester, size: const Size(360, 699));

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppLineIconWidget && widget.icon == AppLineIcon.share,
      ),
      findsOneWidget,
    );
    expect(find.text('Настройки'), findsOneWidget);
    expect(find.byType(SliverAppBar), findsOneWidget);

    final headerActions = find.byType(NinjaIconButton);
    expect(headerActions, findsNWidgets(2));
    for (final action in tester.widgetList<NinjaIconButton>(headerActions)) {
      expect(action.tooltip, isNotNull);
    }
    expect(
      tester.getSize(headerActions.first),
      const Size(
        NinjaMetrics.minTouchTarget,
        NinjaMetrics.minTouchTarget,
      ),
    );
  });

  testWidgets('one pastel feature card carries the whole screen accent', (
    tester,
  ) async {
    await pumpProfile(tester);

    final colors = tester.element(find.byType(ProfilePage)).ninja;
    Finder pastelCards() => find.byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == colors.accentSoft,
    );

    expect(pastelCards(), findsOneWidget);
    expect(
      find.descendant(
        of: pastelCards(),
        matching: find.text('Путь ниндзя'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Путь ниндзя'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.byType(NinjaPathHero), findsOneWidget);
    expect(
      find.descendant(of: find.byType(NinjaPathView), matching: pastelCards()),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(NinjaPathHero),
        matching: find.byType(ProfileProgressBar),
      ),
      findsOneWidget,
    );
  });

  testWidgets('progress reads as an 8 px pill with a tabular percent', (
    tester,
  ) async {
    await pumpProfile(tester);

    final bars = find.byType(ProfileProgressBar);
    expect(bars, findsWidgets);

    final track = tester.widget<SizedBox>(
      find.descendant(of: bars.first, matching: find.byType(SizedBox)).first,
    );
    expect(track.height, 8);

    final clip = tester.widget<ClipRRect>(
      find.descendant(of: bars.first, matching: find.byType(ClipRRect)).first,
    );
    expect(clip.borderRadius, BorderRadius.circular(NinjaRadius.pill));

    final percent = tester.widget<Text>(
      find.descendant(of: bars.first, matching: find.byType(Text)).first,
    );
    expect(
      percent.style?.fontFeatures,
      contains(const FontFeature.tabularFigures()),
    );
  });

  testWidgets('settings pinned search keeps its declared phone extent', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(360, 699)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    Future<void> pumpSearch(double textScale) async {
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
        tester.getSize(find.byType(NinjaInput)).height,
        textScale == 1 ? 54 : 76,
      );
    }

    await pumpSearch(1);
    await pumpSearch(2);
  });

  testWidgets('hides the streak strip without a real history', (tester) async {
    await pumpProfile(tester);

    expect(find.text('сегодня'), findsNothing);
    expect(find.text('Держи стрик каждый день'), findsOneWidget);
    expect(find.text('5 дней'), findsOneWidget);
  });

  testWidgets('shows the streak strip for a full two-week history', (
    tester,
  ) async {
    when(() => repository.getProfileOverview(any())).thenAnswer(
      (_) async => overview.copyWith(
        streakHistory: List.filled(14, true),
      ),
    );

    await pumpProfile(tester);

    expect(find.text('сегодня'), findsOneWidget);
    expect(find.text('14 дн. назад'), findsOneWidget);
  });

  testWidgets('celebrates every badge the sync just unlocked', (tester) async {
    when(
      () => repository.syncGamification(),
    ).thenAnswer((_) async => [earnedBadge]);

    await pumpProfile(tester);

    expect(find.byType(NinjaToast), findsOneWidget);
    expect(find.text('Новое достижение'), findsOneWidget);
    expect(find.text('Огонёк'), findsWidgets);

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
    await tester.tap(find.text('Попробовать снова'));
    await tester.pumpAndSettle();

    expect(find.text('Не удалось загрузить раздел'), findsNothing);
    expect(find.text('Огонёк'), findsOneWidget);
  });

  testWidgets('profile remains usable at 320 px and 200 percent text', (
    tester,
  ) async {
    await pumpProfile(
      tester,
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(ProfileProgressBar), findsWidgets);
    expect(find.byType(AppProgressRing), findsNothing);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -420));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(TabBar), findsNothing);
    expect(find.byType(SliverAppBar), findsOneWidget);
  });

  testWidgets('light profile keeps the same flat hierarchy', (tester) async {
    await pumpProfile(
      tester,
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
      light: true,
    );

    expect(find.byType(TabBar), findsNothing);
    expect(find.byType(Divider), findsNothing);
    expect(find.text('Путь ниндзя'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile reselect returns the active page and header to top', (
    tester,
  ) async {
    await pumpProfile(tester, size: const Size(390, 700));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pumpAndSettle();

    Iterable<ScrollPosition> verticalPositions() => tester
        .stateList<ScrollableState>(find.byType(Scrollable))
        .map((state) => state.position)
        .where(
          (position) =>
              position.axisDirection == AxisDirection.down ||
              position.axisDirection == AxisDirection.up,
        );

    expect(
      verticalPositions().any(
        (position) => position.pixels > position.minScrollExtent + 1,
      ),
      isTrue,
    );

    TabReselectNotifier.instance.reselect(4);
    await tester.pumpAndSettle();

    expect(
      verticalPositions().every(
        (position) => (position.pixels - position.minScrollExtent).abs() < 1,
      ),
      isTrue,
    );
  });

  testWidgets('profile reselect is safe during a fresh scroll attach', (
    tester,
  ) async {
    await tester.pumpWidget(subject());
    TabReselectNotifier.instance.reselect(4);
    await tester.pump();
    TabReselectNotifier.instance.reselect(4);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('achievement carousel clamps when its data shrinks', (
    tester,
  ) async {
    var badges = <GamificationBadge>[earnedBadge, lockedBadge, fartherBadge];
    when(() => repository.getBadges()).thenAnswer((_) async => badges);
    await pumpProfile(tester);

    final pageView = find.byType(PageView);
    await tester.drag(pageView, const Offset(-520, 0));
    await tester.pumpAndSettle();
    final controller = tester.widget<PageView>(pageView).controller!;
    expect(controller.page, greaterThan(.5));

    badges = <GamificationBadge>[earnedBadge];
    final cubit = tester.element(pageView).read<ProfileCubit>();
    await cubit.reloadSection(ProfileSection.badges);
    await tester.pump();
    await tester.pump();

    expect(controller.page, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('achievement semantics describe earned and locked status', (
    tester,
  ) async {
    await pumpProfile(tester);

    final earned = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Огонёк',
      ),
    );
    final locked = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Конспектор',
      ),
    );

    expect(earned.properties.selected, isNull);
    expect(earned.properties.value, 'Получено, Активность');
    expect(locked.properties.selected, isNull);
    expect(locked.properties.value, 'Пока закрыто, 40%');
  });
}
