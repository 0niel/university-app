// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TopicPost {

@JsonKey(defaultValue: 0) int get id;@JsonKey(defaultValue: '') String get username;@JsonKey(name: 'avatar_template', defaultValue: '') String get avatarTemplate;@JsonKey(name: 'created_at', defaultValue: '') String get createdAt;@JsonKey(defaultValue: '') String get cooked;@JsonKey(name: 'post_number', defaultValue: 0) int get postNumber;@JsonKey(name: 'actions_summary', fromJson: _likeCountFromActions) int get likeCount;
/// Create a copy of TopicPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicPostCopyWith<TopicPost> get copyWith => _$TopicPostCopyWithImpl<TopicPost>(this as TopicPost, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicPost&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.cooked, cooked) || other.cooked == cooked)&&(identical(other.postNumber, postNumber) || other.postNumber == postNumber)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatarTemplate,createdAt,cooked,postNumber,likeCount);

@override
String toString() {
  return 'TopicPost(id: $id, username: $username, avatarTemplate: $avatarTemplate, createdAt: $createdAt, cooked: $cooked, postNumber: $postNumber, likeCount: $likeCount)';
}


}

/// @nodoc
abstract mixin class $TopicPostCopyWith<$Res>  {
  factory $TopicPostCopyWith(TopicPost value, $Res Function(TopicPost) _then) = _$TopicPostCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: 0) int id,@JsonKey(defaultValue: '') String username,@JsonKey(name: 'avatar_template', defaultValue: '') String avatarTemplate,@JsonKey(name: 'created_at', defaultValue: '') String createdAt,@JsonKey(defaultValue: '') String cooked,@JsonKey(name: 'post_number', defaultValue: 0) int postNumber,@JsonKey(name: 'actions_summary', fromJson: _likeCountFromActions) int likeCount
});




}
/// @nodoc
class _$TopicPostCopyWithImpl<$Res>
    implements $TopicPostCopyWith<$Res> {
  _$TopicPostCopyWithImpl(this._self, this._then);

  final TopicPost _self;
  final $Res Function(TopicPost) _then;

/// Create a copy of TopicPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatarTemplate = null,Object? createdAt = null,Object? cooked = null,Object? postNumber = null,Object? likeCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,cooked: null == cooked ? _self.cooked : cooked // ignore: cast_nullable_to_non_nullable
as String,postNumber: null == postNumber ? _self.postNumber : postNumber // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TopicPost].
extension TopicPostPatterns on TopicPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopicPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopicPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopicPost value)  $default,){
final _that = this;
switch (_that) {
case _TopicPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopicPost value)?  $default,){
final _that = this;
switch (_that) {
case _TopicPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: 0)  int id, @JsonKey(defaultValue: '')  String username, @JsonKey(name: 'avatar_template', defaultValue: '')  String avatarTemplate, @JsonKey(name: 'created_at', defaultValue: '')  String createdAt, @JsonKey(defaultValue: '')  String cooked, @JsonKey(name: 'post_number', defaultValue: 0)  int postNumber, @JsonKey(name: 'actions_summary', fromJson: _likeCountFromActions)  int likeCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopicPost() when $default != null:
return $default(_that.id,_that.username,_that.avatarTemplate,_that.createdAt,_that.cooked,_that.postNumber,_that.likeCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: 0)  int id, @JsonKey(defaultValue: '')  String username, @JsonKey(name: 'avatar_template', defaultValue: '')  String avatarTemplate, @JsonKey(name: 'created_at', defaultValue: '')  String createdAt, @JsonKey(defaultValue: '')  String cooked, @JsonKey(name: 'post_number', defaultValue: 0)  int postNumber, @JsonKey(name: 'actions_summary', fromJson: _likeCountFromActions)  int likeCount)  $default,) {final _that = this;
switch (_that) {
case _TopicPost():
return $default(_that.id,_that.username,_that.avatarTemplate,_that.createdAt,_that.cooked,_that.postNumber,_that.likeCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: 0)  int id, @JsonKey(defaultValue: '')  String username, @JsonKey(name: 'avatar_template', defaultValue: '')  String avatarTemplate, @JsonKey(name: 'created_at', defaultValue: '')  String createdAt, @JsonKey(defaultValue: '')  String cooked, @JsonKey(name: 'post_number', defaultValue: 0)  int postNumber, @JsonKey(name: 'actions_summary', fromJson: _likeCountFromActions)  int likeCount)?  $default,) {final _that = this;
switch (_that) {
case _TopicPost() when $default != null:
return $default(_that.id,_that.username,_that.avatarTemplate,_that.createdAt,_that.cooked,_that.postNumber,_that.likeCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createToJson: false)

class _TopicPost implements TopicPost {
  const _TopicPost({@JsonKey(defaultValue: 0) required this.id, @JsonKey(defaultValue: '') required this.username, @JsonKey(name: 'avatar_template', defaultValue: '') required this.avatarTemplate, @JsonKey(name: 'created_at', defaultValue: '') required this.createdAt, @JsonKey(defaultValue: '') required this.cooked, @JsonKey(name: 'post_number', defaultValue: 0) required this.postNumber, @JsonKey(name: 'actions_summary', fromJson: _likeCountFromActions) required this.likeCount});
  factory _TopicPost.fromJson(Map<String, dynamic> json) => _$TopicPostFromJson(json);

@override@JsonKey(defaultValue: 0) final  int id;
@override@JsonKey(defaultValue: '') final  String username;
@override@JsonKey(name: 'avatar_template', defaultValue: '') final  String avatarTemplate;
@override@JsonKey(name: 'created_at', defaultValue: '') final  String createdAt;
@override@JsonKey(defaultValue: '') final  String cooked;
@override@JsonKey(name: 'post_number', defaultValue: 0) final  int postNumber;
@override@JsonKey(name: 'actions_summary', fromJson: _likeCountFromActions) final  int likeCount;

/// Create a copy of TopicPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicPostCopyWith<_TopicPost> get copyWith => __$TopicPostCopyWithImpl<_TopicPost>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicPost&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.cooked, cooked) || other.cooked == cooked)&&(identical(other.postNumber, postNumber) || other.postNumber == postNumber)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatarTemplate,createdAt,cooked,postNumber,likeCount);

@override
String toString() {
  return 'TopicPost(id: $id, username: $username, avatarTemplate: $avatarTemplate, createdAt: $createdAt, cooked: $cooked, postNumber: $postNumber, likeCount: $likeCount)';
}


}

/// @nodoc
abstract mixin class _$TopicPostCopyWith<$Res> implements $TopicPostCopyWith<$Res> {
  factory _$TopicPostCopyWith(_TopicPost value, $Res Function(_TopicPost) _then) = __$TopicPostCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: 0) int id,@JsonKey(defaultValue: '') String username,@JsonKey(name: 'avatar_template', defaultValue: '') String avatarTemplate,@JsonKey(name: 'created_at', defaultValue: '') String createdAt,@JsonKey(defaultValue: '') String cooked,@JsonKey(name: 'post_number', defaultValue: 0) int postNumber,@JsonKey(name: 'actions_summary', fromJson: _likeCountFromActions) int likeCount
});




}
/// @nodoc
class __$TopicPostCopyWithImpl<$Res>
    implements _$TopicPostCopyWith<$Res> {
  __$TopicPostCopyWithImpl(this._self, this._then);

  final _TopicPost _self;
  final $Res Function(_TopicPost) _then;

/// Create a copy of TopicPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatarTemplate = null,Object? createdAt = null,Object? cooked = null,Object? postNumber = null,Object? likeCount = null,}) {
  return _then(_TopicPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,cooked: null == cooked ? _self.cooked : cooked // ignore: cast_nullable_to_non_nullable
as String,postNumber: null == postNumber ? _self.postNumber : postNumber // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
