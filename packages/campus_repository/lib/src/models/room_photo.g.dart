// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomPhoto _$RoomPhotoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_RoomPhoto', json, ($checkedConvert) {
      final val = _RoomPhoto(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        path: $checkedConvert('path', (v) => v as String? ?? ''),
        createdBy: $checkedConvert('createdBy', (v) => v as String? ?? ''),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => requiredDateTimeFromJson(v),
        ),
        width: $checkedConvert('width', (v) => (v as num?)?.toInt()),
        height: $checkedConvert('height', (v) => (v as num?)?.toInt()),
        authorName: $checkedConvert('authorName', (v) => v as String? ?? ''),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
        url: $checkedConvert('url', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$RoomPhotoToJson(_RoomPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'createdBy': instance.createdBy,
      'createdAt': requiredDateTimeToJson(instance.createdAt),
      'width': instance.width,
      'height': instance.height,
      'authorName': instance.authorName,
      'isMine': instance.isMine,
      'url': instance.url,
    };
