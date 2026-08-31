import 'package:discourse_api_client/src/models/topic_list.dart';
import 'package:discourse_api_client/src/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'top.freezed.dart';
part 'top.g.dart';

/// Response returned by the Discourse `/top.json` endpoint.
@freezed
abstract class Top with _$Top {
  @JsonSerializable(explicitToJson: true)
  const factory Top({
    required List<User> users,
    @JsonKey(name: 'topic_list') required TopicList topicList,
  }) = _Top;

  factory Top.fromJson(Map<String, dynamic> json) => _$TopFromJson(json);
}
