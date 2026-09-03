// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_note_document_save_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupNoteDocumentSaveResult _$GroupNoteDocumentSaveResultFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_GroupNoteDocumentSaveResult', json, ($checkedConvert) {
  final val = _GroupNoteDocumentSaveResult(
    revision: $checkedConvert('revision', (v) => (v as num).toInt()),
    updatedAt: $checkedConvert('updatedAt', (v) => requiredDateTimeFromJson(v)),
    conflict: $checkedConvert('conflict', (v) => v as bool? ?? false),
    document: $checkedConvert(
      'document',
      (v) => v as List<dynamic>? ?? const <Object?>[],
    ),
    content: $checkedConvert('content', (v) => v as String? ?? ''),
  );
  return val;
});

Map<String, dynamic> _$GroupNoteDocumentSaveResultToJson(
  _GroupNoteDocumentSaveResult instance,
) => <String, dynamic>{
  'revision': instance.revision,
  'updatedAt': requiredDateTimeToJson(instance.updatedAt),
  'conflict': instance.conflict,
  'document': instance.document,
  'content': instance.content,
};
