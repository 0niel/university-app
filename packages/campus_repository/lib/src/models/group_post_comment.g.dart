// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_post_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupPostComment _$GroupPostCommentFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupPostComment', json, ($checkedConvert) {
      final val = _GroupPostComment(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        postId: $checkedConvert('postId', (v) => v as String? ?? ''),
        body: $checkedConvert('body', (v) => v as String? ?? ''),
        authorName: $checkedConvert('authorName', (v) => v as String? ?? ''),
        createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
        canDelete: $checkedConvert('canDelete', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$GroupPostCommentToJson(_GroupPostComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'body': instance.body,
      'authorName': instance.authorName,
      'createdAt': dateTimeToJson(instance.createdAt),
      'isMine': instance.isMine,
      'canDelete': instance.canDelete,
    };
