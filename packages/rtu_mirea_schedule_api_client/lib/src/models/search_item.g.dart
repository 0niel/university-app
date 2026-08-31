// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchItem _$SearchItemFromJson(Map<String, dynamic> json) => _SearchItem(
  id: (json['id'] as num).toInt(),
  targetTitle: json['targetTitle'] as String,
  fullTitle: json['fullTitle'] as String,
  scheduleTarget: (json['scheduleTarget'] as num).toInt(),
  iCalLink: json['iCalLink'] as String,
);

Map<String, dynamic> _$SearchItemToJson(_SearchItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'targetTitle': instance.targetTitle,
      'fullTitle': instance.fullTitle,
      'scheduleTarget': instance.scheduleTarget,
      'iCalLink': instance.iCalLink,
    };
