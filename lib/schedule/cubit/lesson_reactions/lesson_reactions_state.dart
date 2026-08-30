part of 'lesson_reactions_cubit.dart';

@freezed
abstract class LessonReactionsState with _$LessonReactionsState {
  const factory LessonReactionsState({
    @Default([]) List<LessonReactionSummary> summaries,
  }) = _LessonReactionsState;

  factory LessonReactionsState.fromJson(Map<String, dynamic> json) =>
      _$LessonReactionsStateFromJson(json);
}
