// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'free_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FreeRoom {

@JsonKey(defaultValue: '') String get room; String? get campus;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get freeUntil;
/// Create a copy of FreeRoom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreeRoomCopyWith<FreeRoom> get copyWith => _$FreeRoomCopyWithImpl<FreeRoom>(this as FreeRoom, _$identity);

  /// Serializes this FreeRoom to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FreeRoom&&(identical(other.room, room) || other.room == room)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.freeUntil, freeUntil) || other.freeUntil == freeUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,room,campus,freeUntil);

@override
String toString() {
  return 'FreeRoom(room: $room, campus: $campus, freeUntil: $freeUntil)';
}


}

/// @nodoc
abstract mixin class $FreeRoomCopyWith<$Res>  {
  factory $FreeRoomCopyWith(FreeRoom value, $Res Function(FreeRoom) _then) = _$FreeRoomCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String room, String? campus,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? freeUntil
});




}
/// @nodoc
class _$FreeRoomCopyWithImpl<$Res>
    implements $FreeRoomCopyWith<$Res> {
  _$FreeRoomCopyWithImpl(this._self, this._then);

  final FreeRoom _self;
  final $Res Function(FreeRoom) _then;

/// Create a copy of FreeRoom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? room = null,Object? campus = freezed,Object? freeUntil = freezed,}) {
  return _then(_self.copyWith(
room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,campus: freezed == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String?,freeUntil: freezed == freeUntil ? _self.freeUntil : freeUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FreeRoom].
extension FreeRoomPatterns on FreeRoom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FreeRoom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FreeRoom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FreeRoom value)  $default,){
final _that = this;
switch (_that) {
case _FreeRoom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FreeRoom value)?  $default,){
final _that = this;
switch (_that) {
case _FreeRoom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String room,  String? campus, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? freeUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FreeRoom() when $default != null:
return $default(_that.room,_that.campus,_that.freeUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String room,  String? campus, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? freeUntil)  $default,) {final _that = this;
switch (_that) {
case _FreeRoom():
return $default(_that.room,_that.campus,_that.freeUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String room,  String? campus, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? freeUntil)?  $default,) {final _that = this;
switch (_that) {
case _FreeRoom() when $default != null:
return $default(_that.room,_that.campus,_that.freeUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FreeRoom extends FreeRoom {
  const _FreeRoom({@JsonKey(defaultValue: '') required this.room, this.campus, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.freeUntil}): super._();
  factory _FreeRoom.fromJson(Map<String, dynamic> json) => _$FreeRoomFromJson(json);

@override@JsonKey(defaultValue: '') final  String room;
@override final  String? campus;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? freeUntil;

/// Create a copy of FreeRoom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreeRoomCopyWith<_FreeRoom> get copyWith => __$FreeRoomCopyWithImpl<_FreeRoom>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FreeRoomToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FreeRoom&&(identical(other.room, room) || other.room == room)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.freeUntil, freeUntil) || other.freeUntil == freeUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,room,campus,freeUntil);

@override
String toString() {
  return 'FreeRoom(room: $room, campus: $campus, freeUntil: $freeUntil)';
}


}

/// @nodoc
abstract mixin class _$FreeRoomCopyWith<$Res> implements $FreeRoomCopyWith<$Res> {
  factory _$FreeRoomCopyWith(_FreeRoom value, $Res Function(_FreeRoom) _then) = __$FreeRoomCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String room, String? campus,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? freeUntil
});




}
/// @nodoc
class __$FreeRoomCopyWithImpl<$Res>
    implements _$FreeRoomCopyWith<$Res> {
  __$FreeRoomCopyWithImpl(this._self, this._then);

  final _FreeRoom _self;
  final $Res Function(_FreeRoom) _then;

/// Create a copy of FreeRoom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? room = null,Object? campus = freezed,Object? freeUntil = freezed,}) {
  return _then(_FreeRoom(
room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,campus: freezed == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String?,freeUntil: freezed == freeUntil ? _self.freeUntil : freeUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
