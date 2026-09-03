import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_body.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Preferences extends MockCubit<SchedulePreferencesState>
    implements SchedulePreferencesCubit {}

class _Display extends MockCubit<ScheduleDisplayState>
    implements ScheduleDisplayCubit {}

class _Changes extends MockCubit<ScheduleChangesState>
    implements ScheduleChangesCubit {}

class _Activities extends MockCubit<UserActivitiesState>
    implements UserActivitiesCubit {}

class _Classmates extends MockCubit<ClassmatesState>
    implements ClassmatesCubit {}

class _Reminders extends MockCubit<Map<String, int>>
    implements LessonRemindersCubit {}

class _Repository extends Mock implements ScheduleRepository {}

class _Friends extends Mock implements FriendsRepository {}

class _Campus extends Mock implements CampusRepository {}

final scheduleGalleryNow = DateTime(2026, 9, 1, 11, 22);

List<LessonSchedulePart> scheduleGalleryLessons() => [
  for (final data in [
    (
      'Математический анализ',
      LessonType.lecture,
      9,
      0,
      10,
      30,
      'А-318',
      1,
      'Смирнова Е. В.',
    ),
    (
      'Программирование на Python',
      LessonType.practice,
      10,
      40,
      12,
      10,
      'И-204',
      2,
      'Кузнецов А. П.',
    ),
    (
      'Физика',
      LessonType.laboratoryWork,
      12,
      40,
      14,
      10,
      'Б-112',
      3,
      'Иванов Д. С.',
    ),
    (
      'Английский язык',
      LessonType.practice,
      14,
      20,
      15,
      50,
      'А-401',
      4,
      'Морозова К. Л.',
    ),
  ])
    LessonSchedulePart(
      subject: data.$1,
      lessonType: data.$2,
      teachers: [Teacher(name: data.$9)],
      classrooms: [
        Classroom(
          name: data.$7,
          campus: const Campus(name: 'Вернадского, 78', shortName: 'В-78'),
        ),
      ],
      lessonBells: LessonBells(
        startTime: TimeOfDay(hour: data.$3, minute: data.$4),
        endTime: TimeOfDay(hour: data.$5, minute: data.$6),
        number: data.$8,
      ),
      dates: [
        for (var date = 1; date <= 30; date += 7) DateTime(2026, 9, date),
      ],
    ),
  ..._otherGalleryLessons(),
];

List<LessonSchedulePart> _otherGalleryLessons() {
  const bells = [
    (9, 0, 10, 30),
    (10, 40, 12, 10),
    (12, 40, 14, 10),
    (14, 20, 15, 50),
  ];
  return [
    for (final row in [
      (
        0,
        0,
        'Дискретная математика',
        LessonType.lecture,
        'А-16',
        'Петров И. А.',
      ),
      (
        0,
        1,
        'Программирование на Python',
        LessonType.laboratoryWork,
        'И-204',
        'Кузнецов А. П.',
      ),
      (0, 2, 'Философия', LessonType.practice, 'А-201', 'Лебедева Н. С.'),
      (2, 0, 'Английский язык', LessonType.practice, 'А-105', 'Морозова К. Л.'),
      (
        2,
        1,
        'Математический анализ',
        LessonType.practice,
        'А-320',
        'Смирнова Е. В.',
      ),
      (2, 2, 'Физика', LessonType.lecture, 'А-16', 'Иванов Д. С.'),
      (
        2,
        3,
        'Физическая культура',
        LessonType.physicalEducation,
        'Спортзал',
        'Волков С. Н.',
      ),
      (3, 1, 'Базы данных', LessonType.lecture, 'А-318', 'Орлова М. В.'),
      (3, 2, 'Базы данных', LessonType.laboratoryWork, 'И-206', 'Орлова М. В.'),
      (
        4,
        0,
        'Математический анализ',
        LessonType.lecture,
        'А-318',
        'Смирнова Е. В.',
      ),
      (
        4,
        1,
        'Дискретная математика',
        LessonType.practice,
        'А-22',
        'Петров И. А.',
      ),
      (
        4,
        2,
        'Программирование на Python',
        LessonType.practice,
        'И-204',
        'Кузнецов А. П.',
      ),
      (
        5,
        1,
        'Консультация по матанализу',
        LessonType.consultation,
        'А-318',
        'Смирнова Е. В.',
      ),
    ])
      LessonSchedulePart(
        subject: row.$3,
        lessonType: row.$4,
        teachers: [Teacher(name: row.$6)],
        classrooms: [Classroom(name: row.$5)],
        lessonBells: LessonBells(
          number: row.$2 + 1,
          startTime: TimeOfDay(
            hour: bells[row.$2].$1,
            minute: bells[row.$2].$2,
          ),
          endTime: TimeOfDay(hour: bells[row.$2].$3, minute: bells[row.$2].$4),
        ),
        dates: [
          for (var offset = row.$1; offset < 31; offset += 7)
            DateTime(2026, 8, 31 + offset),
        ],
      ),
  ];
}

Widget scheduleGalleryScene({ScheduleView view = ScheduleView.day}) {
  final schedule = _Schedule();
  final preferences = _Preferences();
  final display = _Display();
  final changes = _Changes();
  final activities = _Activities();
  final classmates = _Classmates();
  final reminders = _Reminders();
  final comparison = ScheduleComparisonCubit();
  when(
    () => changes.matchesTarget(ScheduleTargetType.group, 'ИКБО-01-24'),
  ).thenReturn(true);
  addTearDown(comparison.close);
  when(() => schedule.state).thenReturn(
    ScheduleState(
      status: ScheduleStatus.loaded,
      selectedSchedule: SelectedGroupSchedule(
        group: const Group(name: 'ИКБО-01-24'),
        schedule: scheduleGalleryLessons(),
      ),
    ),
  );
  when(() => preferences.state).thenReturn(const SchedulePreferencesState());
  when(() => display.state).thenReturn(const ScheduleDisplayState());
  when(() => changes.state).thenReturn(
    ScheduleChangesState(
      changes: [
        ScheduleChange(
          id: 'moved',
          kind: ScheduleChangeKind.room,
          subject: 'Английский язык',
          lessonDate: scheduleGalleryNow,
          createdAt: scheduleGalleryNow,
          oldValue: const ScheduleChangeSlot(rooms: ['А-105']),
          newValue: const ScheduleChangeSlot(rooms: ['А-401']),
        ),
        ScheduleChange(
          id: 'cancelled',
          kind: ScheduleChangeKind.cancel,
          subject: 'Философия',
          lessonDate: DateTime(2026, 8, 31),
          createdAt: scheduleGalleryNow,
        ),
        ScheduleChange(
          id: 'added',
          kind: ScheduleChangeKind.add,
          subject: 'Консультация по матанализу',
          lessonDate: DateTime(2026, 9, 5),
          createdAt: scheduleGalleryNow,
        ),
      ],
    ),
  );
  when(() => activities.state).thenReturn(const UserActivitiesState());
  when(() => classmates.state).thenReturn(const ClassmatesState());
  when(() => reminders.state).thenReturn({});
  when(
    () => activities.load(
      from: any(named: 'from'),
      to: any(named: 'to'),
    ),
  ).thenAnswer((_) async {});
  when(
    () => changes.load(
      targetType: ScheduleTargetType.group,
      target: any(named: 'target'),
    ),
  ).thenAnswer((_) async {});
  when(() => classmates.load(any())).thenAnswer((_) async {});
  return MultiBlocProvider(
    providers: [
      BlocProvider<ScheduleBloc>.value(value: schedule),
      BlocProvider<SchedulePreferencesCubit>.value(value: preferences),
      BlocProvider<ScheduleDisplayCubit>.value(value: display),
      BlocProvider<ScheduleChangesCubit>.value(value: changes),
      BlocProvider<UserActivitiesCubit>.value(value: activities),
      BlocProvider<ClassmatesCubit>.value(value: classmates),
      BlocProvider<LessonRemindersCubit>.value(value: reminders),
      BlocProvider.value(value: comparison),
    ],
    child: Stack(
      children: [
        Builder(
          builder: (context) => AppBottomBarViewport(
            bottomInset: AppBottomBar.extentOf(context),
            child: ScheduleBody(now: scheduleGalleryNow, initialView: view),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AppBottomBar(
            currentIndex: 1,
            onSelected: (_) {},
            items: const [
              AppBottomBarItem(
                icon: AppLineIconWidget(AppLineIcon.home),
                label: 'Главная',
              ),
              AppBottomBarItem(
                icon: AppLineIconWidget(AppLineIcon.calendar),
                label: 'Пары',
                hasBadge: true,
              ),
              AppBottomBarItem(
                icon: AppLineIconWidget(AppLineIcon.map),
                label: 'Карта',
              ),
              AppBottomBarItem(
                icon: AppLineIconWidget(AppLineIcon.grid),
                label: 'Сервисы',
              ),
              AppBottomBarItem(
                icon: AppLineIconWidget(AppLineIcon.user),
                label: 'Профиль',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget lessonGalleryScene() {
  final repository = _Repository();
  final friends = _Friends();
  final campus = _Campus();
  when(
    () => repository.getLessonDetails(
      subjectName: any(named: 'subjectName'),
      lessonDate: any(named: 'lessonDate'),
      lessonBellsNumber: any(named: 'lessonBellsNumber'),
    ),
  ).thenAnswer(
    (_) async => LessonDetailsResponse(
      reactions: const LessonReactionResponse(
        counts: {'brain': 12, 'thinking': 4, 'sleepy': 2, 'fire': 9},
      ),
      materials: [
        for (final row in [
          (
            '1',
            'Методичка · Программирование на Python',
            'notes.pdf',
            2516582,
            'Аня К.',
            3,
          ),
          ('2', 'Конспект прошлой пары', 'notes.docx', 655360, 'Миша Р.', 1),
        ])
          LessonMaterial(
            id: row.$1,
            type: LessonMaterialType.note,
            title: row.$2,
            fileName: row.$3,
            filePath: row.$3,
            fileSize: row.$4,
            isPublic: true,
            isAnonymous: false,
            downloadCount: 0,
            likeCount: 0,
            authorName: row.$5,
            createdAt: DateTime.now().subtract(Duration(days: row.$6)),
          ),
      ],
      reviews: [],
    ),
  );
  when(
    friends.getGroupMembers,
  ).thenAnswer((_) async => GroupRoster.empty);
  when(
    () => campus.getTeacherProfile(any()),
  ).thenAnswer(
    (_) async => const TeacherProfile(
      teacherName: 'Кузнецов А. П.',
      clarity: 4.6,
      loyalty: 4.6,
      usefulness: 4.6,
    ),
  );
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<ScheduleRepository>.value(value: repository),
      RepositoryProvider<FriendsRepository>.value(value: friends),
      RepositoryProvider<CampusRepository>.value(value: campus),
    ],
    child: ScheduleDetailsPage(
      lesson: scheduleGalleryLessons()[1],
      selectedDate: scheduleGalleryNow,
    ),
  );
}
