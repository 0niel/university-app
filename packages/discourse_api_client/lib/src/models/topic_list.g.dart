// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicList _$TopicListFromJson(Map<String, dynamic> json) => TopicList(
      canCreateTopic: json['can_create_topic'] as bool,
      forPeriod: json['for_period'] as String,
      perPage: json['per_page'] as int,
      topTags: (json['top_tags'] as List<dynamic>).map((e) => e as String).toList(),
      topics: (json['topics'] as List<dynamic>).map((e) => Topic.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$TopicListToJson(TopicList instance) => <String, dynamic>{
      'can_create_topic': instance.canCreateTopic,
      'for_period': instance.forPeriod,
      'per_page': instance.perPage,
      'top_tags': instance.topTags,
      'topics': instance.topics,
    };
