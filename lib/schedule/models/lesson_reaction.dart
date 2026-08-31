import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/schedule/models/reaction_type.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'lesson_reaction.freezed.dart';
part 'lesson_reaction.g.dart';

@freezed
abstract class LessonReaction with _$LessonReaction {
  @JsonSerializable(checked: true, explicitToJson: true)
  const factory LessonReaction({
    required String subjectName,
    required DateTime lessonDate,
    required LessonBells lessonBells,
    required ReactionType reactionType,
    required DateTime createdAt,
  }) = _LessonReaction;

  factory LessonReaction.fromJson(Map<String, Object?> json) =>
      _$LessonReactionFromJson(json);
}
