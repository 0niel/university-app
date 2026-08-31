// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_post_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupPostSearchResult _$GroupPostSearchResultFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_GroupPostSearchResult', json, ($checkedConvert) {
  final val = _GroupPostSearchResult(
    id: $checkedConvert('id', (v) => v as String? ?? ''),
    title: $checkedConvert('title', (v) => v as String? ?? ''),
    body: $checkedConvert('body', (v) => v as String? ?? ''),
    kind: $checkedConvert('kind', (v) => v as String? ?? 'note'),
    isPinned: $checkedConvert('isPinned', (v) => v as bool? ?? false),
    authorName: $checkedConvert('authorName', (v) => v as String? ?? ''),
    createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
  );
  return val;
});

Map<String, dynamic> _$GroupPostSearchResultToJson(
  _GroupPostSearchResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'kind': instance.kind,
  'isPinned': instance.isPinned,
  'authorName': instance.authorName,
  'createdAt': dateTimeToJson(instance.createdAt),
};
