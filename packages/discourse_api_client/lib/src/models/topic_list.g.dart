// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TopicList _$TopicListFromJson(Map<String, dynamic> json) => _TopicList(
  canCreateTopic: json['can_create_topic'] as bool,
  forPeriod: json['for_period'] as String,
  perPage: (json['per_page'] as num).toInt(),
  topTags: json['top_tags'] as List<dynamic>,
  topics: (json['topics'] as List<dynamic>)
      .map((e) => Topic.fromJson(e as Map<String, dynamic>))
      .toList(),
  moreTopicsUrl: json['more_topics_url'] as String?,
);

Map<String, dynamic> _$TopicListToJson(_TopicList instance) =>
    <String, dynamic>{
      'can_create_topic': instance.canCreateTopic,
      'for_period': instance.forPeriod,
      'per_page': instance.perPage,
      'top_tags': instance.topTags,
      'topics': instance.topics.map((e) => e.toJson()).toList(),
      'more_topics_url': instance.moreTopicsUrl,
    };
