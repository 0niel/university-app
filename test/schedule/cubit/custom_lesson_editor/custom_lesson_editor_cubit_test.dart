import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _MockCustomScheduleCubit extends Mock implements CustomScheduleCubit {}

class _FakeLessonSchedulePart extends Fake implements LessonSchedulePart {}

void main() {
  late CustomScheduleCubit schedules;

  setUpAll(() => registerFallbackValue(_FakeLessonSchedulePart()));

  setUp(() {
    schedules = _MockCustomScheduleCubit();
  });

  CustomLessonEditorCubit createCubit({LessonSchedulePart? lesson}) => .new(
    customScheduleCubit: schedules,
    scheduleId: 'schedule-id',
    bellSlots: UniversityConfig.defaultLessonBellSlots,
    colors: UniversityConfig.defaultLessonColorValues,
    reminderLeadMinutes: UniversityConfig.defaultLessonReminderLeadMinutes,
    lesson: lesson,
    weekday: DateTime.monday,
    now: () => DateTime(2026, 7, 6),
  );

  group('CustomLessonEditorCubit', () {
    test('creates a deterministic initial draft', () {
      final cubit = createCubit();
      addTearDown(cubit.close);

      expect(cubit.state.subject, isEmpty);
      expect(cubit.state.weekday, DateTime.monday);
      expect(cubit.state.lessonType, LessonType.lecture);
      expect(cubit.state.selectedDates, isNotEmpty);
      expect(cubit.earliestSelectableDate, DateTime(2026, 7, 5));
    });

    test('validates required subject, dates and time range', () {
      final cubit = createCubit();
      addTearDown(cubit.close);

      expect(cubit.save(), CustomLessonEditorSaveResult.subjectRequired);
      cubit
        ..subjectChanged('Math')
        ..repeatChanged(.custom, []);
      expect(cubit.save(), CustomLessonEditorSaveResult.datesRequired);
      cubit
        ..repeatChanged(.custom, [DateTime(2026, 7, 6)])
        ..timeChanged(
          const TimeOfDay(hour: 12, minute: 0),
          const TimeOfDay(hour: 11, minute: 0),
        );
      expect(cubit.save(), CustomLessonEditorSaveResult.invalidTimeRange);
      verifyNever(() => schedules.addLesson(any(), any()));
    });

    test('adds a trimmed lesson once', () {
      when(
        () => schedules.addLesson(any(), any()),
      ).thenReturn(.success);
      final cubit = createCubit()..subjectChanged('  Math  ');
      addTearDown(cubit.close);

      expect(cubit.save(), CustomLessonEditorSaveResult.success);
      final lesson =
          verify(
                () => schedules.addLesson('schedule-id', captureAny()),
              ).captured.single
              as LessonSchedulePart;
      expect(lesson.subject, 'Math');
      expect(lesson.dates, cubit.state.selectedDates);
    });

    test('maps a configured bell slot to its lesson number', () {
      final cubit = createCubit();
      addTearDown(cubit.close);

      cubit.timeChanged(
        const TimeOfDay(hour: 12, minute: 40),
        const TimeOfDay(hour: 14, minute: 10),
      );

      expect(cubit.state.lessonNumber, 3);
    });

    test('edits with replaceLesson and maps a missing target', () {
      final original = LessonSchedulePart(
        uid: 'lesson-id',
        subject: 'Math',
        lessonType: .lecture,
        teachers: const [],
        classrooms: const [],
        lessonBells: LessonBells(
          startTime: const TimeOfDay(hour: 10, minute: 40),
          endTime: const TimeOfDay(hour: 12, minute: 10),
          number: 1,
        ),
        dates: [DateTime(2026, 7, 6)],
      );
      when(
        () => schedules.replaceLesson(any(), any(), any()),
      ).thenReturn(.lessonNotFound);
      final cubit = createCubit(lesson: original);
      addTearDown(cubit.close);

      expect(cubit.save(), CustomLessonEditorSaveResult.targetNotFound);
      verify(
        () => schedules.replaceLesson('schedule-id', original, any()),
      ).called(1);
      verifyNever(() => schedules.addLesson(any(), any()));
    });
  });
}
