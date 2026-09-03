@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/grades/data/grades_repository.dart';
import 'package:rtu_mirea_app/grades/models/models.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/widgets/app_bottom_navigation_bar.dart';
import 'package:rtu_mirea_app/profile/view/profile_page.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/selected_schedule.dart';
import 'package:schedule_repository/schedule_repository.dart' as schedule;
import 'package:user_repository/user_repository.dart';

import '../profile/helpers/profile_test_environment.dart';
import 'gallery_fonts.dart';

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
    xp: 2340,
    level: 3,
    shurikens: 2660,
    streakDays: 12,
  );
  const overview = ProfileOverview(
    academic: AcademicProfile(
      fullName: 'Олег Кузнецов',
      course: 3,
      group: 'ИКБО-01-24',
    ),
    groupRank: 4,
    groupSize: 28,
    earnedBadges: 4,
    totalBadges: 18,
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
      isEarned: true,
      progress: 1,
    ),
    GamificationBadge(
      id: 'b3',
      category: 'Активность',
      name: 'Исследователь',
      description: 'Изучи кампус',
      emoji: '🧭',
      isEarned: true,
      progress: 1,
    ),
  ];
  const quests = [
    GamificationQuest(
      id: 'q1',
      period: 'weekly',
      emoji: '🎯',
      title: 'Поставь 5 реакций',
      target: 5,
      xpReward: 40,
      progress: 3,
    ),
    GamificationQuest(
      id: 'q2',
      period: 'weekly',
      emoji: '🎯',
      title: 'Закрой 2 дедлайна вовремя',
      target: 2,
      xpReward: 60,
    ),
    GamificationQuest(
      id: 'q3',
      period: 'weekly',
      emoji: '📝',
      title: 'Поделись конспектом',
      target: 1,
      xpReward: 30,
    ),
  ];
  const entry = LeaderboardEntry(
    userId: 'me',
    displayName: 'Олег Кузнецов',
    xp: 2340,
    level: 3,
    streakDays: 12,
    isCurrentUser: true,
  );

  late GamificationRepository repository;
  late AppBloc appBloc;
  late ProfileTestEnvironment environment;

  setUpAll(loadGalleryFonts);

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
    when(() => repository.getQuests()).thenAnswer((_) async => quests);
    when(
      () => repository.getLeaderboard(any(), limit: any(named: 'limit')),
    ).thenAnswer((_) async => [entry]);
    when(() => repository.getBadges()).thenAnswer((_) async => badges);
    when(
      () => repository.getSettings(),
    ).thenAnswer((_) async => const UserSettings());
  });

  Future<void> shoot(WidgetTester tester, {required bool dark}) async {
    final now = DateTime.now();
    await const LocalGradesRepository(userId: 'me').save(
      GradesBook(
        terms: {
          GradesTerm.of(now).id: [
            SubjectGrades(
              subject: 'Физика',
              marks: [
                for (var i = 0; i < 25; i++)
                  GradeMark(
                    value: i < 13 ? 5 : 4,
                    date: now,
                  ),
              ],
            ),
          ],
        },
      ),
    );
    when(() => environment.schedule.state).thenReturn(
      ScheduleState(
        selectedSchedule: SelectedSchedule.custom(
          id: 'reference',
          name: 'ИКБО-01-24',
          schedule: [
            schedule.LessonSchedulePart(
              subject: 'Контрольная работа',
              lessonType: schedule.LessonType.exam,
              lessonBells: schedule.LessonBells(
                startTime: const schedule.TimeOfDay(hour: 12, minute: 40),
                endTime: const schedule.TimeOfDay(hour: 14, minute: 10),
              ),
              dates: [now.add(const Duration(days: 12))],
              teachers: const [],
              classrooms: const [],
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
        child: RepositoryProvider<GamificationRepository>.value(
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
                home: Builder(
                  builder: (context) => Scaffold(
                    backgroundColor: context.colors.canvas,
                    extendBody: true,
                    body: AppBottomBarViewport(
                      bottomInset: AppBottomBar.extentOf(context),
                      child: const ProfilePage(),
                    ),
                    bottomNavigationBar: AppBottomNavigationBar(
                      currentIndex: 4,
                      onSelected: (_) {},
                      scheduleBadge: true,
                    ),
                  ),
                ),
              ),
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
