import 'package:discourse_api_client/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'top.g.dart';

@JsonSerializable()
class Top {
  Top({
    required this.users,
    required this.topicList,
  });

  factory Top.fromJson(Map<String, dynamic> json) => _$TopFromJson(json);
  final List<User> users;
  @JsonKey(name: 'topic_list')
  final TopicList topicList;
  Map<String, dynamic> toJson() => _$TopToJson(this);
}
