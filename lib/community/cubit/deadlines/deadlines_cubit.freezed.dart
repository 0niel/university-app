// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deadlines_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeadlinesState {

 DeadlinesStatus get status; List<Deadline> get deadlines; DeadlineFilter get filter; Set<String> get pendingDeadlineIds; Set<String> get pendingDeleteIds; bool get isCreating; bool get doneGroupExpanded;
/// Create a copy of DeadlinesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeadlinesStateCopyWith<DeadlinesState> get copyWith => _$DeadlinesStateCopyWithImpl<DeadlinesState>(this as DeadlinesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeadlinesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.deadlines, deadlines)&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other.pendingDeadlineIds, pendingDeadlineIds)&&const DeepCollectionEquality().equals(other.pendingDeleteIds, pendingDeleteIds)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating)&&(identical(other.doneGroupExpanded, doneGroupExpanded) || other.doneGroupExpanded == doneGroupExpanded));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(deadlines),filter,const DeepCollectionEquality().hash(pendingDeadlineIds),const DeepCollectionEquality().hash(pendingDeleteIds),isCreating,doneGroupExpanded);

@override
String toString() {
  return 'DeadlinesState(status: $status, deadlines: $deadlines, filter: $filter, pendingDeadlineIds: $pendingDeadlineIds, pendingDeleteIds: $pendingDeleteIds, isCreating: $isCreating, doneGroupExpanded: $doneGroupExpanded)';
}


}

/// @nodoc
abstract mixin class $DeadlinesStateCopyWith<$Res>  {
  factory $DeadlinesStateCopyWith(DeadlinesState value, $Res Function(DeadlinesState) _then) = _$DeadlinesStateCopyWithImpl;
@useResult
$Res call({
 DeadlinesStatus status, List<Deadline> deadlines, DeadlineFilter filter, Set<String> pendingDeadlineIds, Set<String> pendingDeleteIds, bool isCreating, bool doneGroupExpanded
});




}
/// @nodoc
class _$DeadlinesStateCopyWithImpl<$Res>
    implements $DeadlinesStateCopyWith<$Res> {
  _$DeadlinesStateCopyWithImpl(this._self, this._then);

  final DeadlinesState _self;
  final $Res Function(DeadlinesState) _then;

/// Create a copy of DeadlinesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? deadlines = null,Object? filter = null,Object? pendingDeadlineIds = null,Object? pendingDeleteIds = null,Object? isCreating = null,Object? doneGroupExpanded = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeadlinesStatus,deadlines: null == deadlines ? _self.deadlines : deadlines // ignore: cast_nullable_to_non_nullable
as List<Deadline>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as DeadlineFilter,pendingDeadlineIds: null == pendingDeadlineIds ? _self.pendingDeadlineIds : pendingDeadlineIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingDeleteIds: null == pendingDeleteIds ? _self.pendingDeleteIds : pendingDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,doneGroupExpanded: null == doneGroupExpanded ? _self.doneGroupExpanded : doneGroupExpanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeadlinesState].
extension DeadlinesStatePatterns on DeadlinesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeadlinesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeadlinesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeadlinesState value)  $default,){
final _that = this;
switch (_that) {
case _DeadlinesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeadlinesState value)?  $default,){
final _that = this;
switch (_that) {
case _DeadlinesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeadlinesStatus status,  List<Deadline> deadlines,  DeadlineFilter filter,  Set<String> pendingDeadlineIds,  Set<String> pendingDeleteIds,  bool isCreating,  bool doneGroupExpanded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeadlinesState() when $default != null:
return $default(_that.status,_that.deadlines,_that.filter,_that.pendingDeadlineIds,_that.pendingDeleteIds,_that.isCreating,_that.doneGroupExpanded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeadlinesStatus status,  List<Deadline> deadlines,  DeadlineFilter filter,  Set<String> pendingDeadlineIds,  Set<String> pendingDeleteIds,  bool isCreating,  bool doneGroupExpanded)  $default,) {final _that = this;
switch (_that) {
case _DeadlinesState():
return $default(_that.status,_that.deadlines,_that.filter,_that.pendingDeadlineIds,_that.pendingDeleteIds,_that.isCreating,_that.doneGroupExpanded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeadlinesStatus status,  List<Deadline> deadlines,  DeadlineFilter filter,  Set<String> pendingDeadlineIds,  Set<String> pendingDeleteIds,  bool isCreating,  bool doneGroupExpanded)?  $default,) {final _that = this;
switch (_that) {
case _DeadlinesState() when $default != null:
return $default(_that.status,_that.deadlines,_that.filter,_that.pendingDeadlineIds,_that.pendingDeleteIds,_that.isCreating,_that.doneGroupExpanded);case _:
  return null;

}
}

}

/// @nodoc


class _DeadlinesState extends DeadlinesState {
  const _DeadlinesState({this.status = DeadlinesStatus.initial, final  List<Deadline> deadlines = const <Deadline>[], this.filter = DeadlineFilter.all, final  Set<String> pendingDeadlineIds = const <String>{}, final  Set<String> pendingDeleteIds = const <String>{}, this.isCreating = false, this.doneGroupExpanded = false}): _deadlines = deadlines,_pendingDeadlineIds = pendingDeadlineIds,_pendingDeleteIds = pendingDeleteIds,super._();


@override@JsonKey() final  DeadlinesStatus status;
 final  List<Deadline> _deadlines;
@override@JsonKey() List<Deadline> get deadlines {
  if (_deadlines is EqualUnmodifiableListView) return _deadlines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deadlines);
}

@override@JsonKey() final  DeadlineFilter filter;
 final  Set<String> _pendingDeadlineIds;
@override@JsonKey() Set<String> get pendingDeadlineIds {
  if (_pendingDeadlineIds is EqualUnmodifiableSetView) return _pendingDeadlineIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingDeadlineIds);
}

 final  Set<String> _pendingDeleteIds;
@override@JsonKey() Set<String> get pendingDeleteIds {
  if (_pendingDeleteIds is EqualUnmodifiableSetView) return _pendingDeleteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingDeleteIds);
}

@override@JsonKey() final  bool isCreating;
@override@JsonKey() final  bool doneGroupExpanded;

/// Create a copy of DeadlinesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeadlinesStateCopyWith<_DeadlinesState> get copyWith => __$DeadlinesStateCopyWithImpl<_DeadlinesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeadlinesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._deadlines, _deadlines)&&(identical(other.filter, filter) || other.filter == filter)&&const DeepCollectionEquality().equals(other._pendingDeadlineIds, _pendingDeadlineIds)&&const DeepCollectionEquality().equals(other._pendingDeleteIds, _pendingDeleteIds)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating)&&(identical(other.doneGroupExpanded, doneGroupExpanded) || other.doneGroupExpanded == doneGroupExpanded));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_deadlines),filter,const DeepCollectionEquality().hash(_pendingDeadlineIds),const DeepCollectionEquality().hash(_pendingDeleteIds),isCreating,doneGroupExpanded);

@override
String toString() {
  return 'DeadlinesState(status: $status, deadlines: $deadlines, filter: $filter, pendingDeadlineIds: $pendingDeadlineIds, pendingDeleteIds: $pendingDeleteIds, isCreating: $isCreating, doneGroupExpanded: $doneGroupExpanded)';
}


}

/// @nodoc
abstract mixin class _$DeadlinesStateCopyWith<$Res> implements $DeadlinesStateCopyWith<$Res> {
  factory _$DeadlinesStateCopyWith(_DeadlinesState value, $Res Function(_DeadlinesState) _then) = __$DeadlinesStateCopyWithImpl;
@override @useResult
$Res call({
 DeadlinesStatus status, List<Deadline> deadlines, DeadlineFilter filter, Set<String> pendingDeadlineIds, Set<String> pendingDeleteIds, bool isCreating, bool doneGroupExpanded
});




}
/// @nodoc
class __$DeadlinesStateCopyWithImpl<$Res>
    implements _$DeadlinesStateCopyWith<$Res> {
  __$DeadlinesStateCopyWithImpl(this._self, this._then);

  final _DeadlinesState _self;
  final $Res Function(_DeadlinesState) _then;

/// Create a copy of DeadlinesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? deadlines = null,Object? filter = null,Object? pendingDeadlineIds = null,Object? pendingDeleteIds = null,Object? isCreating = null,Object? doneGroupExpanded = null,}) {
  return _then(_DeadlinesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DeadlinesStatus,deadlines: null == deadlines ? _self._deadlines : deadlines // ignore: cast_nullable_to_non_nullable
as List<Deadline>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as DeadlineFilter,pendingDeadlineIds: null == pendingDeadlineIds ? _self._pendingDeadlineIds : pendingDeadlineIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingDeleteIds: null == pendingDeleteIds ? _self._pendingDeleteIds : pendingDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,doneGroupExpanded: null == doneGroupExpanded ? _self.doneGroupExpanded : doneGroupExpanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
