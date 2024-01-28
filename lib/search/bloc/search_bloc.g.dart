// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchState _$SearchStateFromJson(Map<String, dynamic> json) => SearchState(
      groups: SearchGroupsResponse.fromJson(json['groups'] as Map<String, dynamic>),
      teachers: SearchTeachersResponse.fromJson(json['teachers'] as Map<String, dynamic>),
      classrooms: SearchClassroomsResponse.fromJson(json['classrooms'] as Map<String, dynamic>),
      status: $enumDecode(_$SearchStatusEnumMap, json['status']),
      searchHisoty: (json['searchHisoty'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SearchStateToJson(SearchState instance) => <String, dynamic>{
      'groups': instance.groups,
      'teachers': instance.teachers,
      'classrooms': instance.classrooms,
      'searchHisoty': instance.searchHisoty,
      'status': _$SearchStatusEnumMap[instance.status]!,
    };

const _$SearchStatusEnumMap = {
  SearchStatus.initial: 'initial',
  SearchStatus.loading: 'loading',
  SearchStatus.populated: 'populated',
  SearchStatus.failure: 'failure',
};
