// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'free_rooms_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FreeRoomsState {

 FreeRoomsStatus get status; List<FreeRoom> get rooms; String get building;
/// Create a copy of FreeRoomsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreeRoomsStateCopyWith<FreeRoomsState> get copyWith => _$FreeRoomsStateCopyWithImpl<FreeRoomsState>(this as FreeRoomsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FreeRoomsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.rooms, rooms)&&(identical(other.building, building) || other.building == building));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(rooms),building);

@override
String toString() {
  return 'FreeRoomsState(status: $status, rooms: $rooms, building: $building)';
}


}

/// @nodoc
abstract mixin class $FreeRoomsStateCopyWith<$Res>  {
  factory $FreeRoomsStateCopyWith(FreeRoomsState value, $Res Function(FreeRoomsState) _then) = _$FreeRoomsStateCopyWithImpl;
@useResult
$Res call({
 FreeRoomsStatus status, List<FreeRoom> rooms, String building
});




}
/// @nodoc
class _$FreeRoomsStateCopyWithImpl<$Res>
    implements $FreeRoomsStateCopyWith<$Res> {
  _$FreeRoomsStateCopyWithImpl(this._self, this._then);

  final FreeRoomsState _self;
  final $Res Function(FreeRoomsState) _then;

/// Create a copy of FreeRoomsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? rooms = null,Object? building = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FreeRoomsStatus,rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<FreeRoom>,building: null == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FreeRoomsState].
extension FreeRoomsStatePatterns on FreeRoomsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FreeRoomsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FreeRoomsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FreeRoomsState value)  $default,){
final _that = this;
switch (_that) {
case _FreeRoomsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FreeRoomsState value)?  $default,){
final _that = this;
switch (_that) {
case _FreeRoomsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FreeRoomsStatus status,  List<FreeRoom> rooms,  String building)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FreeRoomsState() when $default != null:
return $default(_that.status,_that.rooms,_that.building);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FreeRoomsStatus status,  List<FreeRoom> rooms,  String building)  $default,) {final _that = this;
switch (_that) {
case _FreeRoomsState():
return $default(_that.status,_that.rooms,_that.building);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FreeRoomsStatus status,  List<FreeRoom> rooms,  String building)?  $default,) {final _that = this;
switch (_that) {
case _FreeRoomsState() when $default != null:
return $default(_that.status,_that.rooms,_that.building);case _:
  return null;

}
}

}

/// @nodoc


class _FreeRoomsState extends FreeRoomsState {
  const _FreeRoomsState({this.status = FreeRoomsStatus.initial, final  List<FreeRoom> rooms = const <FreeRoom>[], this.building = 'all'}): _rooms = rooms,super._();


@override@JsonKey() final  FreeRoomsStatus status;
 final  List<FreeRoom> _rooms;
@override@JsonKey() List<FreeRoom> get rooms {
  if (_rooms is EqualUnmodifiableListView) return _rooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rooms);
}

@override@JsonKey() final  String building;

/// Create a copy of FreeRoomsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreeRoomsStateCopyWith<_FreeRoomsState> get copyWith => __$FreeRoomsStateCopyWithImpl<_FreeRoomsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FreeRoomsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._rooms, _rooms)&&(identical(other.building, building) || other.building == building));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_rooms),building);

@override
String toString() {
  return 'FreeRoomsState(status: $status, rooms: $rooms, building: $building)';
}


}

/// @nodoc
abstract mixin class _$FreeRoomsStateCopyWith<$Res> implements $FreeRoomsStateCopyWith<$Res> {
  factory _$FreeRoomsStateCopyWith(_FreeRoomsState value, $Res Function(_FreeRoomsState) _then) = __$FreeRoomsStateCopyWithImpl;
@override @useResult
$Res call({
 FreeRoomsStatus status, List<FreeRoom> rooms, String building
});




}
/// @nodoc
class __$FreeRoomsStateCopyWithImpl<$Res>
    implements _$FreeRoomsStateCopyWith<$Res> {
  __$FreeRoomsStateCopyWithImpl(this._self, this._then);

  final _FreeRoomsState _self;
  final $Res Function(_FreeRoomsState) _then;

/// Create a copy of FreeRoomsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? rooms = null,Object? building = null,}) {
  return _then(_FreeRoomsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FreeRoomsStatus,rooms: null == rooms ? _self._rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<FreeRoom>,building: null == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
