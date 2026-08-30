// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupLink _$GroupLinkFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GroupLink', json, ($checkedConvert) {
      final val = _GroupLink(
        id: $checkedConvert('id', (v) => v as String? ?? ''),
        title: $checkedConvert('title', (v) => v as String? ?? ''),
        url: $checkedConvert('url', (v) => v as String? ?? ''),
        emoji: $checkedConvert('emoji', (v) => v as String? ?? '🔗'),
        kind: $checkedConvert('kind', (v) => v as String? ?? 'link'),
        addedBy: $checkedConvert('addedBy', (v) => v as String? ?? ''),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$GroupLinkToJson(_GroupLink instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'emoji': instance.emoji,
      'kind': instance.kind,
      'addedBy': instance.addedBy,
      'isMine': instance.isMine,
    };
