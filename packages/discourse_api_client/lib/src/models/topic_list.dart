import 'package:discourse_api_client/src/models/topic.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_list.freezed.dart';
part 'topic_list.g.dart';

/// A page of topics returned by a Discourse listing endpoint.
@freezed
abstract class TopicList with _$TopicList {
  @JsonSerializable(explicitToJson: true)
  const factory TopicList({
    @JsonKey(name: 'can_create_topic') required bool canCreateTopic,
    @JsonKey(name: 'for_period') required String forPeriod,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'top_tags') required List<Object?> topTags,
    required List<Topic> topics,
  }) = _TopicList;

  factory TopicList.fromJson(Map<String, dynamic> json) =>
      _$TopicListFromJson(json);
}
