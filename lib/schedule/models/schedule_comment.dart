import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_comment.freezed.dart';
part 'schedule_comment.g.dart';

@freezed
abstract class ScheduleComment with _$ScheduleComment {
  @JsonSerializable(checked: true)
  const factory ScheduleComment({
    required String scheduleName,
    required String text,
  }) = _ScheduleComment;

  factory ScheduleComment.fromJson(Map<String, Object?> json) =>
      _$ScheduleCommentFromJson(json);
}
