// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_changes_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleChangesState {

 List<ScheduleChange> get changes; ScheduleChangesStatus get status;
/// Create a copy of ScheduleChangesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleChangesStateCopyWith<ScheduleChangesState> get copyWith => _$ScheduleChangesStateCopyWithImpl<ScheduleChangesState>(this as ScheduleChangesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleChangesState&&const DeepCollectionEquality().equals(other.changes, changes)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(changes),status);

@override
String toString() {
  return 'ScheduleChangesState(changes: $changes, status: $status)';
}


}

/// @nodoc
abstract mixin class $ScheduleChangesStateCopyWith<$Res>  {
  factory $ScheduleChangesStateCopyWith(ScheduleChangesState value, $Res Function(ScheduleChangesState) _then) = _$ScheduleChangesStateCopyWithImpl;
@useResult
$Res call({
 List<ScheduleChange> changes, ScheduleChangesStatus status
});




}
/// @nodoc
class _$ScheduleChangesStateCopyWithImpl<$Res>
    implements $ScheduleChangesStateCopyWith<$Res> {
  _$ScheduleChangesStateCopyWithImpl(this._self, this._then);

  final ScheduleChangesState _self;
  final $Res Function(ScheduleChangesState) _then;

/// Create a copy of ScheduleChangesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? changes = null,Object? status = null,}) {
  return _then(_self.copyWith(
changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as List<ScheduleChange>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduleChangesStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleChangesState].
extension ScheduleChangesStatePatterns on ScheduleChangesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleChangesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleChangesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleChangesState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleChangesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleChangesState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleChangesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ScheduleChange> changes,  ScheduleChangesStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleChangesState() when $default != null:
return $default(_that.changes,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ScheduleChange> changes,  ScheduleChangesStatus status)  $default,) {final _that = this;
switch (_that) {
case _ScheduleChangesState():
return $default(_that.changes,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ScheduleChange> changes,  ScheduleChangesStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleChangesState() when $default != null:
return $default(_that.changes,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleChangesState extends ScheduleChangesState {
  const _ScheduleChangesState({final  List<ScheduleChange> changes = const <ScheduleChange>[], this.status = ScheduleChangesStatus.initial}): _changes = changes,super._();


 final  List<ScheduleChange> _changes;
@override@JsonKey() List<ScheduleChange> get changes {
  if (_changes is EqualUnmodifiableListView) return _changes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changes);
}

@override@JsonKey() final  ScheduleChangesStatus status;

/// Create a copy of ScheduleChangesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleChangesStateCopyWith<_ScheduleChangesState> get copyWith => __$ScheduleChangesStateCopyWithImpl<_ScheduleChangesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleChangesState&&const DeepCollectionEquality().equals(other._changes, _changes)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_changes),status);

@override
String toString() {
  return 'ScheduleChangesState(changes: $changes, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ScheduleChangesStateCopyWith<$Res> implements $ScheduleChangesStateCopyWith<$Res> {
  factory _$ScheduleChangesStateCopyWith(_ScheduleChangesState value, $Res Function(_ScheduleChangesState) _then) = __$ScheduleChangesStateCopyWithImpl;
@override @useResult
$Res call({
 List<ScheduleChange> changes, ScheduleChangesStatus status
});




}
/// @nodoc
class __$ScheduleChangesStateCopyWithImpl<$Res>
    implements _$ScheduleChangesStateCopyWith<$Res> {
  __$ScheduleChangesStateCopyWithImpl(this._self, this._then);

  final _ScheduleChangesState _self;
  final $Res Function(_ScheduleChangesState) _then;

/// Create a copy of ScheduleChangesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? changes = null,Object? status = null,}) {
  return _then(_ScheduleChangesState(
changes: null == changes ? _self._changes : changes // ignore: cast_nullable_to_non_nullable
as List<ScheduleChange>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduleChangesStatus,
  ));
}


}

// dart format on
