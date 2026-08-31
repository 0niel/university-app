// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommunityCatalog _$CommunityCatalogFromJson(Map<String, dynamic> json) =>
    _CommunityCatalog(
      organizationId: json['organizationId'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map(
            (e) => CommunityCatalogSection.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      suggestionUrl: json['suggestionUrl'] as String?,
    );

Map<String, dynamic> _$CommunityCatalogToJson(_CommunityCatalog instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'sections': instance.sections,
      'suggestionUrl': instance.suggestionUrl,
    };
