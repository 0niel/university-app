import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_note.freezed.dart';
part 'group_note.g.dart';

@freezed
abstract class GroupNote with _$GroupNote {
  const factory GroupNote({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String title,
    @JsonKey(defaultValue: '') required String authorName,
    @Default('') String body,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @Default(false) bool isPinned,
    @Default(false) bool isMine,
    @Default(0) int likes,
    @Default(false) bool likedByMe,
  }) = _GroupNote;

  factory GroupNote.fromJson(Map<String, Object?> json) =>
      _$GroupNoteFromJson(json);
}
