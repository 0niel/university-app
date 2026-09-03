// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupAnnouncement _$GroupAnnouncementFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupAnnouncement', json, ($checkedConvert) {
      final val = _GroupAnnouncement(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        title: $checkedConvert('title', (v) => v as String? ?? ''),
        body: $checkedConvert('body', (v) => v as String? ?? ''),
        authorName: $checkedConvert('authorName', (v) => v as String? ?? ''),
        createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
        commentsCount: $checkedConvert(
          'commentsCount',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    });

Map<String, dynamic> _$GroupAnnouncementToJson(_GroupAnnouncement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'authorName': instance.authorName,
      'createdAt': dateTimeToJson(instance.createdAt),
      'isMine': instance.isMine,
      'commentsCount': instance.commentsCount,
    };
