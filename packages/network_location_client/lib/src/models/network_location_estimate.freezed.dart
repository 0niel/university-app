// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_location_estimate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NetworkLocationEstimate {

 double get latitude; double get longitude; double get accuracyM;
/// Create a copy of NetworkLocationEstimate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkLocationEstimateCopyWith<NetworkLocationEstimate> get copyWith => _$NetworkLocationEstimateCopyWithImpl<NetworkLocationEstimate>(this as NetworkLocationEstimate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkLocationEstimate&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracyM, accuracyM) || other.accuracyM == accuracyM));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracyM);

@override
String toString() {
  return 'NetworkLocationEstimate(latitude: $latitude, longitude: $longitude, accuracyM: $accuracyM)';
}


}

/// @nodoc
abstract mixin class $NetworkLocationEstimateCopyWith<$Res>  {
  factory $NetworkLocationEstimateCopyWith(NetworkLocationEstimate value, $Res Function(NetworkLocationEstimate) _then) = _$NetworkLocationEstimateCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double accuracyM
});




}
/// @nodoc
class _$NetworkLocationEstimateCopyWithImpl<$Res>
    implements $NetworkLocationEstimateCopyWith<$Res> {
  _$NetworkLocationEstimateCopyWithImpl(this._self, this._then);

  final NetworkLocationEstimate _self;
  final $Res Function(NetworkLocationEstimate) _then;

/// Create a copy of NetworkLocationEstimate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? accuracyM = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracyM: null == accuracyM ? _self.accuracyM : accuracyM // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkLocationEstimate].
extension NetworkLocationEstimatePatterns on NetworkLocationEstimate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkLocationEstimate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkLocationEstimate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkLocationEstimate value)  $default,){
final _that = this;
switch (_that) {
case _NetworkLocationEstimate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkLocationEstimate value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkLocationEstimate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracyM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkLocationEstimate() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracyM);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracyM)  $default,) {final _that = this;
switch (_that) {
case _NetworkLocationEstimate():
return $default(_that.latitude,_that.longitude,_that.accuracyM);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  double accuracyM)?  $default,) {final _that = this;
switch (_that) {
case _NetworkLocationEstimate() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracyM);case _:
  return null;

}
}

}

/// @nodoc


class _NetworkLocationEstimate implements NetworkLocationEstimate {
  const _NetworkLocationEstimate({required this.latitude, required this.longitude, required this.accuracyM});


@override final  double latitude;
@override final  double longitude;
@override final  double accuracyM;

/// Create a copy of NetworkLocationEstimate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkLocationEstimateCopyWith<_NetworkLocationEstimate> get copyWith => __$NetworkLocationEstimateCopyWithImpl<_NetworkLocationEstimate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkLocationEstimate&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracyM, accuracyM) || other.accuracyM == accuracyM));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracyM);

@override
String toString() {
  return 'NetworkLocationEstimate(latitude: $latitude, longitude: $longitude, accuracyM: $accuracyM)';
}


}

/// @nodoc
abstract mixin class _$NetworkLocationEstimateCopyWith<$Res> implements $NetworkLocationEstimateCopyWith<$Res> {
  factory _$NetworkLocationEstimateCopyWith(_NetworkLocationEstimate value, $Res Function(_NetworkLocationEstimate) _then) = __$NetworkLocationEstimateCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, double accuracyM
});




}
/// @nodoc
class __$NetworkLocationEstimateCopyWithImpl<$Res>
    implements _$NetworkLocationEstimateCopyWith<$Res> {
  __$NetworkLocationEstimateCopyWithImpl(this._self, this._then);

  final _NetworkLocationEstimate _self;
  final $Res Function(_NetworkLocationEstimate) _then;

/// Create a copy of NetworkLocationEstimate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracyM = null,}) {
  return _then(_NetworkLocationEstimate(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracyM: null == accuracyM ? _self.accuracyM : accuracyM // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
