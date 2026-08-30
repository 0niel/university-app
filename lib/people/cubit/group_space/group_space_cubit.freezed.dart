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

 GroupSpaceStatus get status; GroupSpace get space; bool get isRefreshing; Set<String> get pendingLikeIds; Set<String> get pendingLinkDeleteIds; GroupSpaceMutationFailure? get mutationFailure;
/// Create a copy of GroupSpaceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupSpaceStateCopyWith<GroupSpaceState> get copyWith => _$GroupSpaceStateCopyWithImpl<GroupSpaceState>(this as GroupSpaceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupSpaceState&&(identical(other.status, status) || other.status == status)&&(identical(other.space, space) || other.space == space)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&const DeepCollectionEquality().equals(other.pendingLikeIds, pendingLikeIds)&&const DeepCollectionEquality().equals(other.pendingLinkDeleteIds, pendingLinkDeleteIds)&&(identical(other.mutationFailure, mutationFailure) || other.mutationFailure == mutationFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,space,isRefreshing,const DeepCollectionEquality().hash(pendingLikeIds),const DeepCollectionEquality().hash(pendingLinkDeleteIds),mutationFailure);

@override
String toString() {
  return 'GroupSpaceState(status: $status, space: $space, isRefreshing: $isRefreshing, pendingLikeIds: $pendingLikeIds, pendingLinkDeleteIds: $pendingLinkDeleteIds, mutationFailure: $mutationFailure)';
}


}

/// @nodoc
abstract mixin class $GroupSpaceStateCopyWith<$Res>  {
  factory $GroupSpaceStateCopyWith(GroupSpaceState value, $Res Function(GroupSpaceState) _then) = _$GroupSpaceStateCopyWithImpl;
@useResult
$Res call({
 GroupSpaceStatus status, GroupSpace space, bool isRefreshing, Set<String> pendingLikeIds, Set<String> pendingLinkDeleteIds, GroupSpaceMutationFailure? mutationFailure
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
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? space = null,Object? isRefreshing = null,Object? pendingLikeIds = null,Object? pendingLinkDeleteIds = null,Object? mutationFailure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GroupSpaceStatus,space: null == space ? _self.space : space // ignore: cast_nullable_to_non_nullable
as GroupSpace,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,pendingLikeIds: null == pendingLikeIds ? _self.pendingLikeIds : pendingLikeIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingLinkDeleteIds: null == pendingLinkDeleteIds ? _self.pendingLinkDeleteIds : pendingLinkDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,mutationFailure: freezed == mutationFailure ? _self.mutationFailure : mutationFailure // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GroupSpaceStatus status,  GroupSpace space,  bool isRefreshing,  Set<String> pendingLikeIds,  Set<String> pendingLinkDeleteIds,  GroupSpaceMutationFailure? mutationFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupSpaceState() when $default != null:
return $default(_that.status,_that.space,_that.isRefreshing,_that.pendingLikeIds,_that.pendingLinkDeleteIds,_that.mutationFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GroupSpaceStatus status,  GroupSpace space,  bool isRefreshing,  Set<String> pendingLikeIds,  Set<String> pendingLinkDeleteIds,  GroupSpaceMutationFailure? mutationFailure)  $default,) {final _that = this;
switch (_that) {
case _GroupSpaceState():
return $default(_that.status,_that.space,_that.isRefreshing,_that.pendingLikeIds,_that.pendingLinkDeleteIds,_that.mutationFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GroupSpaceStatus status,  GroupSpace space,  bool isRefreshing,  Set<String> pendingLikeIds,  Set<String> pendingLinkDeleteIds,  GroupSpaceMutationFailure? mutationFailure)?  $default,) {final _that = this;
switch (_that) {
case _GroupSpaceState() when $default != null:
return $default(_that.status,_that.space,_that.isRefreshing,_that.pendingLikeIds,_that.pendingLinkDeleteIds,_that.mutationFailure);case _:
  return null;

}
}

}

/// @nodoc


class _GroupSpaceState implements GroupSpaceState {
  const _GroupSpaceState({this.status = GroupSpaceStatus.initial, this.space = GroupSpace.empty, this.isRefreshing = false, final  Set<String> pendingLikeIds = const <String>{}, final  Set<String> pendingLinkDeleteIds = const <String>{}, this.mutationFailure}): _pendingLikeIds = pendingLikeIds,_pendingLinkDeleteIds = pendingLinkDeleteIds;


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

@override final  GroupSpaceMutationFailure? mutationFailure;

/// Create a copy of GroupSpaceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupSpaceStateCopyWith<_GroupSpaceState> get copyWith => __$GroupSpaceStateCopyWithImpl<_GroupSpaceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupSpaceState&&(identical(other.status, status) || other.status == status)&&(identical(other.space, space) || other.space == space)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&const DeepCollectionEquality().equals(other._pendingLikeIds, _pendingLikeIds)&&const DeepCollectionEquality().equals(other._pendingLinkDeleteIds, _pendingLinkDeleteIds)&&(identical(other.mutationFailure, mutationFailure) || other.mutationFailure == mutationFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,space,isRefreshing,const DeepCollectionEquality().hash(_pendingLikeIds),const DeepCollectionEquality().hash(_pendingLinkDeleteIds),mutationFailure);

@override
String toString() {
  return 'GroupSpaceState(status: $status, space: $space, isRefreshing: $isRefreshing, pendingLikeIds: $pendingLikeIds, pendingLinkDeleteIds: $pendingLinkDeleteIds, mutationFailure: $mutationFailure)';
}


}

/// @nodoc
abstract mixin class _$GroupSpaceStateCopyWith<$Res> implements $GroupSpaceStateCopyWith<$Res> {
  factory _$GroupSpaceStateCopyWith(_GroupSpaceState value, $Res Function(_GroupSpaceState) _then) = __$GroupSpaceStateCopyWithImpl;
@override @useResult
$Res call({
 GroupSpaceStatus status, GroupSpace space, bool isRefreshing, Set<String> pendingLikeIds, Set<String> pendingLinkDeleteIds, GroupSpaceMutationFailure? mutationFailure
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
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? space = null,Object? isRefreshing = null,Object? pendingLikeIds = null,Object? pendingLinkDeleteIds = null,Object? mutationFailure = freezed,}) {
  return _then(_GroupSpaceState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GroupSpaceStatus,space: null == space ? _self.space : space // ignore: cast_nullable_to_non_nullable
as GroupSpace,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,pendingLikeIds: null == pendingLikeIds ? _self._pendingLikeIds : pendingLikeIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingLinkDeleteIds: null == pendingLinkDeleteIds ? _self._pendingLinkDeleteIds : pendingLinkDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,mutationFailure: freezed == mutationFailure ? _self.mutationFailure : mutationFailure // ignore: cast_nullable_to_non_nullable
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
