// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_catalog_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommunityCatalogSection _$CommunityCatalogSectionFromJson(
  Map<String, dynamic> json,
) => _CommunityCatalogSection(
  key: json['key'] as String,
  title: json['title'] as String,
  emoji: json['emoji'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CommunityCatalogEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CommunityCatalogSectionToJson(
  _CommunityCatalogSection instance,
) => <String, dynamic>{
  'key': instance.key,
  'title': instance.title,
  'emoji': instance.emoji,
  'items': instance.items,
  'sortOrder': instance.sortOrder,
};
