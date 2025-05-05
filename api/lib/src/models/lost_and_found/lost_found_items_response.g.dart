// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lost_found_items_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LostFoundItemsResponse _$LostFoundItemsResponseFromJson(
        Map<String, dynamic> json) =>
    LostFoundItemsResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => LostFoundItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LostFoundItemsResponseToJson(
        LostFoundItemsResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
