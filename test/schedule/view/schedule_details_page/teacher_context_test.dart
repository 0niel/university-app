import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';

class _Schedule extends Mock implements ScheduleRepository {}

class _Friends extends Mock implements FriendsRepository {}

class _Campus extends Mock implements CampusRepository {}

class _Persona extends MockCubit<AccountPersonaState>
    implements AccountPersonaCubit {}

class _ScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Changes extends MockCubit<ScheduleChangesState>
    implements ScheduleChangesCubit {}

LessonSchedulePart _sourceLesson(DateTime date) => LessonSchedulePart(
  subject: 'Mathematics',
  lessonType: .lecture,
  teachers: const [],
  classrooms: const [Classroom(name: '101')],
  lessonBells: LessonBells(
    number: 1,
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 10, minute: 30),
  ),
  dates: [date],
  groups: const ['A-01'],
);

void _stubDetails(_Schedule repository) {
  when(
    () => repository.getLessonDetails(
      subjectName: any(named: 'subjectName'),
      lessonDate: any(named: 'lessonDate'),
      lessonBellsNumber: any(named: 'lessonBellsNumber'),
    ),
  ).thenAnswer(
    (_) async => const LessonDetailsResponse(
      reactions: LessonReactionResponse(counts: {}),
      materials: [],
      reviews: [],
    ),
  );
}

Widget _sourcePage({
  required _Schedule repository,
  required _Persona persona,
  required LessonSchedulePart lesson,
  required Teacher teacher,
  _ScheduleBloc? schedule,
  _Changes? changes,
}) => MultiRepositoryProvider(
  providers: [
    RepositoryProvider<ScheduleRepository>.value(value: repository),
    RepositoryProvider<FriendsRepository>.value(value: _Friends()),
    RepositoryProvider<CampusRepository>.value(value: _Campus()),
  ],
  child: MultiBlocProvider(
    providers: [
      BlocProvider<AccountPersonaCubit>.value(value: persona),
      if (schedule != null) BlocProvider<ScheduleBloc>.value(value: schedule),
      if (changes != null)
        BlocProvider<ScheduleChangesCubit>.value(value: changes),
    ],
    child: ScheduleDetailsPage(
      lesson: lesson,
      selectedDate: lesson.dates.first,
      sourceTeacher: teacher,
    ),
  ),
);

void main() {
  for (final role in AccountRole.values) {
    testWidgets('$role lesson keeps groups and respects student roster scope', (
      tester,
    ) async {
      final schedule = _Schedule();
      final friends = _Friends();
      final campus = _Campus();
      final persona = _Persona();
      when(() => persona.state).thenReturn(
        AccountPersonaState(persona: AccountPersona(role: role)),
      );
      when(
        () => schedule.getLessonDetails(
          subjectName: any(named: 'subjectName'),
          lessonDate: any(named: 'lessonDate'),
          lessonBellsNumber: any(named: 'lessonBellsNumber'),
        ),
      ).thenAnswer(
        (_) async => const LessonDetailsResponse(
          reactions: LessonReactionResponse(counts: {}),
          materials: [],
          reviews: [],
        ),
      );
      when(friends.getGroupMembers).thenAnswer((_) async => GroupRoster.empty);
      final date = DateTime.now().add(const Duration(days: 1));
      final lesson = LessonSchedulePart(
        subject: 'Mathematics',
        lessonType: .lecture,
        teachers: const [],
        classrooms: const [Classroom(name: '101')],
        lessonBells: LessonBells(
          number: 1,
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 10, minute: 30),
        ),
        dates: [date],
        groups: const ['A-01'],
      );
      await tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ScheduleRepository>.value(value: schedule),
            RepositoryProvider<FriendsRepository>.value(value: friends),
            RepositoryProvider<CampusRepository>.value(value: campus),
          ],
          child: BlocProvider<AccountPersonaCubit>.value(
            value: persona,
            child: ScheduleDetailsPage(lesson: lesson, selectedDate: date),
          ),
        ),
        size: const Size(1000, 2400),
      );
      await tester.pumpAndSettle();
      expect(find.text('A-01'), findsOneWidget);
      if (role == AccountRole.teacher) {
        verifyNever(friends.getGroupMembers);
      } else {
        verify(friends.getGroupMembers).called(1);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('switching to teacher hides already loaded student classmates', (
    tester,
  ) async {
    final schedule = _Schedule();
    final friends = _Friends();
    final campus = _Campus();
    final persona = _Persona();
    final states = StreamController<AccountPersonaState>.broadcast();
    addTearDown(states.close);
    whenListen(
      persona,
      states.stream,
      initialState: const AccountPersonaState(),
    );
    when(
      () => schedule.getLessonDetails(
        subjectName: any(named: 'subjectName'),
        lessonDate: any(named: 'lessonDate'),
        lessonBellsNumber: any(named: 'lessonBellsNumber'),
      ),
    ).thenAnswer(
      (_) async => const LessonDetailsResponse(
        reactions: LessonReactionResponse(counts: {}),
        materials: [],
        reviews: [],
      ),
    );
    when(friends.getGroupMembers).thenAnswer(
      (_) async => const GroupRoster(
        members: [GroupMember(userId: 'student', fullName: 'Student')],
      ),
    );
    final date = DateTime.now().add(const Duration(days: 1));
    final lesson = LessonSchedulePart(
      subject: 'Mathematics',
      lessonType: .lecture,
      teachers: const [],
      classrooms: const [Classroom(name: '101')],
      lessonBells: LessonBells(
        number: 1,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
      ),
      dates: [date],
      groups: const ['A-01'],
    );
    await tester.pumpApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ScheduleRepository>.value(value: schedule),
          RepositoryProvider<FriendsRepository>.value(value: friends),
          RepositoryProvider<CampusRepository>.value(value: campus),
        ],
        child: BlocProvider<AccountPersonaCubit>.value(
          value: persona,
          child: ScheduleDetailsPage(lesson: lesson, selectedDate: date),
        ),
      ),
      size: const Size(1000, 2400),
    );
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(ScheduleDetailsPage)).l10n;
    expect(find.text(l10n.lessonDetailsPeersTitle), findsOneWidget);
    states.add(
      const AccountPersonaState(
        persona: AccountPersona(role: AccountRole.teacher),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.lessonDetailsPeersTitle), findsNothing);
    expect(find.text('A-01'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('own teacher lesson uses its source while a group is active', (
    tester,
  ) async {
    final repository = _Schedule();
    final persona = _Persona();
    final schedule = _ScheduleBloc();
    final changes = _Changes();
    final date = DateTime.now().add(const Duration(days: 1));
    final lesson = _sourceLesson(date);
    const teacher = Teacher(name: 'Teacher', uid: 'teacher');
    _stubDetails(repository);
    when(() => persona.state).thenReturn(
      const AccountPersonaState(
        persona: AccountPersona(role: AccountRole.teacher),
      ),
    );
    when(() => schedule.state).thenReturn(
      ScheduleState(
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'A-01'),
          schedule: [lesson],
        ),
      ),
    );
    when(() => changes.state).thenReturn(
      ScheduleChangesState(
        changes: [
          ScheduleChange(
            id: 'group-room',
            kind: .room,
            subject: lesson.subject,
            lessonDate: date,
            lessonNumber: 1,
            oldValue: const ScheduleChangeSlot(rooms: ['201']),
            newValue: const ScheduleChangeSlot(rooms: ['202']),
            createdAt: date,
          ),
        ],
      ),
    );
    when(() => changes.matchesTarget(.group, 'A-01')).thenReturn(true);
    when(
      () => repository.getScheduleChanges(
        targetType: .teacher,
        target: teacher.uid!,
      ),
    ).thenAnswer(
      (_) async => [
        ScheduleChange(
          id: 'cancel-own',
          kind: .cancel,
          subject: lesson.subject,
          lessonDate: date,
          lessonNumber: 1,
          createdAt: date,
        ),
        ScheduleChange(
          id: 'other-own-slot',
          kind: .room,
          subject: lesson.subject,
          lessonDate: date,
          lessonNumber: 1,
          oldValue: const ScheduleChangeSlot(start: '11:00', rooms: ['301']),
          newValue: const ScheduleChangeSlot(start: '11:00', rooms: ['302']),
          createdAt: date.add(const Duration(hours: 1)),
        ),
      ],
    );
    await tester.pumpApp(
      _sourcePage(
        repository: repository,
        persona: persona,
        lesson: lesson,
        teacher: teacher,
        schedule: schedule,
        changes: changes,
      ),
      size: const Size(1000, 2400),
    );
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(ScheduleDetailsPage)).l10n;
    expect(find.text(l10n.lessonCancelledBanner), findsOneWidget);
    expect(find.text(l10n.lessonMovedBanner('201', '202')), findsNothing);
    expect(find.text(l10n.lessonMovedBanner('301', '302')), findsNothing);
    expect(schedule.state.selectedSchedule, isA<SelectedGroupSchedule>());
    verifyNever(() => changes.load(targetType: .teacher, target: teacher.uid!));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'teacher source changes failure retries independently of materials',
    (
      tester,
    ) async {
      final repository = _Schedule();
      final persona = _Persona();
      final date = DateTime.now().add(const Duration(days: 1));
      final lesson = _sourceLesson(date);
      const teacher = Teacher(name: 'Teacher', uid: 'teacher');
      _stubDetails(repository);
      when(() => persona.state).thenReturn(
        const AccountPersonaState(
          persona: AccountPersona(role: AccountRole.teacher),
        ),
      );
      var attempts = 0;
      when(
        () => repository.getScheduleChanges(
          targetType: .teacher,
          target: teacher.uid!,
        ),
      ).thenAnswer((_) async {
        if (attempts++ == 0) throw Exception('offline');
        return [
          ScheduleChange(
            id: 'cancel',
            kind: .cancel,
            subject: lesson.subject,
            lessonDate: date,
            lessonNumber: 1,
            createdAt: date,
          ),
        ];
      });
      await tester.pumpApp(
        _sourcePage(
          repository: repository,
          persona: persona,
          lesson: lesson,
          teacher: teacher,
        ),
        size: const Size(1000, 2400),
      );
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(ScheduleDetailsPage)).l10n;
      expect(
        find.byKey(const ValueKey('teacher-lesson-changes-error')),
        findsOneWidget,
      );
      expect(find.text(l10n.lessonCancelledBanner), findsNothing);
      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('teacher-lesson-changes-error')),
        findsNothing,
      );
      expect(find.text(l10n.lessonCancelledBanner), findsOneWidget);
      verify(
        () => repository.getLessonDetails(
          subjectName: any(named: 'subjectName'),
          lessonDate: any(named: 'lessonDate'),
          lessonBellsNumber: any(named: 'lessonBellsNumber'),
        ),
      ).called(1);
      expect(attempts, 2);
    },
  );

  testWidgets('changed teacher source discards a late previous response', (
    tester,
  ) async {
    final repository = _Schedule();
    final persona = _Persona();
    final date = DateTime.now().add(const Duration(days: 1));
    final lesson = _sourceLesson(date);
    const oldTeacher = Teacher(name: 'Old', uid: 'old');
    const newTeacher = Teacher(name: 'New', uid: 'new');
    _stubDetails(repository);
    when(() => persona.state).thenReturn(
      const AccountPersonaState(
        persona: AccountPersona(role: AccountRole.teacher),
      ),
    );
    final old = Completer<List<ScheduleChange>>();
    when(
      () => repository.getScheduleChanges(
        targetType: .teacher,
        target: oldTeacher.uid!,
      ),
    ).thenAnswer((_) => old.future);
    when(
      () => repository.getScheduleChanges(
        targetType: .teacher,
        target: newTeacher.uid!,
      ),
    ).thenAnswer((_) async => const []);
    Widget page(Teacher teacher) => _sourcePage(
      repository: repository,
      persona: persona,
      lesson: lesson,
      teacher: teacher,
    );
    await tester.pumpApp(page(oldTeacher), size: const Size(1000, 2400));
    await tester.pumpAndSettle();
    await tester.pumpApp(page(newTeacher), size: const Size(1000, 2400));
    await tester.pumpAndSettle();
    old.complete([
      ScheduleChange(
        id: 'old-cancel',
        kind: .cancel,
        subject: lesson.subject,
        lessonDate: date,
        lessonNumber: 1,
        createdAt: date,
      ),
    ]);
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(ScheduleDetailsPage)).l10n;
    expect(find.text(l10n.lessonCancelledBanner), findsNothing);
    verify(
      () => repository.getScheduleChanges(
        targetType: .teacher,
        target: newTeacher.uid!,
      ),
    ).called(1);
    expect(tester.takeException(), isNull);
  });
}
