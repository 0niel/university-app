// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_groups_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchGroupsResponse _$SearchGroupsResponseFromJson(Map<String, dynamic> json) => SearchGroupsResponse(
      results: (json['results'] as List<dynamic>).map((e) => Group.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$SearchGroupsResponseToJson(SearchGroupsResponse instance) => <String, dynamic>{
      'results': instance.results,
    };
