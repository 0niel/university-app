// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchState _$SearchStateFromJson(Map<String, dynamic> json) =>
    SearchState(searchHisoty: (json['searchHisoty'] as List<dynamic>?)?.map((e) => e as String).toList());

Map<String, dynamic> _$SearchStateToJson(SearchState instance) => <String, dynamic>{
  'searchHisoty': instance.searchHisoty,
};
