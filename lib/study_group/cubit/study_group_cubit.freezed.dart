// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_group_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudyGroupState {

 StudyGroupStatus get status; MyStudyGroup get data; Set<String> get pendingRequestIds; Set<String> get pendingMemberIds;
/// Create a copy of StudyGroupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyGroupStateCopyWith<StudyGroupState> get copyWith => _$StudyGroupStateCopyWithImpl<StudyGroupState>(this as StudyGroupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyGroupState&&(identical(other.status, status) || other.status == status)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.pendingRequestIds, pendingRequestIds)&&const DeepCollectionEquality().equals(other.pendingMemberIds, pendingMemberIds));
}


@override
int get hashCode => Object.hash(runtimeType,status,data,const DeepCollectionEquality().hash(pendingRequestIds),const DeepCollectionEquality().hash(pendingMemberIds));

@override
String toString() {
  return 'StudyGroupState(status: $status, data: $data, pendingRequestIds: $pendingRequestIds, pendingMemberIds: $pendingMemberIds)';
}


}

/// @nodoc
abstract mixin class $StudyGroupStateCopyWith<$Res>  {
  factory $StudyGroupStateCopyWith(StudyGroupState value, $Res Function(StudyGroupState) _then) = _$StudyGroupStateCopyWithImpl;
@useResult
$Res call({
 StudyGroupStatus status, MyStudyGroup data, Set<String> pendingRequestIds, Set<String> pendingMemberIds
});


$MyStudyGroupCopyWith<$Res> get data;

}
/// @nodoc
class _$StudyGroupStateCopyWithImpl<$Res>
    implements $StudyGroupStateCopyWith<$Res> {
  _$StudyGroupStateCopyWithImpl(this._self, this._then);

  final StudyGroupState _self;
  final $Res Function(StudyGroupState) _then;

/// Create a copy of StudyGroupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? data = null,Object? pendingRequestIds = null,Object? pendingMemberIds = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StudyGroupStatus,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MyStudyGroup,pendingRequestIds: null == pendingRequestIds ? _self.pendingRequestIds : pendingRequestIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingMemberIds: null == pendingMemberIds ? _self.pendingMemberIds : pendingMemberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}
/// Create a copy of StudyGroupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyStudyGroupCopyWith<$Res> get data {

  return $MyStudyGroupCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [StudyGroupState].
extension StudyGroupStatePatterns on StudyGroupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyGroupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyGroupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyGroupState value)  $default,){
final _that = this;
switch (_that) {
case _StudyGroupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyGroupState value)?  $default,){
final _that = this;
switch (_that) {
case _StudyGroupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StudyGroupStatus status,  MyStudyGroup data,  Set<String> pendingRequestIds,  Set<String> pendingMemberIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyGroupState() when $default != null:
return $default(_that.status,_that.data,_that.pendingRequestIds,_that.pendingMemberIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StudyGroupStatus status,  MyStudyGroup data,  Set<String> pendingRequestIds,  Set<String> pendingMemberIds)  $default,) {final _that = this;
switch (_that) {
case _StudyGroupState():
return $default(_that.status,_that.data,_that.pendingRequestIds,_that.pendingMemberIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StudyGroupStatus status,  MyStudyGroup data,  Set<String> pendingRequestIds,  Set<String> pendingMemberIds)?  $default,) {final _that = this;
switch (_that) {
case _StudyGroupState() when $default != null:
return $default(_that.status,_that.data,_that.pendingRequestIds,_that.pendingMemberIds);case _:
  return null;

}
}

}

/// @nodoc


class _StudyGroupState extends StudyGroupState {
  const _StudyGroupState({this.status = StudyGroupStatus.initial, this.data = MyStudyGroup.empty, final  Set<String> pendingRequestIds = const <String>{}, final  Set<String> pendingMemberIds = const <String>{}}): _pendingRequestIds = pendingRequestIds,_pendingMemberIds = pendingMemberIds,super._();


@override@JsonKey() final  StudyGroupStatus status;
@override@JsonKey() final  MyStudyGroup data;
 final  Set<String> _pendingRequestIds;
@override@JsonKey() Set<String> get pendingRequestIds {
  if (_pendingRequestIds is EqualUnmodifiableSetView) return _pendingRequestIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingRequestIds);
}

 final  Set<String> _pendingMemberIds;
@override@JsonKey() Set<String> get pendingMemberIds {
  if (_pendingMemberIds is EqualUnmodifiableSetView) return _pendingMemberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingMemberIds);
}


/// Create a copy of StudyGroupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyGroupStateCopyWith<_StudyGroupState> get copyWith => __$StudyGroupStateCopyWithImpl<_StudyGroupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyGroupState&&(identical(other.status, status) || other.status == status)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other._pendingRequestIds, _pendingRequestIds)&&const DeepCollectionEquality().equals(other._pendingMemberIds, _pendingMemberIds));
}


@override
int get hashCode => Object.hash(runtimeType,status,data,const DeepCollectionEquality().hash(_pendingRequestIds),const DeepCollectionEquality().hash(_pendingMemberIds));

@override
String toString() {
  return 'StudyGroupState(status: $status, data: $data, pendingRequestIds: $pendingRequestIds, pendingMemberIds: $pendingMemberIds)';
}


}

/// @nodoc
abstract mixin class _$StudyGroupStateCopyWith<$Res> implements $StudyGroupStateCopyWith<$Res> {
  factory _$StudyGroupStateCopyWith(_StudyGroupState value, $Res Function(_StudyGroupState) _then) = __$StudyGroupStateCopyWithImpl;
@override @useResult
$Res call({
 StudyGroupStatus status, MyStudyGroup data, Set<String> pendingRequestIds, Set<String> pendingMemberIds
});


@override $MyStudyGroupCopyWith<$Res> get data;

}
/// @nodoc
class __$StudyGroupStateCopyWithImpl<$Res>
    implements _$StudyGroupStateCopyWith<$Res> {
  __$StudyGroupStateCopyWithImpl(this._self, this._then);

  final _StudyGroupState _self;
  final $Res Function(_StudyGroupState) _then;

/// Create a copy of StudyGroupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? data = null,Object? pendingRequestIds = null,Object? pendingMemberIds = null,}) {
  return _then(_StudyGroupState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StudyGroupStatus,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MyStudyGroup,pendingRequestIds: null == pendingRequestIds ? _self._pendingRequestIds : pendingRequestIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingMemberIds: null == pendingMemberIds ? _self._pendingMemberIds : pendingMemberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

/// Create a copy of StudyGroupState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyStudyGroupCopyWith<$Res> get data {

  return $MyStudyGroupCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
