part of 'custom_lesson_editor_cubit.dart';

@freezed
abstract class CustomLessonEditorState with _$CustomLessonEditorState {
  const factory CustomLessonEditorState({
    @Default('') String subject,
    @Default(LessonType.lecture) LessonType lessonType,
    @Default(TimeOfDay(hour: 10, minute: 40)) TimeOfDay startTime,
    @Default(TimeOfDay(hour: 12, minute: 10)) TimeOfDay endTime,
    @Default(1) int? lessonNumber,
    @Default(0xFF2F7AFF) int color,
    int? reminderMinutes,
    @Default(1) int weekday,
    @Default(LessonRepeat.everyWeek) LessonRepeat repeat,
    @Default(<DateTime>[]) List<DateTime> selectedDates,
    @Default(<Classroom>[]) List<Classroom> selectedClassrooms,
    @Default(<Teacher>[]) List<Teacher> selectedTeachers,
  }) = _CustomLessonEditorState;
}
