part of 'lesson_comments_cubit.dart';

@freezed
abstract class LessonCommentsState with _$LessonCommentsState {
  const factory LessonCommentsState({
    @Default([]) List<LessonComment> comments,
    @Default([]) List<ScheduleComment> scheduleComments,
  }) = _LessonCommentsState;

  factory LessonCommentsState.fromJson(Map<String, dynamic> json) =>
      _$LessonCommentsStateFromJson(json);
}
