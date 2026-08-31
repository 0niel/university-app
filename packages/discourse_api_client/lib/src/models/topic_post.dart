import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_post.freezed.dart';
part 'topic_post.g.dart';

int _likeCountFromActions(Object? actionsSummary) {
  if (actionsSummary is! List) return 0;

  for (final action in actionsSummary) {
    if (action case {'id': 2, 'count': final num count}) {
      return count.toInt();
    }
  }

  return 0;
}

/// A post embedded in a Discourse topic's `post_stream`.
@Freezed(toJson: false)
abstract class TopicPost with _$TopicPost {
  const factory TopicPost({
    @JsonKey(defaultValue: 0) required int id,
    @JsonKey(defaultValue: '') required String username,
    @JsonKey(name: 'avatar_template', defaultValue: '')
    required String avatarTemplate,
    @JsonKey(name: 'created_at', defaultValue: '') required String createdAt,
    @JsonKey(defaultValue: '') required String cooked,
    @JsonKey(name: 'post_number', defaultValue: 0) required int postNumber,
    @JsonKey(name: 'actions_summary', fromJson: _likeCountFromActions)
    required int likeCount,
  }) = _TopicPost;

  factory TopicPost.fromJson(Map<String, dynamic> json) =>
      _$TopicPostFromJson(json);
}
