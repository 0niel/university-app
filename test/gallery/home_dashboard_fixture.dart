import 'package:bloc_test/bloc_test.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/home/cubit/home_gamification_cubit.dart';
import 'package:rtu_mirea_app/home/cubit/home_stories_cubit.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_content.dart';
import 'package:rtu_mirea_app/notifications/notifications.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:user_repository/user_repository.dart';

class _App extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Changes extends MockCubit<ScheduleChangesState>
    implements ScheduleChangesCubit {}

class _Deadlines extends MockCubit<DeadlinesState> implements DeadlinesCubit {}

class _Profile extends MockCubit<UserGamificationProfile?>
    implements HomeGamificationCubit {}

class _Categories extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

class _Preferences extends MockCubit<UiPreferencesState>
    implements UiPreferencesCubit {}

class _Favorites extends MockCubit<FavoriteServicesState>
    implements FavoriteServicesCubit {}

class _Catalog extends MockCubit<ServiceCatalogState>
    implements ServiceCatalogCubit {}

class _Notifications extends MockCubit<NotificationsState>
    implements NotificationsCubit {}

class _Exam extends MockCubit<ExamReadinessState>
    implements ExamReadinessCubit {}

class _Home extends MockCubit<HomeState> implements HomeCubit {}

class _Stories extends MockCubit<Set<String>> implements HomeStoriesCubit {}

class _Discourse extends MockBloc<DiscourseEvent, DiscourseState>
    implements DiscourseBloc {}

Widget homeDashboardFixture({
  required ScrollController controller,
  bool loading = false,
  bool noSchedule = false,
  bool offline = false,
  ValueChanged<DateTime>? onSelectedDay,
  Widget? child,
  DateTime? clock,
  DateTime? selectedDay,
  List<SchedulePart>? scheduleOverride,
  String userName = 'Олег Ковалёв',
}) {
  final now = clock ?? DateTime(2026, 9, 1, 11, 22);
  LessonSchedulePart lesson(
    String title,
    int hour,
    int minute,
    String room,
    String teacher, {
    LessonType type = LessonType.lecture,
    DateTime? date,
  }) {
    final start = DateTime(2026, 9, 1, hour, minute);
    final end = start.add(const Duration(minutes: 90));
    return LessonSchedulePart(
      subject: title,
      lessonType: type,
      teachers: [Teacher(name: teacher)],
      classrooms: [Classroom(name: room)],
      lessonBells: LessonBells(
        startTime: TimeOfDay(hour: hour, minute: minute),
        endTime: TimeOfDay(hour: end.hour, minute: end.minute),
      ),
      dates: [date ?? now],
    );
  }

  final lessons = [
    lesson('Математический анализ', 9, 0, 'А-318', 'Смирнова Е. В.'),
    lesson(
      'Программирование на Python',
      10,
      40,
      'И-204',
      'Кузнецов А. П.',
      type: LessonType.practice,
    ),
    lesson(
      'Физика',
      12,
      40,
      'Б-112',
      'Иванов Д. С.',
      type: LessonType.laboratoryWork,
    ),
    lesson(
      'Английский язык',
      14,
      20,
      'А-401',
      'Морозова К. Л.',
      type: LessonType.practice,
    ),
    for (final day in [
      DateTime(2026, 8, 31),
      DateTime(2026, 9, 2),
      DateTime(2026, 9, 3),
      DateTime(2026, 9, 4),
      DateTime(2026, 9, 5),
    ])
      lesson(
        'Математический анализ',
        9,
        0,
        'А-318',
        'Смирнова Е. В.',
        date: day,
      ),
  ];
  final app = _App();
  when(() => app.state).thenReturn(
    AppState(
      user: User(id: 'gallery', name: userName),
    ),
  );
  final schedule = _Schedule();
  when(() => schedule.state).thenReturn(
    ScheduleState(
      status: loading ? ScheduleStatus.loading : ScheduleStatus.loaded,
      selectedSchedule: loading || noSchedule
          ? null
          : SelectedSchedule.group(
              group: const Group(name: 'ИКБО-01-24'),
              schedule: scheduleOverride ?? lessons,
            ),
      isOffline: offline,
    ),
  );
  final changes = _Changes();
  when(() => changes.state).thenReturn(
    ScheduleChangesState(
      changes: [
        ScheduleChange(
          id: 'room',
          kind: ScheduleChangeKind.room,
          subject: 'Английский язык',
          lessonDate: now,
          createdAt: now,
          oldValue: const ScheduleChangeSlot(start: '14:20', rooms: ['А-105']),
          newValue: const ScheduleChangeSlot(start: '14:20', rooms: ['А-401']),
        ),
        ScheduleChange(
          id: 'monday',
          kind: ScheduleChangeKind.cancel,
          subject: 'Философия',
          lessonDate: DateTime(2026, 8, 31),
          createdAt: now,
        ),
        ScheduleChange(
          id: 'saturday',
          kind: ScheduleChangeKind.room,
          subject: 'Консультация по матанализу',
          lessonDate: DateTime(2026, 9, 5),
          createdAt: now,
        ),
      ],
    ),
  );
  when(
    () => changes.matchesTarget(ScheduleTargetType.group, 'ИКБО-01-24'),
  ).thenReturn(true);
  final deadlines = _Deadlines();
  when(() => deadlines.state).thenReturn(
    DeadlinesState(
      status: DeadlinesStatus.ready,
      deadlines: [
        Deadline(
          id: 'd1',
          title: 'Отчёт по лабораторной №3',
          subjectName: 'Программирование',
          dueAt: now.add(const Duration(hours: 7)),
          source: DeadlineSource.me,
          isMine: true,
        ),
        Deadline(
          id: 'd2',
          title: 'Эссе: My future career',
          subjectName: 'Английский',
          dueAt: now.add(const Duration(days: 2)),
          source: DeadlineSource.me,
          isMine: true,
        ),
      ],
    ),
  );
  final profile = _Profile();
  when(() => profile.state).thenReturn(
    const UserGamificationProfile(
      userId: 'gallery',
      level: 7,
      streakDays: 12,
    ),
  );
  final categories = _Categories();
  when(() => categories.state).thenReturn(
    const CategoriesState(
      sources: [
        NewsSourceItem(
          sourceType: 'telegram',
          sourceId: 'mirea',
          sourceName: 'МИРЭА',
        ),
        NewsSourceItem(
          sourceType: 'telegram',
          sourceId: 'events',
          sourceName: 'ИИТ',
        ),
        NewsSourceItem(
          sourceType: 'telegram',
          sourceId: 'science',
          sourceName: 'Профком',
        ),
        NewsSourceItem(
          sourceType: 'telegram',
          sourceId: 'sport',
          sourceName: 'Спорт',
        ),
        NewsSourceItem(
          sourceType: 'telegram',
          sourceId: 'campus',
          sourceName: 'Наука',
        ),
      ],
    ),
  );
  final preferences = _Preferences();
  when(() => preferences.state).thenReturn(const UiPreferencesState());
  final favorites = _Favorites();
  when(() => favorites.state).thenReturn(
    FavoriteServicesState(
      loaded: true,
      ids: {
        '/services/free-rooms',
        '/services/map',
        '/services/deadlines',
        '/services/friends',
      },
    ),
  );
  final catalog = _Catalog();
  when(() => catalog.state).thenReturn(const ServiceCatalogState());
  when(() => catalog.load(locale: 'ru')).thenAnswer((_) async {});
  final notifications = _Notifications();
  when(() => notifications.state).thenReturn(
    NotificationsState(
      pushes: [
        AppNotification(
          id: 'note',
          kind: AppNotificationKind.accent,
          title: 'Аня К. поделилась конспектом',
          createdAt: now,
        ),
        AppNotification(
          id: 'achievement',
          kind: AppNotificationKind.lecture,
          title: 'Достижение «Ранняя пташка»',
          createdAt: now,
        ),
      ],
    ),
  );
  final exam = _Exam();
  when(() => exam.state).thenReturn(const ExamReadinessState());
  when(exam.load).thenAnswer((_) async {});
  final home = _Home();
  final stories = _Stories();
  when(() => stories.state).thenReturn({'sport', 'campus'});
  when(() => home.state).thenReturn(const HomeState(searchCoachShown: true));
  final discourse = _Discourse();
  when(() => discourse.state).thenReturn(
    const DiscourseState(
      status: DiscourseStatus.loaded,
      topTopics: TopTopicsResponse(
        users: [],
        topics: [
          DiscourseTopic(
            id: 1,
            title: 'Кто был на консультации по матанализу? Что задали?',
            postsCount: 12,
            replyCount: 11,
            likeCount: 7,
            views: 120,
            posters: [],
          ),
          DiscourseTopic(
            id: 2,
            title: 'Опубликовали расписание пересдач за весенний семестр',
            postsCount: 5,
            replyCount: 4,
            likeCount: 3,
            views: 80,
            posters: [],
          ),
        ],
      ),
    ),
  );
  return RepositoryProvider<UniversityConfig>.value(
    value: const UniversityConfig(
      organizationId: 'test',
      appName: 'Campus',
      universityName: 'Университет',
      universityShortName: 'Университет',
      websiteUrl: 'https://example.edu',
      supportEmail: 'support@example.edu',
      deepLinkScheme: 'campus',
      webAppHost: 'example.edu',
      webAppPathPrefix: '/',
    ),
    child: MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>.value(value: app),
        BlocProvider<ScheduleBloc>.value(value: schedule),
        BlocProvider<ScheduleChangesCubit>.value(value: changes),
        BlocProvider<DeadlinesCubit>.value(value: deadlines),
        BlocProvider<HomeGamificationCubit>.value(value: profile),
        BlocProvider<CategoriesBloc>.value(value: categories),
        BlocProvider<UiPreferencesCubit>.value(value: preferences),
        BlocProvider<FavoriteServicesCubit>.value(value: favorites),
        BlocProvider<ServiceCatalogCubit>.value(value: catalog),
        BlocProvider<NotificationsCubit>.value(value: notifications),
        BlocProvider<ExamReadinessCubit>.value(value: exam),
        BlocProvider<HomeCubit>.value(value: home),
        BlocProvider<HomeStoriesCubit>.value(value: stories),
        BlocProvider<DiscourseBloc>.value(value: discourse),
      ],
      child:
          child ??
          HomeDashboardContent(
            now: now,
            selectedDay: selectedDay ?? now,
            scrollController: controller,
            searchKey: GlobalKey(),
            onSelectedDay: onSelectedDay ?? (_) {},
            onRetry: () {},
          ),
    ),
  );
}
