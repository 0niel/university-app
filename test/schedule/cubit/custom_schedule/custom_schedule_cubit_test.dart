import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockStorage extends Mock implements Storage {}

class MockRemindersRepository extends Mock
    implements LocalNotificationsRepository {}

class MockPreferencesRepository extends Mock implements PreferencesRepository {}

LessonSchedulePart _lesson({
  required String subject,
  required int number,
  required int startHour,
  required int endHour,
  required DateTime date,
  String? classroom,
}) {
  return LessonSchedulePart(
    subject: subject,
    lessonType: .lecture,
    teachers: const [],
    classrooms: classroom == null ? const [] : [Classroom(name: classroom)],
    lessonBells: LessonBells(
      startTime: TimeOfDay(hour: startHour, minute: 0),
      endTime: TimeOfDay(hour: endHour, minute: 0),
      number: number,
    ),
    dates: [date],
  );
}

void main() {
  group('CustomScheduleCubit.reorderLessons', () {
    late Storage storage;
    final monday = DateTime(2026, 5, 18); // a Monday

    setUp(() {
      storage = MockStorage();
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.delete(any())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
    });

    test('swaps time slots so the moved lesson takes the new position', () {
      final cubit = CustomScheduleCubit();
      final schedule = cubit.create(name: 'My week');
      final a = _lesson(
        subject: 'A',
        number: 1,
        startHour: 9,
        endHour: 10,
        date: monday,
      );
      final b = _lesson(
        subject: 'B',
        number: 2,
        startHour: 11,
        endHour: 12,
        date: monday,
      );
      cubit
        ..addLesson(schedule.id, a)
        ..addLesson(schedule.id, b)
        ..reorderLessons(schedule.id, DateTime.monday, 0, 1);

      final updated = cubit.state.customSchedules.firstWhere(
        (s) => s.id == schedule.id,
      );
      final byTime = updated.lessons.toList()
        ..sort(
          (x, y) => x.lessonBells.startTime.hour.compareTo(
            y.lessonBells.startTime.hour,
          ),
        );

      // After the swap B occupies the 09:00 slot and A the 11:00 slot.
      expect(byTime.first.subject, 'B');
      expect(byTime.first.lessonBells.startTime.hour, 9);
      expect(byTime.last.subject, 'A');
      expect(byTime.last.lessonBells.startTime.hour, 11);
    });

    test('a no-op reorder (same position) leaves the schedule unchanged', () {
      final cubit = CustomScheduleCubit();
      final schedule = cubit.create(name: 'My week');
      cubit
        ..addLesson(
          schedule.id,
          _lesson(
            subject: 'A',
            number: 1,
            startHour: 9,
            endHour: 10,
            date: monday,
          ),
        )
        ..addLesson(
          schedule.id,
          _lesson(
            subject: 'B',
            number: 2,
            startHour: 11,
            endHour: 12,
            date: monday,
          ),
        );
      final before = cubit.state.customSchedules.firstWhere(
        (s) => s.id == schedule.id,
      );

      cubit.reorderLessons(schedule.id, DateTime.monday, 0, 0);

      final after = cubit.state.customSchedules.firstWhere(
        (s) => s.id == schedule.id,
      );
      expect(after.lessons.toSet(), before.lessons.toSet());
    });
  });

  group('CustomScheduleCubit color & reminders', () {
    late Storage storage;
    final monday = DateTime(2026, 5, 18);

    setUpAll(() => registerFallbackValue(<LessonReminder>[]));

    setUp(() {
      storage = MockStorage();
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.delete(any())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
    });

    test('persists a lesson color and reminderMinutes', () {
      final cubit = CustomScheduleCubit();
      final schedule = cubit.create(name: 'W');
      final lesson = _lesson(
        subject: 'A',
        number: 1,
        startHour: 9,
        endHour: 10,
        date: monday,
      ).copyWith(color: 0xFF2F7AFF, reminderMinutes: 15);

      cubit.addLesson(schedule.id, lesson);

      final saved = cubit.state.customSchedules
          .firstWhere((s) => s.id == schedule.id)
          .lessons
          .single;
      expect(saved.color, 0xFF2F7AFF);
      expect(saved.reminderMinutes, 15);
    });

    test('hands reminders to the repository when lessons change', () {
      final reminders = MockRemindersRepository();
      when(
        () => reminders.syncLessonReminders(
          scheduleId: any(named: 'scheduleId'),
          reminders: any(named: 'reminders'),
        ),
      ).thenAnswer((_) async {});
      when(() => reminders.cancelSchedule(any())).thenAnswer((_) async {});

      final cubit = CustomScheduleCubit(remindersRepository: reminders);
      final schedule = cubit.create(name: 'W');
      cubit.addLesson(
        schedule.id,
        _lesson(
          subject: 'A',
          number: 1,
          startHour: 9,
          endHour: 10,
          date: monday,
        ),
      );

      verify(
        () => reminders.syncLessonReminders(
          scheduleId: 'custom-schedules',
          reminders: any(named: 'reminders'),
        ),
      ).called(1);
    });

    test('serializes a delete behind an in-flight reminder sync', () async {
      final reminders = MockRemindersRepository();
      final firstSync = Completer<void>();
      final batches = <List<LessonReminder>>[];
      when(
        () => reminders.syncLessonReminders(
          scheduleId: any(named: 'scheduleId'),
          reminders: any(named: 'reminders'),
        ),
      ).thenAnswer((invocation) {
        batches.add(
          invocation.namedArguments[#reminders] as List<LessonReminder>,
        );
        return firstSync.future;
      });
      when(() => reminders.cancelSchedule(any())).thenAnswer((_) async {});
      final cubit = CustomScheduleCubit(remindersRepository: reminders);
      final schedule = cubit.create(name: 'W');
      cubit.addLesson(
        schedule.id,
        _lesson(
          subject: 'A',
          number: 1,
          startHour: 9,
          endHour: 10,
          date: monday,
        ).copyWith(reminderMinutes: 15),
      );
      await Future<void>.delayed(Duration.zero);

      cubit.delete(schedule.id);
      firstSync.complete();
      await cubit.close();

      expect(batches, hasLength(2));
      expect(batches.last, isEmpty);
    });
  });

  group('CustomScheduleCubit stable lesson mutations', () {
    late Storage storage;
    final monday = DateTime(2026, 5, 18);

    setUp(() {
      storage = MockStorage();
      when(() => storage.read(any())).thenReturn(null);
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.delete(any())).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
    });

    test('an edit collision preserves both existing lessons', () {
      final cubit = CustomScheduleCubit(now: () => monday);
      final schedule = cubit.create(name: 'W');
      final first = _lesson(
        subject: 'Math',
        number: 1,
        startHour: 9,
        endHour: 10,
        date: monday,
      );
      final second = _lesson(
        subject: 'Physics',
        number: 2,
        startHour: 11,
        endHour: 12,
        date: monday,
      );
      cubit
        ..addLesson(schedule.id, first)
        ..addLesson(schedule.id, second);
      final displayed = cubit.lessonsForWeekday(
        schedule.id,
        DateTime.monday,
      );

      final result = cubit.replaceLesson(
        schedule.id,
        displayed.last,
        first,
      );

      expect(result, CustomLessonMutationResult.duplicate);
      expect(cubit.scheduleById(schedule.id)?.lessons, hasLength(2));
    });

    test('similar slots with different classrooms can coexist', () {
      final cubit = CustomScheduleCubit(now: () => monday);
      final schedule = cubit.create(name: 'W');
      final first = _lesson(
        subject: 'Math',
        number: 1,
        startHour: 9,
        endHour: 10,
        date: monday,
        classroom: 'A-1',
      );
      final second = _lesson(
        subject: 'Math',
        number: 1,
        startHour: 9,
        endHour: 10,
        date: monday,
        classroom: 'B-2',
      );

      expect(
        cubit.addLesson(schedule.id, first),
        CustomLessonMutationResult.success,
      );
      expect(
        cubit.addLesson(schedule.id, second),
        CustomLessonMutationResult.success,
      );
      expect(cubit.scheduleById(schedule.id)?.lessons, hasLength(2));
    });

    test('replace emits once and preserves the stable lesson id', () async {
      final cubit = CustomScheduleCubit(now: () => monday);
      final schedule = cubit.create(name: 'W');
      cubit.addLesson(
        schedule.id,
        _lesson(
          subject: 'Math',
          number: 1,
          startHour: 9,
          endHour: 10,
          date: monday,
        ),
      );
      final existing = cubit
          .lessonsForWeekday(
            schedule.id,
            DateTime.monday,
          )
          .single;
      final emitted = <CustomScheduleState>[];
      final subscription = cubit.stream.listen(emitted.add);

      final result = cubit.replaceLesson(
        schedule.id,
        existing,
        existing.copyWith(subject: 'Algorithms'),
      );
      await Future<void>.delayed(.zero);

      expect(result, CustomLessonMutationResult.success);
      expect(emitted, hasLength(1));
      expect(
        cubit.scheduleById(schedule.id)?.lessons.single.id,
        existing.uid,
      );
      await subscription.cancel();
      await cubit.close();
    });

    test('remote restore resynchronizes lesson reminders', () async {
      final reminders = MockRemindersRepository();
      final preferences = MockPreferencesRepository();
      when(() => reminders.cancelSchedule(any())).thenAnswer((_) async {});
      when(
        () => reminders.syncLessonReminders(
          scheduleId: any(named: 'scheduleId'),
          reminders: any(named: 'reminders'),
        ),
      ).thenAnswer((_) async {});
      when(() => preferences.hasAuthenticatedUser).thenReturn(true);
      final remoteSchedule = CustomSchedule(
        id: 'remote',
        name: 'Remote',
        lessons: [
          CustomLesson.fromSchedulePart(
            _lesson(
              subject: 'Remote lesson',
              number: 1,
              startHour: 9,
              endHour: 10,
              date: monday,
            ).copyWith(reminderMinutes: 15),
            id: 'remote-lesson',
            now: monday,
          ),
        ],
        updatedAt: monday,
      );
      final remoteState = CustomScheduleState(
        customSchedules: [remoteSchedule],
      );
      when(() => preferences.get('custom_schedules')).thenAnswer(
        (_) async => UserPreferenceEntry(
          key: 'custom_schedules',
          value: remoteState.toJson(),
          revision: 1,
          updatedAt: monday.toUtc(),
        ),
      );
      final cubit = CustomScheduleCubit(
        preferencesRepository: preferences,
        remindersRepository: reminders,
        now: () => monday,
      );

      await cubit.restoreFromRemote();

      expect(cubit.state.customSchedules.single.id, 'remote');
      verify(
        () => reminders.syncLessonReminders(
          scheduleId: 'custom-schedules',
          reminders: any(named: 'reminders'),
        ),
      ).called(2);
      await cubit.close();
    });

    test('close awaits reminder reconciliation started by restore', () async {
      final reminders = MockRemindersRepository();
      final preferences = MockPreferencesRepository();
      final remote = Completer<UserPreferenceEntry?>();
      final remoteSync = Completer<void>();
      when(() => preferences.hasAuthenticatedUser).thenReturn(true);
      when(() => preferences.get('custom_schedules')).thenAnswer(
        (_) => remote.future,
      );
      when(
        () => reminders.syncLessonReminders(
          scheduleId: 'custom-schedules',
          reminders: any(named: 'reminders'),
        ),
      ).thenAnswer((invocation) {
        final batch =
            invocation.namedArguments[#reminders] as List<LessonReminder>;
        return batch.isEmpty ? Future<void>.value() : remoteSync.future;
      });
      final remoteSchedule = CustomSchedule(
        id: 'remote',
        name: 'Remote',
        lessons: [
          CustomLesson.fromSchedulePart(
            _lesson(
              subject: 'Remote lesson',
              number: 1,
              startHour: 9,
              endHour: 10,
              date: monday,
            ).copyWith(reminderMinutes: 15),
            id: 'remote-lesson',
            now: monday,
          ),
        ],
      );
      final cubit = CustomScheduleCubit(
        preferencesRepository: preferences,
        remindersRepository: reminders,
        now: () => monday,
      );
      var closed = false;
      final close = cubit.close().then((_) => closed = true);

      remote.complete(
        UserPreferenceEntry(
          key: 'custom_schedules',
          value: CustomScheduleState(
            customSchedules: [remoteSchedule],
          ).toJson(),
          revision: 1,
          updatedAt: monday.toUtc(),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(closed, isFalse);

      remoteSync.complete();
      await close;
      expect(cubit.isClosed, isTrue);
    });
  });
}
