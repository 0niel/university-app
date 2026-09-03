import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/exam_readiness/exam_readiness_cubit.dart';
import 'package:rtu_mirea_app/schedule/models/selected_schedule.dart';
import 'package:rtu_mirea_app/schedule/view/session/session_exam.dart';
import 'package:rtu_mirea_app/schedule/view/session/session_page.dart';
import 'package:rtu_mirea_app/schedule/view/session/widgets/countdown_hero.dart';
import 'package:rtu_mirea_app/schedule/view/session/widgets/exam_topics.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import '../schedule_page/schedule_test_data.dart';

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Readiness extends MockCubit<ExamReadinessState>
    implements ExamReadinessCubit {}

class _Repository extends Mock implements ScheduleRepository {}

class _Storage extends Mock implements Storage {}

void main() {
  late _Schedule schedule;
  late _Readiness readiness;
  late _Repository repository;

  setUp(() {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    schedule = _Schedule();
    readiness = _Readiness();
    repository = _Repository();
    when(() => schedule.state).thenReturn(const ScheduleState());
    when(() => readiness.state).thenReturn(const ExamReadinessState());
    when(readiness.load).thenAnswer((_) async {});
    when(() => repository.hasAuthenticatedUser).thenReturn(false);
  });

  Widget subject() => RepositoryProvider<ScheduleRepository>.value(
    value: repository,
    child: MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleBloc>.value(value: schedule),
        BlocProvider<ExamReadinessCubit>.value(value: readiness),
      ],
      child: const SessionPage(),
    ),
  );

  testWidgets('shows an honest empty state without fabricated exams', (
    tester,
  ) async {
    await tester.pumpApp(subject());
    expect(find.byType(AppEmptyState), findsOneWidget);
    verify(readiness.load).called(1);
  });

  testWidgets(
    'schedule failure retries instead of claiming there are no exams',
    (
      tester,
    ) async {
      when(() => schedule.state).thenReturn(
        const ScheduleState(status: ScheduleStatus.failure),
      );
      await tester.pumpApp(subject());
      expect(find.byType(AppErrorState), findsOneWidget);
      expect(find.byType(AppEmptyState), findsNothing);
      tester.widget<AppErrorState>(find.byType(AppErrorState)).onPrimary!();
      verify(
        () => schedule.add(
          const SelectedScheduleRefreshRequested(manual: true),
        ),
      ).called(1);
    },
  );

  testWidgets('derives sorted unique assessments from real dates and bells', (
    tester,
  ) async {
    final date = DateTime(2026, 9, 2);
    final exam = scheduleTestLesson(day: date, type: LessonType.exam);
    final tomorrow = scheduleTestLesson(
      subject: 'Physics',
      day: date.add(const Duration(days: 1)),
      type: LessonType.credit,
    );
    late List<SessionExam> exams;
    await tester.pumpApp(
      Builder(
        builder: (context) {
          exams = SessionExam.fromSchedule(context, [
            tomorrow,
            exam,
            exam,
            scheduleTestLesson(day: date),
            scheduleTestLesson(
              day: date.subtract(const Duration(days: 1)),
              type: LessonType.exam,
            ),
          ], now: date);
          return const SizedBox.shrink();
        },
      ),
    );
    expect(exams.map((exam) => exam.subject), ['Математика', 'Physics']);
    expect(exams.first.date, DateTime(2026, 9, 2, 9));
    expect(exams.first.room, 'А-101');
    expect(exams.first.teacher, 'Преподаватель');
    expect(exams.last.days, 1);
  });

  testWidgets('real exams fit a narrow screen with large text', (tester) async {
    when(() => schedule.state).thenReturn(
      ScheduleState(
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'Test'),
          schedule: [
            scheduleTestLesson(
              day: DateTime.now().add(const Duration(days: 2)),
              type: LessonType.exam,
            ),
          ],
        ),
      ),
    );
    await tester.pumpApp(
      subject(),
      size: const Size(320, 900),
      textScaler: const TextScaler.linear(2),
    );
    expect(find.byType(CountdownHero), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('topic completion and secondary removal remain usable', (
    tester,
  ) async {
    when(() => schedule.state).thenReturn(
      ScheduleState(
        selectedSchedule: SelectedGroupSchedule(
          group: const Group(name: 'Test'),
          schedule: [
            scheduleTestLesson(
              day: DateTime.now().add(const Duration(days: 2)),
              type: LessonType.exam,
            ),
          ],
        ),
      ),
    );
    await tester.pumpApp(subject());
    final topics = tester.widget<ExamTopics>(find.byType(ExamTopics));
    topics.cubit.addTopic(topics.exam.key, 'Реляционная модель и нормализация');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Реляционная модель и нормализация').first);
    await tester.pumpAndSettle();
    expect(topics.cubit.state.forExam(topics.exam.key).single.done, isTrue);
    await tester.longPress(
      find.text('Реляционная модель и нормализация').first,
    );
    await tester.pumpAndSettle();
    final remove = find.ancestor(
      of: find.text('Удалить тему'),
      matching: find.byType(AppButton),
    );
    await tester.tap(remove);
    await tester.pumpAndSettle();
    expect(topics.cubit.state.forExam(topics.exam.key), isEmpty);
    expect(tester.takeException(), isNull);
  });
}
