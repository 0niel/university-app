// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchData _$SearchDataFromJson(Map<String, dynamic> json) => SearchData(
      data: (json['data'] as List<dynamic>).map((e) => SearchItem.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$SearchDataToJson(SearchData instance) => <String, dynamic>{
      'data': instance.data,
    };
