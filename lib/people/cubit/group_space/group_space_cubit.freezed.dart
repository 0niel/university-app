// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_space_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupSpaceState {

 GroupSpaceStatus get status; GroupSpace get space; bool get isRefreshing; Set<String> get pendingLikeIds; Set<String> get pendingLinkDeleteIds; List<CollabNote> get notesPreview; Map<String, List<GroupPostComment>> get comments; Set<String> get loadingCommentPostIds; bool get isSubmittingComment; Set<String> get pendingCommentDeleteIds; int get onlineCount; GroupSpaceMutationFailure? get mutationFailure;
/// Create a copy of GroupSpaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupSpaceStateCopyWith<GroupSpaceState> get copyWith => _$GroupSpaceStateCopyWithImpl<GroupSpaceState>(this as GroupSpaceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupSpaceState&&(identical(other.status, status) || other.status == status)&&(identical(other.space, space) || other.space == space)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&const DeepCollectionEquality().equals(other.pendingLikeIds, pendingLikeIds)&&const DeepCollectionEquality().equals(other.pendingLinkDeleteIds, pendingLinkDeleteIds)&&const DeepCollectionEquality().equals(other.notesPreview, notesPreview)&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.loadingCommentPostIds, loadingCommentPostIds)&&(identical(other.isSubmittingComment, isSubmittingComment) || other.isSubmittingComment == isSubmittingComment)&&const DeepCollectionEquality().equals(other.pendingCommentDeleteIds, pendingCommentDeleteIds)&&(identical(other.onlineCount, onlineCount) || other.onlineCount == onlineCount)&&(identical(other.mutationFailure, mutationFailure) || other.mutationFailure == mutationFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,space,isRefreshing,const DeepCollectionEquality().hash(pendingLikeIds),const DeepCollectionEquality().hash(pendingLinkDeleteIds),const DeepCollectionEquality().hash(notesPreview),const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(loadingCommentPostIds),isSubmittingComment,const DeepCollectionEquality().hash(pendingCommentDeleteIds),onlineCount,mutationFailure);

@override
String toString() {
  return 'GroupSpaceState(status: $status, space: $space, isRefreshing: $isRefreshing, pendingLikeIds: $pendingLikeIds, pendingLinkDeleteIds: $pendingLinkDeleteIds, notesPreview: $notesPreview, comments: $comments, loadingCommentPostIds: $loadingCommentPostIds, isSubmittingComment: $isSubmittingComment, pendingCommentDeleteIds: $pendingCommentDeleteIds, onlineCount: $onlineCount, mutationFailure: $mutationFailure)';
}


}

/// @nodoc
abstract mixin class $GroupSpaceStateCopyWith<$Res>  {
  factory $GroupSpaceStateCopyWith(GroupSpaceState value, $Res Function(GroupSpaceState) _then) = _$GroupSpaceStateCopyWithImpl;
@useResult
$Res call({
 GroupSpaceStatus status, GroupSpace space, bool isRefreshing, Set<String> pendingLikeIds, Set<String> pendingLinkDeleteIds, List<CollabNote> notesPreview, Map<String, List<GroupPostComment>> comments, Set<String> loadingCommentPostIds, bool isSubmittingComment, Set<String> pendingCommentDeleteIds, int onlineCount, GroupSpaceMutationFailure? mutationFailure
});


$GroupSpaceCopyWith<$Res> get space;

}
/// @nodoc
class _$GroupSpaceStateCopyWithImpl<$Res>
    implements $GroupSpaceStateCopyWith<$Res> {
  _$GroupSpaceStateCopyWithImpl(this._self, this._then);

  final GroupSpaceState _self;
  final $Res Function(GroupSpaceState) _then;

/// Create a copy of GroupSpaceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? space = null,Object? isRefreshing = null,Object? pendingLikeIds = null,Object? pendingLinkDeleteIds = null,Object? notesPreview = null,Object? comments = null,Object? loadingCommentPostIds = null,Object? isSubmittingComment = null,Object? pendingCommentDeleteIds = null,Object? onlineCount = null,Object? mutationFailure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GroupSpaceStatus,space: null == space ? _self.space : space // ignore: cast_nullable_to_non_nullable
as GroupSpace,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,pendingLikeIds: null == pendingLikeIds ? _self.pendingLikeIds : pendingLikeIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingLinkDeleteIds: null == pendingLinkDeleteIds ? _self.pendingLinkDeleteIds : pendingLinkDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,notesPreview: null == notesPreview ? _self.notesPreview : notesPreview // ignore: cast_nullable_to_non_nullable
as List<CollabNote>,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as Map<String, List<GroupPostComment>>,loadingCommentPostIds: null == loadingCommentPostIds ? _self.loadingCommentPostIds : loadingCommentPostIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isSubmittingComment: null == isSubmittingComment ? _self.isSubmittingComment : isSubmittingComment // ignore: cast_nullable_to_non_nullable
as bool,pendingCommentDeleteIds: null == pendingCommentDeleteIds ? _self.pendingCommentDeleteIds : pendingCommentDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,onlineCount: null == onlineCount ? _self.onlineCount : onlineCount // ignore: cast_nullable_to_non_nullable
as int,mutationFailure: freezed == mutationFailure ? _self.mutationFailure : mutationFailure // ignore: cast_nullable_to_non_nullable
as GroupSpaceMutationFailure?,
  ));
}
/// Create a copy of GroupSpaceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupSpaceCopyWith<$Res> get space {

  return $GroupSpaceCopyWith<$Res>(_self.space, (value) {
    return _then(_self.copyWith(space: value));
  });
}
}


/// Adds pattern-matching-related methods to [GroupSpaceState].
extension GroupSpaceStatePatterns on GroupSpaceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupSpaceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupSpaceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupSpaceState value)  $default,){
final _that = this;
switch (_that) {
case _GroupSpaceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupSpaceState value)?  $default,){
final _that = this;
switch (_that) {
case _GroupSpaceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GroupSpaceStatus status,  GroupSpace space,  bool isRefreshing,  Set<String> pendingLikeIds,  Set<String> pendingLinkDeleteIds,  List<CollabNote> notesPreview,  Map<String, List<GroupPostComment>> comments,  Set<String> loadingCommentPostIds,  bool isSubmittingComment,  Set<String> pendingCommentDeleteIds,  int onlineCount,  GroupSpaceMutationFailure? mutationFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupSpaceState() when $default != null:
return $default(_that.status,_that.space,_that.isRefreshing,_that.pendingLikeIds,_that.pendingLinkDeleteIds,_that.notesPreview,_that.comments,_that.loadingCommentPostIds,_that.isSubmittingComment,_that.pendingCommentDeleteIds,_that.onlineCount,_that.mutationFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GroupSpaceStatus status,  GroupSpace space,  bool isRefreshing,  Set<String> pendingLikeIds,  Set<String> pendingLinkDeleteIds,  List<CollabNote> notesPreview,  Map<String, List<GroupPostComment>> comments,  Set<String> loadingCommentPostIds,  bool isSubmittingComment,  Set<String> pendingCommentDeleteIds,  int onlineCount,  GroupSpaceMutationFailure? mutationFailure)  $default,) {final _that = this;
switch (_that) {
case _GroupSpaceState():
return $default(_that.status,_that.space,_that.isRefreshing,_that.pendingLikeIds,_that.pendingLinkDeleteIds,_that.notesPreview,_that.comments,_that.loadingCommentPostIds,_that.isSubmittingComment,_that.pendingCommentDeleteIds,_that.onlineCount,_that.mutationFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GroupSpaceStatus status,  GroupSpace space,  bool isRefreshing,  Set<String> pendingLikeIds,  Set<String> pendingLinkDeleteIds,  List<CollabNote> notesPreview,  Map<String, List<GroupPostComment>> comments,  Set<String> loadingCommentPostIds,  bool isSubmittingComment,  Set<String> pendingCommentDeleteIds,  int onlineCount,  GroupSpaceMutationFailure? mutationFailure)?  $default,) {final _that = this;
switch (_that) {
case _GroupSpaceState() when $default != null:
return $default(_that.status,_that.space,_that.isRefreshing,_that.pendingLikeIds,_that.pendingLinkDeleteIds,_that.notesPreview,_that.comments,_that.loadingCommentPostIds,_that.isSubmittingComment,_that.pendingCommentDeleteIds,_that.onlineCount,_that.mutationFailure);case _:
  return null;

}
}

}

/// @nodoc


class _GroupSpaceState implements GroupSpaceState {
  const _GroupSpaceState({this.status = GroupSpaceStatus.initial, this.space = GroupSpace.empty, this.isRefreshing = false, final  Set<String> pendingLikeIds = const <String>{}, final  Set<String> pendingLinkDeleteIds = const <String>{}, final  List<CollabNote> notesPreview = const <CollabNote>[], final  Map<String, List<GroupPostComment>> comments = const <String, List<GroupPostComment>>{}, final  Set<String> loadingCommentPostIds = const <String>{}, this.isSubmittingComment = false, final  Set<String> pendingCommentDeleteIds = const <String>{}, this.onlineCount = 1, this.mutationFailure}): _pendingLikeIds = pendingLikeIds,_pendingLinkDeleteIds = pendingLinkDeleteIds,_notesPreview = notesPreview,_comments = comments,_loadingCommentPostIds = loadingCommentPostIds,_pendingCommentDeleteIds = pendingCommentDeleteIds;


@override@JsonKey() final  GroupSpaceStatus status;
@override@JsonKey() final  GroupSpace space;
@override@JsonKey() final  bool isRefreshing;
 final  Set<String> _pendingLikeIds;
@override@JsonKey() Set<String> get pendingLikeIds {
  if (_pendingLikeIds is EqualUnmodifiableSetView) return _pendingLikeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingLikeIds);
}

 final  Set<String> _pendingLinkDeleteIds;
@override@JsonKey() Set<String> get pendingLinkDeleteIds {
  if (_pendingLinkDeleteIds is EqualUnmodifiableSetView) return _pendingLinkDeleteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingLinkDeleteIds);
}

 final  List<CollabNote> _notesPreview;
@override@JsonKey() List<CollabNote> get notesPreview {
  if (_notesPreview is EqualUnmodifiableListView) return _notesPreview;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notesPreview);
}

 final  Map<String, List<GroupPostComment>> _comments;
@override@JsonKey() Map<String, List<GroupPostComment>> get comments {
  if (_comments is EqualUnmodifiableMapView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_comments);
}

 final  Set<String> _loadingCommentPostIds;
@override@JsonKey() Set<String> get loadingCommentPostIds {
  if (_loadingCommentPostIds is EqualUnmodifiableSetView) return _loadingCommentPostIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_loadingCommentPostIds);
}

@override@JsonKey() final  bool isSubmittingComment;
 final  Set<String> _pendingCommentDeleteIds;
@override@JsonKey() Set<String> get pendingCommentDeleteIds {
  if (_pendingCommentDeleteIds is EqualUnmodifiableSetView) return _pendingCommentDeleteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingCommentDeleteIds);
}

@override@JsonKey() final  int onlineCount;
@override final  GroupSpaceMutationFailure? mutationFailure;

/// Create a copy of GroupSpaceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupSpaceStateCopyWith<_GroupSpaceState> get copyWith => __$GroupSpaceStateCopyWithImpl<_GroupSpaceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupSpaceState&&(identical(other.status, status) || other.status == status)&&(identical(other.space, space) || other.space == space)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&const DeepCollectionEquality().equals(other._pendingLikeIds, _pendingLikeIds)&&const DeepCollectionEquality().equals(other._pendingLinkDeleteIds, _pendingLinkDeleteIds)&&const DeepCollectionEquality().equals(other._notesPreview, _notesPreview)&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._loadingCommentPostIds, _loadingCommentPostIds)&&(identical(other.isSubmittingComment, isSubmittingComment) || other.isSubmittingComment == isSubmittingComment)&&const DeepCollectionEquality().equals(other._pendingCommentDeleteIds, _pendingCommentDeleteIds)&&(identical(other.onlineCount, onlineCount) || other.onlineCount == onlineCount)&&(identical(other.mutationFailure, mutationFailure) || other.mutationFailure == mutationFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,space,isRefreshing,const DeepCollectionEquality().hash(_pendingLikeIds),const DeepCollectionEquality().hash(_pendingLinkDeleteIds),const DeepCollectionEquality().hash(_notesPreview),const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_loadingCommentPostIds),isSubmittingComment,const DeepCollectionEquality().hash(_pendingCommentDeleteIds),onlineCount,mutationFailure);

@override
String toString() {
  return 'GroupSpaceState(status: $status, space: $space, isRefreshing: $isRefreshing, pendingLikeIds: $pendingLikeIds, pendingLinkDeleteIds: $pendingLinkDeleteIds, notesPreview: $notesPreview, comments: $comments, loadingCommentPostIds: $loadingCommentPostIds, isSubmittingComment: $isSubmittingComment, pendingCommentDeleteIds: $pendingCommentDeleteIds, onlineCount: $onlineCount, mutationFailure: $mutationFailure)';
}


}

/// @nodoc
abstract mixin class _$GroupSpaceStateCopyWith<$Res> implements $GroupSpaceStateCopyWith<$Res> {
  factory _$GroupSpaceStateCopyWith(_GroupSpaceState value, $Res Function(_GroupSpaceState) _then) = __$GroupSpaceStateCopyWithImpl;
@override @useResult
$Res call({
 GroupSpaceStatus status, GroupSpace space, bool isRefreshing, Set<String> pendingLikeIds, Set<String> pendingLinkDeleteIds, List<CollabNote> notesPreview, Map<String, List<GroupPostComment>> comments, Set<String> loadingCommentPostIds, bool isSubmittingComment, Set<String> pendingCommentDeleteIds, int onlineCount, GroupSpaceMutationFailure? mutationFailure
});


@override $GroupSpaceCopyWith<$Res> get space;

}
/// @nodoc
class __$GroupSpaceStateCopyWithImpl<$Res>
    implements _$GroupSpaceStateCopyWith<$Res> {
  __$GroupSpaceStateCopyWithImpl(this._self, this._then);

  final _GroupSpaceState _self;
  final $Res Function(_GroupSpaceState) _then;

/// Create a copy of GroupSpaceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? space = null,Object? isRefreshing = null,Object? pendingLikeIds = null,Object? pendingLinkDeleteIds = null,Object? notesPreview = null,Object? comments = null,Object? loadingCommentPostIds = null,Object? isSubmittingComment = null,Object? pendingCommentDeleteIds = null,Object? onlineCount = null,Object? mutationFailure = freezed,}) {
  return _then(_GroupSpaceState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GroupSpaceStatus,space: null == space ? _self.space : space // ignore: cast_nullable_to_non_nullable
as GroupSpace,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,pendingLikeIds: null == pendingLikeIds ? _self._pendingLikeIds : pendingLikeIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingLinkDeleteIds: null == pendingLinkDeleteIds ? _self._pendingLinkDeleteIds : pendingLinkDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,notesPreview: null == notesPreview ? _self._notesPreview : notesPreview // ignore: cast_nullable_to_non_nullable
as List<CollabNote>,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as Map<String, List<GroupPostComment>>,loadingCommentPostIds: null == loadingCommentPostIds ? _self._loadingCommentPostIds : loadingCommentPostIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isSubmittingComment: null == isSubmittingComment ? _self.isSubmittingComment : isSubmittingComment // ignore: cast_nullable_to_non_nullable
as bool,pendingCommentDeleteIds: null == pendingCommentDeleteIds ? _self._pendingCommentDeleteIds : pendingCommentDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,onlineCount: null == onlineCount ? _self.onlineCount : onlineCount // ignore: cast_nullable_to_non_nullable
as int,mutationFailure: freezed == mutationFailure ? _self.mutationFailure : mutationFailure // ignore: cast_nullable_to_non_nullable
as GroupSpaceMutationFailure?,
  ));
}

/// Create a copy of GroupSpaceState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupSpaceCopyWith<$Res> get space {

  return $GroupSpaceCopyWith<$Res>(_self.space, (value) {
    return _then(_self.copyWith(space: value));
  });
}
}

// dart format on
