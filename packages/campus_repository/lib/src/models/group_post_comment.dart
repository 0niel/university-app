import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_post_comment.freezed.dart';
part 'group_post_comment.g.dart';

@freezed
abstract class GroupPostComment with _$GroupPostComment {
  const factory GroupPostComment({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String postId,
    @JsonKey(defaultValue: '') required String body,
    @JsonKey(defaultValue: '') required String authorName,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @Default(false) bool isMine,
    @Default(false) bool canDelete,
  }) = _GroupPostComment;

  factory GroupPostComment.fromJson(Map<String, Object?> json) =>
      _$GroupPostCommentFromJson(json);
}
