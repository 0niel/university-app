// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchItem _$SearchItemFromJson(Map<String, dynamic> json) => SearchItem(
      id: json['id'] as int,
      targetTitle: json['targetTitle'] as String,
      fullTitle: json['fullTitle'] as String,
      scheduleTarget: json['scheduleTarget'] as int,
      iCalLink: json['iCalLink'] as String,
    );

Map<String, dynamic> _$SearchItemToJson(SearchItem instance) => <String, dynamic>{
      'id': instance.id,
      'targetTitle': instance.targetTitle,
      'fullTitle': instance.fullTitle,
      'scheduleTarget': instance.scheduleTarget,
      'iCalLink': instance.iCalLink,
    };
