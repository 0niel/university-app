import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/schedule/models/reaction_counts.dart';
import 'package:rtu_mirea_app/schedule/models/reaction_type.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'lesson_reaction_summary.freezed.dart';
part 'lesson_reaction_summary.g.dart';

@freezed
abstract class LessonReactionSummary with _$LessonReactionSummary {
  @JsonSerializable(checked: true, explicitToJson: true)
  const factory LessonReactionSummary({
    required String subjectName,
    required DateTime lessonDate,
    required LessonBells lessonBells,
    @Default(ReactionCounts()) ReactionCounts reactionCounts,
    ReactionType? userReaction,
  }) = _LessonReactionSummary;

  const LessonReactionSummary._();

  factory LessonReactionSummary.fromJson(Map<String, Object?> json) =>
      _$LessonReactionSummaryFromJson(json);

  int get totalReactions => reactionCounts.total;
}
