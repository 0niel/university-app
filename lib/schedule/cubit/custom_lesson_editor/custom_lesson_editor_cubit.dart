import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/schedule/cubit/custom_schedule/custom_lesson_mutation_result.dart';
import 'package:rtu_mirea_app/schedule/cubit/custom_schedule/custom_schedule_cubit.dart';
import 'package:rtu_mirea_app/schedule/utils/lesson_repeat.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'custom_lesson_editor_cubit.freezed.dart';
part 'custom_lesson_editor_state.dart';

class CustomLessonEditorCubit extends Cubit<CustomLessonEditorState> {
  factory CustomLessonEditorCubit({
    required CustomScheduleCubit customScheduleCubit,
    required String scheduleId,
    required List<LessonBellSlotConfig> bellSlots,
    required List<int> colors,
    required List<int> reminderLeadMinutes,
    LessonSchedulePart? lesson,
    int? weekday,
    DateTime Function()? now,
  }) => CustomLessonEditorCubit._(
    customScheduleCubit,
    scheduleId,
    bellSlots,
    reminderLeadMinutes,
    lesson,
    now ?? DateTime.now,
    _initialState(
      lesson: lesson,
      weekday: weekday,
      clockBuilder: now ?? DateTime.now,
      defaultColor: colors.firstOrNull ?? 0xFF2F7AFF,
    ),
  );

  CustomLessonEditorCubit._(
    this._customScheduleCubit,
    this._scheduleId,
    this._bellSlots,
    this._reminderLeadMinutes,
    this._lesson,
    this._nowBuilder,
    CustomLessonEditorState initialState,
  ) : super(
        initialState,
      );

  final CustomScheduleCubit _customScheduleCubit;
  final String _scheduleId;
  final List<LessonBellSlotConfig> _bellSlots;
  final List<int> _reminderLeadMinutes;
  final LessonSchedulePart? _lesson;
  final DateTime Function() _nowBuilder;

  static CustomLessonEditorState _initialState({
    required LessonSchedulePart? lesson,
    required int? weekday,
    required DateTime Function() clockBuilder,
    required int defaultColor,
  }) {
    if (lesson != null) {
      final dates = lesson.dates.toList();
      final selectedWeekday =
          weekday ?? dates.firstOrNull?.weekday ?? clockBuilder().weekday;
      return CustomLessonEditorState(
        subject: lesson.subject,
        lessonType: lesson.lessonType,
        startTime: lesson.lessonBells.startTime,
        endTime: lesson.lessonBells.endTime,
        lessonNumber: lesson.lessonBells.number,
        color: lesson.color ?? defaultColor,
        reminderMinutes: lesson.reminderMinutes,
        weekday: selectedWeekday,
        repeat: inferRepeat(dates, selectedWeekday),
        selectedDates: dates,
        selectedClassrooms: lesson.classrooms.toList(),
        selectedTeachers: lesson.teachers.toList(),
      );
    }
    final selectedWeekday = clampWeekday(weekday ?? clockBuilder().weekday);
    return CustomLessonEditorState(
      weekday: selectedWeekday,
      selectedDates: expandRepeat(
        weekday: selectedWeekday,
        repeat: .everyWeek,
        reference: clockBuilder(),
      ),
    );
  }

  DateTime get earliestSelectableDate =>
      _nowBuilder().subtract(const Duration(days: 1));

  void subjectChanged(String value) => emit(state.copyWith(subject: value));

  void lessonTypeChanged(LessonType value) =>
      emit(state.copyWith(lessonType: value));

  void colorChanged(int value) => emit(state.copyWith(color: value));

  void timeChanged(TimeOfDay start, TimeOfDay end) {
    final lessonNumber = _bellSlots.indexWhere(
      (slot) =>
          slot.startMinutes == _minutesOf(start) &&
          slot.endMinutes == _minutesOf(end),
    );
    emit(
      state.copyWith(
        startTime: start,
        endTime: end,
        lessonNumber: lessonNumber < 0 ? state.lessonNumber : lessonNumber + 1,
      ),
    );
  }

  void classroomsChanged(List<Classroom> value) =>
      emit(state.copyWith(selectedClassrooms: value));

  void teachersChanged(List<Teacher> value) =>
      emit(state.copyWith(selectedTeachers: value));

  void repeatChanged(LessonRepeat repeat, List<DateTime> dates) =>
      emit(state.copyWith(repeat: repeat, selectedDates: dates));

  void reminderEnabledChanged({required bool enabled}) => emit(
    state.copyWith(
      reminderMinutes: enabled ? _defaultReminderLead : null,
    ),
  );

  void reminderMinutesChanged(int value) =>
      emit(state.copyWith(reminderMinutes: value));

  CustomLessonEditorSaveResult save() {
    final validation = _validate();
    if (validation != null) return validation;
    final replacement = _buildLesson(state.subject.trim());
    final result = _persist(replacement);
    return switch (result) {
      .success => .success,
      .duplicate => .duplicate,
      .scheduleNotFound || .lessonNotFound => .targetNotFound,
    };
  }

  CustomLessonEditorSaveResult? _validate() {
    if (state.subject.trim().isEmpty) return .subjectRequired;
    if (state.selectedDates.isEmpty) return .datesRequired;
    if (_minutesOf(state.endTime) <= _minutesOf(state.startTime)) {
      return .invalidTimeRange;
    }
    return null;
  }

  LessonSchedulePart _buildLesson(String subject) => .new(
    subject: subject,
    lessonType: state.lessonType,
    teachers: state.selectedTeachers,
    classrooms: state.selectedClassrooms,
    lessonBells: LessonBells(
      startTime: state.startTime,
      endTime: state.endTime,
      number: state.lessonNumber,
    ),
    dates: state.selectedDates,
    color: state.color,
    reminderMinutes: state.reminderMinutes,
  );

  CustomLessonMutationResult _persist(LessonSchedulePart replacement) {
    final original = _lesson;
    return original == null
        ? _customScheduleCubit.addLesson(_scheduleId, replacement)
        : _customScheduleCubit.replaceLesson(
            _scheduleId,
            original,
            replacement,
          );
  }

  int get _defaultReminderLead => _reminderLeadMinutes.contains(15)
      ? 15
      : (_reminderLeadMinutes.firstOrNull ?? 15);

  static int _minutesOf(TimeOfDay time) =>
      time.hour * Duration.minutesPerHour + time.minute;
}

enum CustomLessonEditorSaveResult {
  success,
  subjectRequired,
  datesRequired,
  invalidTimeRange,
  duplicate,
  targetNotFound,
}
