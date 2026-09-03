// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_booking_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomBooking {

 String get room; DateTime get until; String? get campus;
/// Create a copy of RoomBooking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomBookingCopyWith<RoomBooking> get copyWith => _$RoomBookingCopyWithImpl<RoomBooking>(this as RoomBooking, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomBooking&&(identical(other.room, room) || other.room == room)&&(identical(other.until, until) || other.until == until)&&(identical(other.campus, campus) || other.campus == campus));
}


@override
int get hashCode => Object.hash(runtimeType,room,until,campus);

@override
String toString() {
  return 'RoomBooking(room: $room, until: $until, campus: $campus)';
}


}

/// @nodoc
abstract mixin class $RoomBookingCopyWith<$Res>  {
  factory $RoomBookingCopyWith(RoomBooking value, $Res Function(RoomBooking) _then) = _$RoomBookingCopyWithImpl;
@useResult
$Res call({
 String room, DateTime until, String? campus
});




}
/// @nodoc
class _$RoomBookingCopyWithImpl<$Res>
    implements $RoomBookingCopyWith<$Res> {
  _$RoomBookingCopyWithImpl(this._self, this._then);

  final RoomBooking _self;
  final $Res Function(RoomBooking) _then;

/// Create a copy of RoomBooking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? room = null,Object? until = null,Object? campus = freezed,}) {
  return _then(_self.copyWith(
room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,until: null == until ? _self.until : until // ignore: cast_nullable_to_non_nullable
as DateTime,campus: freezed == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomBooking].
extension RoomBookingPatterns on RoomBooking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomBooking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomBooking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomBooking value)  $default,){
final _that = this;
switch (_that) {
case _RoomBooking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomBooking value)?  $default,){
final _that = this;
switch (_that) {
case _RoomBooking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String room,  DateTime until,  String? campus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomBooking() when $default != null:
return $default(_that.room,_that.until,_that.campus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String room,  DateTime until,  String? campus)  $default,) {final _that = this;
switch (_that) {
case _RoomBooking():
return $default(_that.room,_that.until,_that.campus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String room,  DateTime until,  String? campus)?  $default,) {final _that = this;
switch (_that) {
case _RoomBooking() when $default != null:
return $default(_that.room,_that.until,_that.campus);case _:
  return null;

}
}

}

/// @nodoc


class _RoomBooking implements RoomBooking {
  const _RoomBooking({required this.room, required this.until, this.campus});


@override final  String room;
@override final  DateTime until;
@override final  String? campus;

/// Create a copy of RoomBooking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomBookingCopyWith<_RoomBooking> get copyWith => __$RoomBookingCopyWithImpl<_RoomBooking>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomBooking&&(identical(other.room, room) || other.room == room)&&(identical(other.until, until) || other.until == until)&&(identical(other.campus, campus) || other.campus == campus));
}


@override
int get hashCode => Object.hash(runtimeType,room,until,campus);

@override
String toString() {
  return 'RoomBooking(room: $room, until: $until, campus: $campus)';
}


}

/// @nodoc
abstract mixin class _$RoomBookingCopyWith<$Res> implements $RoomBookingCopyWith<$Res> {
  factory _$RoomBookingCopyWith(_RoomBooking value, $Res Function(_RoomBooking) _then) = __$RoomBookingCopyWithImpl;
@override @useResult
$Res call({
 String room, DateTime until, String? campus
});




}
/// @nodoc
class __$RoomBookingCopyWithImpl<$Res>
    implements _$RoomBookingCopyWith<$Res> {
  __$RoomBookingCopyWithImpl(this._self, this._then);

  final _RoomBooking _self;
  final $Res Function(_RoomBooking) _then;

/// Create a copy of RoomBooking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? room = null,Object? until = null,Object? campus = freezed,}) {
  return _then(_RoomBooking(
room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,until: null == until ? _self.until : until // ignore: cast_nullable_to_non_nullable
as DateTime,campus: freezed == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$RoomBookingState {

 RoomBooking? get booking;
/// Create a copy of RoomBookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomBookingStateCopyWith<RoomBookingState> get copyWith => _$RoomBookingStateCopyWithImpl<RoomBookingState>(this as RoomBookingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomBookingState&&(identical(other.booking, booking) || other.booking == booking));
}


@override
int get hashCode => Object.hash(runtimeType,booking);

@override
String toString() {
  return 'RoomBookingState(booking: $booking)';
}


}

/// @nodoc
abstract mixin class $RoomBookingStateCopyWith<$Res>  {
  factory $RoomBookingStateCopyWith(RoomBookingState value, $Res Function(RoomBookingState) _then) = _$RoomBookingStateCopyWithImpl;
@useResult
$Res call({
 RoomBooking? booking
});


$RoomBookingCopyWith<$Res>? get booking;

}
/// @nodoc
class _$RoomBookingStateCopyWithImpl<$Res>
    implements $RoomBookingStateCopyWith<$Res> {
  _$RoomBookingStateCopyWithImpl(this._self, this._then);

  final RoomBookingState _self;
  final $Res Function(RoomBookingState) _then;

/// Create a copy of RoomBookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = freezed,}) {
  return _then(_self.copyWith(
booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as RoomBooking?,
  ));
}
/// Create a copy of RoomBookingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomBookingCopyWith<$Res>? get booking {
    if (_self.booking == null) {
    return null;
  }

  return $RoomBookingCopyWith<$Res>(_self.booking!, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomBookingState].
extension RoomBookingStatePatterns on RoomBookingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomBookingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomBookingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomBookingState value)  $default,){
final _that = this;
switch (_that) {
case _RoomBookingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomBookingState value)?  $default,){
final _that = this;
switch (_that) {
case _RoomBookingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RoomBooking? booking)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomBookingState() when $default != null:
return $default(_that.booking);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RoomBooking? booking)  $default,) {final _that = this;
switch (_that) {
case _RoomBookingState():
return $default(_that.booking);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RoomBooking? booking)?  $default,) {final _that = this;
switch (_that) {
case _RoomBookingState() when $default != null:
return $default(_that.booking);case _:
  return null;

}
}

}

/// @nodoc


class _RoomBookingState extends RoomBookingState {
  const _RoomBookingState({this.booking}): super._();


@override final  RoomBooking? booking;

/// Create a copy of RoomBookingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomBookingStateCopyWith<_RoomBookingState> get copyWith => __$RoomBookingStateCopyWithImpl<_RoomBookingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomBookingState&&(identical(other.booking, booking) || other.booking == booking));
}


@override
int get hashCode => Object.hash(runtimeType,booking);

@override
String toString() {
  return 'RoomBookingState(booking: $booking)';
}


}

/// @nodoc
abstract mixin class _$RoomBookingStateCopyWith<$Res> implements $RoomBookingStateCopyWith<$Res> {
  factory _$RoomBookingStateCopyWith(_RoomBookingState value, $Res Function(_RoomBookingState) _then) = __$RoomBookingStateCopyWithImpl;
@override @useResult
$Res call({
 RoomBooking? booking
});


@override $RoomBookingCopyWith<$Res>? get booking;

}
/// @nodoc
class __$RoomBookingStateCopyWithImpl<$Res>
    implements _$RoomBookingStateCopyWith<$Res> {
  __$RoomBookingStateCopyWithImpl(this._self, this._then);

  final _RoomBookingState _self;
  final $Res Function(_RoomBookingState) _then;

/// Create a copy of RoomBookingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = freezed,}) {
  return _then(_RoomBookingState(
booking: freezed == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as RoomBooking?,
  ));
}

/// Create a copy of RoomBookingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomBookingCopyWith<$Res>? get booking {
    if (_self.booking == null) {
    return null;
  }

  return $RoomBookingCopyWith<$Res>(_self.booking!, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}

// dart format on
