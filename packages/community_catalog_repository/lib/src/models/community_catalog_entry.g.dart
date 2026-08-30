// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_catalog_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommunityCatalogEntry _$CommunityCatalogEntryFromJson(
  Map<String, dynamic> json,
) => _CommunityCatalogEntry(
  id: json['id'] as String,
  slug: json['slug'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  url: json['url'] as String,
  platform: json['platform'] as String,
  logoUrl: json['logoUrl'] as String?,
  membersCount: (json['membersCount'] as num?)?.toInt(),
  membersCountUpdatedAt: json['membersCountUpdatedAt'] == null
      ? null
      : DateTime.parse(json['membersCountUpdatedAt'] as String),
  isFeatured: json['isFeatured'] as bool? ?? false,
  isOfficial: json['isOfficial'] as bool? ?? false,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CommunityCatalogEntryToJson(
  _CommunityCatalogEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'title': instance.title,
  'description': instance.description,
  'url': instance.url,
  'platform': instance.platform,
  'logoUrl': instance.logoUrl,
  'membersCount': instance.membersCount,
  'membersCountUpdatedAt': instance.membersCountUpdatedAt?.toIso8601String(),
  'isFeatured': instance.isFeatured,
  'isOfficial': instance.isOfficial,
  'sortOrder': instance.sortOrder,
};
