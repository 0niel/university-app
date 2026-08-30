// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LessonMaterial _$LessonMaterialFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_LessonMaterial', json, ($checkedConvert) {
  final val = _LessonMaterial(
    id: $checkedConvert('id', (v) => v as String),
    type: $checkedConvert(
      'type',
      (v) => $enumDecode(_$LessonMaterialTypeEnumMap, v),
    ),
    title: $checkedConvert('title', (v) => v as String),
    fileName: $checkedConvert('fileName', (v) => v as String),
    filePath: $checkedConvert('filePath', (v) => v as String),
    fileSize: $checkedConvert('fileSize', (v) => (v as num).toInt()),
    isPublic: $checkedConvert('isPublic', (v) => v as bool),
    isAnonymous: $checkedConvert('isAnonymous', (v) => v as bool),
    downloadCount: $checkedConvert('downloadCount', (v) => (v as num).toInt()),
    likeCount: $checkedConvert('likeCount', (v) => (v as num).toInt()),
    authorName: $checkedConvert('authorName', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    mimeType: $checkedConvert('mimeType', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$LessonMaterialToJson(_LessonMaterial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$LessonMaterialTypeEnumMap[instance.type]!,
      'title': instance.title,
      'fileName': instance.fileName,
      'filePath': instance.filePath,
      'fileSize': instance.fileSize,
      'isPublic': instance.isPublic,
      'isAnonymous': instance.isAnonymous,
      'downloadCount': instance.downloadCount,
      'likeCount': instance.likeCount,
      'authorName': instance.authorName,
      'createdAt': instance.createdAt.toIso8601String(),
      'mimeType': instance.mimeType,
    };

const _$LessonMaterialTypeEnumMap = {
  LessonMaterialType.note: 'note',
  LessonMaterialType.board: 'board',
  LessonMaterialType.task: 'task',
  LessonMaterialType.extra: 'extra',
};
