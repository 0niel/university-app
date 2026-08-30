// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collab_notes_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CollabNotesState {

 CollabNotesStatus get status; List<CollabNote> get notes; bool get isCreating;
/// Create a copy of CollabNotesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollabNotesStateCopyWith<CollabNotesState> get copyWith => _$CollabNotesStateCopyWithImpl<CollabNotesState>(this as CollabNotesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollabNotesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.notes, notes)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(notes),isCreating);

@override
String toString() {
  return 'CollabNotesState(status: $status, notes: $notes, isCreating: $isCreating)';
}


}

/// @nodoc
abstract mixin class $CollabNotesStateCopyWith<$Res>  {
  factory $CollabNotesStateCopyWith(CollabNotesState value, $Res Function(CollabNotesState) _then) = _$CollabNotesStateCopyWithImpl;
@useResult
$Res call({
 CollabNotesStatus status, List<CollabNote> notes, bool isCreating
});




}
/// @nodoc
class _$CollabNotesStateCopyWithImpl<$Res>
    implements $CollabNotesStateCopyWith<$Res> {
  _$CollabNotesStateCopyWithImpl(this._self, this._then);

  final CollabNotesState _self;
  final $Res Function(CollabNotesState) _then;

/// Create a copy of CollabNotesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? notes = null,Object? isCreating = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollabNotesStatus,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<CollabNote>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CollabNotesState].
extension CollabNotesStatePatterns on CollabNotesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollabNotesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollabNotesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollabNotesState value)  $default,){
final _that = this;
switch (_that) {
case _CollabNotesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollabNotesState value)?  $default,){
final _that = this;
switch (_that) {
case _CollabNotesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CollabNotesStatus status,  List<CollabNote> notes,  bool isCreating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollabNotesState() when $default != null:
return $default(_that.status,_that.notes,_that.isCreating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CollabNotesStatus status,  List<CollabNote> notes,  bool isCreating)  $default,) {final _that = this;
switch (_that) {
case _CollabNotesState():
return $default(_that.status,_that.notes,_that.isCreating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CollabNotesStatus status,  List<CollabNote> notes,  bool isCreating)?  $default,) {final _that = this;
switch (_that) {
case _CollabNotesState() when $default != null:
return $default(_that.status,_that.notes,_that.isCreating);case _:
  return null;

}
}

}

/// @nodoc


class _CollabNotesState implements CollabNotesState {
  const _CollabNotesState({this.status = CollabNotesStatus.initial, final  List<CollabNote> notes = const <CollabNote>[], this.isCreating = false}): _notes = notes;


@override@JsonKey() final  CollabNotesStatus status;
 final  List<CollabNote> _notes;
@override@JsonKey() List<CollabNote> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

@override@JsonKey() final  bool isCreating;

/// Create a copy of CollabNotesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollabNotesStateCopyWith<_CollabNotesState> get copyWith => __$CollabNotesStateCopyWithImpl<_CollabNotesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollabNotesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._notes, _notes)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_notes),isCreating);

@override
String toString() {
  return 'CollabNotesState(status: $status, notes: $notes, isCreating: $isCreating)';
}


}

/// @nodoc
abstract mixin class _$CollabNotesStateCopyWith<$Res> implements $CollabNotesStateCopyWith<$Res> {
  factory _$CollabNotesStateCopyWith(_CollabNotesState value, $Res Function(_CollabNotesState) _then) = __$CollabNotesStateCopyWithImpl;
@override @useResult
$Res call({
 CollabNotesStatus status, List<CollabNote> notes, bool isCreating
});




}
/// @nodoc
class __$CollabNotesStateCopyWithImpl<$Res>
    implements _$CollabNotesStateCopyWith<$Res> {
  __$CollabNotesStateCopyWithImpl(this._self, this._then);

  final _CollabNotesState _self;
  final $Res Function(_CollabNotesState) _then;

/// Create a copy of CollabNotesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? notes = null,Object? isCreating = null,}) {
  return _then(_CollabNotesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollabNotesStatus,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<CollabNote>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
