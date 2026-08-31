// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_catalog_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceCatalogSection _$ServiceCatalogSectionFromJson(
  Map<String, dynamic> json,
) => _ServiceCatalogSection(
  key: json['key'] as String,
  title: json['title'] as String,
  sortOrder: (json['sortOrder'] as num).toInt(),
  items: (json['items'] as List<dynamic>)
      .map((e) => ServiceCatalogEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ServiceCatalogSectionToJson(
  _ServiceCatalogSection instance,
) => <String, dynamic>{
  'key': instance.key,
  'title': instance.title,
  'sortOrder': instance.sortOrder,
  'items': instance.items,
};
