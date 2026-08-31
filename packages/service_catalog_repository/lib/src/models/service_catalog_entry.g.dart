// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_catalog_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceCatalogEntry _$ServiceCatalogEntryFromJson(Map<String, dynamic> json) =>
    _ServiceCatalogEntry(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      iconKey: json['iconKey'] as String,
      colorKey: json['colorKey'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      emoji: json['emoji'] as String?,
    );

Map<String, dynamic> _$ServiceCatalogEntryToJson(
  _ServiceCatalogEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'title': instance.title,
  'description': instance.description,
  'url': instance.url,
  'iconKey': instance.iconKey,
  'colorKey': instance.colorKey,
  'sortOrder': instance.sortOrder,
  'emoji': instance.emoji,
};
