import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

/// A post returned by the Discourse `/posts/{id}.json` endpoint.
@freezed
abstract class Post with _$Post {
  const factory Post({
    required int id,
    required String username,
    @JsonKey(name: 'avatar_template') required String avatarTemplate,
    @JsonKey(name: 'created_at') required String createdAt,
    required String cooked,
    @JsonKey(name: 'post_number') required int postNumber,
    @JsonKey(name: 'post_type') required int postType,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'reply_count') required int replyCount,
    @JsonKey(name: 'reply_to_post_number') required Object? replyToPostNumber,
    @JsonKey(name: 'quote_count') required int quoteCount,
    @JsonKey(name: 'incoming_link_count') required int incomingLinkCount,
    required int reads,
    @JsonKey(name: 'readers_count') required int readersCount,
    required double score,
    required bool yours,
    @JsonKey(name: 'topic_id') required int topicId,
    @JsonKey(name: 'topic_slug') required String topicSlug,
    @JsonKey(name: 'display_username') required String displayUsername,
    required int version,
    @JsonKey(name: 'can_edit') required bool canEdit,
    @JsonKey(name: 'can_delete') required bool canDelete,
    @JsonKey(name: 'can_recover') required bool canRecover,
    @JsonKey(name: 'can_see_hidden_post') required bool canSeeHiddenPost,
    @JsonKey(name: 'can_wiki') required bool canWiki,
    required bool bookmarked,
    required String raw,
    @JsonKey(name: 'actions_summary') required List<Object?> actionsSummary,
    required bool moderator,
    required bool admin,
    required bool staff,
    @JsonKey(name: 'user_id') required int userId,
    required bool hidden,
    @JsonKey(name: 'trust_level') required int trustLevel,
    @JsonKey(name: 'deleted_at') required Object? deletedAt,
    @JsonKey(name: 'user_deleted') required bool userDeleted,
    @JsonKey(name: 'can_view_edit_history') required bool canViewEditHistory,
    required bool wiki,
    @JsonKey(name: 'mentioned_users') required List<Object?> mentionedUsers,
    @JsonKey(name: 'calendar_details') required List<Object?> calendarDetails,
    @JsonKey(name: 'can_manage_category_expert_posts')
    required bool canManageCategoryExpertPosts,
    required List<Object?> ratings,
    required List<Object?> reactions,
    @JsonKey(name: 'reaction_users_count') required int reactionUsersCount,
    @JsonKey(name: 'current_user_used_main_reaction')
    required bool currentUserUsedMainReaction,
    @JsonKey(name: 'can_accept_answer') required bool canAcceptAnswer,
    @JsonKey(name: 'can_unaccept_answer') required bool canUnacceptAnswer,
    @JsonKey(name: 'accepted_answer') required bool acceptedAnswer,
    @JsonKey(name: 'topic_accepted_answer') required bool topicAcceptedAnswer,
    String? name,
    @JsonKey(name: 'primary_group_name') String? primaryGroupName,
    @JsonKey(name: 'flair_name') String? flairName,
    @JsonKey(name: 'flair_url') String? flairUrl,
    @JsonKey(name: 'flair_bg_color') String? flairBgColor,
    @JsonKey(name: 'flair_color') String? flairColor,
    @JsonKey(name: 'flair_group_id') int? flairGroupId,
    @JsonKey(name: 'user_title') String? userTitle,
    @JsonKey(name: 'edit_reason') Object? editReason,
    @JsonKey(name: 'reviewable_id') Object? reviewableId,
    @JsonKey(name: 'reviewable_score_count') int? reviewableScoreCount,
    @JsonKey(name: 'reviewable_score_pending_count')
    int? reviewableScorePendingCount,
    Object? event,
    @JsonKey(name: 'category_expert_approved_group')
    Object? categoryExpertApprovedGroup,
    @JsonKey(name: 'needs_category_expert_approval')
    Object? needsCategoryExpertApproval,
    @JsonKey(name: 'user_nft_verified') Object? userNftVerified,
    @JsonKey(name: 'current_user_reaction') Object? currentUserReaction,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
