import 'package:discourse_api_client/src/models/topic.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic_list.g.dart';

@JsonSerializable()
class TopicList {
  TopicList({
    required this.canCreateTopic,
    required this.forPeriod,
    required this.perPage,
    required this.topTags,
    required this.topics,
  });

  factory TopicList.fromJson(Map<String, dynamic> json) => _$TopicListFromJson(json);
  @JsonKey(name: 'can_create_topic')
  final bool canCreateTopic;
  @JsonKey(name: 'for_period')
  final String forPeriod;
  @JsonKey(name: 'per_page')
  final int perPage;
  @JsonKey(name: 'top_tags')
  final List<String> topTags;
  final List<Topic> topics;
  Map<String, dynamic> toJson() => _$TopicListToJson(this);
}
