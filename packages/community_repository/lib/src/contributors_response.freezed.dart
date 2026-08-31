// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contributors_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContributorsResponse {

 List<Contributor> get contributors;
/// Create a copy of ContributorsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContributorsResponseCopyWith<ContributorsResponse> get copyWith => _$ContributorsResponseCopyWithImpl<ContributorsResponse>(this as ContributorsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContributorsResponse&&const DeepCollectionEquality().equals(other.contributors, contributors));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(contributors));

@override
String toString() {
  return 'ContributorsResponse(contributors: $contributors)';
}


}

/// @nodoc
abstract mixin class $ContributorsResponseCopyWith<$Res>  {
  factory $ContributorsResponseCopyWith(ContributorsResponse value, $Res Function(ContributorsResponse) _then) = _$ContributorsResponseCopyWithImpl;
@useResult
$Res call({
 List<Contributor> contributors
});




}
/// @nodoc
class _$ContributorsResponseCopyWithImpl<$Res>
    implements $ContributorsResponseCopyWith<$Res> {
  _$ContributorsResponseCopyWithImpl(this._self, this._then);

  final ContributorsResponse _self;
  final $Res Function(ContributorsResponse) _then;

/// Create a copy of ContributorsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contributors = null,}) {
  return _then(_self.copyWith(
contributors: null == contributors ? _self.contributors : contributors // ignore: cast_nullable_to_non_nullable
as List<Contributor>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContributorsResponse].
extension ContributorsResponsePatterns on ContributorsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContributorsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContributorsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContributorsResponse value)  $default,){
final _that = this;
switch (_that) {
case _ContributorsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContributorsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ContributorsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Contributor> contributors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContributorsResponse() when $default != null:
return $default(_that.contributors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Contributor> contributors)  $default,) {final _that = this;
switch (_that) {
case _ContributorsResponse():
return $default(_that.contributors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Contributor> contributors)?  $default,) {final _that = this;
switch (_that) {
case _ContributorsResponse() when $default != null:
return $default(_that.contributors);case _:
  return null;

}
}

}

/// @nodoc


class _ContributorsResponse implements ContributorsResponse {
  const _ContributorsResponse({required final  List<Contributor> contributors}): _contributors = contributors;


 final  List<Contributor> _contributors;
@override List<Contributor> get contributors {
  if (_contributors is EqualUnmodifiableListView) return _contributors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contributors);
}


/// Create a copy of ContributorsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContributorsResponseCopyWith<_ContributorsResponse> get copyWith => __$ContributorsResponseCopyWithImpl<_ContributorsResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContributorsResponse&&const DeepCollectionEquality().equals(other._contributors, _contributors));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_contributors));

@override
String toString() {
  return 'ContributorsResponse(contributors: $contributors)';
}


}

/// @nodoc
abstract mixin class _$ContributorsResponseCopyWith<$Res> implements $ContributorsResponseCopyWith<$Res> {
  factory _$ContributorsResponseCopyWith(_ContributorsResponse value, $Res Function(_ContributorsResponse) _then) = __$ContributorsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Contributor> contributors
});




}
/// @nodoc
class __$ContributorsResponseCopyWithImpl<$Res>
    implements _$ContributorsResponseCopyWith<$Res> {
  __$ContributorsResponseCopyWithImpl(this._self, this._then);

  final _ContributorsResponse _self;
  final $Res Function(_ContributorsResponse) _then;

/// Create a copy of ContributorsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contributors = null,}) {
  return _then(_ContributorsResponse(
contributors: null == contributors ? _self._contributors : contributors // ignore: cast_nullable_to_non_nullable
as List<Contributor>,
  ));
}


}

/// @nodoc
mixin _$DiscourseTopicPoster {

 int get userId;
/// Create a copy of DiscourseTopicPoster
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscourseTopicPosterCopyWith<DiscourseTopicPoster> get copyWith => _$DiscourseTopicPosterCopyWithImpl<DiscourseTopicPoster>(this as DiscourseTopicPoster, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscourseTopicPoster&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'DiscourseTopicPoster(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $DiscourseTopicPosterCopyWith<$Res>  {
  factory $DiscourseTopicPosterCopyWith(DiscourseTopicPoster value, $Res Function(DiscourseTopicPoster) _then) = _$DiscourseTopicPosterCopyWithImpl;
@useResult
$Res call({
 int userId
});




}
/// @nodoc
class _$DiscourseTopicPosterCopyWithImpl<$Res>
    implements $DiscourseTopicPosterCopyWith<$Res> {
  _$DiscourseTopicPosterCopyWithImpl(this._self, this._then);

  final DiscourseTopicPoster _self;
  final $Res Function(DiscourseTopicPoster) _then;

/// Create a copy of DiscourseTopicPoster
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscourseTopicPoster].
extension DiscourseTopicPosterPatterns on DiscourseTopicPoster {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscourseTopicPoster value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscourseTopicPoster() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscourseTopicPoster value)  $default,){
final _that = this;
switch (_that) {
case _DiscourseTopicPoster():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscourseTopicPoster value)?  $default,){
final _that = this;
switch (_that) {
case _DiscourseTopicPoster() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscourseTopicPoster() when $default != null:
return $default(_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId)  $default,) {final _that = this;
switch (_that) {
case _DiscourseTopicPoster():
return $default(_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId)?  $default,) {final _that = this;
switch (_that) {
case _DiscourseTopicPoster() when $default != null:
return $default(_that.userId);case _:
  return null;

}
}

}

/// @nodoc


class _DiscourseTopicPoster implements DiscourseTopicPoster {
  const _DiscourseTopicPoster({required this.userId});


@override final  int userId;

/// Create a copy of DiscourseTopicPoster
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscourseTopicPosterCopyWith<_DiscourseTopicPoster> get copyWith => __$DiscourseTopicPosterCopyWithImpl<_DiscourseTopicPoster>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscourseTopicPoster&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'DiscourseTopicPoster(userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$DiscourseTopicPosterCopyWith<$Res> implements $DiscourseTopicPosterCopyWith<$Res> {
  factory _$DiscourseTopicPosterCopyWith(_DiscourseTopicPoster value, $Res Function(_DiscourseTopicPoster) _then) = __$DiscourseTopicPosterCopyWithImpl;
@override @useResult
$Res call({
 int userId
});




}
/// @nodoc
class __$DiscourseTopicPosterCopyWithImpl<$Res>
    implements _$DiscourseTopicPosterCopyWith<$Res> {
  __$DiscourseTopicPosterCopyWithImpl(this._self, this._then);

  final _DiscourseTopicPoster _self;
  final $Res Function(_DiscourseTopicPoster) _then;

/// Create a copy of DiscourseTopicPoster
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(_DiscourseTopicPoster(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$DiscourseTopic {

 int get id; String get title; int get postsCount; int get replyCount; int get likeCount; int get views; List<DiscourseTopicPoster> get posters; DateTime? get lastPostedAt; DateTime? get createdAt; String? get imageUrl; String? get excerpt;
/// Create a copy of DiscourseTopic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscourseTopicCopyWith<DiscourseTopic> get copyWith => _$DiscourseTopicCopyWithImpl<DiscourseTopic>(this as DiscourseTopic, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscourseTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.postsCount, postsCount) || other.postsCount == postsCount)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.views, views) || other.views == views)&&const DeepCollectionEquality().equals(other.posters, posters)&&(identical(other.lastPostedAt, lastPostedAt) || other.lastPostedAt == lastPostedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,postsCount,replyCount,likeCount,views,const DeepCollectionEquality().hash(posters),lastPostedAt,createdAt,imageUrl,excerpt);

@override
String toString() {
  return 'DiscourseTopic(id: $id, title: $title, postsCount: $postsCount, replyCount: $replyCount, likeCount: $likeCount, views: $views, posters: $posters, lastPostedAt: $lastPostedAt, createdAt: $createdAt, imageUrl: $imageUrl, excerpt: $excerpt)';
}


}

/// @nodoc
abstract mixin class $DiscourseTopicCopyWith<$Res>  {
  factory $DiscourseTopicCopyWith(DiscourseTopic value, $Res Function(DiscourseTopic) _then) = _$DiscourseTopicCopyWithImpl;
@useResult
$Res call({
 int id, String title, int postsCount, int replyCount, int likeCount, int views, List<DiscourseTopicPoster> posters, DateTime? lastPostedAt, DateTime? createdAt, String? imageUrl, String? excerpt
});




}
/// @nodoc
class _$DiscourseTopicCopyWithImpl<$Res>
    implements $DiscourseTopicCopyWith<$Res> {
  _$DiscourseTopicCopyWithImpl(this._self, this._then);

  final DiscourseTopic _self;
  final $Res Function(DiscourseTopic) _then;

/// Create a copy of DiscourseTopic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? postsCount = null,Object? replyCount = null,Object? likeCount = null,Object? views = null,Object? posters = null,Object? lastPostedAt = freezed,Object? createdAt = freezed,Object? imageUrl = freezed,Object? excerpt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,postsCount: null == postsCount ? _self.postsCount : postsCount // ignore: cast_nullable_to_non_nullable
as int,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,posters: null == posters ? _self.posters : posters // ignore: cast_nullable_to_non_nullable
as List<DiscourseTopicPoster>,lastPostedAt: freezed == lastPostedAt ? _self.lastPostedAt : lastPostedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,excerpt: freezed == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscourseTopic].
extension DiscourseTopicPatterns on DiscourseTopic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscourseTopic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscourseTopic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscourseTopic value)  $default,){
final _that = this;
switch (_that) {
case _DiscourseTopic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscourseTopic value)?  $default,){
final _that = this;
switch (_that) {
case _DiscourseTopic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  int postsCount,  int replyCount,  int likeCount,  int views,  List<DiscourseTopicPoster> posters,  DateTime? lastPostedAt,  DateTime? createdAt,  String? imageUrl,  String? excerpt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscourseTopic() when $default != null:
return $default(_that.id,_that.title,_that.postsCount,_that.replyCount,_that.likeCount,_that.views,_that.posters,_that.lastPostedAt,_that.createdAt,_that.imageUrl,_that.excerpt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  int postsCount,  int replyCount,  int likeCount,  int views,  List<DiscourseTopicPoster> posters,  DateTime? lastPostedAt,  DateTime? createdAt,  String? imageUrl,  String? excerpt)  $default,) {final _that = this;
switch (_that) {
case _DiscourseTopic():
return $default(_that.id,_that.title,_that.postsCount,_that.replyCount,_that.likeCount,_that.views,_that.posters,_that.lastPostedAt,_that.createdAt,_that.imageUrl,_that.excerpt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  int postsCount,  int replyCount,  int likeCount,  int views,  List<DiscourseTopicPoster> posters,  DateTime? lastPostedAt,  DateTime? createdAt,  String? imageUrl,  String? excerpt)?  $default,) {final _that = this;
switch (_that) {
case _DiscourseTopic() when $default != null:
return $default(_that.id,_that.title,_that.postsCount,_that.replyCount,_that.likeCount,_that.views,_that.posters,_that.lastPostedAt,_that.createdAt,_that.imageUrl,_that.excerpt);case _:
  return null;

}
}

}

/// @nodoc


class _DiscourseTopic implements DiscourseTopic {
  const _DiscourseTopic({required this.id, required this.title, required this.postsCount, required this.replyCount, required this.likeCount, required this.views, required final  List<DiscourseTopicPoster> posters, this.lastPostedAt, this.createdAt, this.imageUrl, this.excerpt}): _posters = posters;


@override final  int id;
@override final  String title;
@override final  int postsCount;
@override final  int replyCount;
@override final  int likeCount;
@override final  int views;
 final  List<DiscourseTopicPoster> _posters;
@override List<DiscourseTopicPoster> get posters {
  if (_posters is EqualUnmodifiableListView) return _posters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posters);
}

@override final  DateTime? lastPostedAt;
@override final  DateTime? createdAt;
@override final  String? imageUrl;
@override final  String? excerpt;

/// Create a copy of DiscourseTopic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscourseTopicCopyWith<_DiscourseTopic> get copyWith => __$DiscourseTopicCopyWithImpl<_DiscourseTopic>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscourseTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.postsCount, postsCount) || other.postsCount == postsCount)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.views, views) || other.views == views)&&const DeepCollectionEquality().equals(other._posters, _posters)&&(identical(other.lastPostedAt, lastPostedAt) || other.lastPostedAt == lastPostedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.excerpt, excerpt) || other.excerpt == excerpt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,postsCount,replyCount,likeCount,views,const DeepCollectionEquality().hash(_posters),lastPostedAt,createdAt,imageUrl,excerpt);

@override
String toString() {
  return 'DiscourseTopic(id: $id, title: $title, postsCount: $postsCount, replyCount: $replyCount, likeCount: $likeCount, views: $views, posters: $posters, lastPostedAt: $lastPostedAt, createdAt: $createdAt, imageUrl: $imageUrl, excerpt: $excerpt)';
}


}

/// @nodoc
abstract mixin class _$DiscourseTopicCopyWith<$Res> implements $DiscourseTopicCopyWith<$Res> {
  factory _$DiscourseTopicCopyWith(_DiscourseTopic value, $Res Function(_DiscourseTopic) _then) = __$DiscourseTopicCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, int postsCount, int replyCount, int likeCount, int views, List<DiscourseTopicPoster> posters, DateTime? lastPostedAt, DateTime? createdAt, String? imageUrl, String? excerpt
});




}
/// @nodoc
class __$DiscourseTopicCopyWithImpl<$Res>
    implements _$DiscourseTopicCopyWith<$Res> {
  __$DiscourseTopicCopyWithImpl(this._self, this._then);

  final _DiscourseTopic _self;
  final $Res Function(_DiscourseTopic) _then;

/// Create a copy of DiscourseTopic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? postsCount = null,Object? replyCount = null,Object? likeCount = null,Object? views = null,Object? posters = null,Object? lastPostedAt = freezed,Object? createdAt = freezed,Object? imageUrl = freezed,Object? excerpt = freezed,}) {
  return _then(_DiscourseTopic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,postsCount: null == postsCount ? _self.postsCount : postsCount // ignore: cast_nullable_to_non_nullable
as int,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,posters: null == posters ? _self._posters : posters // ignore: cast_nullable_to_non_nullable
as List<DiscourseTopicPoster>,lastPostedAt: freezed == lastPostedAt ? _self.lastPostedAt : lastPostedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,excerpt: freezed == excerpt ? _self.excerpt : excerpt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$DiscourseUser {

 int get id; String get username; String get avatarTemplate;
/// Create a copy of DiscourseUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscourseUserCopyWith<DiscourseUser> get copyWith => _$DiscourseUserCopyWithImpl<DiscourseUser>(this as DiscourseUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscourseUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate));
}


@override
int get hashCode => Object.hash(runtimeType,id,username,avatarTemplate);

@override
String toString() {
  return 'DiscourseUser(id: $id, username: $username, avatarTemplate: $avatarTemplate)';
}


}

/// @nodoc
abstract mixin class $DiscourseUserCopyWith<$Res>  {
  factory $DiscourseUserCopyWith(DiscourseUser value, $Res Function(DiscourseUser) _then) = _$DiscourseUserCopyWithImpl;
@useResult
$Res call({
 int id, String username, String avatarTemplate
});




}
/// @nodoc
class _$DiscourseUserCopyWithImpl<$Res>
    implements $DiscourseUserCopyWith<$Res> {
  _$DiscourseUserCopyWithImpl(this._self, this._then);

  final DiscourseUser _self;
  final $Res Function(DiscourseUser) _then;

/// Create a copy of DiscourseUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatarTemplate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscourseUser].
extension DiscourseUserPatterns on DiscourseUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscourseUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscourseUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscourseUser value)  $default,){
final _that = this;
switch (_that) {
case _DiscourseUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscourseUser value)?  $default,){
final _that = this;
switch (_that) {
case _DiscourseUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username,  String avatarTemplate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscourseUser() when $default != null:
return $default(_that.id,_that.username,_that.avatarTemplate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username,  String avatarTemplate)  $default,) {final _that = this;
switch (_that) {
case _DiscourseUser():
return $default(_that.id,_that.username,_that.avatarTemplate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username,  String avatarTemplate)?  $default,) {final _that = this;
switch (_that) {
case _DiscourseUser() when $default != null:
return $default(_that.id,_that.username,_that.avatarTemplate);case _:
  return null;

}
}

}

/// @nodoc


class _DiscourseUser implements DiscourseUser {
  const _DiscourseUser({required this.id, required this.username, required this.avatarTemplate});


@override final  int id;
@override final  String username;
@override final  String avatarTemplate;

/// Create a copy of DiscourseUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscourseUserCopyWith<_DiscourseUser> get copyWith => __$DiscourseUserCopyWithImpl<_DiscourseUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscourseUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate));
}


@override
int get hashCode => Object.hash(runtimeType,id,username,avatarTemplate);

@override
String toString() {
  return 'DiscourseUser(id: $id, username: $username, avatarTemplate: $avatarTemplate)';
}


}

/// @nodoc
abstract mixin class _$DiscourseUserCopyWith<$Res> implements $DiscourseUserCopyWith<$Res> {
  factory _$DiscourseUserCopyWith(_DiscourseUser value, $Res Function(_DiscourseUser) _then) = __$DiscourseUserCopyWithImpl;
@override @useResult
$Res call({
 int id, String username, String avatarTemplate
});




}
/// @nodoc
class __$DiscourseUserCopyWithImpl<$Res>
    implements _$DiscourseUserCopyWith<$Res> {
  __$DiscourseUserCopyWithImpl(this._self, this._then);

  final _DiscourseUser _self;
  final $Res Function(_DiscourseUser) _then;

/// Create a copy of DiscourseUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatarTemplate = null,}) {
  return _then(_DiscourseUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TopTopicsResponse {

 List<DiscourseTopic> get topics; List<DiscourseUser> get users;
/// Create a copy of TopTopicsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopTopicsResponseCopyWith<TopTopicsResponse> get copyWith => _$TopTopicsResponseCopyWithImpl<TopTopicsResponse>(this as TopTopicsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopTopicsResponse&&const DeepCollectionEquality().equals(other.topics, topics)&&const DeepCollectionEquality().equals(other.users, users));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(topics),const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'TopTopicsResponse(topics: $topics, users: $users)';
}


}

/// @nodoc
abstract mixin class $TopTopicsResponseCopyWith<$Res>  {
  factory $TopTopicsResponseCopyWith(TopTopicsResponse value, $Res Function(TopTopicsResponse) _then) = _$TopTopicsResponseCopyWithImpl;
@useResult
$Res call({
 List<DiscourseTopic> topics, List<DiscourseUser> users
});




}
/// @nodoc
class _$TopTopicsResponseCopyWithImpl<$Res>
    implements $TopTopicsResponseCopyWith<$Res> {
  _$TopTopicsResponseCopyWithImpl(this._self, this._then);

  final TopTopicsResponse _self;
  final $Res Function(TopTopicsResponse) _then;

/// Create a copy of TopTopicsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topics = null,Object? users = null,}) {
  return _then(_self.copyWith(
topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<DiscourseTopic>,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<DiscourseUser>,
  ));
}

}


/// Adds pattern-matching-related methods to [TopTopicsResponse].
extension TopTopicsResponsePatterns on TopTopicsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopTopicsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopTopicsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopTopicsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TopTopicsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopTopicsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TopTopicsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DiscourseTopic> topics,  List<DiscourseUser> users)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopTopicsResponse() when $default != null:
return $default(_that.topics,_that.users);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DiscourseTopic> topics,  List<DiscourseUser> users)  $default,) {final _that = this;
switch (_that) {
case _TopTopicsResponse():
return $default(_that.topics,_that.users);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DiscourseTopic> topics,  List<DiscourseUser> users)?  $default,) {final _that = this;
switch (_that) {
case _TopTopicsResponse() when $default != null:
return $default(_that.topics,_that.users);case _:
  return null;

}
}

}

/// @nodoc


class _TopTopicsResponse implements TopTopicsResponse {
  const _TopTopicsResponse({required final  List<DiscourseTopic> topics, required final  List<DiscourseUser> users}): _topics = topics,_users = users;


 final  List<DiscourseTopic> _topics;
@override List<DiscourseTopic> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}

 final  List<DiscourseUser> _users;
@override List<DiscourseUser> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of TopTopicsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopTopicsResponseCopyWith<_TopTopicsResponse> get copyWith => __$TopTopicsResponseCopyWithImpl<_TopTopicsResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopTopicsResponse&&const DeepCollectionEquality().equals(other._topics, _topics)&&const DeepCollectionEquality().equals(other._users, _users));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_topics),const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'TopTopicsResponse(topics: $topics, users: $users)';
}


}

/// @nodoc
abstract mixin class _$TopTopicsResponseCopyWith<$Res> implements $TopTopicsResponseCopyWith<$Res> {
  factory _$TopTopicsResponseCopyWith(_TopTopicsResponse value, $Res Function(_TopTopicsResponse) _then) = __$TopTopicsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<DiscourseTopic> topics, List<DiscourseUser> users
});




}
/// @nodoc
class __$TopTopicsResponseCopyWithImpl<$Res>
    implements _$TopTopicsResponseCopyWith<$Res> {
  __$TopTopicsResponseCopyWithImpl(this._self, this._then);

  final _TopTopicsResponse _self;
  final $Res Function(_TopTopicsResponse) _then;

/// Create a copy of TopTopicsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topics = null,Object? users = null,}) {
  return _then(_TopTopicsResponse(
topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<DiscourseTopic>,users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<DiscourseUser>,
  ));
}


}

/// @nodoc
mixin _$DiscoursePost {

 int get id; int get topicId; String get username; String get avatarTemplate; String get cooked; DateTime get createdAt;
/// Create a copy of DiscoursePost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoursePostCopyWith<DiscoursePost> get copyWith => _$DiscoursePostCopyWithImpl<DiscoursePost>(this as DiscoursePost, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoursePost&&(identical(other.id, id) || other.id == id)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate)&&(identical(other.cooked, cooked) || other.cooked == cooked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,topicId,username,avatarTemplate,cooked,createdAt);

@override
String toString() {
  return 'DiscoursePost(id: $id, topicId: $topicId, username: $username, avatarTemplate: $avatarTemplate, cooked: $cooked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DiscoursePostCopyWith<$Res>  {
  factory $DiscoursePostCopyWith(DiscoursePost value, $Res Function(DiscoursePost) _then) = _$DiscoursePostCopyWithImpl;
@useResult
$Res call({
 int id, int topicId, String username, String avatarTemplate, String cooked, DateTime createdAt
});




}
/// @nodoc
class _$DiscoursePostCopyWithImpl<$Res>
    implements $DiscoursePostCopyWith<$Res> {
  _$DiscoursePostCopyWithImpl(this._self, this._then);

  final DiscoursePost _self;
  final $Res Function(DiscoursePost) _then;

/// Create a copy of DiscoursePost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? topicId = null,Object? username = null,Object? avatarTemplate = null,Object? cooked = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,cooked: null == cooked ? _self.cooked : cooked // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoursePost].
extension DiscoursePostPatterns on DiscoursePost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoursePost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoursePost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoursePost value)  $default,){
final _that = this;
switch (_that) {
case _DiscoursePost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoursePost value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoursePost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int topicId,  String username,  String avatarTemplate,  String cooked,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoursePost() when $default != null:
return $default(_that.id,_that.topicId,_that.username,_that.avatarTemplate,_that.cooked,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int topicId,  String username,  String avatarTemplate,  String cooked,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DiscoursePost():
return $default(_that.id,_that.topicId,_that.username,_that.avatarTemplate,_that.cooked,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int topicId,  String username,  String avatarTemplate,  String cooked,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DiscoursePost() when $default != null:
return $default(_that.id,_that.topicId,_that.username,_that.avatarTemplate,_that.cooked,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoursePost implements DiscoursePost {
  const _DiscoursePost({required this.id, required this.topicId, required this.username, required this.avatarTemplate, required this.cooked, required this.createdAt});


@override final  int id;
@override final  int topicId;
@override final  String username;
@override final  String avatarTemplate;
@override final  String cooked;
@override final  DateTime createdAt;

/// Create a copy of DiscoursePost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoursePostCopyWith<_DiscoursePost> get copyWith => __$DiscoursePostCopyWithImpl<_DiscoursePost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoursePost&&(identical(other.id, id) || other.id == id)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate)&&(identical(other.cooked, cooked) || other.cooked == cooked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,topicId,username,avatarTemplate,cooked,createdAt);

@override
String toString() {
  return 'DiscoursePost(id: $id, topicId: $topicId, username: $username, avatarTemplate: $avatarTemplate, cooked: $cooked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DiscoursePostCopyWith<$Res> implements $DiscoursePostCopyWith<$Res> {
  factory _$DiscoursePostCopyWith(_DiscoursePost value, $Res Function(_DiscoursePost) _then) = __$DiscoursePostCopyWithImpl;
@override @useResult
$Res call({
 int id, int topicId, String username, String avatarTemplate, String cooked, DateTime createdAt
});




}
/// @nodoc
class __$DiscoursePostCopyWithImpl<$Res>
    implements _$DiscoursePostCopyWith<$Res> {
  __$DiscoursePostCopyWithImpl(this._self, this._then);

  final _DiscoursePost _self;
  final $Res Function(_DiscoursePost) _then;

/// Create a copy of DiscoursePost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? topicId = null,Object? username = null,Object? avatarTemplate = null,Object? cooked = null,Object? createdAt = null,}) {
  return _then(_DiscoursePost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,cooked: null == cooked ? _self.cooked : cooked // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$DiscoursePostComment {

 int get id; String get username; String get avatarTemplate; String get cooked; DateTime get createdAt; int get likeCount;
/// Create a copy of DiscoursePostComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoursePostCommentCopyWith<DiscoursePostComment> get copyWith => _$DiscoursePostCommentCopyWithImpl<DiscoursePostComment>(this as DiscoursePostComment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoursePostComment&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate)&&(identical(other.cooked, cooked) || other.cooked == cooked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,username,avatarTemplate,cooked,createdAt,likeCount);

@override
String toString() {
  return 'DiscoursePostComment(id: $id, username: $username, avatarTemplate: $avatarTemplate, cooked: $cooked, createdAt: $createdAt, likeCount: $likeCount)';
}


}

/// @nodoc
abstract mixin class $DiscoursePostCommentCopyWith<$Res>  {
  factory $DiscoursePostCommentCopyWith(DiscoursePostComment value, $Res Function(DiscoursePostComment) _then) = _$DiscoursePostCommentCopyWithImpl;
@useResult
$Res call({
 int id, String username, String avatarTemplate, String cooked, DateTime createdAt, int likeCount
});




}
/// @nodoc
class _$DiscoursePostCommentCopyWithImpl<$Res>
    implements $DiscoursePostCommentCopyWith<$Res> {
  _$DiscoursePostCommentCopyWithImpl(this._self, this._then);

  final DiscoursePostComment _self;
  final $Res Function(DiscoursePostComment) _then;

/// Create a copy of DiscoursePostComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatarTemplate = null,Object? cooked = null,Object? createdAt = null,Object? likeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,cooked: null == cooked ? _self.cooked : cooked // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoursePostComment].
extension DiscoursePostCommentPatterns on DiscoursePostComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoursePostComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoursePostComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoursePostComment value)  $default,){
final _that = this;
switch (_that) {
case _DiscoursePostComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoursePostComment value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoursePostComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username,  String avatarTemplate,  String cooked,  DateTime createdAt,  int likeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoursePostComment() when $default != null:
return $default(_that.id,_that.username,_that.avatarTemplate,_that.cooked,_that.createdAt,_that.likeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username,  String avatarTemplate,  String cooked,  DateTime createdAt,  int likeCount)  $default,) {final _that = this;
switch (_that) {
case _DiscoursePostComment():
return $default(_that.id,_that.username,_that.avatarTemplate,_that.cooked,_that.createdAt,_that.likeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username,  String avatarTemplate,  String cooked,  DateTime createdAt,  int likeCount)?  $default,) {final _that = this;
switch (_that) {
case _DiscoursePostComment() when $default != null:
return $default(_that.id,_that.username,_that.avatarTemplate,_that.cooked,_that.createdAt,_that.likeCount);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoursePostComment implements DiscoursePostComment {
  const _DiscoursePostComment({required this.id, required this.username, required this.avatarTemplate, required this.cooked, required this.createdAt, this.likeCount = 0});


@override final  int id;
@override final  String username;
@override final  String avatarTemplate;
@override final  String cooked;
@override final  DateTime createdAt;
@override@JsonKey() final  int likeCount;

/// Create a copy of DiscoursePostComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoursePostCommentCopyWith<_DiscoursePostComment> get copyWith => __$DiscoursePostCommentCopyWithImpl<_DiscoursePostComment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoursePostComment&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate)&&(identical(other.cooked, cooked) || other.cooked == cooked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,username,avatarTemplate,cooked,createdAt,likeCount);

@override
String toString() {
  return 'DiscoursePostComment(id: $id, username: $username, avatarTemplate: $avatarTemplate, cooked: $cooked, createdAt: $createdAt, likeCount: $likeCount)';
}


}

/// @nodoc
abstract mixin class _$DiscoursePostCommentCopyWith<$Res> implements $DiscoursePostCommentCopyWith<$Res> {
  factory _$DiscoursePostCommentCopyWith(_DiscoursePostComment value, $Res Function(_DiscoursePostComment) _then) = __$DiscoursePostCommentCopyWithImpl;
@override @useResult
$Res call({
 int id, String username, String avatarTemplate, String cooked, DateTime createdAt, int likeCount
});




}
/// @nodoc
class __$DiscoursePostCommentCopyWithImpl<$Res>
    implements _$DiscoursePostCommentCopyWith<$Res> {
  __$DiscoursePostCommentCopyWithImpl(this._self, this._then);

  final _DiscoursePostComment _self;
  final $Res Function(_DiscoursePostComment) _then;

/// Create a copy of DiscoursePostComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatarTemplate = null,Object? cooked = null,Object? createdAt = null,Object? likeCount = null,}) {
  return _then(_DiscoursePostComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,cooked: null == cooked ? _self.cooked : cooked // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
