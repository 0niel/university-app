// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_classrooms_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchClassroomsResponse _$SearchClassroomsResponseFromJson(Map<String, dynamic> json) => SearchClassroomsResponse(
      results: (json['results'] as List<dynamic>).map((e) => Classroom.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$SearchClassroomsResponseToJson(SearchClassroomsResponse instance) => <String, dynamic>{
      'results': instance.results,
    };
