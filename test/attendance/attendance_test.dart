import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/attendance/cubit/attendance_cubit.dart';
import 'package:rtu_mirea_app/attendance/data/absences_repository.dart';
import 'package:rtu_mirea_app/attendance/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Repository implements AbsencesRepository {
  List<Absence> absences = [];
  bool failLoad = false;
  bool failSave = false;

  @override
  Future<List<Absence>> load() async {
    if (failLoad) throw StateError('read failed');
    return absences;
  }

  @override
  Future<void> save(List<Absence> next) async {
    if (failSave) throw StateError('write failed');
    absences = next;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime(2026, 9, 14, 18);
  final lesson = LessonSchedulePart(
    subject: 'Physics',
    lessonType: LessonType.lecture,
    teachers: const [],
    classrooms: const [],
    lessonBells: LessonBells(
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
    ),
    dates: [DateTime(2026, 9), DateTime(2026, 9, 8), DateTime(2026, 9, 21)],
  );
  late _Repository repository;
  late AttendanceCubit cubit;

  setUp(() {
    repository = _Repository();
    cubit = AttendanceCubit(repository: repository, now: () => now);
    SharedPreferences.setMockInitialValues({});
  });
  tearDown(() async => cubit.close());

  test(
    'no schedule means unknown attendance, not verified 100 percent',
    () async {
      await cubit.load();
      expect(cubit.state.totalPercent, isNull);
      expect(cubit.state.weeks.every((week) => week.ratio == null), isTrue);
      expect(cubit.state.riskCount, 0);
    },
  );

  test('estimates only past scheduled lessons minus manual absences', () async {
    await cubit.load();
    cubit.lessonsChanged([lesson]);
    expect(cubit.state.subjects.single.total, 2);
    expect(
      await cubit.addAbsence(
        subject: 'Physics',
        date: DateTime(2026, 9, 8),
        reason: AbsenceReason.noReason,
      ),
      isTrue,
    );
    expect(cubit.state.totalPercent, 50);
    expect(cubit.state.missedCount, 1);
    expect(cubit.state.riskCount, 1);
    expect(cubit.state.weeks.length, 14);
  });

  test(
    'absences with no available schedule do not claim academic risk',
    () async {
      await cubit.load();
      await cubit.addAbsence(
        subject: 'Physics',
        date: DateTime(2026, 9, 8),
        reason: AbsenceReason.sick,
      );
      expect(cubit.state.totalPercent, isNull);
      expect(cubit.state.riskCount, 0);
    },
  );

  test('rejects empty subjects, future dates, and other semesters', () async {
    await cubit.load();
    for (final (subject, date) in [
      (' ', now),
      ('Physics', DateTime(2026, 9, 15)),
      ('Physics', DateTime(2025, 9, 8)),
    ]) {
      expect(
        await cubit.addAbsence(
          subject: subject,
          date: date,
          reason: AbsenceReason.noReason,
        ),
        isFalse,
      );
    }
    expect(cubit.state.absences, isEmpty);
  });

  test('does not count lessons before they end today', () {
    final todaysLesson = lesson.copyWith(dates: [DateTime(2026, 9, 14)]);
    final duringLesson = AttendanceState(
      lessons: [todaysLesson],
      now: DateTime(2026, 9, 14, 10),
    );
    expect(duringLesson.totalPercent, isNull);
    expect(duringLesson.copyWith(now: now).totalPercent, 100);
  });

  test('same-time additions retain independent identities', () async {
    await cubit.load();
    await Future.wait([
      cubit.addAbsence(
        subject: 'Physics',
        date: now,
        reason: AbsenceReason.sick,
      ),
      cubit.addAbsence(
        subject: 'Physics',
        date: now,
        reason: AbsenceReason.noReason,
      ),
    ]);
    expect(cubit.state.absences.length, 2);
    expect(cubit.state.absences.map((absence) => absence.id).toSet().length, 2);
    await cubit.removeAbsence(cubit.state.absences.first.id);
    expect(cubit.state.absences.length, 1);
  });

  test('failed saves preserve the previous state and permit retry', () async {
    await cubit.load();
    repository.failSave = true;
    expect(
      await cubit.addAbsence(
        subject: 'Physics',
        date: now,
        reason: AbsenceReason.noReason,
      ),
      isFalse,
    );
    expect(cubit.state.absences, isEmpty);
    repository.failSave = false;
    expect(
      await cubit.addAbsence(
        subject: 'Physics',
        date: now,
        reason: AbsenceReason.noReason,
      ),
      isTrue,
    );
  });

  test('reason changes and removal persist', () async {
    await cubit.load();
    await cubit.addAbsence(
      subject: 'Physics',
      date: now,
      reason: AbsenceReason.noReason,
    );
    final id = cubit.state.absences.single.id;
    expect(await cubit.attachCertificate(id), isTrue);
    expect(cubit.state.absences.single.reason, AbsenceReason.sick);
    expect(await cubit.removeAbsence(id), isTrue);
    expect(repository.absences, isEmpty);
  });

  test('load errors are retryable', () async {
    repository.failLoad = true;
    await cubit.load();
    expect(cubit.state.status, AttendanceStatus.failure);
    repository.failLoad = false;
    await cubit.load();
    expect(cubit.state.status, AttendanceStatus.ready);
  });

  test('local repository round trips and isolates accounts', () async {
    await cubit.load();
    await cubit.addAbsence(
      subject: 'Physics',
      date: now,
      reason: AbsenceReason.sick,
    );
    const first = LocalAbsencesRepository(userId: 'first');
    const second = LocalAbsencesRepository(userId: 'second');
    await first.save(cubit.state.absences);
    expect(await first.load(), cubit.state.absences);
    expect(await second.load(), isEmpty);
  });
}
