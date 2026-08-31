// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Topic {

 int get id; String get title;@JsonKey(name: 'posts_count') int get postsCount;@JsonKey(name: 'reply_count') int get replyCount;@JsonKey(name: 'highest_post_number') int get highestPostNumber;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'last_posted_at') String get lastPostedAt; bool get bumped;@JsonKey(name: 'bumped_at') String get bumpedAt; String get archetype; bool get unseen;@JsonKey(name: 'last_read_post_number') int? get lastReadPostNumber; int? get unread;@JsonKey(name: 'new_posts') int? get newPosts;@JsonKey(name: 'unread_posts') int? get unreadPosts; bool get pinned; String? get excerpt; bool get visible; bool get closed; bool get archived;@JsonKey(name: 'notification_level') int? get notificationLevel; bool? get bookmarked; bool? get liked; List<Object?> get tags; int get views;@JsonKey(name: 'like_count') int get likeCount;@JsonKey(name: 'has_summary') bool get hasSummary;@JsonKey(name: 'last_poster_username') String? get lastPosterUsername;@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'pinned_globally') bool get pinnedGlobally; List<Map<String, dynamic>> get posters;@JsonKey(name: 'image_url') String? get imageUrl; Object? get unpinned;@JsonKey(name: 'tags_descriptions') Map<String, dynamic>? get tagsDescriptions;@JsonKey(name: 'featured_link') String? get featuredLink;
/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicCopyWith<Topic> get copyWith => _$TopicCopyWithImpl<Topic>(this as Topic, _$identity);

  /// Serializes this Topic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Topic&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.postsCount, postsCount) || other.postsCount == postsCount)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.highestPostNumber, highestPostNumber) || other.highestPostNumber == highestPostNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastPostedAt, lastPostedAt) || other.lastPostedAt == lastPostedAt)&&(identical(other.bumped, bumped) || other.bumped == bumped)&&(identical(other.bumpedAt, bumpedAt) || other.bumpedAt == bumpedAt)&&(identical(other.archetype, archetype) || other.archetype == archetype)&&(identical(other.unseen, unseen) || other.unseen == unseen)&&(identical(other.lastReadPostNumber, lastReadPostNumber) || other.lastReadPostNumber == lastReadPostNumber)&&(identical(other.unread, unread) || other.unread == unread)&&(identical(other.newPosts, newPosts) || other.newPosts == newPosts)&&(identical(other.unreadPosts, unreadPosts) || other.unreadPosts == unreadPosts)&&(identical(other.pinned, pinned) || other.pinned == pinned)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt)&&(identical(other.visible, visible) || other.visible == visible)&&(identical(other.closed, closed) || other.closed == closed)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.notificationLevel, notificationLevel) || other.notificationLevel == notificationLevel)&&(identical(other.bookmarked, bookmarked) || other.bookmarked == bookmarked)&&(identical(other.liked, liked) || other.liked == liked)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.views, views) || other.views == views)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.hasSummary, hasSummary) || other.hasSummary == hasSummary)&&(identical(other.lastPosterUsername, lastPosterUsername) || other.lastPosterUsername == lastPosterUsername)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.pinnedGlobally, pinnedGlobally) || other.pinnedGlobally == pinnedGlobally)&&const DeepCollectionEquality().equals(other.posters, posters)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.unpinned, unpinned)&&const DeepCollectionEquality().equals(other.tagsDescriptions, tagsDescriptions)&&(identical(other.featuredLink, featuredLink) || other.featuredLink == featuredLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,postsCount,replyCount,highestPostNumber,createdAt,lastPostedAt,bumped,bumpedAt,archetype,unseen,lastReadPostNumber,unread,newPosts,unreadPosts,pinned,excerpt,visible,closed,archived,notificationLevel,bookmarked,liked,const DeepCollectionEquality().hash(tags),views,likeCount,hasSummary,lastPosterUsername,categoryId,pinnedGlobally,const DeepCollectionEquality().hash(posters),imageUrl,const DeepCollectionEquality().hash(unpinned),const DeepCollectionEquality().hash(tagsDescriptions),featuredLink]);

@override
String toString() {
  return 'Topic(id: $id, title: $title, postsCount: $postsCount, replyCount: $replyCount, highestPostNumber: $highestPostNumber, createdAt: $createdAt, lastPostedAt: $lastPostedAt, bumped: $bumped, bumpedAt: $bumpedAt, archetype: $archetype, unseen: $unseen, lastReadPostNumber: $lastReadPostNumber, unread: $unread, newPosts: $newPosts, unreadPosts: $unreadPosts, pinned: $pinned, excerpt: $excerpt, visible: $visible, closed: $closed, archived: $archived, notificationLevel: $notificationLevel, bookmarked: $bookmarked, liked: $liked, tags: $tags, views: $views, likeCount: $likeCount, hasSummary: $hasSummary, lastPosterUsername: $lastPosterUsername, categoryId: $categoryId, pinnedGlobally: $pinnedGlobally, posters: $posters, imageUrl: $imageUrl, unpinned: $unpinned, tagsDescriptions: $tagsDescriptions, featuredLink: $featuredLink)';
}


}

/// @nodoc
abstract mixin class $TopicCopyWith<$Res>  {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) _then) = _$TopicCopyWithImpl;
@useResult
$Res call({
 int id, String title,@JsonKey(name: 'posts_count') int postsCount,@JsonKey(name: 'reply_count') int replyCount,@JsonKey(name: 'highest_post_number') int highestPostNumber,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'last_posted_at') String lastPostedAt, bool bumped,@JsonKey(name: 'bumped_at') String bumpedAt, String archetype, bool unseen,@JsonKey(name: 'last_read_post_number') int? lastReadPostNumber, int? unread,@JsonKey(name: 'new_posts') int? newPosts,@JsonKey(name: 'unread_posts') int? unreadPosts, bool pinned, String? excerpt, bool visible, bool closed, bool archived,@JsonKey(name: 'notification_level') int? notificationLevel, bool? bookmarked, bool? liked, List<Object?> tags, int views,@JsonKey(name: 'like_count') int likeCount,@JsonKey(name: 'has_summary') bool hasSummary,@JsonKey(name: 'last_poster_username') String? lastPosterUsername,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'pinned_globally') bool pinnedGlobally, List<Map<String, dynamic>> posters,@JsonKey(name: 'image_url') String? imageUrl, Object? unpinned,@JsonKey(name: 'tags_descriptions') Map<String, dynamic>? tagsDescriptions,@JsonKey(name: 'featured_link') String? featuredLink
});




}
/// @nodoc
class _$TopicCopyWithImpl<$Res>
    implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._self, this._then);

  final Topic _self;
  final $Res Function(Topic) _then;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? postsCount = null,Object? replyCount = null,Object? highestPostNumber = null,Object? createdAt = null,Object? lastPostedAt = null,Object? bumped = null,Object? bumpedAt = null,Object? archetype = null,Object? unseen = null,Object? lastReadPostNumber = freezed,Object? unread = freezed,Object? newPosts = freezed,Object? unreadPosts = freezed,Object? pinned = null,Object? excerpt = freezed,Object? visible = null,Object? closed = null,Object? archived = null,Object? notificationLevel = freezed,Object? bookmarked = freezed,Object? liked = freezed,Object? tags = null,Object? views = null,Object? likeCount = null,Object? hasSummary = null,Object? lastPosterUsername = freezed,Object? categoryId = null,Object? pinnedGlobally = null,Object? posters = null,Object? imageUrl = freezed,Object? unpinned = freezed,Object? tagsDescriptions = freezed,Object? featuredLink = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,postsCount: null == postsCount ? _self.postsCount : postsCount // ignore: cast_nullable_to_non_nullable
as int,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,highestPostNumber: null == highestPostNumber ? _self.highestPostNumber : highestPostNumber // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,lastPostedAt: null == lastPostedAt ? _self.lastPostedAt : lastPostedAt // ignore: cast_nullable_to_non_nullable
as String,bumped: null == bumped ? _self.bumped : bumped // ignore: cast_nullable_to_non_nullable
as bool,bumpedAt: null == bumpedAt ? _self.bumpedAt : bumpedAt // ignore: cast_nullable_to_non_nullable
as String,archetype: null == archetype ? _self.archetype : archetype // ignore: cast_nullable_to_non_nullable
as String,unseen: null == unseen ? _self.unseen : unseen // ignore: cast_nullable_to_non_nullable
as bool,lastReadPostNumber: freezed == lastReadPostNumber ? _self.lastReadPostNumber : lastReadPostNumber // ignore: cast_nullable_to_non_nullable
as int?,unread: freezed == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int?,newPosts: freezed == newPosts ? _self.newPosts : newPosts // ignore: cast_nullable_to_non_nullable
as int?,unreadPosts: freezed == unreadPosts ? _self.unreadPosts : unreadPosts // ignore: cast_nullable_to_non_nullable
as int?,pinned: null == pinned ? _self.pinned : pinned // ignore: cast_nullable_to_non_nullable
as bool,excerpt: freezed == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String?,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,notificationLevel: freezed == notificationLevel ? _self.notificationLevel : notificationLevel // ignore: cast_nullable_to_non_nullable
as int?,bookmarked: freezed == bookmarked ? _self.bookmarked : bookmarked // ignore: cast_nullable_to_non_nullable
as bool?,liked: freezed == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<Object?>,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,hasSummary: null == hasSummary ? _self.hasSummary : hasSummary // ignore: cast_nullable_to_non_nullable
as bool,lastPosterUsername: freezed == lastPosterUsername ? _self.lastPosterUsername : lastPosterUsername // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,pinnedGlobally: null == pinnedGlobally ? _self.pinnedGlobally : pinnedGlobally // ignore: cast_nullable_to_non_nullable
as bool,posters: null == posters ? _self.posters : posters // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,unpinned: freezed == unpinned ? _self.unpinned : unpinned ,tagsDescriptions: freezed == tagsDescriptions ? _self.tagsDescriptions : tagsDescriptions // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,featuredLink: freezed == featuredLink ? _self.featuredLink : featuredLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Topic].
extension TopicPatterns on Topic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Topic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Topic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Topic value)  $default,){
final _that = this;
switch (_that) {
case _Topic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Topic value)?  $default,){
final _that = this;
switch (_that) {
case _Topic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title, @JsonKey(name: 'posts_count')  int postsCount, @JsonKey(name: 'reply_count')  int replyCount, @JsonKey(name: 'highest_post_number')  int highestPostNumber, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'last_posted_at')  String lastPostedAt,  bool bumped, @JsonKey(name: 'bumped_at')  String bumpedAt,  String archetype,  bool unseen, @JsonKey(name: 'last_read_post_number')  int? lastReadPostNumber,  int? unread, @JsonKey(name: 'new_posts')  int? newPosts, @JsonKey(name: 'unread_posts')  int? unreadPosts,  bool pinned,  String? excerpt,  bool visible,  bool closed,  bool archived, @JsonKey(name: 'notification_level')  int? notificationLevel,  bool? bookmarked,  bool? liked,  List<Object?> tags,  int views, @JsonKey(name: 'like_count')  int likeCount, @JsonKey(name: 'has_summary')  bool hasSummary, @JsonKey(name: 'last_poster_username')  String? lastPosterUsername, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'pinned_globally')  bool pinnedGlobally,  List<Map<String, dynamic>> posters, @JsonKey(name: 'image_url')  String? imageUrl,  Object? unpinned, @JsonKey(name: 'tags_descriptions')  Map<String, dynamic>? tagsDescriptions, @JsonKey(name: 'featured_link')  String? featuredLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that.id,_that.title,_that.postsCount,_that.replyCount,_that.highestPostNumber,_that.createdAt,_that.lastPostedAt,_that.bumped,_that.bumpedAt,_that.archetype,_that.unseen,_that.lastReadPostNumber,_that.unread,_that.newPosts,_that.unreadPosts,_that.pinned,_that.excerpt,_that.visible,_that.closed,_that.archived,_that.notificationLevel,_that.bookmarked,_that.liked,_that.tags,_that.views,_that.likeCount,_that.hasSummary,_that.lastPosterUsername,_that.categoryId,_that.pinnedGlobally,_that.posters,_that.imageUrl,_that.unpinned,_that.tagsDescriptions,_that.featuredLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title, @JsonKey(name: 'posts_count')  int postsCount, @JsonKey(name: 'reply_count')  int replyCount, @JsonKey(name: 'highest_post_number')  int highestPostNumber, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'last_posted_at')  String lastPostedAt,  bool bumped, @JsonKey(name: 'bumped_at')  String bumpedAt,  String archetype,  bool unseen, @JsonKey(name: 'last_read_post_number')  int? lastReadPostNumber,  int? unread, @JsonKey(name: 'new_posts')  int? newPosts, @JsonKey(name: 'unread_posts')  int? unreadPosts,  bool pinned,  String? excerpt,  bool visible,  bool closed,  bool archived, @JsonKey(name: 'notification_level')  int? notificationLevel,  bool? bookmarked,  bool? liked,  List<Object?> tags,  int views, @JsonKey(name: 'like_count')  int likeCount, @JsonKey(name: 'has_summary')  bool hasSummary, @JsonKey(name: 'last_poster_username')  String? lastPosterUsername, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'pinned_globally')  bool pinnedGlobally,  List<Map<String, dynamic>> posters, @JsonKey(name: 'image_url')  String? imageUrl,  Object? unpinned, @JsonKey(name: 'tags_descriptions')  Map<String, dynamic>? tagsDescriptions, @JsonKey(name: 'featured_link')  String? featuredLink)  $default,) {final _that = this;
switch (_that) {
case _Topic():
return $default(_that.id,_that.title,_that.postsCount,_that.replyCount,_that.highestPostNumber,_that.createdAt,_that.lastPostedAt,_that.bumped,_that.bumpedAt,_that.archetype,_that.unseen,_that.lastReadPostNumber,_that.unread,_that.newPosts,_that.unreadPosts,_that.pinned,_that.excerpt,_that.visible,_that.closed,_that.archived,_that.notificationLevel,_that.bookmarked,_that.liked,_that.tags,_that.views,_that.likeCount,_that.hasSummary,_that.lastPosterUsername,_that.categoryId,_that.pinnedGlobally,_that.posters,_that.imageUrl,_that.unpinned,_that.tagsDescriptions,_that.featuredLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title, @JsonKey(name: 'posts_count')  int postsCount, @JsonKey(name: 'reply_count')  int replyCount, @JsonKey(name: 'highest_post_number')  int highestPostNumber, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'last_posted_at')  String lastPostedAt,  bool bumped, @JsonKey(name: 'bumped_at')  String bumpedAt,  String archetype,  bool unseen, @JsonKey(name: 'last_read_post_number')  int? lastReadPostNumber,  int? unread, @JsonKey(name: 'new_posts')  int? newPosts, @JsonKey(name: 'unread_posts')  int? unreadPosts,  bool pinned,  String? excerpt,  bool visible,  bool closed,  bool archived, @JsonKey(name: 'notification_level')  int? notificationLevel,  bool? bookmarked,  bool? liked,  List<Object?> tags,  int views, @JsonKey(name: 'like_count')  int likeCount, @JsonKey(name: 'has_summary')  bool hasSummary, @JsonKey(name: 'last_poster_username')  String? lastPosterUsername, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'pinned_globally')  bool pinnedGlobally,  List<Map<String, dynamic>> posters, @JsonKey(name: 'image_url')  String? imageUrl,  Object? unpinned, @JsonKey(name: 'tags_descriptions')  Map<String, dynamic>? tagsDescriptions, @JsonKey(name: 'featured_link')  String? featuredLink)?  $default,) {final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that.id,_that.title,_that.postsCount,_that.replyCount,_that.highestPostNumber,_that.createdAt,_that.lastPostedAt,_that.bumped,_that.bumpedAt,_that.archetype,_that.unseen,_that.lastReadPostNumber,_that.unread,_that.newPosts,_that.unreadPosts,_that.pinned,_that.excerpt,_that.visible,_that.closed,_that.archived,_that.notificationLevel,_that.bookmarked,_that.liked,_that.tags,_that.views,_that.likeCount,_that.hasSummary,_that.lastPosterUsername,_that.categoryId,_that.pinnedGlobally,_that.posters,_that.imageUrl,_that.unpinned,_that.tagsDescriptions,_that.featuredLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Topic implements Topic {
  const _Topic({required this.id, required this.title, @JsonKey(name: 'posts_count') required this.postsCount, @JsonKey(name: 'reply_count') required this.replyCount, @JsonKey(name: 'highest_post_number') required this.highestPostNumber, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'last_posted_at') required this.lastPostedAt, required this.bumped, @JsonKey(name: 'bumped_at') required this.bumpedAt, required this.archetype, required this.unseen, @JsonKey(name: 'last_read_post_number') required this.lastReadPostNumber, required this.unread, @JsonKey(name: 'new_posts') required this.newPosts, @JsonKey(name: 'unread_posts') required this.unreadPosts, required this.pinned, required this.excerpt, required this.visible, required this.closed, required this.archived, @JsonKey(name: 'notification_level') required this.notificationLevel, required this.bookmarked, required this.liked, required final  List<Object?> tags, required this.views, @JsonKey(name: 'like_count') required this.likeCount, @JsonKey(name: 'has_summary') required this.hasSummary, @JsonKey(name: 'last_poster_username') required this.lastPosterUsername, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'pinned_globally') required this.pinnedGlobally, required final  List<Map<String, dynamic>> posters, @JsonKey(name: 'image_url') this.imageUrl, this.unpinned, @JsonKey(name: 'tags_descriptions') final  Map<String, dynamic>? tagsDescriptions, @JsonKey(name: 'featured_link') this.featuredLink}): _tags = tags,_posters = posters,_tagsDescriptions = tagsDescriptions;
  factory _Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

@override final  int id;
@override final  String title;
@override@JsonKey(name: 'posts_count') final  int postsCount;
@override@JsonKey(name: 'reply_count') final  int replyCount;
@override@JsonKey(name: 'highest_post_number') final  int highestPostNumber;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'last_posted_at') final  String lastPostedAt;
@override final  bool bumped;
@override@JsonKey(name: 'bumped_at') final  String bumpedAt;
@override final  String archetype;
@override final  bool unseen;
@override@JsonKey(name: 'last_read_post_number') final  int? lastReadPostNumber;
@override final  int? unread;
@override@JsonKey(name: 'new_posts') final  int? newPosts;
@override@JsonKey(name: 'unread_posts') final  int? unreadPosts;
@override final  bool pinned;
@override final  String? excerpt;
@override final  bool visible;
@override final  bool closed;
@override final  bool archived;
@override@JsonKey(name: 'notification_level') final  int? notificationLevel;
@override final  bool? bookmarked;
@override final  bool? liked;
 final  List<Object?> _tags;
@override List<Object?> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  int views;
@override@JsonKey(name: 'like_count') final  int likeCount;
@override@JsonKey(name: 'has_summary') final  bool hasSummary;
@override@JsonKey(name: 'last_poster_username') final  String? lastPosterUsername;
@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'pinned_globally') final  bool pinnedGlobally;
 final  List<Map<String, dynamic>> _posters;
@override List<Map<String, dynamic>> get posters {
  if (_posters is EqualUnmodifiableListView) return _posters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posters);
}

@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override final  Object? unpinned;
 final  Map<String, dynamic>? _tagsDescriptions;
@override@JsonKey(name: 'tags_descriptions') Map<String, dynamic>? get tagsDescriptions {
  final value = _tagsDescriptions;
  if (value == null) return null;
  if (_tagsDescriptions is EqualUnmodifiableMapView) return _tagsDescriptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'featured_link') final  String? featuredLink;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicCopyWith<_Topic> get copyWith => __$TopicCopyWithImpl<_Topic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Topic&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.postsCount, postsCount) || other.postsCount == postsCount)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.highestPostNumber, highestPostNumber) || other.highestPostNumber == highestPostNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastPostedAt, lastPostedAt) || other.lastPostedAt == lastPostedAt)&&(identical(other.bumped, bumped) || other.bumped == bumped)&&(identical(other.bumpedAt, bumpedAt) || other.bumpedAt == bumpedAt)&&(identical(other.archetype, archetype) || other.archetype == archetype)&&(identical(other.unseen, unseen) || other.unseen == unseen)&&(identical(other.lastReadPostNumber, lastReadPostNumber) || other.lastReadPostNumber == lastReadPostNumber)&&(identical(other.unread, unread) || other.unread == unread)&&(identical(other.newPosts, newPosts) || other.newPosts == newPosts)&&(identical(other.unreadPosts, unreadPosts) || other.unreadPosts == unreadPosts)&&(identical(other.pinned, pinned) || other.pinned == pinned)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt)&&(identical(other.visible, visible) || other.visible == visible)&&(identical(other.closed, closed) || other.closed == closed)&&(identical(other.archived, archived) || other.archived == archived)&&(identical(other.notificationLevel, notificationLevel) || other.notificationLevel == notificationLevel)&&(identical(other.bookmarked, bookmarked) || other.bookmarked == bookmarked)&&(identical(other.liked, liked) || other.liked == liked)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.views, views) || other.views == views)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.hasSummary, hasSummary) || other.hasSummary == hasSummary)&&(identical(other.lastPosterUsername, lastPosterUsername) || other.lastPosterUsername == lastPosterUsername)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.pinnedGlobally, pinnedGlobally) || other.pinnedGlobally == pinnedGlobally)&&const DeepCollectionEquality().equals(other._posters, _posters)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.unpinned, unpinned)&&const DeepCollectionEquality().equals(other._tagsDescriptions, _tagsDescriptions)&&(identical(other.featuredLink, featuredLink) || other.featuredLink == featuredLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,postsCount,replyCount,highestPostNumber,createdAt,lastPostedAt,bumped,bumpedAt,archetype,unseen,lastReadPostNumber,unread,newPosts,unreadPosts,pinned,excerpt,visible,closed,archived,notificationLevel,bookmarked,liked,const DeepCollectionEquality().hash(_tags),views,likeCount,hasSummary,lastPosterUsername,categoryId,pinnedGlobally,const DeepCollectionEquality().hash(_posters),imageUrl,const DeepCollectionEquality().hash(unpinned),const DeepCollectionEquality().hash(_tagsDescriptions),featuredLink]);

@override
String toString() {
  return 'Topic(id: $id, title: $title, postsCount: $postsCount, replyCount: $replyCount, highestPostNumber: $highestPostNumber, createdAt: $createdAt, lastPostedAt: $lastPostedAt, bumped: $bumped, bumpedAt: $bumpedAt, archetype: $archetype, unseen: $unseen, lastReadPostNumber: $lastReadPostNumber, unread: $unread, newPosts: $newPosts, unreadPosts: $unreadPosts, pinned: $pinned, excerpt: $excerpt, visible: $visible, closed: $closed, archived: $archived, notificationLevel: $notificationLevel, bookmarked: $bookmarked, liked: $liked, tags: $tags, views: $views, likeCount: $likeCount, hasSummary: $hasSummary, lastPosterUsername: $lastPosterUsername, categoryId: $categoryId, pinnedGlobally: $pinnedGlobally, posters: $posters, imageUrl: $imageUrl, unpinned: $unpinned, tagsDescriptions: $tagsDescriptions, featuredLink: $featuredLink)';
}


}

/// @nodoc
abstract mixin class _$TopicCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$TopicCopyWith(_Topic value, $Res Function(_Topic) _then) = __$TopicCopyWithImpl;
@override @useResult
$Res call({
 int id, String title,@JsonKey(name: 'posts_count') int postsCount,@JsonKey(name: 'reply_count') int replyCount,@JsonKey(name: 'highest_post_number') int highestPostNumber,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'last_posted_at') String lastPostedAt, bool bumped,@JsonKey(name: 'bumped_at') String bumpedAt, String archetype, bool unseen,@JsonKey(name: 'last_read_post_number') int? lastReadPostNumber, int? unread,@JsonKey(name: 'new_posts') int? newPosts,@JsonKey(name: 'unread_posts') int? unreadPosts, bool pinned, String? excerpt, bool visible, bool closed, bool archived,@JsonKey(name: 'notification_level') int? notificationLevel, bool? bookmarked, bool? liked, List<Object?> tags, int views,@JsonKey(name: 'like_count') int likeCount,@JsonKey(name: 'has_summary') bool hasSummary,@JsonKey(name: 'last_poster_username') String? lastPosterUsername,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'pinned_globally') bool pinnedGlobally, List<Map<String, dynamic>> posters,@JsonKey(name: 'image_url') String? imageUrl, Object? unpinned,@JsonKey(name: 'tags_descriptions') Map<String, dynamic>? tagsDescriptions,@JsonKey(name: 'featured_link') String? featuredLink
});




}
/// @nodoc
class __$TopicCopyWithImpl<$Res>
    implements _$TopicCopyWith<$Res> {
  __$TopicCopyWithImpl(this._self, this._then);

  final _Topic _self;
  final $Res Function(_Topic) _then;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? postsCount = null,Object? replyCount = null,Object? highestPostNumber = null,Object? createdAt = null,Object? lastPostedAt = null,Object? bumped = null,Object? bumpedAt = null,Object? archetype = null,Object? unseen = null,Object? lastReadPostNumber = freezed,Object? unread = freezed,Object? newPosts = freezed,Object? unreadPosts = freezed,Object? pinned = null,Object? excerpt = freezed,Object? visible = null,Object? closed = null,Object? archived = null,Object? notificationLevel = freezed,Object? bookmarked = freezed,Object? liked = freezed,Object? tags = null,Object? views = null,Object? likeCount = null,Object? hasSummary = null,Object? lastPosterUsername = freezed,Object? categoryId = null,Object? pinnedGlobally = null,Object? posters = null,Object? imageUrl = freezed,Object? unpinned = freezed,Object? tagsDescriptions = freezed,Object? featuredLink = freezed,}) {
  return _then(_Topic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,postsCount: null == postsCount ? _self.postsCount : postsCount // ignore: cast_nullable_to_non_nullable
as int,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,highestPostNumber: null == highestPostNumber ? _self.highestPostNumber : highestPostNumber // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,lastPostedAt: null == lastPostedAt ? _self.lastPostedAt : lastPostedAt // ignore: cast_nullable_to_non_nullable
as String,bumped: null == bumped ? _self.bumped : bumped // ignore: cast_nullable_to_non_nullable
as bool,bumpedAt: null == bumpedAt ? _self.bumpedAt : bumpedAt // ignore: cast_nullable_to_non_nullable
as String,archetype: null == archetype ? _self.archetype : archetype // ignore: cast_nullable_to_non_nullable
as String,unseen: null == unseen ? _self.unseen : unseen // ignore: cast_nullable_to_non_nullable
as bool,lastReadPostNumber: freezed == lastReadPostNumber ? _self.lastReadPostNumber : lastReadPostNumber // ignore: cast_nullable_to_non_nullable
as int?,unread: freezed == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int?,newPosts: freezed == newPosts ? _self.newPosts : newPosts // ignore: cast_nullable_to_non_nullable
as int?,unreadPosts: freezed == unreadPosts ? _self.unreadPosts : unreadPosts // ignore: cast_nullable_to_non_nullable
as int?,pinned: null == pinned ? _self.pinned : pinned // ignore: cast_nullable_to_non_nullable
as bool,excerpt: freezed == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String?,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,closed: null == closed ? _self.closed : closed // ignore: cast_nullable_to_non_nullable
as bool,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,notificationLevel: freezed == notificationLevel ? _self.notificationLevel : notificationLevel // ignore: cast_nullable_to_non_nullable
as int?,bookmarked: freezed == bookmarked ? _self.bookmarked : bookmarked // ignore: cast_nullable_to_non_nullable
as bool?,liked: freezed == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<Object?>,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,hasSummary: null == hasSummary ? _self.hasSummary : hasSummary // ignore: cast_nullable_to_non_nullable
as bool,lastPosterUsername: freezed == lastPosterUsername ? _self.lastPosterUsername : lastPosterUsername // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,pinnedGlobally: null == pinnedGlobally ? _self.pinnedGlobally : pinnedGlobally // ignore: cast_nullable_to_non_nullable
as bool,posters: null == posters ? _self._posters : posters // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,unpinned: freezed == unpinned ? _self.unpinned : unpinned ,tagsDescriptions: freezed == tagsDescriptions ? _self._tagsDescriptions : tagsDescriptions // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,featuredLink: freezed == featuredLink ? _self.featuredLink : featuredLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
