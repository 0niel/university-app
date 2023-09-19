// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupsResponse _$GroupsResponseFromJson(Map<String, dynamic> json) =>
    GroupsResponse(
      count: json['count'] as int,
      groups:
          (json['groups'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GroupsResponseToJson(GroupsResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'groups': instance.groups,
    };
