import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable()
class Topic {
  Topic({
    required this.id,
    required this.title,
    required this.postsCount,
    required this.replyCount,
    required this.highestPostNumber,
    required this.createdAt,
    required this.lastPostedAt,
    required this.bumped,
    required this.bumpedAt,
    required this.archetype,
    required this.unseen,
    required this.lastReadPostNumber,
    required this.unread,
    required this.newPosts,
    required this.unreadPosts,
    required this.pinned,
    required this.excerpt,
    required this.visible,
    required this.closed,
    required this.archived,
    required this.notificationLevel,
    required this.bookmarked,
    required this.liked,
    required this.tags,
    required this.views,
    required this.likeCount,
    required this.hasSummary,
    required this.lastPosterUsername,
    required this.categoryId,
    required this.pinnedGlobally,
    required this.posters,
    this.imageUrl,
    this.unpinned,
    this.tagsDescriptions,
    this.featuredLink,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  final int id;
  final String title;
  @JsonKey(name: 'posts_count')
  final int postsCount;
  @JsonKey(name: 'reply_count')
  final int replyCount;
  @JsonKey(name: 'highest_post_number')
  final int highestPostNumber;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'last_posted_at')
  final String lastPostedAt;
  final bool bumped;
  @JsonKey(name: 'bumped_at')
  final String bumpedAt;
  final String archetype;
  final bool unseen;
  @JsonKey(name: 'last_read_post_number')
  final int? lastReadPostNumber;
  final int? unread;
  @JsonKey(name: 'new_posts')
  final int? newPosts;
  @JsonKey(name: 'unread_posts')
  final int? unreadPosts;
  final bool pinned;
  final dynamic unpinned; // Might need more specific type
  final String? excerpt;
  final bool visible;
  final bool closed;
  final bool archived;
  @JsonKey(name: 'notification_level')
  final int? notificationLevel;
  final bool? bookmarked;
  final bool? liked;
  final List<String> tags;
  @JsonKey(name: 'tags_descriptions')
  final Map<String, dynamic>? tagsDescriptions;
  final int views;
  @JsonKey(name: 'like_count')
  final int likeCount;
  @JsonKey(name: 'has_summary')
  final bool hasSummary;
  @JsonKey(name: 'last_poster_username')
  final String? lastPosterUsername;
  @JsonKey(name: 'category_id')
  final int categoryId;
  @JsonKey(name: 'pinned_globally')
  final bool pinnedGlobally;
  @JsonKey(name: 'featured_link')
  final String? featuredLink;
  final List<Map<String, dynamic>> posters;
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}
