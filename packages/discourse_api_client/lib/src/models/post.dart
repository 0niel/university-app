import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  Post({
    required this.id,
    required this.username,
    required this.avatarTemplate,
    required this.createdAt,
    required this.cooked,
    required this.postNumber,
    required this.postType,
    required this.updatedAt,
    required this.replyCount,
    required this.replyToPostNumber,
    required this.quoteCount,
    required this.incomingLinkCount,
    required this.reads,
    required this.readersCount,
    required this.score,
    required this.yours,
    required this.topicId,
    required this.topicSlug,
    required this.displayUsername,
    required this.version,
    required this.canEdit,
    required this.canDelete,
    required this.canRecover,
    required this.canSeeHiddenPost,
    required this.canWiki,
    required this.bookmarked,
    required this.raw,
    required this.actionsSummary,
    required this.moderator,
    required this.admin,
    required this.staff,
    required this.userId,
    required this.hidden,
    required this.trustLevel,
    required this.deletedAt,
    required this.userDeleted,
    required this.canViewEditHistory,
    required this.wiki,
    required this.mentionedUsers,
    required this.calendarDetails,
    required this.canManageCategoryExpertPosts,
    required this.ratings,
    required this.reactions,
    required this.reactionUsersCount,
    required this.currentUserUsedMainReaction,
    required this.canAcceptAnswer,
    required this.canUnacceptAnswer,
    required this.acceptedAnswer,
    required this.topicAcceptedAnswer,
    this.name,
    this.primaryGroupName,
    this.flairName,
    this.flairUrl,
    this.flairBgColor,
    this.flairColor,
    this.flairGroupId,
    this.userTitle,
    this.editReason,
    this.reviewableId,
    this.reviewableScoreCount,
    this.reviewableScorePendingCount,
    this.event,
    this.categoryExpertApprovedGroup,
    this.needsCategoryExpertApproval,
    this.userNftVerified,
    this.currentUserReaction,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  final int id;
  final String? name;
  final String username;
  @JsonKey(name: 'avatar_template')
  final String avatarTemplate;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String cooked;
  @JsonKey(name: 'post_number')
  final int postNumber;
  @JsonKey(name: 'post_type')
  final int postType;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'reply_count')
  final int replyCount;
  @JsonKey(name: 'reply_to_post_number')
  final dynamic replyToPostNumber;
  @JsonKey(name: 'quote_count')
  final int quoteCount;
  @JsonKey(name: 'incoming_link_count')
  final int incomingLinkCount;
  final int reads;
  @JsonKey(name: 'readers_count')
  final int readersCount;
  final double score;
  final bool yours;
  @JsonKey(name: 'topic_id')
  final int topicId;
  @JsonKey(name: 'topic_slug')
  final String topicSlug;
  @JsonKey(name: 'display_username')
  final String displayUsername;
  @JsonKey(name: 'primary_group_name')
  final String? primaryGroupName;
  @JsonKey(name: 'flair_name')
  final String? flairName;
  @JsonKey(name: 'flair_url')
  final String? flairUrl;
  @JsonKey(name: 'flair_bg_color')
  final String? flairBgColor;
  @JsonKey(name: 'flair_color')
  final String? flairColor;
  @JsonKey(name: 'flair_group_id')
  final int? flairGroupId;
  final int version;
  @JsonKey(name: 'can_edit')
  final bool canEdit;
  @JsonKey(name: 'can_delete')
  final bool canDelete;
  @JsonKey(name: 'can_recover')
  final bool canRecover;
  @JsonKey(name: 'can_see_hidden_post')
  final bool canSeeHiddenPost;
  @JsonKey(name: 'can_wiki')
  final bool canWiki;
  @JsonKey(name: 'user_title')
  final String? userTitle;
  final bool bookmarked;
  final String raw;
  @JsonKey(name: 'actions_summary')
  final List<dynamic> actionsSummary;
  final bool moderator;
  final bool admin;
  final bool staff;
  @JsonKey(name: 'user_id')
  final int userId;
  final bool hidden;
  @JsonKey(name: 'trust_level')
  final int trustLevel;
  @JsonKey(name: 'deleted_at')
  final dynamic deletedAt;
  @JsonKey(name: 'user_deleted')
  final bool userDeleted;
  @JsonKey(name: 'edit_reason')
  final dynamic editReason;
  @JsonKey(name: 'can_view_edit_history')
  final bool canViewEditHistory;
  final bool wiki;
  @JsonKey(name: 'reviewable_id')
  final dynamic reviewableId;
  @JsonKey(name: 'reviewable_score_count')
  final int? reviewableScoreCount;
  @JsonKey(name: 'reviewable_score_pending_count')
  final int? reviewableScorePendingCount;
  @JsonKey(name: 'mentioned_users')
  final List<dynamic> mentionedUsers;
  final dynamic event;
  @JsonKey(name: 'calendar_details')
  final List<dynamic> calendarDetails;
  @JsonKey(name: 'category_expert_approved_group')
  final dynamic categoryExpertApprovedGroup;
  @JsonKey(name: 'needs_category_expert_approval')
  final dynamic needsCategoryExpertApproval;
  @JsonKey(name: 'can_manage_category_expert_posts')
  final bool canManageCategoryExpertPosts;
  @JsonKey(name: 'user_nft_verified')
  final dynamic userNftVerified;
  final List<dynamic> ratings;
  final List<dynamic> reactions;
  @JsonKey(name: 'current_user_reaction')
  final dynamic currentUserReaction;
  @JsonKey(name: 'reaction_users_count')
  final int reactionUsersCount;
  @JsonKey(name: 'current_user_used_main_reaction')
  final bool currentUserUsedMainReaction;
  @JsonKey(name: 'can_accept_answer')
  final bool canAcceptAnswer;
  @JsonKey(name: 'can_unaccept_answer')
  final bool canUnacceptAnswer;
  @JsonKey(name: 'accepted_answer')
  final bool acceptedAnswer;
  @JsonKey(name: 'topic_accepted_answer')
  final bool topicAcceptedAnswer;

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
