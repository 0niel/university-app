// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wifi_access_point_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WifiAccessPointReading {

 String get bssid; int get rssi;
/// Create a copy of WifiAccessPointReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WifiAccessPointReadingCopyWith<WifiAccessPointReading> get copyWith => _$WifiAccessPointReadingCopyWithImpl<WifiAccessPointReading>(this as WifiAccessPointReading, _$identity);

  /// Serializes this WifiAccessPointReading to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WifiAccessPointReading&&(identical(other.bssid, bssid) || other.bssid == bssid)&&(identical(other.rssi, rssi) || other.rssi == rssi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bssid,rssi);

@override
String toString() {
  return 'WifiAccessPointReading(bssid: $bssid, rssi: $rssi)';
}


}

/// @nodoc
abstract mixin class $WifiAccessPointReadingCopyWith<$Res>  {
  factory $WifiAccessPointReadingCopyWith(WifiAccessPointReading value, $Res Function(WifiAccessPointReading) _then) = _$WifiAccessPointReadingCopyWithImpl;
@useResult
$Res call({
 String bssid, int rssi
});




}
/// @nodoc
class _$WifiAccessPointReadingCopyWithImpl<$Res>
    implements $WifiAccessPointReadingCopyWith<$Res> {
  _$WifiAccessPointReadingCopyWithImpl(this._self, this._then);

  final WifiAccessPointReading _self;
  final $Res Function(WifiAccessPointReading) _then;

/// Create a copy of WifiAccessPointReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bssid = null,Object? rssi = null,}) {
  return _then(_self.copyWith(
bssid: null == bssid ? _self.bssid : bssid // ignore: cast_nullable_to_non_nullable
as String,rssi: null == rssi ? _self.rssi : rssi // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WifiAccessPointReading].
extension WifiAccessPointReadingPatterns on WifiAccessPointReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WifiAccessPointReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WifiAccessPointReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WifiAccessPointReading value)  $default,){
final _that = this;
switch (_that) {
case _WifiAccessPointReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WifiAccessPointReading value)?  $default,){
final _that = this;
switch (_that) {
case _WifiAccessPointReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bssid,  int rssi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WifiAccessPointReading() when $default != null:
return $default(_that.bssid,_that.rssi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bssid,  int rssi)  $default,) {final _that = this;
switch (_that) {
case _WifiAccessPointReading():
return $default(_that.bssid,_that.rssi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bssid,  int rssi)?  $default,) {final _that = this;
switch (_that) {
case _WifiAccessPointReading() when $default != null:
return $default(_that.bssid,_that.rssi);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WifiAccessPointReading extends WifiAccessPointReading {
  const _WifiAccessPointReading({required this.bssid, required this.rssi}): super._();
  factory _WifiAccessPointReading.fromJson(Map<String, dynamic> json) => _$WifiAccessPointReadingFromJson(json);

@override final  String bssid;
@override final  int rssi;

/// Create a copy of WifiAccessPointReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WifiAccessPointReadingCopyWith<_WifiAccessPointReading> get copyWith => __$WifiAccessPointReadingCopyWithImpl<_WifiAccessPointReading>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WifiAccessPointReadingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WifiAccessPointReading&&(identical(other.bssid, bssid) || other.bssid == bssid)&&(identical(other.rssi, rssi) || other.rssi == rssi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bssid,rssi);

@override
String toString() {
  return 'WifiAccessPointReading(bssid: $bssid, rssi: $rssi)';
}


}

/// @nodoc
abstract mixin class _$WifiAccessPointReadingCopyWith<$Res> implements $WifiAccessPointReadingCopyWith<$Res> {
  factory _$WifiAccessPointReadingCopyWith(_WifiAccessPointReading value, $Res Function(_WifiAccessPointReading) _then) = __$WifiAccessPointReadingCopyWithImpl;
@override @useResult
$Res call({
 String bssid, int rssi
});




}
/// @nodoc
class __$WifiAccessPointReadingCopyWithImpl<$Res>
    implements _$WifiAccessPointReadingCopyWith<$Res> {
  __$WifiAccessPointReadingCopyWithImpl(this._self, this._then);

  final _WifiAccessPointReading _self;
  final $Res Function(_WifiAccessPointReading) _then;

/// Create a copy of WifiAccessPointReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bssid = null,Object? rssi = null,}) {
  return _then(_WifiAccessPointReading(
bssid: null == bssid ? _self.bssid : bssid // ignore: cast_nullable_to_non_nullable
as String,rssi: null == rssi ? _self.rssi : rssi // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
