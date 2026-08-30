import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

/// A topic embedded in a Discourse listing response.
@freezed
abstract class Topic with _$Topic {
  const factory Topic({
    required int id,
    required String title,
    @JsonKey(name: 'posts_count') required int postsCount,
    @JsonKey(name: 'reply_count') required int replyCount,
    @JsonKey(name: 'highest_post_number') required int highestPostNumber,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'last_posted_at') required String lastPostedAt,
    required bool bumped,
    @JsonKey(name: 'bumped_at') required String bumpedAt,
    required String archetype,
    required bool unseen,
    @JsonKey(name: 'last_read_post_number') required int? lastReadPostNumber,
    required int? unread,
    @JsonKey(name: 'new_posts') required int? newPosts,
    @JsonKey(name: 'unread_posts') required int? unreadPosts,
    required bool pinned,
    required String? excerpt,
    required bool visible,
    required bool closed,
    required bool archived,
    @JsonKey(name: 'notification_level') required int? notificationLevel,
    required bool? bookmarked,
    required bool? liked,
    required List<Object?> tags,
    required int views,
    @JsonKey(name: 'like_count') required int likeCount,
    @JsonKey(name: 'has_summary') required bool hasSummary,
    @JsonKey(name: 'last_poster_username') required String? lastPosterUsername,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'pinned_globally') required bool pinnedGlobally,
    required List<Map<String, dynamic>> posters,
    @JsonKey(name: 'image_url') String? imageUrl,
    Object? unpinned,
    @JsonKey(name: 'tags_descriptions') Map<String, dynamic>? tagsDescriptions,
    @JsonKey(name: 'featured_link') String? featuredLink,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
