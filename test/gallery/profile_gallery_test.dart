@Tags(['gallery'])
library;

import 'dart:io';

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
import 'package:rtu_mirea_app/profile/view/profile_page.dart';
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
    shurikens: 2660,
    streakDays: 12,
  );
  const overview = ProfileOverview(
    academic: AcademicProfile(
      fullName: 'Анна Соколова',
      handle: 'anna',
      group: 'ИКБО-09-23',
    ),
    groupRank: 2,
    groupSize: 28,
    earnedBadges: 4,
    totalBadges: 17,
  );
  const badges = [
    GamificationBadge(
      id: 'b1',
      category: 'Активность',
      name: 'Огонёк',
      description: 'Серия из 7 дней',
      emoji: '🔥',
      isEarned: true,
      progress: 1,
    ),
    GamificationBadge(
      id: 'b2',
      category: 'Учёба',
      name: 'Конспектор',
      description: 'Оставь 10 заметок',
      emoji: '📝',
      progress: 0.4,
    ),
  ];
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
    displayName: 'Анна Соколова',
    xp: 2400,
    level: 3,
    streakDays: 12,
    isCurrentUser: true,
  );

  late GamificationRepository repository;
  late AppBloc appBloc;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final loader = FontLoader('Inter');
    for (final weight in const [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
    ]) {
      loader.addFont(
        rootBundle.load(
          'packages/app_ui/assets/fonts/Inter/Inter-$weight.ttf',
        ),
      );
    }
    await loader.load();
    final emojiFile = File(r'C:\Windows\Fonts\seguiemj.ttf');
    if (emojiFile.existsSync()) {
      final emojiLoader = FontLoader('Segoe UI Emoji')
        ..addFont(
          emojiFile.readAsBytes().then(ByteData.sublistView),
        );
      await emojiLoader.load();
    }
  });

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
    when(() => repository.getBadges()).thenAnswer((_) async => badges);
    when(
      () => repository.getSettings(),
    ).thenAnswer((_) async => const UserSettings());
  });

  Future<void> shoot(WidgetTester tester, {required bool dark}) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      RepositoryProvider<GamificationRepository>.value(
        value: repository,
        child: RepositoryProvider<UniversityConfig>.value(
          value: config,
          child: BlocProvider<AppBloc>.value(
            value: appBloc,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const ProfilePage(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/profile_7b${dark ? '_dark' : ''}.png'),
    );
  }

  testWidgets('7b · profile', (tester) => shoot(tester, dark: false));
  testWidgets('7b · profile (dark)', (tester) => shoot(tester, dark: true));
}
