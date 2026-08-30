// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_notifications_client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PendingReminder {

 int get id; String? get payload;
/// Create a copy of PendingReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingReminderCopyWith<PendingReminder> get copyWith => _$PendingReminderCopyWithImpl<PendingReminder>(this as PendingReminder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingReminder&&(identical(other.id, id) || other.id == id)&&(identical(other.payload, payload) || other.payload == payload));
}


@override
int get hashCode => Object.hash(runtimeType,id,payload);

@override
String toString() {
  return 'PendingReminder(id: $id, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $PendingReminderCopyWith<$Res>  {
  factory $PendingReminderCopyWith(PendingReminder value, $Res Function(PendingReminder) _then) = _$PendingReminderCopyWithImpl;
@useResult
$Res call({
 int id, String? payload
});




}
/// @nodoc
class _$PendingReminderCopyWithImpl<$Res>
    implements $PendingReminderCopyWith<$Res> {
  _$PendingReminderCopyWithImpl(this._self, this._then);

  final PendingReminder _self;
  final $Res Function(PendingReminder) _then;

/// Create a copy of PendingReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? payload = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingReminder].
extension PendingReminderPatterns on PendingReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingReminder value)  $default,){
final _that = this;
switch (_that) {
case _PendingReminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingReminder value)?  $default,){
final _that = this;
switch (_that) {
case _PendingReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingReminder() when $default != null:
return $default(_that.id,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? payload)  $default,) {final _that = this;
switch (_that) {
case _PendingReminder():
return $default(_that.id,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? payload)?  $default,) {final _that = this;
switch (_that) {
case _PendingReminder() when $default != null:
return $default(_that.id,_that.payload);case _:
  return null;

}
}

}

/// @nodoc


class _PendingReminder implements PendingReminder {
  const _PendingReminder({required this.id, this.payload});


@override final  int id;
@override final  String? payload;

/// Create a copy of PendingReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingReminderCopyWith<_PendingReminder> get copyWith => __$PendingReminderCopyWithImpl<_PendingReminder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingReminder&&(identical(other.id, id) || other.id == id)&&(identical(other.payload, payload) || other.payload == payload));
}


@override
int get hashCode => Object.hash(runtimeType,id,payload);

@override
String toString() {
  return 'PendingReminder(id: $id, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$PendingReminderCopyWith<$Res> implements $PendingReminderCopyWith<$Res> {
  factory _$PendingReminderCopyWith(_PendingReminder value, $Res Function(_PendingReminder) _then) = __$PendingReminderCopyWithImpl;
@override @useResult
$Res call({
 int id, String? payload
});




}
/// @nodoc
class __$PendingReminderCopyWithImpl<$Res>
    implements _$PendingReminderCopyWith<$Res> {
  __$PendingReminderCopyWithImpl(this._self, this._then);

  final _PendingReminder _self;
  final $Res Function(_PendingReminder) _then;

/// Create a copy of PendingReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? payload = freezed,}) {
  return _then(_PendingReminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
