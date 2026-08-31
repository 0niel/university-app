// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleResponse {

 List<domain.SchedulePart> get data;
/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleResponseCopyWith<ScheduleResponse> get copyWith => _$ScheduleResponseCopyWithImpl<ScheduleResponse>(this as ScheduleResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleResponse&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ScheduleResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class $ScheduleResponseCopyWith<$Res>  {
  factory $ScheduleResponseCopyWith(ScheduleResponse value, $Res Function(ScheduleResponse) _then) = _$ScheduleResponseCopyWithImpl;
@useResult
$Res call({
 List<domain.SchedulePart> data
});




}
/// @nodoc
class _$ScheduleResponseCopyWithImpl<$Res>
    implements $ScheduleResponseCopyWith<$Res> {
  _$ScheduleResponseCopyWithImpl(this._self, this._then);

  final ScheduleResponse _self;
  final $Res Function(ScheduleResponse) _then;

/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<domain.SchedulePart>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleResponse].
extension ScheduleResponsePatterns on ScheduleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleResponse value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<domain.SchedulePart> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<domain.SchedulePart> data)  $default,) {final _that = this;
switch (_that) {
case _ScheduleResponse():
return $default(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<domain.SchedulePart> data)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleResponse implements ScheduleResponse {
  const _ScheduleResponse({required final  List<domain.SchedulePart> data}): _data = data;


 final  List<domain.SchedulePart> _data;
@override List<domain.SchedulePart> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleResponseCopyWith<_ScheduleResponse> get copyWith => __$ScheduleResponseCopyWithImpl<_ScheduleResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleResponse&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'ScheduleResponse(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ScheduleResponseCopyWith<$Res> implements $ScheduleResponseCopyWith<$Res> {
  factory _$ScheduleResponseCopyWith(_ScheduleResponse value, $Res Function(_ScheduleResponse) _then) = __$ScheduleResponseCopyWithImpl;
@override @useResult
$Res call({
 List<domain.SchedulePart> data
});




}
/// @nodoc
class __$ScheduleResponseCopyWithImpl<$Res>
    implements _$ScheduleResponseCopyWith<$Res> {
  __$ScheduleResponseCopyWithImpl(this._self, this._then);

  final _ScheduleResponse _self;
  final $Res Function(_ScheduleResponse) _then;

/// Create a copy of ScheduleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ScheduleResponse(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<domain.SchedulePart>,
  ));
}


}

// dart format on
