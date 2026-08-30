// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collab_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollabNote _$CollabNoteFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_CollabNote', json, ($checkedConvert) {
      final val = _CollabNote(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        title: $checkedConvert('title', (v) => v as String? ?? ''),
        content: $checkedConvert('content', (v) => v as String? ?? ''),
        updatedByName: $checkedConvert(
          'updatedByName',
          (v) => v as String? ?? '',
        ),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
        isPersonal: $checkedConvert('isPersonal', (v) => v as bool? ?? false),
        revision: $checkedConvert('revision', (v) => (v as num?)?.toInt() ?? 0),
        createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
        updatedAt: $checkedConvert('updatedAt', (v) => dateTimeFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$CollabNoteToJson(_CollabNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'updatedByName': instance.updatedByName,
      'isMine': instance.isMine,
      'isPersonal': instance.isPersonal,
      'revision': instance.revision,
      'createdAt': dateTimeToJson(instance.createdAt),
      'updatedAt': dateTimeToJson(instance.updatedAt),
    };
