import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_note_save_result.freezed.dart';
part 'group_note_save_result.g.dart';

@freezed
abstract class GroupNoteSaveResult with _$GroupNoteSaveResult {
  const factory GroupNoteSaveResult({
    required int revision,
    @JsonKey(
      fromJson: requiredDateTimeFromJson,
      toJson: requiredDateTimeToJson,
    )
    required DateTime updatedAt,
  }) = _GroupNoteSaveResult;

  factory GroupNoteSaveResult.fromJson(Map<String, Object?> json) =>
      _$GroupNoteSaveResultFromJson(json);
}

final class CollabNoteConflictException implements Exception {
  const CollabNoteConflictException();

  @override
  String toString() => 'The note was changed by another editor';
}
