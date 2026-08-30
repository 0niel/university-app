import 'package:mocktail/mocktail.dart';
import 'package:schedule_repository/src/data/deadlines_data_source.dart';
import 'package:schedule_repository/src/data/lesson_materials_data_source.dart';
import 'package:schedule_repository/src/data/lesson_reactions_data_source.dart';
import 'package:schedule_repository/src/data/schedule_remote_data_source.dart';
import 'package:schedule_repository/src/data/user_activities_data_source.dart';
import 'package:schedule_repository/src/schedule_failure.dart';
import 'package:schedule_repository/src/schedule_repository.dart';
import 'package:supabase/supabase.dart';
import 'package:test/test.dart';

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockScheduleDataSource extends Mock
    implements ScheduleRemoteDataSource {}

class _MockReactionsDataSource extends Mock
    implements LessonReactionsDataSource {}

class _MockMaterialsDataSource extends Mock
    implements LessonMaterialsDataSource {}

class _MockActivitiesDataSource extends Mock
    implements UserActivitiesDataSource {}

class _MockDeadlinesDataSource extends Mock implements DeadlinesDataSource {}

void main() {
  late DeadlinesDataSource deadlines;
  late ScheduleRepository repository;

  setUp(() {
    deadlines = _MockDeadlinesDataSource();
    repository = ScheduleRepository.fromDataSources(
      auth: _MockGoTrueClient(),
      schedule: _MockScheduleDataSource(),
      reactions: _MockReactionsDataSource(),
      materials: _MockMaterialsDataSource(),
      activities: _MockActivitiesDataSource(),
      deadlines: deadlines,
    );
  });

  test('getDeadlines preserves the cause in GetDeadlinesFailure', () async {
    final cause = StateError('read failed');
    when(deadlines.getDeadlines).thenThrow(cause);

    await expectLater(
      repository.getDeadlines(),
      throwsA(
        isA<GetDeadlinesFailure>().having((e) => e.error, 'error', cause),
      ),
    );
  });

  test('createDeadline uses CreateDeadlineFailure', () async {
    final cause = StateError('create failed');
    final dueAt = DateTime.utc(2026, 12);
    when(
      () => deadlines.createDeadline(
        title: 'Exam',
        subjectName: 'Math',
        dueAt: dueAt,
      ),
    ).thenThrow(cause);

    await expectLater(
      repository.createDeadline(
        title: 'Exam',
        subjectName: 'Math',
        dueAt: dueAt,
      ),
      throwsA(isA<CreateDeadlineFailure>()),
    );
  });

  test('createReminder uses CreateReminderFailure', () async {
    final cause = StateError('reminder failed');
    final fireAt = DateTime.utc(2026, 11, 30);
    when(
      () => deadlines.createReminder(fireAt: fireAt, title: 'Exam'),
    ).thenThrow(cause);

    await expectLater(
      repository.createReminder(fireAt: fireAt, title: 'Exam'),
      throwsA(isA<CreateReminderFailure>()),
    );
  });

  test('setDeadlineState uses SetDeadlineStateFailure', () async {
    final cause = StateError('update failed');
    when(
      () => deadlines.setDeadlineState(id: 'deadline-1', done: true),
    ).thenThrow(cause);

    await expectLater(
      repository.setDeadlineState(id: 'deadline-1', done: true),
      throwsA(isA<SetDeadlineStateFailure>()),
    );
  });

  test('deleteDeadline uses DeleteDeadlineFailure', () async {
    final cause = StateError('delete failed');
    when(() => deadlines.deleteDeadline('deadline-1')).thenThrow(cause);

    await expectLater(
      repository.deleteDeadline('deadline-1'),
      throwsA(isA<DeleteDeadlineFailure>()),
    );
  });
}
