import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'lesson_comment.freezed.dart';
part 'lesson_comment.g.dart';

@freezed
abstract class LessonComment with _$LessonComment {
  @JsonSerializable(checked: true, explicitToJson: true)
  const factory LessonComment({
    required String subjectName,
    required DateTime lessonDate,
    required LessonBells lessonBells,
    required String text,
    @Default(false) bool isSharedWithGroup,
  }) = _LessonComment;

  factory LessonComment.fromJson(Map<String, Object?> json) =>
      _$LessonCommentFromJson(json);
}
