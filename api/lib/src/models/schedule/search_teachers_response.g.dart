// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_teachers_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchTeachersResponse _$SearchTeachersResponseFromJson(Map<String, dynamic> json) => SearchTeachersResponse(
      results: (json['results'] as List<dynamic>).map((e) => Teacher.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$SearchTeachersResponseToJson(SearchTeachersResponse instance) => <String, dynamic>{
      'results': instance.results,
    };
