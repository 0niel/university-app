// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Post {

 int get id; String get username;@JsonKey(name: 'avatar_template') String get avatarTemplate;@JsonKey(name: 'created_at') String get createdAt; String get cooked;@JsonKey(name: 'post_number') int get postNumber;@JsonKey(name: 'post_type') int get postType;@JsonKey(name: 'updated_at') String get updatedAt;@JsonKey(name: 'reply_count') int get replyCount;@JsonKey(name: 'reply_to_post_number') Object? get replyToPostNumber;@JsonKey(name: 'quote_count') int get quoteCount;@JsonKey(name: 'incoming_link_count') int get incomingLinkCount; int get reads;@JsonKey(name: 'readers_count') int get readersCount; double get score; bool get yours;@JsonKey(name: 'topic_id') int get topicId;@JsonKey(name: 'topic_slug') String get topicSlug;@JsonKey(name: 'display_username') String get displayUsername; int get version;@JsonKey(name: 'can_edit') bool get canEdit;@JsonKey(name: 'can_delete') bool get canDelete;@JsonKey(name: 'can_recover') bool get canRecover;@JsonKey(name: 'can_see_hidden_post') bool get canSeeHiddenPost;@JsonKey(name: 'can_wiki') bool get canWiki; bool get bookmarked; String get raw;@JsonKey(name: 'actions_summary') List<Object?> get actionsSummary; bool get moderator; bool get admin; bool get staff;@JsonKey(name: 'user_id') int get userId; bool get hidden;@JsonKey(name: 'trust_level') int get trustLevel;@JsonKey(name: 'deleted_at') Object? get deletedAt;@JsonKey(name: 'user_deleted') bool get userDeleted;@JsonKey(name: 'can_view_edit_history') bool get canViewEditHistory; bool get wiki;@JsonKey(name: 'mentioned_users') List<Object?> get mentionedUsers;@JsonKey(name: 'calendar_details') List<Object?> get calendarDetails;@JsonKey(name: 'can_manage_category_expert_posts') bool get canManageCategoryExpertPosts; List<Object?> get ratings; List<Object?> get reactions;@JsonKey(name: 'reaction_users_count') int get reactionUsersCount;@JsonKey(name: 'current_user_used_main_reaction') bool get currentUserUsedMainReaction;@JsonKey(name: 'can_accept_answer') bool get canAcceptAnswer;@JsonKey(name: 'can_unaccept_answer') bool get canUnacceptAnswer;@JsonKey(name: 'accepted_answer') bool get acceptedAnswer;@JsonKey(name: 'topic_accepted_answer') bool get topicAcceptedAnswer; String? get name;@JsonKey(name: 'primary_group_name') String? get primaryGroupName;@JsonKey(name: 'flair_name') String? get flairName;@JsonKey(name: 'flair_url') String? get flairUrl;@JsonKey(name: 'flair_bg_color') String? get flairBgColor;@JsonKey(name: 'flair_color') String? get flairColor;@JsonKey(name: 'flair_group_id') int? get flairGroupId;@JsonKey(name: 'user_title') String? get userTitle;@JsonKey(name: 'edit_reason') Object? get editReason;@JsonKey(name: 'reviewable_id') Object? get reviewableId;@JsonKey(name: 'reviewable_score_count') int? get reviewableScoreCount;@JsonKey(name: 'reviewable_score_pending_count') int? get reviewableScorePendingCount; Object? get event;@JsonKey(name: 'category_expert_approved_group') Object? get categoryExpertApprovedGroup;@JsonKey(name: 'needs_category_expert_approval') Object? get needsCategoryExpertApproval;@JsonKey(name: 'user_nft_verified') Object? get userNftVerified;@JsonKey(name: 'current_user_reaction') Object? get currentUserReaction;
/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostCopyWith<Post> get copyWith => _$PostCopyWithImpl<Post>(this as Post, _$identity);

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Post&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.cooked, cooked) || other.cooked == cooked)&&(identical(other.postNumber, postNumber) || other.postNumber == postNumber)&&(identical(other.postType, postType) || other.postType == postType)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&const DeepCollectionEquality().equals(other.replyToPostNumber, replyToPostNumber)&&(identical(other.quoteCount, quoteCount) || other.quoteCount == quoteCount)&&(identical(other.incomingLinkCount, incomingLinkCount) || other.incomingLinkCount == incomingLinkCount)&&(identical(other.reads, reads) || other.reads == reads)&&(identical(other.readersCount, readersCount) || other.readersCount == readersCount)&&(identical(other.score, score) || other.score == score)&&(identical(other.yours, yours) || other.yours == yours)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.topicSlug, topicSlug) || other.topicSlug == topicSlug)&&(identical(other.displayUsername, displayUsername) || other.displayUsername == displayUsername)&&(identical(other.version, version) || other.version == version)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.canRecover, canRecover) || other.canRecover == canRecover)&&(identical(other.canSeeHiddenPost, canSeeHiddenPost) || other.canSeeHiddenPost == canSeeHiddenPost)&&(identical(other.canWiki, canWiki) || other.canWiki == canWiki)&&(identical(other.bookmarked, bookmarked) || other.bookmarked == bookmarked)&&(identical(other.raw, raw) || other.raw == raw)&&const DeepCollectionEquality().equals(other.actionsSummary, actionsSummary)&&(identical(other.moderator, moderator) || other.moderator == moderator)&&(identical(other.admin, admin) || other.admin == admin)&&(identical(other.staff, staff) || other.staff == staff)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.hidden, hidden) || other.hidden == hidden)&&(identical(other.trustLevel, trustLevel) || other.trustLevel == trustLevel)&&const DeepCollectionEquality().equals(other.deletedAt, deletedAt)&&(identical(other.userDeleted, userDeleted) || other.userDeleted == userDeleted)&&(identical(other.canViewEditHistory, canViewEditHistory) || other.canViewEditHistory == canViewEditHistory)&&(identical(other.wiki, wiki) || other.wiki == wiki)&&const DeepCollectionEquality().equals(other.mentionedUsers, mentionedUsers)&&const DeepCollectionEquality().equals(other.calendarDetails, calendarDetails)&&(identical(other.canManageCategoryExpertPosts, canManageCategoryExpertPosts) || other.canManageCategoryExpertPosts == canManageCategoryExpertPosts)&&const DeepCollectionEquality().equals(other.ratings, ratings)&&const DeepCollectionEquality().equals(other.reactions, reactions)&&(identical(other.reactionUsersCount, reactionUsersCount) || other.reactionUsersCount == reactionUsersCount)&&(identical(other.currentUserUsedMainReaction, currentUserUsedMainReaction) || other.currentUserUsedMainReaction == currentUserUsedMainReaction)&&(identical(other.canAcceptAnswer, canAcceptAnswer) || other.canAcceptAnswer == canAcceptAnswer)&&(identical(other.canUnacceptAnswer, canUnacceptAnswer) || other.canUnacceptAnswer == canUnacceptAnswer)&&(identical(other.acceptedAnswer, acceptedAnswer) || other.acceptedAnswer == acceptedAnswer)&&(identical(other.topicAcceptedAnswer, topicAcceptedAnswer) || other.topicAcceptedAnswer == topicAcceptedAnswer)&&(identical(other.name, name) || other.name == name)&&(identical(other.primaryGroupName, primaryGroupName) || other.primaryGroupName == primaryGroupName)&&(identical(other.flairName, flairName) || other.flairName == flairName)&&(identical(other.flairUrl, flairUrl) || other.flairUrl == flairUrl)&&(identical(other.flairBgColor, flairBgColor) || other.flairBgColor == flairBgColor)&&(identical(other.flairColor, flairColor) || other.flairColor == flairColor)&&(identical(other.flairGroupId, flairGroupId) || other.flairGroupId == flairGroupId)&&(identical(other.userTitle, userTitle) || other.userTitle == userTitle)&&const DeepCollectionEquality().equals(other.editReason, editReason)&&const DeepCollectionEquality().equals(other.reviewableId, reviewableId)&&(identical(other.reviewableScoreCount, reviewableScoreCount) || other.reviewableScoreCount == reviewableScoreCount)&&(identical(other.reviewableScorePendingCount, reviewableScorePendingCount) || other.reviewableScorePendingCount == reviewableScorePendingCount)&&const DeepCollectionEquality().equals(other.event, event)&&const DeepCollectionEquality().equals(other.categoryExpertApprovedGroup, categoryExpertApprovedGroup)&&const DeepCollectionEquality().equals(other.needsCategoryExpertApproval, needsCategoryExpertApproval)&&const DeepCollectionEquality().equals(other.userNftVerified, userNftVerified)&&const DeepCollectionEquality().equals(other.currentUserReaction, currentUserReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,avatarTemplate,createdAt,cooked,postNumber,postType,updatedAt,replyCount,const DeepCollectionEquality().hash(replyToPostNumber),quoteCount,incomingLinkCount,reads,readersCount,score,yours,topicId,topicSlug,displayUsername,version,canEdit,canDelete,canRecover,canSeeHiddenPost,canWiki,bookmarked,raw,const DeepCollectionEquality().hash(actionsSummary),moderator,admin,staff,userId,hidden,trustLevel,const DeepCollectionEquality().hash(deletedAt),userDeleted,canViewEditHistory,wiki,const DeepCollectionEquality().hash(mentionedUsers),const DeepCollectionEquality().hash(calendarDetails),canManageCategoryExpertPosts,const DeepCollectionEquality().hash(ratings),const DeepCollectionEquality().hash(reactions),reactionUsersCount,currentUserUsedMainReaction,canAcceptAnswer,canUnacceptAnswer,acceptedAnswer,topicAcceptedAnswer,name,primaryGroupName,flairName,flairUrl,flairBgColor,flairColor,flairGroupId,userTitle,const DeepCollectionEquality().hash(editReason),const DeepCollectionEquality().hash(reviewableId),reviewableScoreCount,reviewableScorePendingCount,const DeepCollectionEquality().hash(event),const DeepCollectionEquality().hash(categoryExpertApprovedGroup),const DeepCollectionEquality().hash(needsCategoryExpertApproval),const DeepCollectionEquality().hash(userNftVerified),const DeepCollectionEquality().hash(currentUserReaction)]);

@override
String toString() {
  return 'Post(id: $id, username: $username, avatarTemplate: $avatarTemplate, createdAt: $createdAt, cooked: $cooked, postNumber: $postNumber, postType: $postType, updatedAt: $updatedAt, replyCount: $replyCount, replyToPostNumber: $replyToPostNumber, quoteCount: $quoteCount, incomingLinkCount: $incomingLinkCount, reads: $reads, readersCount: $readersCount, score: $score, yours: $yours, topicId: $topicId, topicSlug: $topicSlug, displayUsername: $displayUsername, version: $version, canEdit: $canEdit, canDelete: $canDelete, canRecover: $canRecover, canSeeHiddenPost: $canSeeHiddenPost, canWiki: $canWiki, bookmarked: $bookmarked, raw: $raw, actionsSummary: $actionsSummary, moderator: $moderator, admin: $admin, staff: $staff, userId: $userId, hidden: $hidden, trustLevel: $trustLevel, deletedAt: $deletedAt, userDeleted: $userDeleted, canViewEditHistory: $canViewEditHistory, wiki: $wiki, mentionedUsers: $mentionedUsers, calendarDetails: $calendarDetails, canManageCategoryExpertPosts: $canManageCategoryExpertPosts, ratings: $ratings, reactions: $reactions, reactionUsersCount: $reactionUsersCount, currentUserUsedMainReaction: $currentUserUsedMainReaction, canAcceptAnswer: $canAcceptAnswer, canUnacceptAnswer: $canUnacceptAnswer, acceptedAnswer: $acceptedAnswer, topicAcceptedAnswer: $topicAcceptedAnswer, name: $name, primaryGroupName: $primaryGroupName, flairName: $flairName, flairUrl: $flairUrl, flairBgColor: $flairBgColor, flairColor: $flairColor, flairGroupId: $flairGroupId, userTitle: $userTitle, editReason: $editReason, reviewableId: $reviewableId, reviewableScoreCount: $reviewableScoreCount, reviewableScorePendingCount: $reviewableScorePendingCount, event: $event, categoryExpertApprovedGroup: $categoryExpertApprovedGroup, needsCategoryExpertApproval: $needsCategoryExpertApproval, userNftVerified: $userNftVerified, currentUserReaction: $currentUserReaction)';
}


}

/// @nodoc
abstract mixin class $PostCopyWith<$Res>  {
  factory $PostCopyWith(Post value, $Res Function(Post) _then) = _$PostCopyWithImpl;
@useResult
$Res call({
 int id, String username,@JsonKey(name: 'avatar_template') String avatarTemplate,@JsonKey(name: 'created_at') String createdAt, String cooked,@JsonKey(name: 'post_number') int postNumber,@JsonKey(name: 'post_type') int postType,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'reply_count') int replyCount,@JsonKey(name: 'reply_to_post_number') Object? replyToPostNumber,@JsonKey(name: 'quote_count') int quoteCount,@JsonKey(name: 'incoming_link_count') int incomingLinkCount, int reads,@JsonKey(name: 'readers_count') int readersCount, double score, bool yours,@JsonKey(name: 'topic_id') int topicId,@JsonKey(name: 'topic_slug') String topicSlug,@JsonKey(name: 'display_username') String displayUsername, int version,@JsonKey(name: 'can_edit') bool canEdit,@JsonKey(name: 'can_delete') bool canDelete,@JsonKey(name: 'can_recover') bool canRecover,@JsonKey(name: 'can_see_hidden_post') bool canSeeHiddenPost,@JsonKey(name: 'can_wiki') bool canWiki, bool bookmarked, String raw,@JsonKey(name: 'actions_summary') List<Object?> actionsSummary, bool moderator, bool admin, bool staff,@JsonKey(name: 'user_id') int userId, bool hidden,@JsonKey(name: 'trust_level') int trustLevel,@JsonKey(name: 'deleted_at') Object? deletedAt,@JsonKey(name: 'user_deleted') bool userDeleted,@JsonKey(name: 'can_view_edit_history') bool canViewEditHistory, bool wiki,@JsonKey(name: 'mentioned_users') List<Object?> mentionedUsers,@JsonKey(name: 'calendar_details') List<Object?> calendarDetails,@JsonKey(name: 'can_manage_category_expert_posts') bool canManageCategoryExpertPosts, List<Object?> ratings, List<Object?> reactions,@JsonKey(name: 'reaction_users_count') int reactionUsersCount,@JsonKey(name: 'current_user_used_main_reaction') bool currentUserUsedMainReaction,@JsonKey(name: 'can_accept_answer') bool canAcceptAnswer,@JsonKey(name: 'can_unaccept_answer') bool canUnacceptAnswer,@JsonKey(name: 'accepted_answer') bool acceptedAnswer,@JsonKey(name: 'topic_accepted_answer') bool topicAcceptedAnswer, String? name,@JsonKey(name: 'primary_group_name') String? primaryGroupName,@JsonKey(name: 'flair_name') String? flairName,@JsonKey(name: 'flair_url') String? flairUrl,@JsonKey(name: 'flair_bg_color') String? flairBgColor,@JsonKey(name: 'flair_color') String? flairColor,@JsonKey(name: 'flair_group_id') int? flairGroupId,@JsonKey(name: 'user_title') String? userTitle,@JsonKey(name: 'edit_reason') Object? editReason,@JsonKey(name: 'reviewable_id') Object? reviewableId,@JsonKey(name: 'reviewable_score_count') int? reviewableScoreCount,@JsonKey(name: 'reviewable_score_pending_count') int? reviewableScorePendingCount, Object? event,@JsonKey(name: 'category_expert_approved_group') Object? categoryExpertApprovedGroup,@JsonKey(name: 'needs_category_expert_approval') Object? needsCategoryExpertApproval,@JsonKey(name: 'user_nft_verified') Object? userNftVerified,@JsonKey(name: 'current_user_reaction') Object? currentUserReaction
});




}
/// @nodoc
class _$PostCopyWithImpl<$Res>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._self, this._then);

  final Post _self;
  final $Res Function(Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatarTemplate = null,Object? createdAt = null,Object? cooked = null,Object? postNumber = null,Object? postType = null,Object? updatedAt = null,Object? replyCount = null,Object? replyToPostNumber = freezed,Object? quoteCount = null,Object? incomingLinkCount = null,Object? reads = null,Object? readersCount = null,Object? score = null,Object? yours = null,Object? topicId = null,Object? topicSlug = null,Object? displayUsername = null,Object? version = null,Object? canEdit = null,Object? canDelete = null,Object? canRecover = null,Object? canSeeHiddenPost = null,Object? canWiki = null,Object? bookmarked = null,Object? raw = null,Object? actionsSummary = null,Object? moderator = null,Object? admin = null,Object? staff = null,Object? userId = null,Object? hidden = null,Object? trustLevel = null,Object? deletedAt = freezed,Object? userDeleted = null,Object? canViewEditHistory = null,Object? wiki = null,Object? mentionedUsers = null,Object? calendarDetails = null,Object? canManageCategoryExpertPosts = null,Object? ratings = null,Object? reactions = null,Object? reactionUsersCount = null,Object? currentUserUsedMainReaction = null,Object? canAcceptAnswer = null,Object? canUnacceptAnswer = null,Object? acceptedAnswer = null,Object? topicAcceptedAnswer = null,Object? name = freezed,Object? primaryGroupName = freezed,Object? flairName = freezed,Object? flairUrl = freezed,Object? flairBgColor = freezed,Object? flairColor = freezed,Object? flairGroupId = freezed,Object? userTitle = freezed,Object? editReason = freezed,Object? reviewableId = freezed,Object? reviewableScoreCount = freezed,Object? reviewableScorePendingCount = freezed,Object? event = freezed,Object? categoryExpertApprovedGroup = freezed,Object? needsCategoryExpertApproval = freezed,Object? userNftVerified = freezed,Object? currentUserReaction = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,cooked: null == cooked ? _self.cooked : cooked // ignore: cast_nullable_to_non_nullable
as String,postNumber: null == postNumber ? _self.postNumber : postNumber // ignore: cast_nullable_to_non_nullable
as int,postType: null == postType ? _self.postType : postType // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,replyToPostNumber: freezed == replyToPostNumber ? _self.replyToPostNumber : replyToPostNumber ,quoteCount: null == quoteCount ? _self.quoteCount : quoteCount // ignore: cast_nullable_to_non_nullable
as int,incomingLinkCount: null == incomingLinkCount ? _self.incomingLinkCount : incomingLinkCount // ignore: cast_nullable_to_non_nullable
as int,reads: null == reads ? _self.reads : reads // ignore: cast_nullable_to_non_nullable
as int,readersCount: null == readersCount ? _self.readersCount : readersCount // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,yours: null == yours ? _self.yours : yours // ignore: cast_nullable_to_non_nullable
as bool,topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as int,topicSlug: null == topicSlug ? _self.topicSlug : topicSlug // ignore: cast_nullable_to_non_nullable
as String,displayUsername: null == displayUsername ? _self.displayUsername : displayUsername // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,canRecover: null == canRecover ? _self.canRecover : canRecover // ignore: cast_nullable_to_non_nullable
as bool,canSeeHiddenPost: null == canSeeHiddenPost ? _self.canSeeHiddenPost : canSeeHiddenPost // ignore: cast_nullable_to_non_nullable
as bool,canWiki: null == canWiki ? _self.canWiki : canWiki // ignore: cast_nullable_to_non_nullable
as bool,bookmarked: null == bookmarked ? _self.bookmarked : bookmarked // ignore: cast_nullable_to_non_nullable
as bool,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as String,actionsSummary: null == actionsSummary ? _self.actionsSummary : actionsSummary // ignore: cast_nullable_to_non_nullable
as List<Object?>,moderator: null == moderator ? _self.moderator : moderator // ignore: cast_nullable_to_non_nullable
as bool,admin: null == admin ? _self.admin : admin // ignore: cast_nullable_to_non_nullable
as bool,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as bool,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,hidden: null == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool,trustLevel: null == trustLevel ? _self.trustLevel : trustLevel // ignore: cast_nullable_to_non_nullable
as int,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt ,userDeleted: null == userDeleted ? _self.userDeleted : userDeleted // ignore: cast_nullable_to_non_nullable
as bool,canViewEditHistory: null == canViewEditHistory ? _self.canViewEditHistory : canViewEditHistory // ignore: cast_nullable_to_non_nullable
as bool,wiki: null == wiki ? _self.wiki : wiki // ignore: cast_nullable_to_non_nullable
as bool,mentionedUsers: null == mentionedUsers ? _self.mentionedUsers : mentionedUsers // ignore: cast_nullable_to_non_nullable
as List<Object?>,calendarDetails: null == calendarDetails ? _self.calendarDetails : calendarDetails // ignore: cast_nullable_to_non_nullable
as List<Object?>,canManageCategoryExpertPosts: null == canManageCategoryExpertPosts ? _self.canManageCategoryExpertPosts : canManageCategoryExpertPosts // ignore: cast_nullable_to_non_nullable
as bool,ratings: null == ratings ? _self.ratings : ratings // ignore: cast_nullable_to_non_nullable
as List<Object?>,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<Object?>,reactionUsersCount: null == reactionUsersCount ? _self.reactionUsersCount : reactionUsersCount // ignore: cast_nullable_to_non_nullable
as int,currentUserUsedMainReaction: null == currentUserUsedMainReaction ? _self.currentUserUsedMainReaction : currentUserUsedMainReaction // ignore: cast_nullable_to_non_nullable
as bool,canAcceptAnswer: null == canAcceptAnswer ? _self.canAcceptAnswer : canAcceptAnswer // ignore: cast_nullable_to_non_nullable
as bool,canUnacceptAnswer: null == canUnacceptAnswer ? _self.canUnacceptAnswer : canUnacceptAnswer // ignore: cast_nullable_to_non_nullable
as bool,acceptedAnswer: null == acceptedAnswer ? _self.acceptedAnswer : acceptedAnswer // ignore: cast_nullable_to_non_nullable
as bool,topicAcceptedAnswer: null == topicAcceptedAnswer ? _self.topicAcceptedAnswer : topicAcceptedAnswer // ignore: cast_nullable_to_non_nullable
as bool,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,primaryGroupName: freezed == primaryGroupName ? _self.primaryGroupName : primaryGroupName // ignore: cast_nullable_to_non_nullable
as String?,flairName: freezed == flairName ? _self.flairName : flairName // ignore: cast_nullable_to_non_nullable
as String?,flairUrl: freezed == flairUrl ? _self.flairUrl : flairUrl // ignore: cast_nullable_to_non_nullable
as String?,flairBgColor: freezed == flairBgColor ? _self.flairBgColor : flairBgColor // ignore: cast_nullable_to_non_nullable
as String?,flairColor: freezed == flairColor ? _self.flairColor : flairColor // ignore: cast_nullable_to_non_nullable
as String?,flairGroupId: freezed == flairGroupId ? _self.flairGroupId : flairGroupId // ignore: cast_nullable_to_non_nullable
as int?,userTitle: freezed == userTitle ? _self.userTitle : userTitle // ignore: cast_nullable_to_non_nullable
as String?,editReason: freezed == editReason ? _self.editReason : editReason ,reviewableId: freezed == reviewableId ? _self.reviewableId : reviewableId ,reviewableScoreCount: freezed == reviewableScoreCount ? _self.reviewableScoreCount : reviewableScoreCount // ignore: cast_nullable_to_non_nullable
as int?,reviewableScorePendingCount: freezed == reviewableScorePendingCount ? _self.reviewableScorePendingCount : reviewableScorePendingCount // ignore: cast_nullable_to_non_nullable
as int?,event: freezed == event ? _self.event : event ,categoryExpertApprovedGroup: freezed == categoryExpertApprovedGroup ? _self.categoryExpertApprovedGroup : categoryExpertApprovedGroup ,needsCategoryExpertApproval: freezed == needsCategoryExpertApproval ? _self.needsCategoryExpertApproval : needsCategoryExpertApproval ,userNftVerified: freezed == userNftVerified ? _self.userNftVerified : userNftVerified ,currentUserReaction: freezed == currentUserReaction ? _self.currentUserReaction : currentUserReaction ,
  ));
}

}


/// Adds pattern-matching-related methods to [Post].
extension PostPatterns on Post {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Post value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Post value)  $default,){
final _that = this;
switch (_that) {
case _Post():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Post value)?  $default,){
final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username, @JsonKey(name: 'avatar_template')  String avatarTemplate, @JsonKey(name: 'created_at')  String createdAt,  String cooked, @JsonKey(name: 'post_number')  int postNumber, @JsonKey(name: 'post_type')  int postType, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'reply_count')  int replyCount, @JsonKey(name: 'reply_to_post_number')  Object? replyToPostNumber, @JsonKey(name: 'quote_count')  int quoteCount, @JsonKey(name: 'incoming_link_count')  int incomingLinkCount,  int reads, @JsonKey(name: 'readers_count')  int readersCount,  double score,  bool yours, @JsonKey(name: 'topic_id')  int topicId, @JsonKey(name: 'topic_slug')  String topicSlug, @JsonKey(name: 'display_username')  String displayUsername,  int version, @JsonKey(name: 'can_edit')  bool canEdit, @JsonKey(name: 'can_delete')  bool canDelete, @JsonKey(name: 'can_recover')  bool canRecover, @JsonKey(name: 'can_see_hidden_post')  bool canSeeHiddenPost, @JsonKey(name: 'can_wiki')  bool canWiki,  bool bookmarked,  String raw, @JsonKey(name: 'actions_summary')  List<Object?> actionsSummary,  bool moderator,  bool admin,  bool staff, @JsonKey(name: 'user_id')  int userId,  bool hidden, @JsonKey(name: 'trust_level')  int trustLevel, @JsonKey(name: 'deleted_at')  Object? deletedAt, @JsonKey(name: 'user_deleted')  bool userDeleted, @JsonKey(name: 'can_view_edit_history')  bool canViewEditHistory,  bool wiki, @JsonKey(name: 'mentioned_users')  List<Object?> mentionedUsers, @JsonKey(name: 'calendar_details')  List<Object?> calendarDetails, @JsonKey(name: 'can_manage_category_expert_posts')  bool canManageCategoryExpertPosts,  List<Object?> ratings,  List<Object?> reactions, @JsonKey(name: 'reaction_users_count')  int reactionUsersCount, @JsonKey(name: 'current_user_used_main_reaction')  bool currentUserUsedMainReaction, @JsonKey(name: 'can_accept_answer')  bool canAcceptAnswer, @JsonKey(name: 'can_unaccept_answer')  bool canUnacceptAnswer, @JsonKey(name: 'accepted_answer')  bool acceptedAnswer, @JsonKey(name: 'topic_accepted_answer')  bool topicAcceptedAnswer,  String? name, @JsonKey(name: 'primary_group_name')  String? primaryGroupName, @JsonKey(name: 'flair_name')  String? flairName, @JsonKey(name: 'flair_url')  String? flairUrl, @JsonKey(name: 'flair_bg_color')  String? flairBgColor, @JsonKey(name: 'flair_color')  String? flairColor, @JsonKey(name: 'flair_group_id')  int? flairGroupId, @JsonKey(name: 'user_title')  String? userTitle, @JsonKey(name: 'edit_reason')  Object? editReason, @JsonKey(name: 'reviewable_id')  Object? reviewableId, @JsonKey(name: 'reviewable_score_count')  int? reviewableScoreCount, @JsonKey(name: 'reviewable_score_pending_count')  int? reviewableScorePendingCount,  Object? event, @JsonKey(name: 'category_expert_approved_group')  Object? categoryExpertApprovedGroup, @JsonKey(name: 'needs_category_expert_approval')  Object? needsCategoryExpertApproval, @JsonKey(name: 'user_nft_verified')  Object? userNftVerified, @JsonKey(name: 'current_user_reaction')  Object? currentUserReaction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.username,_that.avatarTemplate,_that.createdAt,_that.cooked,_that.postNumber,_that.postType,_that.updatedAt,_that.replyCount,_that.replyToPostNumber,_that.quoteCount,_that.incomingLinkCount,_that.reads,_that.readersCount,_that.score,_that.yours,_that.topicId,_that.topicSlug,_that.displayUsername,_that.version,_that.canEdit,_that.canDelete,_that.canRecover,_that.canSeeHiddenPost,_that.canWiki,_that.bookmarked,_that.raw,_that.actionsSummary,_that.moderator,_that.admin,_that.staff,_that.userId,_that.hidden,_that.trustLevel,_that.deletedAt,_that.userDeleted,_that.canViewEditHistory,_that.wiki,_that.mentionedUsers,_that.calendarDetails,_that.canManageCategoryExpertPosts,_that.ratings,_that.reactions,_that.reactionUsersCount,_that.currentUserUsedMainReaction,_that.canAcceptAnswer,_that.canUnacceptAnswer,_that.acceptedAnswer,_that.topicAcceptedAnswer,_that.name,_that.primaryGroupName,_that.flairName,_that.flairUrl,_that.flairBgColor,_that.flairColor,_that.flairGroupId,_that.userTitle,_that.editReason,_that.reviewableId,_that.reviewableScoreCount,_that.reviewableScorePendingCount,_that.event,_that.categoryExpertApprovedGroup,_that.needsCategoryExpertApproval,_that.userNftVerified,_that.currentUserReaction);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username, @JsonKey(name: 'avatar_template')  String avatarTemplate, @JsonKey(name: 'created_at')  String createdAt,  String cooked, @JsonKey(name: 'post_number')  int postNumber, @JsonKey(name: 'post_type')  int postType, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'reply_count')  int replyCount, @JsonKey(name: 'reply_to_post_number')  Object? replyToPostNumber, @JsonKey(name: 'quote_count')  int quoteCount, @JsonKey(name: 'incoming_link_count')  int incomingLinkCount,  int reads, @JsonKey(name: 'readers_count')  int readersCount,  double score,  bool yours, @JsonKey(name: 'topic_id')  int topicId, @JsonKey(name: 'topic_slug')  String topicSlug, @JsonKey(name: 'display_username')  String displayUsername,  int version, @JsonKey(name: 'can_edit')  bool canEdit, @JsonKey(name: 'can_delete')  bool canDelete, @JsonKey(name: 'can_recover')  bool canRecover, @JsonKey(name: 'can_see_hidden_post')  bool canSeeHiddenPost, @JsonKey(name: 'can_wiki')  bool canWiki,  bool bookmarked,  String raw, @JsonKey(name: 'actions_summary')  List<Object?> actionsSummary,  bool moderator,  bool admin,  bool staff, @JsonKey(name: 'user_id')  int userId,  bool hidden, @JsonKey(name: 'trust_level')  int trustLevel, @JsonKey(name: 'deleted_at')  Object? deletedAt, @JsonKey(name: 'user_deleted')  bool userDeleted, @JsonKey(name: 'can_view_edit_history')  bool canViewEditHistory,  bool wiki, @JsonKey(name: 'mentioned_users')  List<Object?> mentionedUsers, @JsonKey(name: 'calendar_details')  List<Object?> calendarDetails, @JsonKey(name: 'can_manage_category_expert_posts')  bool canManageCategoryExpertPosts,  List<Object?> ratings,  List<Object?> reactions, @JsonKey(name: 'reaction_users_count')  int reactionUsersCount, @JsonKey(name: 'current_user_used_main_reaction')  bool currentUserUsedMainReaction, @JsonKey(name: 'can_accept_answer')  bool canAcceptAnswer, @JsonKey(name: 'can_unaccept_answer')  bool canUnacceptAnswer, @JsonKey(name: 'accepted_answer')  bool acceptedAnswer, @JsonKey(name: 'topic_accepted_answer')  bool topicAcceptedAnswer,  String? name, @JsonKey(name: 'primary_group_name')  String? primaryGroupName, @JsonKey(name: 'flair_name')  String? flairName, @JsonKey(name: 'flair_url')  String? flairUrl, @JsonKey(name: 'flair_bg_color')  String? flairBgColor, @JsonKey(name: 'flair_color')  String? flairColor, @JsonKey(name: 'flair_group_id')  int? flairGroupId, @JsonKey(name: 'user_title')  String? userTitle, @JsonKey(name: 'edit_reason')  Object? editReason, @JsonKey(name: 'reviewable_id')  Object? reviewableId, @JsonKey(name: 'reviewable_score_count')  int? reviewableScoreCount, @JsonKey(name: 'reviewable_score_pending_count')  int? reviewableScorePendingCount,  Object? event, @JsonKey(name: 'category_expert_approved_group')  Object? categoryExpertApprovedGroup, @JsonKey(name: 'needs_category_expert_approval')  Object? needsCategoryExpertApproval, @JsonKey(name: 'user_nft_verified')  Object? userNftVerified, @JsonKey(name: 'current_user_reaction')  Object? currentUserReaction)  $default,) {final _that = this;
switch (_that) {
case _Post():
return $default(_that.id,_that.username,_that.avatarTemplate,_that.createdAt,_that.cooked,_that.postNumber,_that.postType,_that.updatedAt,_that.replyCount,_that.replyToPostNumber,_that.quoteCount,_that.incomingLinkCount,_that.reads,_that.readersCount,_that.score,_that.yours,_that.topicId,_that.topicSlug,_that.displayUsername,_that.version,_that.canEdit,_that.canDelete,_that.canRecover,_that.canSeeHiddenPost,_that.canWiki,_that.bookmarked,_that.raw,_that.actionsSummary,_that.moderator,_that.admin,_that.staff,_that.userId,_that.hidden,_that.trustLevel,_that.deletedAt,_that.userDeleted,_that.canViewEditHistory,_that.wiki,_that.mentionedUsers,_that.calendarDetails,_that.canManageCategoryExpertPosts,_that.ratings,_that.reactions,_that.reactionUsersCount,_that.currentUserUsedMainReaction,_that.canAcceptAnswer,_that.canUnacceptAnswer,_that.acceptedAnswer,_that.topicAcceptedAnswer,_that.name,_that.primaryGroupName,_that.flairName,_that.flairUrl,_that.flairBgColor,_that.flairColor,_that.flairGroupId,_that.userTitle,_that.editReason,_that.reviewableId,_that.reviewableScoreCount,_that.reviewableScorePendingCount,_that.event,_that.categoryExpertApprovedGroup,_that.needsCategoryExpertApproval,_that.userNftVerified,_that.currentUserReaction);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username, @JsonKey(name: 'avatar_template')  String avatarTemplate, @JsonKey(name: 'created_at')  String createdAt,  String cooked, @JsonKey(name: 'post_number')  int postNumber, @JsonKey(name: 'post_type')  int postType, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'reply_count')  int replyCount, @JsonKey(name: 'reply_to_post_number')  Object? replyToPostNumber, @JsonKey(name: 'quote_count')  int quoteCount, @JsonKey(name: 'incoming_link_count')  int incomingLinkCount,  int reads, @JsonKey(name: 'readers_count')  int readersCount,  double score,  bool yours, @JsonKey(name: 'topic_id')  int topicId, @JsonKey(name: 'topic_slug')  String topicSlug, @JsonKey(name: 'display_username')  String displayUsername,  int version, @JsonKey(name: 'can_edit')  bool canEdit, @JsonKey(name: 'can_delete')  bool canDelete, @JsonKey(name: 'can_recover')  bool canRecover, @JsonKey(name: 'can_see_hidden_post')  bool canSeeHiddenPost, @JsonKey(name: 'can_wiki')  bool canWiki,  bool bookmarked,  String raw, @JsonKey(name: 'actions_summary')  List<Object?> actionsSummary,  bool moderator,  bool admin,  bool staff, @JsonKey(name: 'user_id')  int userId,  bool hidden, @JsonKey(name: 'trust_level')  int trustLevel, @JsonKey(name: 'deleted_at')  Object? deletedAt, @JsonKey(name: 'user_deleted')  bool userDeleted, @JsonKey(name: 'can_view_edit_history')  bool canViewEditHistory,  bool wiki, @JsonKey(name: 'mentioned_users')  List<Object?> mentionedUsers, @JsonKey(name: 'calendar_details')  List<Object?> calendarDetails, @JsonKey(name: 'can_manage_category_expert_posts')  bool canManageCategoryExpertPosts,  List<Object?> ratings,  List<Object?> reactions, @JsonKey(name: 'reaction_users_count')  int reactionUsersCount, @JsonKey(name: 'current_user_used_main_reaction')  bool currentUserUsedMainReaction, @JsonKey(name: 'can_accept_answer')  bool canAcceptAnswer, @JsonKey(name: 'can_unaccept_answer')  bool canUnacceptAnswer, @JsonKey(name: 'accepted_answer')  bool acceptedAnswer, @JsonKey(name: 'topic_accepted_answer')  bool topicAcceptedAnswer,  String? name, @JsonKey(name: 'primary_group_name')  String? primaryGroupName, @JsonKey(name: 'flair_name')  String? flairName, @JsonKey(name: 'flair_url')  String? flairUrl, @JsonKey(name: 'flair_bg_color')  String? flairBgColor, @JsonKey(name: 'flair_color')  String? flairColor, @JsonKey(name: 'flair_group_id')  int? flairGroupId, @JsonKey(name: 'user_title')  String? userTitle, @JsonKey(name: 'edit_reason')  Object? editReason, @JsonKey(name: 'reviewable_id')  Object? reviewableId, @JsonKey(name: 'reviewable_score_count')  int? reviewableScoreCount, @JsonKey(name: 'reviewable_score_pending_count')  int? reviewableScorePendingCount,  Object? event, @JsonKey(name: 'category_expert_approved_group')  Object? categoryExpertApprovedGroup, @JsonKey(name: 'needs_category_expert_approval')  Object? needsCategoryExpertApproval, @JsonKey(name: 'user_nft_verified')  Object? userNftVerified, @JsonKey(name: 'current_user_reaction')  Object? currentUserReaction)?  $default,) {final _that = this;
switch (_that) {
case _Post() when $default != null:
return $default(_that.id,_that.username,_that.avatarTemplate,_that.createdAt,_that.cooked,_that.postNumber,_that.postType,_that.updatedAt,_that.replyCount,_that.replyToPostNumber,_that.quoteCount,_that.incomingLinkCount,_that.reads,_that.readersCount,_that.score,_that.yours,_that.topicId,_that.topicSlug,_that.displayUsername,_that.version,_that.canEdit,_that.canDelete,_that.canRecover,_that.canSeeHiddenPost,_that.canWiki,_that.bookmarked,_that.raw,_that.actionsSummary,_that.moderator,_that.admin,_that.staff,_that.userId,_that.hidden,_that.trustLevel,_that.deletedAt,_that.userDeleted,_that.canViewEditHistory,_that.wiki,_that.mentionedUsers,_that.calendarDetails,_that.canManageCategoryExpertPosts,_that.ratings,_that.reactions,_that.reactionUsersCount,_that.currentUserUsedMainReaction,_that.canAcceptAnswer,_that.canUnacceptAnswer,_that.acceptedAnswer,_that.topicAcceptedAnswer,_that.name,_that.primaryGroupName,_that.flairName,_that.flairUrl,_that.flairBgColor,_that.flairColor,_that.flairGroupId,_that.userTitle,_that.editReason,_that.reviewableId,_that.reviewableScoreCount,_that.reviewableScorePendingCount,_that.event,_that.categoryExpertApprovedGroup,_that.needsCategoryExpertApproval,_that.userNftVerified,_that.currentUserReaction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Post implements Post {
  const _Post({required this.id, required this.username, @JsonKey(name: 'avatar_template') required this.avatarTemplate, @JsonKey(name: 'created_at') required this.createdAt, required this.cooked, @JsonKey(name: 'post_number') required this.postNumber, @JsonKey(name: 'post_type') required this.postType, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'reply_count') required this.replyCount, @JsonKey(name: 'reply_to_post_number') required this.replyToPostNumber, @JsonKey(name: 'quote_count') required this.quoteCount, @JsonKey(name: 'incoming_link_count') required this.incomingLinkCount, required this.reads, @JsonKey(name: 'readers_count') required this.readersCount, required this.score, required this.yours, @JsonKey(name: 'topic_id') required this.topicId, @JsonKey(name: 'topic_slug') required this.topicSlug, @JsonKey(name: 'display_username') required this.displayUsername, required this.version, @JsonKey(name: 'can_edit') required this.canEdit, @JsonKey(name: 'can_delete') required this.canDelete, @JsonKey(name: 'can_recover') required this.canRecover, @JsonKey(name: 'can_see_hidden_post') required this.canSeeHiddenPost, @JsonKey(name: 'can_wiki') required this.canWiki, required this.bookmarked, required this.raw, @JsonKey(name: 'actions_summary') required final  List<Object?> actionsSummary, required this.moderator, required this.admin, required this.staff, @JsonKey(name: 'user_id') required this.userId, required this.hidden, @JsonKey(name: 'trust_level') required this.trustLevel, @JsonKey(name: 'deleted_at') required this.deletedAt, @JsonKey(name: 'user_deleted') required this.userDeleted, @JsonKey(name: 'can_view_edit_history') required this.canViewEditHistory, required this.wiki, @JsonKey(name: 'mentioned_users') required final  List<Object?> mentionedUsers, @JsonKey(name: 'calendar_details') required final  List<Object?> calendarDetails, @JsonKey(name: 'can_manage_category_expert_posts') required this.canManageCategoryExpertPosts, required final  List<Object?> ratings, required final  List<Object?> reactions, @JsonKey(name: 'reaction_users_count') required this.reactionUsersCount, @JsonKey(name: 'current_user_used_main_reaction') required this.currentUserUsedMainReaction, @JsonKey(name: 'can_accept_answer') required this.canAcceptAnswer, @JsonKey(name: 'can_unaccept_answer') required this.canUnacceptAnswer, @JsonKey(name: 'accepted_answer') required this.acceptedAnswer, @JsonKey(name: 'topic_accepted_answer') required this.topicAcceptedAnswer, this.name, @JsonKey(name: 'primary_group_name') this.primaryGroupName, @JsonKey(name: 'flair_name') this.flairName, @JsonKey(name: 'flair_url') this.flairUrl, @JsonKey(name: 'flair_bg_color') this.flairBgColor, @JsonKey(name: 'flair_color') this.flairColor, @JsonKey(name: 'flair_group_id') this.flairGroupId, @JsonKey(name: 'user_title') this.userTitle, @JsonKey(name: 'edit_reason') this.editReason, @JsonKey(name: 'reviewable_id') this.reviewableId, @JsonKey(name: 'reviewable_score_count') this.reviewableScoreCount, @JsonKey(name: 'reviewable_score_pending_count') this.reviewableScorePendingCount, this.event, @JsonKey(name: 'category_expert_approved_group') this.categoryExpertApprovedGroup, @JsonKey(name: 'needs_category_expert_approval') this.needsCategoryExpertApproval, @JsonKey(name: 'user_nft_verified') this.userNftVerified, @JsonKey(name: 'current_user_reaction') this.currentUserReaction}): _actionsSummary = actionsSummary,_mentionedUsers = mentionedUsers,_calendarDetails = calendarDetails,_ratings = ratings,_reactions = reactions;
  factory _Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

@override final  int id;
@override final  String username;
@override@JsonKey(name: 'avatar_template') final  String avatarTemplate;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override final  String cooked;
@override@JsonKey(name: 'post_number') final  int postNumber;
@override@JsonKey(name: 'post_type') final  int postType;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
@override@JsonKey(name: 'reply_count') final  int replyCount;
@override@JsonKey(name: 'reply_to_post_number') final  Object? replyToPostNumber;
@override@JsonKey(name: 'quote_count') final  int quoteCount;
@override@JsonKey(name: 'incoming_link_count') final  int incomingLinkCount;
@override final  int reads;
@override@JsonKey(name: 'readers_count') final  int readersCount;
@override final  double score;
@override final  bool yours;
@override@JsonKey(name: 'topic_id') final  int topicId;
@override@JsonKey(name: 'topic_slug') final  String topicSlug;
@override@JsonKey(name: 'display_username') final  String displayUsername;
@override final  int version;
@override@JsonKey(name: 'can_edit') final  bool canEdit;
@override@JsonKey(name: 'can_delete') final  bool canDelete;
@override@JsonKey(name: 'can_recover') final  bool canRecover;
@override@JsonKey(name: 'can_see_hidden_post') final  bool canSeeHiddenPost;
@override@JsonKey(name: 'can_wiki') final  bool canWiki;
@override final  bool bookmarked;
@override final  String raw;
 final  List<Object?> _actionsSummary;
@override@JsonKey(name: 'actions_summary') List<Object?> get actionsSummary {
  if (_actionsSummary is EqualUnmodifiableListView) return _actionsSummary;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionsSummary);
}

@override final  bool moderator;
@override final  bool admin;
@override final  bool staff;
@override@JsonKey(name: 'user_id') final  int userId;
@override final  bool hidden;
@override@JsonKey(name: 'trust_level') final  int trustLevel;
@override@JsonKey(name: 'deleted_at') final  Object? deletedAt;
@override@JsonKey(name: 'user_deleted') final  bool userDeleted;
@override@JsonKey(name: 'can_view_edit_history') final  bool canViewEditHistory;
@override final  bool wiki;
 final  List<Object?> _mentionedUsers;
@override@JsonKey(name: 'mentioned_users') List<Object?> get mentionedUsers {
  if (_mentionedUsers is EqualUnmodifiableListView) return _mentionedUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mentionedUsers);
}

 final  List<Object?> _calendarDetails;
@override@JsonKey(name: 'calendar_details') List<Object?> get calendarDetails {
  if (_calendarDetails is EqualUnmodifiableListView) return _calendarDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_calendarDetails);
}

@override@JsonKey(name: 'can_manage_category_expert_posts') final  bool canManageCategoryExpertPosts;
 final  List<Object?> _ratings;
@override List<Object?> get ratings {
  if (_ratings is EqualUnmodifiableListView) return _ratings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ratings);
}

 final  List<Object?> _reactions;
@override List<Object?> get reactions {
  if (_reactions is EqualUnmodifiableListView) return _reactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reactions);
}

@override@JsonKey(name: 'reaction_users_count') final  int reactionUsersCount;
@override@JsonKey(name: 'current_user_used_main_reaction') final  bool currentUserUsedMainReaction;
@override@JsonKey(name: 'can_accept_answer') final  bool canAcceptAnswer;
@override@JsonKey(name: 'can_unaccept_answer') final  bool canUnacceptAnswer;
@override@JsonKey(name: 'accepted_answer') final  bool acceptedAnswer;
@override@JsonKey(name: 'topic_accepted_answer') final  bool topicAcceptedAnswer;
@override final  String? name;
@override@JsonKey(name: 'primary_group_name') final  String? primaryGroupName;
@override@JsonKey(name: 'flair_name') final  String? flairName;
@override@JsonKey(name: 'flair_url') final  String? flairUrl;
@override@JsonKey(name: 'flair_bg_color') final  String? flairBgColor;
@override@JsonKey(name: 'flair_color') final  String? flairColor;
@override@JsonKey(name: 'flair_group_id') final  int? flairGroupId;
@override@JsonKey(name: 'user_title') final  String? userTitle;
@override@JsonKey(name: 'edit_reason') final  Object? editReason;
@override@JsonKey(name: 'reviewable_id') final  Object? reviewableId;
@override@JsonKey(name: 'reviewable_score_count') final  int? reviewableScoreCount;
@override@JsonKey(name: 'reviewable_score_pending_count') final  int? reviewableScorePendingCount;
@override final  Object? event;
@override@JsonKey(name: 'category_expert_approved_group') final  Object? categoryExpertApprovedGroup;
@override@JsonKey(name: 'needs_category_expert_approval') final  Object? needsCategoryExpertApproval;
@override@JsonKey(name: 'user_nft_verified') final  Object? userNftVerified;
@override@JsonKey(name: 'current_user_reaction') final  Object? currentUserReaction;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostCopyWith<_Post> get copyWith => __$PostCopyWithImpl<_Post>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Post&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.cooked, cooked) || other.cooked == cooked)&&(identical(other.postNumber, postNumber) || other.postNumber == postNumber)&&(identical(other.postType, postType) || other.postType == postType)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&const DeepCollectionEquality().equals(other.replyToPostNumber, replyToPostNumber)&&(identical(other.quoteCount, quoteCount) || other.quoteCount == quoteCount)&&(identical(other.incomingLinkCount, incomingLinkCount) || other.incomingLinkCount == incomingLinkCount)&&(identical(other.reads, reads) || other.reads == reads)&&(identical(other.readersCount, readersCount) || other.readersCount == readersCount)&&(identical(other.score, score) || other.score == score)&&(identical(other.yours, yours) || other.yours == yours)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.topicSlug, topicSlug) || other.topicSlug == topicSlug)&&(identical(other.displayUsername, displayUsername) || other.displayUsername == displayUsername)&&(identical(other.version, version) || other.version == version)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.canRecover, canRecover) || other.canRecover == canRecover)&&(identical(other.canSeeHiddenPost, canSeeHiddenPost) || other.canSeeHiddenPost == canSeeHiddenPost)&&(identical(other.canWiki, canWiki) || other.canWiki == canWiki)&&(identical(other.bookmarked, bookmarked) || other.bookmarked == bookmarked)&&(identical(other.raw, raw) || other.raw == raw)&&const DeepCollectionEquality().equals(other._actionsSummary, _actionsSummary)&&(identical(other.moderator, moderator) || other.moderator == moderator)&&(identical(other.admin, admin) || other.admin == admin)&&(identical(other.staff, staff) || other.staff == staff)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.hidden, hidden) || other.hidden == hidden)&&(identical(other.trustLevel, trustLevel) || other.trustLevel == trustLevel)&&const DeepCollectionEquality().equals(other.deletedAt, deletedAt)&&(identical(other.userDeleted, userDeleted) || other.userDeleted == userDeleted)&&(identical(other.canViewEditHistory, canViewEditHistory) || other.canViewEditHistory == canViewEditHistory)&&(identical(other.wiki, wiki) || other.wiki == wiki)&&const DeepCollectionEquality().equals(other._mentionedUsers, _mentionedUsers)&&const DeepCollectionEquality().equals(other._calendarDetails, _calendarDetails)&&(identical(other.canManageCategoryExpertPosts, canManageCategoryExpertPosts) || other.canManageCategoryExpertPosts == canManageCategoryExpertPosts)&&const DeepCollectionEquality().equals(other._ratings, _ratings)&&const DeepCollectionEquality().equals(other._reactions, _reactions)&&(identical(other.reactionUsersCount, reactionUsersCount) || other.reactionUsersCount == reactionUsersCount)&&(identical(other.currentUserUsedMainReaction, currentUserUsedMainReaction) || other.currentUserUsedMainReaction == currentUserUsedMainReaction)&&(identical(other.canAcceptAnswer, canAcceptAnswer) || other.canAcceptAnswer == canAcceptAnswer)&&(identical(other.canUnacceptAnswer, canUnacceptAnswer) || other.canUnacceptAnswer == canUnacceptAnswer)&&(identical(other.acceptedAnswer, acceptedAnswer) || other.acceptedAnswer == acceptedAnswer)&&(identical(other.topicAcceptedAnswer, topicAcceptedAnswer) || other.topicAcceptedAnswer == topicAcceptedAnswer)&&(identical(other.name, name) || other.name == name)&&(identical(other.primaryGroupName, primaryGroupName) || other.primaryGroupName == primaryGroupName)&&(identical(other.flairName, flairName) || other.flairName == flairName)&&(identical(other.flairUrl, flairUrl) || other.flairUrl == flairUrl)&&(identical(other.flairBgColor, flairBgColor) || other.flairBgColor == flairBgColor)&&(identical(other.flairColor, flairColor) || other.flairColor == flairColor)&&(identical(other.flairGroupId, flairGroupId) || other.flairGroupId == flairGroupId)&&(identical(other.userTitle, userTitle) || other.userTitle == userTitle)&&const DeepCollectionEquality().equals(other.editReason, editReason)&&const DeepCollectionEquality().equals(other.reviewableId, reviewableId)&&(identical(other.reviewableScoreCount, reviewableScoreCount) || other.reviewableScoreCount == reviewableScoreCount)&&(identical(other.reviewableScorePendingCount, reviewableScorePendingCount) || other.reviewableScorePendingCount == reviewableScorePendingCount)&&const DeepCollectionEquality().equals(other.event, event)&&const DeepCollectionEquality().equals(other.categoryExpertApprovedGroup, categoryExpertApprovedGroup)&&const DeepCollectionEquality().equals(other.needsCategoryExpertApproval, needsCategoryExpertApproval)&&const DeepCollectionEquality().equals(other.userNftVerified, userNftVerified)&&const DeepCollectionEquality().equals(other.currentUserReaction, currentUserReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,avatarTemplate,createdAt,cooked,postNumber,postType,updatedAt,replyCount,const DeepCollectionEquality().hash(replyToPostNumber),quoteCount,incomingLinkCount,reads,readersCount,score,yours,topicId,topicSlug,displayUsername,version,canEdit,canDelete,canRecover,canSeeHiddenPost,canWiki,bookmarked,raw,const DeepCollectionEquality().hash(_actionsSummary),moderator,admin,staff,userId,hidden,trustLevel,const DeepCollectionEquality().hash(deletedAt),userDeleted,canViewEditHistory,wiki,const DeepCollectionEquality().hash(_mentionedUsers),const DeepCollectionEquality().hash(_calendarDetails),canManageCategoryExpertPosts,const DeepCollectionEquality().hash(_ratings),const DeepCollectionEquality().hash(_reactions),reactionUsersCount,currentUserUsedMainReaction,canAcceptAnswer,canUnacceptAnswer,acceptedAnswer,topicAcceptedAnswer,name,primaryGroupName,flairName,flairUrl,flairBgColor,flairColor,flairGroupId,userTitle,const DeepCollectionEquality().hash(editReason),const DeepCollectionEquality().hash(reviewableId),reviewableScoreCount,reviewableScorePendingCount,const DeepCollectionEquality().hash(event),const DeepCollectionEquality().hash(categoryExpertApprovedGroup),const DeepCollectionEquality().hash(needsCategoryExpertApproval),const DeepCollectionEquality().hash(userNftVerified),const DeepCollectionEquality().hash(currentUserReaction)]);

@override
String toString() {
  return 'Post(id: $id, username: $username, avatarTemplate: $avatarTemplate, createdAt: $createdAt, cooked: $cooked, postNumber: $postNumber, postType: $postType, updatedAt: $updatedAt, replyCount: $replyCount, replyToPostNumber: $replyToPostNumber, quoteCount: $quoteCount, incomingLinkCount: $incomingLinkCount, reads: $reads, readersCount: $readersCount, score: $score, yours: $yours, topicId: $topicId, topicSlug: $topicSlug, displayUsername: $displayUsername, version: $version, canEdit: $canEdit, canDelete: $canDelete, canRecover: $canRecover, canSeeHiddenPost: $canSeeHiddenPost, canWiki: $canWiki, bookmarked: $bookmarked, raw: $raw, actionsSummary: $actionsSummary, moderator: $moderator, admin: $admin, staff: $staff, userId: $userId, hidden: $hidden, trustLevel: $trustLevel, deletedAt: $deletedAt, userDeleted: $userDeleted, canViewEditHistory: $canViewEditHistory, wiki: $wiki, mentionedUsers: $mentionedUsers, calendarDetails: $calendarDetails, canManageCategoryExpertPosts: $canManageCategoryExpertPosts, ratings: $ratings, reactions: $reactions, reactionUsersCount: $reactionUsersCount, currentUserUsedMainReaction: $currentUserUsedMainReaction, canAcceptAnswer: $canAcceptAnswer, canUnacceptAnswer: $canUnacceptAnswer, acceptedAnswer: $acceptedAnswer, topicAcceptedAnswer: $topicAcceptedAnswer, name: $name, primaryGroupName: $primaryGroupName, flairName: $flairName, flairUrl: $flairUrl, flairBgColor: $flairBgColor, flairColor: $flairColor, flairGroupId: $flairGroupId, userTitle: $userTitle, editReason: $editReason, reviewableId: $reviewableId, reviewableScoreCount: $reviewableScoreCount, reviewableScorePendingCount: $reviewableScorePendingCount, event: $event, categoryExpertApprovedGroup: $categoryExpertApprovedGroup, needsCategoryExpertApproval: $needsCategoryExpertApproval, userNftVerified: $userNftVerified, currentUserReaction: $currentUserReaction)';
}


}

/// @nodoc
abstract mixin class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) _then) = __$PostCopyWithImpl;
@override @useResult
$Res call({
 int id, String username,@JsonKey(name: 'avatar_template') String avatarTemplate,@JsonKey(name: 'created_at') String createdAt, String cooked,@JsonKey(name: 'post_number') int postNumber,@JsonKey(name: 'post_type') int postType,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'reply_count') int replyCount,@JsonKey(name: 'reply_to_post_number') Object? replyToPostNumber,@JsonKey(name: 'quote_count') int quoteCount,@JsonKey(name: 'incoming_link_count') int incomingLinkCount, int reads,@JsonKey(name: 'readers_count') int readersCount, double score, bool yours,@JsonKey(name: 'topic_id') int topicId,@JsonKey(name: 'topic_slug') String topicSlug,@JsonKey(name: 'display_username') String displayUsername, int version,@JsonKey(name: 'can_edit') bool canEdit,@JsonKey(name: 'can_delete') bool canDelete,@JsonKey(name: 'can_recover') bool canRecover,@JsonKey(name: 'can_see_hidden_post') bool canSeeHiddenPost,@JsonKey(name: 'can_wiki') bool canWiki, bool bookmarked, String raw,@JsonKey(name: 'actions_summary') List<Object?> actionsSummary, bool moderator, bool admin, bool staff,@JsonKey(name: 'user_id') int userId, bool hidden,@JsonKey(name: 'trust_level') int trustLevel,@JsonKey(name: 'deleted_at') Object? deletedAt,@JsonKey(name: 'user_deleted') bool userDeleted,@JsonKey(name: 'can_view_edit_history') bool canViewEditHistory, bool wiki,@JsonKey(name: 'mentioned_users') List<Object?> mentionedUsers,@JsonKey(name: 'calendar_details') List<Object?> calendarDetails,@JsonKey(name: 'can_manage_category_expert_posts') bool canManageCategoryExpertPosts, List<Object?> ratings, List<Object?> reactions,@JsonKey(name: 'reaction_users_count') int reactionUsersCount,@JsonKey(name: 'current_user_used_main_reaction') bool currentUserUsedMainReaction,@JsonKey(name: 'can_accept_answer') bool canAcceptAnswer,@JsonKey(name: 'can_unaccept_answer') bool canUnacceptAnswer,@JsonKey(name: 'accepted_answer') bool acceptedAnswer,@JsonKey(name: 'topic_accepted_answer') bool topicAcceptedAnswer, String? name,@JsonKey(name: 'primary_group_name') String? primaryGroupName,@JsonKey(name: 'flair_name') String? flairName,@JsonKey(name: 'flair_url') String? flairUrl,@JsonKey(name: 'flair_bg_color') String? flairBgColor,@JsonKey(name: 'flair_color') String? flairColor,@JsonKey(name: 'flair_group_id') int? flairGroupId,@JsonKey(name: 'user_title') String? userTitle,@JsonKey(name: 'edit_reason') Object? editReason,@JsonKey(name: 'reviewable_id') Object? reviewableId,@JsonKey(name: 'reviewable_score_count') int? reviewableScoreCount,@JsonKey(name: 'reviewable_score_pending_count') int? reviewableScorePendingCount, Object? event,@JsonKey(name: 'category_expert_approved_group') Object? categoryExpertApprovedGroup,@JsonKey(name: 'needs_category_expert_approval') Object? needsCategoryExpertApproval,@JsonKey(name: 'user_nft_verified') Object? userNftVerified,@JsonKey(name: 'current_user_reaction') Object? currentUserReaction
});




}
/// @nodoc
class __$PostCopyWithImpl<$Res>
    implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(this._self, this._then);

  final _Post _self;
  final $Res Function(_Post) _then;

/// Create a copy of Post
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatarTemplate = null,Object? createdAt = null,Object? cooked = null,Object? postNumber = null,Object? postType = null,Object? updatedAt = null,Object? replyCount = null,Object? replyToPostNumber = freezed,Object? quoteCount = null,Object? incomingLinkCount = null,Object? reads = null,Object? readersCount = null,Object? score = null,Object? yours = null,Object? topicId = null,Object? topicSlug = null,Object? displayUsername = null,Object? version = null,Object? canEdit = null,Object? canDelete = null,Object? canRecover = null,Object? canSeeHiddenPost = null,Object? canWiki = null,Object? bookmarked = null,Object? raw = null,Object? actionsSummary = null,Object? moderator = null,Object? admin = null,Object? staff = null,Object? userId = null,Object? hidden = null,Object? trustLevel = null,Object? deletedAt = freezed,Object? userDeleted = null,Object? canViewEditHistory = null,Object? wiki = null,Object? mentionedUsers = null,Object? calendarDetails = null,Object? canManageCategoryExpertPosts = null,Object? ratings = null,Object? reactions = null,Object? reactionUsersCount = null,Object? currentUserUsedMainReaction = null,Object? canAcceptAnswer = null,Object? canUnacceptAnswer = null,Object? acceptedAnswer = null,Object? topicAcceptedAnswer = null,Object? name = freezed,Object? primaryGroupName = freezed,Object? flairName = freezed,Object? flairUrl = freezed,Object? flairBgColor = freezed,Object? flairColor = freezed,Object? flairGroupId = freezed,Object? userTitle = freezed,Object? editReason = freezed,Object? reviewableId = freezed,Object? reviewableScoreCount = freezed,Object? reviewableScorePendingCount = freezed,Object? event = freezed,Object? categoryExpertApprovedGroup = freezed,Object? needsCategoryExpertApproval = freezed,Object? userNftVerified = freezed,Object? currentUserReaction = freezed,}) {
  return _then(_Post(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,cooked: null == cooked ? _self.cooked : cooked // ignore: cast_nullable_to_non_nullable
as String,postNumber: null == postNumber ? _self.postNumber : postNumber // ignore: cast_nullable_to_non_nullable
as int,postType: null == postType ? _self.postType : postType // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,replyToPostNumber: freezed == replyToPostNumber ? _self.replyToPostNumber : replyToPostNumber ,quoteCount: null == quoteCount ? _self.quoteCount : quoteCount // ignore: cast_nullable_to_non_nullable
as int,incomingLinkCount: null == incomingLinkCount ? _self.incomingLinkCount : incomingLinkCount // ignore: cast_nullable_to_non_nullable
as int,reads: null == reads ? _self.reads : reads // ignore: cast_nullable_to_non_nullable
as int,readersCount: null == readersCount ? _self.readersCount : readersCount // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,yours: null == yours ? _self.yours : yours // ignore: cast_nullable_to_non_nullable
as bool,topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as int,topicSlug: null == topicSlug ? _self.topicSlug : topicSlug // ignore: cast_nullable_to_non_nullable
as String,displayUsername: null == displayUsername ? _self.displayUsername : displayUsername // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,canRecover: null == canRecover ? _self.canRecover : canRecover // ignore: cast_nullable_to_non_nullable
as bool,canSeeHiddenPost: null == canSeeHiddenPost ? _self.canSeeHiddenPost : canSeeHiddenPost // ignore: cast_nullable_to_non_nullable
as bool,canWiki: null == canWiki ? _self.canWiki : canWiki // ignore: cast_nullable_to_non_nullable
as bool,bookmarked: null == bookmarked ? _self.bookmarked : bookmarked // ignore: cast_nullable_to_non_nullable
as bool,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as String,actionsSummary: null == actionsSummary ? _self._actionsSummary : actionsSummary // ignore: cast_nullable_to_non_nullable
as List<Object?>,moderator: null == moderator ? _self.moderator : moderator // ignore: cast_nullable_to_non_nullable
as bool,admin: null == admin ? _self.admin : admin // ignore: cast_nullable_to_non_nullable
as bool,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as bool,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,hidden: null == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool,trustLevel: null == trustLevel ? _self.trustLevel : trustLevel // ignore: cast_nullable_to_non_nullable
as int,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt ,userDeleted: null == userDeleted ? _self.userDeleted : userDeleted // ignore: cast_nullable_to_non_nullable
as bool,canViewEditHistory: null == canViewEditHistory ? _self.canViewEditHistory : canViewEditHistory // ignore: cast_nullable_to_non_nullable
as bool,wiki: null == wiki ? _self.wiki : wiki // ignore: cast_nullable_to_non_nullable
as bool,mentionedUsers: null == mentionedUsers ? _self._mentionedUsers : mentionedUsers // ignore: cast_nullable_to_non_nullable
as List<Object?>,calendarDetails: null == calendarDetails ? _self._calendarDetails : calendarDetails // ignore: cast_nullable_to_non_nullable
as List<Object?>,canManageCategoryExpertPosts: null == canManageCategoryExpertPosts ? _self.canManageCategoryExpertPosts : canManageCategoryExpertPosts // ignore: cast_nullable_to_non_nullable
as bool,ratings: null == ratings ? _self._ratings : ratings // ignore: cast_nullable_to_non_nullable
as List<Object?>,reactions: null == reactions ? _self._reactions : reactions // ignore: cast_nullable_to_non_nullable
as List<Object?>,reactionUsersCount: null == reactionUsersCount ? _self.reactionUsersCount : reactionUsersCount // ignore: cast_nullable_to_non_nullable
as int,currentUserUsedMainReaction: null == currentUserUsedMainReaction ? _self.currentUserUsedMainReaction : currentUserUsedMainReaction // ignore: cast_nullable_to_non_nullable
as bool,canAcceptAnswer: null == canAcceptAnswer ? _self.canAcceptAnswer : canAcceptAnswer // ignore: cast_nullable_to_non_nullable
as bool,canUnacceptAnswer: null == canUnacceptAnswer ? _self.canUnacceptAnswer : canUnacceptAnswer // ignore: cast_nullable_to_non_nullable
as bool,acceptedAnswer: null == acceptedAnswer ? _self.acceptedAnswer : acceptedAnswer // ignore: cast_nullable_to_non_nullable
as bool,topicAcceptedAnswer: null == topicAcceptedAnswer ? _self.topicAcceptedAnswer : topicAcceptedAnswer // ignore: cast_nullable_to_non_nullable
as bool,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,primaryGroupName: freezed == primaryGroupName ? _self.primaryGroupName : primaryGroupName // ignore: cast_nullable_to_non_nullable
as String?,flairName: freezed == flairName ? _self.flairName : flairName // ignore: cast_nullable_to_non_nullable
as String?,flairUrl: freezed == flairUrl ? _self.flairUrl : flairUrl // ignore: cast_nullable_to_non_nullable
as String?,flairBgColor: freezed == flairBgColor ? _self.flairBgColor : flairBgColor // ignore: cast_nullable_to_non_nullable
as String?,flairColor: freezed == flairColor ? _self.flairColor : flairColor // ignore: cast_nullable_to_non_nullable
as String?,flairGroupId: freezed == flairGroupId ? _self.flairGroupId : flairGroupId // ignore: cast_nullable_to_non_nullable
as int?,userTitle: freezed == userTitle ? _self.userTitle : userTitle // ignore: cast_nullable_to_non_nullable
as String?,editReason: freezed == editReason ? _self.editReason : editReason ,reviewableId: freezed == reviewableId ? _self.reviewableId : reviewableId ,reviewableScoreCount: freezed == reviewableScoreCount ? _self.reviewableScoreCount : reviewableScoreCount // ignore: cast_nullable_to_non_nullable
as int?,reviewableScorePendingCount: freezed == reviewableScorePendingCount ? _self.reviewableScorePendingCount : reviewableScorePendingCount // ignore: cast_nullable_to_non_nullable
as int?,event: freezed == event ? _self.event : event ,categoryExpertApprovedGroup: freezed == categoryExpertApprovedGroup ? _self.categoryExpertApprovedGroup : categoryExpertApprovedGroup ,needsCategoryExpertApproval: freezed == needsCategoryExpertApproval ? _self.needsCategoryExpertApproval : needsCategoryExpertApproval ,userNftVerified: freezed == userNftVerified ? _self.userNftVerified : userNftVerified ,currentUserReaction: freezed == currentUserReaction ? _self.currentUserReaction : currentUserReaction ,
  ));
}


}

// dart format on
