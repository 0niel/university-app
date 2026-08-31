// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_overview_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostOverviewState {

 DiscoursePost? get post; List<DiscoursePostComment> get comments; PostOverviewStatus get status;
/// Create a copy of PostOverviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostOverviewStateCopyWith<PostOverviewState> get copyWith => _$PostOverviewStateCopyWithImpl<PostOverviewState>(this as PostOverviewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostOverviewState&&(identical(other.post, post) || other.post == post)&&const DeepCollectionEquality().equals(other.comments, comments)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,post,const DeepCollectionEquality().hash(comments),status);

@override
String toString() {
  return 'PostOverviewState(post: $post, comments: $comments, status: $status)';
}


}

/// @nodoc
abstract mixin class $PostOverviewStateCopyWith<$Res>  {
  factory $PostOverviewStateCopyWith(PostOverviewState value, $Res Function(PostOverviewState) _then) = _$PostOverviewStateCopyWithImpl;
@useResult
$Res call({
 DiscoursePost? post, List<DiscoursePostComment> comments, PostOverviewStatus status
});


$DiscoursePostCopyWith<$Res>? get post;

}
/// @nodoc
class _$PostOverviewStateCopyWithImpl<$Res>
    implements $PostOverviewStateCopyWith<$Res> {
  _$PostOverviewStateCopyWithImpl(this._self, this._then);

  final PostOverviewState _self;
  final $Res Function(PostOverviewState) _then;

/// Create a copy of PostOverviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? post = freezed,Object? comments = null,Object? status = null,}) {
  return _then(_self.copyWith(
post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as DiscoursePost?,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<DiscoursePostComment>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PostOverviewStatus,
  ));
}
/// Create a copy of PostOverviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoursePostCopyWith<$Res>? get post {
    if (_self.post == null) {
    return null;
  }

  return $DiscoursePostCopyWith<$Res>(_self.post!, (value) {
    return _then(_self.copyWith(post: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostOverviewState].
extension PostOverviewStatePatterns on PostOverviewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostOverviewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostOverviewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostOverviewState value)  $default,){
final _that = this;
switch (_that) {
case _PostOverviewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostOverviewState value)?  $default,){
final _that = this;
switch (_that) {
case _PostOverviewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiscoursePost? post,  List<DiscoursePostComment> comments,  PostOverviewStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostOverviewState() when $default != null:
return $default(_that.post,_that.comments,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiscoursePost? post,  List<DiscoursePostComment> comments,  PostOverviewStatus status)  $default,) {final _that = this;
switch (_that) {
case _PostOverviewState():
return $default(_that.post,_that.comments,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiscoursePost? post,  List<DiscoursePostComment> comments,  PostOverviewStatus status)?  $default,) {final _that = this;
switch (_that) {
case _PostOverviewState() when $default != null:
return $default(_that.post,_that.comments,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _PostOverviewState extends PostOverviewState {
  const _PostOverviewState({this.post, final  List<DiscoursePostComment> comments = const <DiscoursePostComment>[], this.status = PostOverviewStatus.initial}): _comments = comments,super._();


@override final  DiscoursePost? post;
 final  List<DiscoursePostComment> _comments;
@override@JsonKey() List<DiscoursePostComment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

@override@JsonKey() final  PostOverviewStatus status;

/// Create a copy of PostOverviewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostOverviewStateCopyWith<_PostOverviewState> get copyWith => __$PostOverviewStateCopyWithImpl<_PostOverviewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostOverviewState&&(identical(other.post, post) || other.post == post)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,post,const DeepCollectionEquality().hash(_comments),status);

@override
String toString() {
  return 'PostOverviewState(post: $post, comments: $comments, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PostOverviewStateCopyWith<$Res> implements $PostOverviewStateCopyWith<$Res> {
  factory _$PostOverviewStateCopyWith(_PostOverviewState value, $Res Function(_PostOverviewState) _then) = __$PostOverviewStateCopyWithImpl;
@override @useResult
$Res call({
 DiscoursePost? post, List<DiscoursePostComment> comments, PostOverviewStatus status
});


@override $DiscoursePostCopyWith<$Res>? get post;

}
/// @nodoc
class __$PostOverviewStateCopyWithImpl<$Res>
    implements _$PostOverviewStateCopyWith<$Res> {
  __$PostOverviewStateCopyWithImpl(this._self, this._then);

  final _PostOverviewState _self;
  final $Res Function(_PostOverviewState) _then;

/// Create a copy of PostOverviewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? post = freezed,Object? comments = null,Object? status = null,}) {
  return _then(_PostOverviewState(
post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as DiscoursePost?,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<DiscoursePostComment>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PostOverviewStatus,
  ));
}

/// Create a copy of PostOverviewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoursePostCopyWith<$Res>? get post {
    if (_self.post == null) {
    return null;
  }

  return $DiscoursePostCopyWith<$Res>(_self.post!, (value) {
    return _then(_self.copyWith(post: value));
  });
}
}

// dart format on
