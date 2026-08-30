// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceCatalog _$ServiceCatalogFromJson(Map<String, dynamic> json) =>
    _ServiceCatalog(
      organizationId: json['organizationId'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => ServiceCatalogSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ServiceCatalogToJson(_ServiceCatalog instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'sections': instance.sections,
    };
