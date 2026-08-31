// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_change_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleChangeSlot {

 String? get start; String? get end; List<String> get rooms; List<String> get teachers;
/// Create a copy of ScheduleChangeSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleChangeSlotCopyWith<ScheduleChangeSlot> get copyWith => _$ScheduleChangeSlotCopyWithImpl<ScheduleChangeSlot>(this as ScheduleChangeSlot, _$identity);

  /// Serializes this ScheduleChangeSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleChangeSlot&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&const DeepCollectionEquality().equals(other.rooms, rooms)&&const DeepCollectionEquality().equals(other.teachers, teachers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,const DeepCollectionEquality().hash(rooms),const DeepCollectionEquality().hash(teachers));

@override
String toString() {
  return 'ScheduleChangeSlot(start: $start, end: $end, rooms: $rooms, teachers: $teachers)';
}


}

/// @nodoc
abstract mixin class $ScheduleChangeSlotCopyWith<$Res>  {
  factory $ScheduleChangeSlotCopyWith(ScheduleChangeSlot value, $Res Function(ScheduleChangeSlot) _then) = _$ScheduleChangeSlotCopyWithImpl;
@useResult
$Res call({
 String? start, String? end, List<String> rooms, List<String> teachers
});




}
/// @nodoc
class _$ScheduleChangeSlotCopyWithImpl<$Res>
    implements $ScheduleChangeSlotCopyWith<$Res> {
  _$ScheduleChangeSlotCopyWithImpl(this._self, this._then);

  final ScheduleChangeSlot _self;
  final $Res Function(ScheduleChangeSlot) _then;

/// Create a copy of ScheduleChangeSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = freezed,Object? end = freezed,Object? rooms = null,Object? teachers = null,}) {
  return _then(_self.copyWith(
start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String?,rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<String>,teachers: null == teachers ? _self.teachers : teachers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleChangeSlot].
extension ScheduleChangeSlotPatterns on ScheduleChangeSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleChangeSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleChangeSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleChangeSlot value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleChangeSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleChangeSlot value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleChangeSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? start,  String? end,  List<String> rooms,  List<String> teachers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleChangeSlot() when $default != null:
return $default(_that.start,_that.end,_that.rooms,_that.teachers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? start,  String? end,  List<String> rooms,  List<String> teachers)  $default,) {final _that = this;
switch (_that) {
case _ScheduleChangeSlot():
return $default(_that.start,_that.end,_that.rooms,_that.teachers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? start,  String? end,  List<String> rooms,  List<String> teachers)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleChangeSlot() when $default != null:
return $default(_that.start,_that.end,_that.rooms,_that.teachers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleChangeSlot extends ScheduleChangeSlot {
  const _ScheduleChangeSlot({this.start, this.end, final  List<String> rooms = const [], final  List<String> teachers = const []}): _rooms = rooms,_teachers = teachers,super._();
  factory _ScheduleChangeSlot.fromJson(Map<String, dynamic> json) => _$ScheduleChangeSlotFromJson(json);

@override final  String? start;
@override final  String? end;
 final  List<String> _rooms;
@override@JsonKey() List<String> get rooms {
  if (_rooms is EqualUnmodifiableListView) return _rooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rooms);
}

 final  List<String> _teachers;
@override@JsonKey() List<String> get teachers {
  if (_teachers is EqualUnmodifiableListView) return _teachers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teachers);
}


/// Create a copy of ScheduleChangeSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleChangeSlotCopyWith<_ScheduleChangeSlot> get copyWith => __$ScheduleChangeSlotCopyWithImpl<_ScheduleChangeSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleChangeSlotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleChangeSlot&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&const DeepCollectionEquality().equals(other._rooms, _rooms)&&const DeepCollectionEquality().equals(other._teachers, _teachers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,const DeepCollectionEquality().hash(_rooms),const DeepCollectionEquality().hash(_teachers));

@override
String toString() {
  return 'ScheduleChangeSlot(start: $start, end: $end, rooms: $rooms, teachers: $teachers)';
}


}

/// @nodoc
abstract mixin class _$ScheduleChangeSlotCopyWith<$Res> implements $ScheduleChangeSlotCopyWith<$Res> {
  factory _$ScheduleChangeSlotCopyWith(_ScheduleChangeSlot value, $Res Function(_ScheduleChangeSlot) _then) = __$ScheduleChangeSlotCopyWithImpl;
@override @useResult
$Res call({
 String? start, String? end, List<String> rooms, List<String> teachers
});




}
/// @nodoc
class __$ScheduleChangeSlotCopyWithImpl<$Res>
    implements _$ScheduleChangeSlotCopyWith<$Res> {
  __$ScheduleChangeSlotCopyWithImpl(this._self, this._then);

  final _ScheduleChangeSlot _self;
  final $Res Function(_ScheduleChangeSlot) _then;

/// Create a copy of ScheduleChangeSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = freezed,Object? end = freezed,Object? rooms = null,Object? teachers = null,}) {
  return _then(_ScheduleChangeSlot(
start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String?,rooms: null == rooms ? _self._rooms : rooms // ignore: cast_nullable_to_non_nullable
as List<String>,teachers: null == teachers ? _self._teachers : teachers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
