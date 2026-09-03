// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupNote _$GroupNoteFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupNote', json, ($checkedConvert) {
      final val = _GroupNote(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        title: $checkedConvert('title', (v) => v as String? ?? ''),
        authorName: $checkedConvert('authorName', (v) => v as String? ?? ''),
        body: $checkedConvert('body', (v) => v as String? ?? ''),
        createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
        isPinned: $checkedConvert('isPinned', (v) => v as bool? ?? false),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
        likes: $checkedConvert('likes', (v) => (v as num?)?.toInt() ?? 0),
        likedByMe: $checkedConvert('likedByMe', (v) => v as bool? ?? false),
        commentsCount: $checkedConvert(
          'commentsCount',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    });

Map<String, dynamic> _$GroupNoteToJson(_GroupNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authorName': instance.authorName,
      'body': instance.body,
      'createdAt': dateTimeToJson(instance.createdAt),
      'isPinned': instance.isPinned,
      'isMine': instance.isMine,
      'likes': instance.likes,
      'likedByMe': instance.likedByMe,
      'commentsCount': instance.commentsCount,
    };
