import 'package:campus_repository/src/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_note_document_save_result.freezed.dart';
part 'group_note_document_save_result.g.dart';

@freezed
abstract class GroupNoteDocumentSaveResult with _$GroupNoteDocumentSaveResult {
  const factory GroupNoteDocumentSaveResult({
    required int revision,
    @JsonKey(
      fromJson: requiredDateTimeFromJson,
      toJson: requiredDateTimeToJson,
    )
    required DateTime updatedAt,
    @Default(false) bool conflict,
    @Default(<Object?>[]) List<Object?> document,
    @Default('') String content,
  }) = _GroupNoteDocumentSaveResult;

  factory GroupNoteDocumentSaveResult.fromJson(Map<String, Object?> json) =>
      _$GroupNoteDocumentSaveResultFromJson(json);
}

final class CollabNoteUnavailableException implements Exception {
  const CollabNoteUnavailableException();

  @override
  String toString() => 'This note is no longer available to you';
}
