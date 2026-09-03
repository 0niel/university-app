// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_post_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupPostComment {

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get postId;@JsonKey(defaultValue: '') String get body;@JsonKey(defaultValue: '') String get authorName;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt; bool get isMine; bool get canDelete;
/// Create a copy of GroupPostComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupPostCommentCopyWith<GroupPostComment> get copyWith => _$GroupPostCommentCopyWithImpl<GroupPostComment>(this as GroupPostComment, _$identity);

  /// Serializes this GroupPostComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupPostComment&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.body, body) || other.body == body)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,body,authorName,createdAt,isMine,canDelete);

@override
String toString() {
  return 'GroupPostComment(id: $id, postId: $postId, body: $body, authorName: $authorName, createdAt: $createdAt, isMine: $isMine, canDelete: $canDelete)';
}


}

/// @nodoc
abstract mixin class $GroupPostCommentCopyWith<$Res>  {
  factory $GroupPostCommentCopyWith(GroupPostComment value, $Res Function(GroupPostComment) _then) = _$GroupPostCommentCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String postId,@JsonKey(defaultValue: '') String body,@JsonKey(defaultValue: '') String authorName,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isMine, bool canDelete
});




}
/// @nodoc
class _$GroupPostCommentCopyWithImpl<$Res>
    implements $GroupPostCommentCopyWith<$Res> {
  _$GroupPostCommentCopyWithImpl(this._self, this._then);

  final GroupPostComment _self;
  final $Res Function(GroupPostComment) _then;

/// Create a copy of GroupPostComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postId = null,Object? body = null,Object? authorName = null,Object? createdAt = freezed,Object? isMine = null,Object? canDelete = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupPostComment].
extension GroupPostCommentPatterns on GroupPostComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupPostComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupPostComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupPostComment value)  $default,){
final _that = this;
switch (_that) {
case _GroupPostComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupPostComment value)?  $default,){
final _that = this;
switch (_that) {
case _GroupPostComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String postId, @JsonKey(defaultValue: '')  String body, @JsonKey(defaultValue: '')  String authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine,  bool canDelete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupPostComment() when $default != null:
return $default(_that.id,_that.postId,_that.body,_that.authorName,_that.createdAt,_that.isMine,_that.canDelete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String postId, @JsonKey(defaultValue: '')  String body, @JsonKey(defaultValue: '')  String authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine,  bool canDelete)  $default,) {final _that = this;
switch (_that) {
case _GroupPostComment():
return $default(_that.id,_that.postId,_that.body,_that.authorName,_that.createdAt,_that.isMine,_that.canDelete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String postId, @JsonKey(defaultValue: '')  String body, @JsonKey(defaultValue: '')  String authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine,  bool canDelete)?  $default,) {final _that = this;
switch (_that) {
case _GroupPostComment() when $default != null:
return $default(_that.id,_that.postId,_that.body,_that.authorName,_that.createdAt,_that.isMine,_that.canDelete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupPostComment implements GroupPostComment {
  const _GroupPostComment({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.postId, @JsonKey(defaultValue: '') required this.body, @JsonKey(defaultValue: '') required this.authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt, this.isMine = false, this.canDelete = false});
  factory _GroupPostComment.fromJson(Map<String, dynamic> json) => _$GroupPostCommentFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String postId;
@override@JsonKey(defaultValue: '') final  String body;
@override@JsonKey(defaultValue: '') final  String authorName;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey() final  bool isMine;
@override@JsonKey() final  bool canDelete;

/// Create a copy of GroupPostComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupPostCommentCopyWith<_GroupPostComment> get copyWith => __$GroupPostCommentCopyWithImpl<_GroupPostComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupPostCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupPostComment&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.body, body) || other.body == body)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,body,authorName,createdAt,isMine,canDelete);

@override
String toString() {
  return 'GroupPostComment(id: $id, postId: $postId, body: $body, authorName: $authorName, createdAt: $createdAt, isMine: $isMine, canDelete: $canDelete)';
}


}

/// @nodoc
abstract mixin class _$GroupPostCommentCopyWith<$Res> implements $GroupPostCommentCopyWith<$Res> {
  factory _$GroupPostCommentCopyWith(_GroupPostComment value, $Res Function(_GroupPostComment) _then) = __$GroupPostCommentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String postId,@JsonKey(defaultValue: '') String body,@JsonKey(defaultValue: '') String authorName,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isMine, bool canDelete
});




}
/// @nodoc
class __$GroupPostCommentCopyWithImpl<$Res>
    implements _$GroupPostCommentCopyWith<$Res> {
  __$GroupPostCommentCopyWithImpl(this._self, this._then);

  final _GroupPostComment _self;
  final $Res Function(_GroupPostComment) _then;

/// Create a copy of GroupPostComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? body = null,Object? authorName = null,Object? createdAt = freezed,Object? isMine = null,Object? canDelete = null,}) {
  return _then(_GroupPostComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
