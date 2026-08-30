import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

class MockFriendsRepository extends Mock implements FriendsRepository {}

class MockCampusRepository extends Mock implements CampusRepository {}

void main() {
  group('ScheduleDetailsPage combined-lecture rendering', () {
    late ScheduleRepository scheduleRepository;
    late FriendsRepository friendsRepository;
    late CampusRepository campusRepository;

    setUp(() {
      scheduleRepository = MockScheduleRepository();
      friendsRepository = MockFriendsRepository();
      campusRepository = MockCampusRepository();

      // The lesson details load stays in flight so the page renders directly
      // from `widget.lesson`; the teacher/group sections do not depend on it.
      when(
        () => scheduleRepository.getLessonDetails(
          subjectName: any(named: 'subjectName'),
          lessonDate: any(named: 'lessonDate'),
          lessonBellsNumber: any(named: 'lessonBellsNumber'),
        ),
      ).thenAnswer((_) => Completer<LessonDetailsResponse>().future);
      when(
        () => friendsRepository.getGroupMembers(),
      ).thenAnswer((_) async => GroupRoster.empty);
      when(
        () => campusRepository.getTeacherProfile(any()),
      ).thenThrow(Exception('no profile in test'));
    });

    Widget buildPage(LessonSchedulePart lesson) {
      return MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ScheduleRepository>.value(
              value: scheduleRepository,
            ),
            RepositoryProvider<FriendsRepository>.value(
              value: friendsRepository,
            ),
            RepositoryProvider<CampusRepository>.value(value: campusRepository),
          ],
          child: ScheduleDetailsPage(
            lesson: lesson,
            selectedDate: DateTime(2026, 3, 6),
          ),
        ),
      );
    }

    LessonSchedulePart lessonWithGroups(List<String> groupNames) {
      return LessonSchedulePart(
        subject: 'Психология и педагогика высшей школы',
        lessonType: LessonType.lecture,
        teachers: const [
          Teacher(name: 'Иванов Иван Иванович', uid: '1'),
          Teacher(name: 'Петров Пётр Петрович', uid: '2'),
        ],
        classrooms: const [Classroom(name: 'А-1', uid: 'c1')],
        lessonBells: LessonBells(
          startTime: const TimeOfDay(hour: 9, minute: 0),
          endTime: const TimeOfDay(hour: 10, minute: 30),
          number: 1,
        ),
        dates: [DateTime(2026, 3, 6)],
        groups: groupNames,
        groupEntities: [
          for (var i = 0; i < groupNames.length; i++)
            Group(name: groupNames[i], uid: 'g$i'),
        ],
      );
    }

    testWidgets('shows every teacher and all поток groups', (tester) async {
      tester.view.physicalSize = const Size(1200, 5000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildPage(
          lessonWithGroups(const ['ИКБО-01-25', 'ИКБО-02-25', 'ИКБО-03-25']),
        ),
      );
      await tester.pump();

      // Both teachers render (not just teachers.first).
      expect(find.text('Иванов Иван Иванович'), findsOneWidget);
      expect(find.text('Петров Пётр Петрович'), findsOneWidget);

      // Every group of the combined lecture renders as a chip.
      expect(find.text('ИКБО-01-25'), findsOneWidget);
      expect(find.text('ИКБО-02-25'), findsOneWidget);
      expect(find.text('ИКБО-03-25'), findsOneWidget);
    });

    testWidgets('shows the group for a single-group lesson', (tester) async {
      tester.view.physicalSize = const Size(1200, 5000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildPage(lessonWithGroups(const ['ИКБО-09-25'])),
      );
      await tester.pump();

      // The group is the key "who is in the room" context on a teacher's or
      // classroom's schedule, so even a single group renders as a chip.
      expect(find.text('ИКБО-09-25'), findsOneWidget);
    });
  });
}
