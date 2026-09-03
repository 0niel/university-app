import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/common/bloc/remote_preference_sync.dart';
import 'package:rtu_mirea_app/schedule/cubit/custom_schedule/custom_lesson_mutation_result.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/utils/lesson_reminders.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'custom_schedule_cubit.freezed.dart';
part 'custom_schedule_cubit.g.dart';
part 'custom_schedule_state.dart';

class CustomScheduleCubit extends HydratedCubit<CustomScheduleState>
    with RemotePreferenceSync<CustomScheduleState> {
  CustomScheduleCubit({
    this.preferencesRepository,
    this.remindersRepository,
    DateTime Function()? now,
  }) : _nowBuilder = now ?? DateTime.now,
       super(const CustomScheduleState()) {
    unawaited(restoreFromRemote());
    _syncAllReminders();
  }

  static const _reminderNamespace = 'custom-schedules';

  @override
  final PreferencesRepository? preferencesRepository;
  final LocalNotificationsRepository? remindersRepository;
  final DateTime Function() _nowBuilder;
  Future<void>? _activeReminderSync;
  var _reminderSyncPending = false;

  @override
  String get preferenceKey => 'custom_schedules';

  @override
  Map<String, dynamic> toPreferencePayload(CustomScheduleState state) =>
      state.toJson();

  @override
  CustomScheduleState? fromPreferencePayload(Map<String, dynamic> payload) {
    try {
      final restored = CustomScheduleState.fromJson(payload);
      if (restored.customSchedules.isEmpty &&
          state.customSchedules.isNotEmpty) {
        return null;
      }
      return restored;
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      return null;
    }
  }

  @override
  DateTime? remotePreferenceUpdatedAt(CustomScheduleState state) => state
      .customSchedules
      .map((schedule) => schedule.lastModifiedAt)
      .nonNulls
      .maxOrNull;

  @override
  Future<void> onRemotePreferenceRestored(
    CustomScheduleState previous,
    CustomScheduleState restored,
  ) async {
    _syncAllReminders();
    await _waitForReminderSync();
  }

  @override
  void onRemotePreferenceSyncStatusChanged(
    RemotePreferenceSyncStatus status,
  ) {
    emit(state.copyWith(syncStatus: status));
  }

  CustomSchedule create({required String name, String? description}) {
    final schedule = CustomSchedule.create(
      name,
      description: description,
      now: _nowBuilder(),
    );
    emit(state.copyWith(customSchedules: [...state.customSchedules, schedule]));
    return schedule;
  }

  void delete(String scheduleId) {
    final schedules = state.customSchedules
        .where((schedule) => schedule.id != scheduleId)
        .toList();
    if (schedules.length == state.customSchedules.length) return;
    emit(state.copyWith(customSchedules: schedules));
    _syncReminders(scheduleId);
  }

  void update(CustomSchedule schedule) {
    _mutate(schedule.id, (_) => schedule);
  }

  CustomLessonMutationResult addLesson(
    String scheduleId,
    LessonSchedulePart lesson,
  ) {
    final customLesson = CustomLesson.fromSchedulePart(
      lesson,
      now: _nowBuilder(),
    );
    var result = CustomLessonMutationResult.scheduleNotFound;
    _mutate(scheduleId, (schedule) {
      if (schedule.lessons.any((item) => _sameContent(item, customLesson))) {
        result = .duplicate;
        return schedule;
      }
      result = .success;
      return schedule.copyWith(
        lessons: [...schedule.lessons, customLesson],
        updatedAt: _nowBuilder(),
      );
    });
    return result;
  }

  CustomLessonMutationResult replaceLesson(
    String scheduleId,
    LessonSchedulePart existing,
    LessonSchedulePart replacement,
  ) {
    final lessonId = existing.uid;
    if (lessonId == null) return .lessonNotFound;
    var result = CustomLessonMutationResult.scheduleNotFound;
    _mutate(scheduleId, (schedule) {
      final index = schedule.lessons.indexWhere((item) => item.id == lessonId);
      if (index < 0) {
        result = .lessonNotFound;
        return schedule;
      }
      final original = schedule.lessons.elementAtOrNull(index);
      if (original == null) {
        result = .lessonNotFound;
        return schedule;
      }
      final updated = CustomLesson.fromSchedulePart(
        replacement,
        id: lessonId,
        now: _nowBuilder(),
      ).copyWith(createdAt: original.createdAt);
      if (schedule.lessons.indexed.any(
        (entry) => entry.$1 != index && _sameContent(entry.$2, updated),
      )) {
        result = .duplicate;
        return schedule;
      }
      final lessons = schedule.lessons
          .mapIndexed((itemIndex, item) => itemIndex == index ? updated : item)
          .toList();
      result = .success;
      return schedule.copyWith(lessons: lessons, updatedAt: _nowBuilder());
    });
    return result;
  }

  CustomLessonMutationResult removeLesson(
    String scheduleId,
    LessonSchedulePart lesson,
  ) {
    final lessonId = lesson.uid;
    if (lessonId == null) return .lessonNotFound;
    var result = CustomLessonMutationResult.scheduleNotFound;
    _mutate(scheduleId, (schedule) {
      final lessons = schedule.lessons
          .where((item) => item.id != lessonId)
          .toList();
      if (lessons.length == schedule.lessons.length) {
        result = .lessonNotFound;
        return schedule;
      }
      result = .success;
      return schedule.copyWith(lessons: lessons, updatedAt: _nowBuilder());
    });
    return result;
  }

  void reorderLessons(
    String scheduleId,
    int weekday,
    int oldIndex,
    int newIndex,
  ) {
    _mutate(scheduleId, (schedule) {
      final dayLessons = _customLessonsOn(schedule, weekday);
      final target = newIndex;
      if (dayLessons.elementAtOrNull(oldIndex) == null ||
          dayLessons.elementAtOrNull(target) == null ||
          target == oldIndex) {
        return schedule;
      }
      final slots = dayLessons.map((lesson) => lesson.lessonBells).toList();
      final reordered = [...dayLessons];
      reordered.insert(target, reordered.removeAt(oldIndex));
      final repositioned = reordered.mapIndexed((index, lesson) {
        final bells = slots.elementAtOrNull(index);
        return bells == null
            ? lesson
            : lesson.copyWith(
                lessonBells: bells,
                updatedAt: _nowBuilder(),
              );
      }).toList();
      final rest = schedule.lessons.whereNot(dayLessons.contains).toList();
      return schedule.copyWith(
        lessons: [...rest, ...repositioned],
        updatedAt: _nowBuilder(),
      );
    });
  }

  CustomSchedule? scheduleById(String scheduleId) => state.customSchedules
      .firstWhereOrNull((schedule) => schedule.id == scheduleId);

  List<LessonSchedulePart> lessonsForWeekday(String scheduleId, int weekday) {
    final schedule = scheduleById(scheduleId);
    if (schedule == null) return const [];
    return _customLessonsOn(
      schedule,
      weekday,
    ).map((lesson) => lesson.toSchedulePart(_nowBuilder())).toList();
  }

  SelectedCustomSchedule? buildSelectedSchedule(String scheduleId) {
    final schedule = scheduleById(scheduleId);
    if (schedule == null) return null;
    return SelectedCustomSchedule(
      id: schedule.id,
      name: schedule.name,
      description: schedule.description,
      schedule: schedule.lessons
          .map((lesson) => lesson.toSchedulePart(_nowBuilder()))
          .toList(),
    );
  }

  List<CustomLesson> _customLessonsOn(
    CustomSchedule schedule,
    int weekday,
  ) {
    final reference = _nowBuilder();
    return schedule.lessons
        .where(
          (lesson) => lesson.recurrence
              .expand(reference)
              .any((date) => date.weekday == weekday),
        )
        .sortedBy<num>(
          (lesson) =>
              lesson.lessonBells.startTime.hour * 60 +
              lesson.lessonBells.startTime.minute,
        );
  }

  bool _mutate(
    String scheduleId,
    CustomSchedule Function(CustomSchedule schedule) transform,
  ) {
    final index = state.customSchedules.indexWhere(
      (schedule) => schedule.id == scheduleId,
    );
    final current = state.customSchedules.elementAtOrNull(index);
    if (current == null) return false;
    final updated = transform(current);
    if (updated == current) return false;
    final schedules = state.customSchedules
        .mapIndexed((itemIndex, item) => itemIndex == index ? updated : item)
        .toList();
    emit(state.copyWith(customSchedules: schedules));
    _syncReminders(scheduleId);
    return true;
  }

  void _syncAllReminders() {
    _syncReminders(_reminderNamespace);
  }

  void refreshReminders() => _syncAllReminders();

  void _syncReminders(String _) {
    if (remindersRepository == null) return;
    _reminderSyncPending = true;
    if (_activeReminderSync != null) return;
    final sync = _drainReminderSync();
    _activeReminderSync = sync;
    unawaited(
      sync.whenComplete(() {
        _activeReminderSync = null;
        if (_reminderSyncPending) _syncReminders(_reminderNamespace);
      }),
    );
  }

  Future<void> _drainReminderSync() async {
    while (_reminderSyncPending) {
      _reminderSyncPending = false;
      try {
        await _performReminderSync();
      } on Object catch (error, stackTrace) {
        addError(error, stackTrace);
      }
    }
  }

  Future<void> _performReminderSync() async {
    final repository = remindersRepository;
    if (repository == null) return;
    final reminders = state.customSchedules
        .expand(
          (schedule) => buildLessonReminders(
            scheduleId: schedule.id,
            schedule: schedule,
            now: _nowBuilder(),
            bodyOf: defaultLessonReminderBody,
          ),
        )
        .toList();
    await repository.syncLessonReminders(
      scheduleId: _reminderNamespace,
      reminders: reminders,
    );
  }

  Future<void> _waitForReminderSync() async {
    while (true) {
      final sync = _activeReminderSync;
      if (sync == null) return;
      await sync;
    }
  }

  bool _sameContent(CustomLesson left, CustomLesson right) =>
      left.copyWith(id: '', createdAt: null, updatedAt: null) ==
      right.copyWith(id: '', createdAt: null, updatedAt: null);

  @override
  CustomScheduleState fromJson(Map<String, dynamic> json) => .fromJson(json);

  @override
  Map<String, dynamic> toJson(CustomScheduleState state) => state.toJson();

  @override
  Future<void> close() async {
    await _waitForReminderSync();
    return super.close();
  }
}
