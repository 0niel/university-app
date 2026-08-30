import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'collab_note.freezed.dart';
part 'collab_note.g.dart';

@freezed
abstract class CollabNote with _$CollabNote {
  const factory CollabNote({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(defaultValue: '') required String title,
    @Default('') String content,
    @Default('') String updatedByName,
    @Default(false) bool isMine,
    @Default(false) bool isPersonal,
    @Default(0) int revision,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
    DateTime? updatedAt,
  }) = _CollabNote;

  factory CollabNote.fromJson(Map<String, Object?> json) =>
      _$CollabNoteFromJson(json);
}
