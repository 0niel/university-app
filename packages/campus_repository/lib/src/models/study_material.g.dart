// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_material.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudyMaterial _$StudyMaterialFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_StudyMaterial', json, ($checkedConvert) {
      final val = _StudyMaterial(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        title: $checkedConvert('title', (v) => v as String? ?? ''),
        subjectName: $checkedConvert('subjectName', (v) => v as String? ?? ''),
        materialType: $checkedConvert(
          'materialType',
          (v) => v as String? ?? 'note',
        ),
        downloads: $checkedConvert(
          'downloads',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        likes: $checkedConvert('likes', (v) => (v as num?)?.toInt() ?? 0),
        price: $checkedConvert('price', (v) => (v as num?)?.toInt() ?? 0),
        pages: $checkedConvert('pages', (v) => (v as num?)?.toInt() ?? 0),
        authorName: $checkedConvert('authorName', (v) => v as String? ?? ''),
        fileName: $checkedConvert('fileName', (v) => v as String? ?? ''),
        mimeType: $checkedConvert('mimeType', (v) => v as String? ?? ''),
        fileSize: $checkedConvert('fileSize', (v) => (v as num?)?.toInt() ?? 0),
        hasFile: $checkedConvert('hasFile', (v) => v as bool? ?? false),
        requiresRepublish: $checkedConvert(
          'requiresRepublish',
          (v) => v as bool? ?? false,
        ),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
        createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$StudyMaterialToJson(_StudyMaterial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subjectName': instance.subjectName,
      'materialType': instance.materialType,
      'downloads': instance.downloads,
      'likes': instance.likes,
      'price': instance.price,
      'pages': instance.pages,
      'authorName': instance.authorName,
      'fileName': instance.fileName,
      'mimeType': instance.mimeType,
      'fileSize': instance.fileSize,
      'hasFile': instance.hasFile,
      'requiresRepublish': instance.requiresRepublish,
      'isMine': instance.isMine,
      'createdAt': dateTimeToJson(instance.createdAt),
    };

_MaterialAuthor _$MaterialAuthorFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MaterialAuthor', json, ($checkedConvert) {
  final val = _MaterialAuthor(
    name: $checkedConvert('name', (v) => v as String? ?? ''),
    downloads: $checkedConvert('downloads', (v) => (v as num?)?.toInt() ?? 0),
    materials: $checkedConvert('materials', (v) => (v as num?)?.toInt() ?? 0),
  );
  return val;
});

Map<String, dynamic> _$MaterialAuthorToJson(_MaterialAuthor instance) =>
    <String, dynamic>{
      'name': instance.name,
      'downloads': instance.downloads,
      'materials': instance.materials,
    };
