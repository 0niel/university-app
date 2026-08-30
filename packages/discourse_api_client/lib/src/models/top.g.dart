// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Top _$TopFromJson(Map<String, dynamic> json) => _Top(
  users: (json['users'] as List<dynamic>)
      .map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList(),
  topicList: TopicList.fromJson(json['topic_list'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TopToJson(_Top instance) => <String, dynamic>{
  'users': instance.users.map((e) => e.toJson()).toList(),
  'topic_list': instance.topicList.toJson(),
};
