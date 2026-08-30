// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchData _$SearchDataFromJson(Map<String, dynamic> json) => _SearchData(
  data: (json['data'] as List<dynamic>)
      .map((e) => SearchItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SearchDataToJson(_SearchData instance) =>
    <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
