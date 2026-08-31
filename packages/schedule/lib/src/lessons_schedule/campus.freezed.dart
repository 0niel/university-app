// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campus.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Campus {

 String get name; String? get shortName; double? get latitude; double? get longitude; String? get uid;
/// Create a copy of Campus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampusCopyWith<Campus> get copyWith => _$CampusCopyWithImpl<Campus>(this as Campus, _$identity);

  /// Serializes this Campus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Campus&&(identical(other.name, name) || other.name == name)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.uid, uid) || other.uid == uid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,shortName,latitude,longitude,uid);

@override
String toString() {
  return 'Campus(name: $name, shortName: $shortName, latitude: $latitude, longitude: $longitude, uid: $uid)';
}


}

/// @nodoc
abstract mixin class $CampusCopyWith<$Res>  {
  factory $CampusCopyWith(Campus value, $Res Function(Campus) _then) = _$CampusCopyWithImpl;
@useResult
$Res call({
 String name, String? shortName, double? latitude, double? longitude, String? uid
});




}
/// @nodoc
class _$CampusCopyWithImpl<$Res>
    implements $CampusCopyWith<$Res> {
  _$CampusCopyWithImpl(this._self, this._then);

  final Campus _self;
  final $Res Function(Campus) _then;

/// Create a copy of Campus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? shortName = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? uid = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Campus].
extension CampusPatterns on Campus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Campus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Campus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Campus value)  $default,){
final _that = this;
switch (_that) {
case _Campus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Campus value)?  $default,){
final _that = this;
switch (_that) {
case _Campus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? shortName,  double? latitude,  double? longitude,  String? uid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Campus() when $default != null:
return $default(_that.name,_that.shortName,_that.latitude,_that.longitude,_that.uid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? shortName,  double? latitude,  double? longitude,  String? uid)  $default,) {final _that = this;
switch (_that) {
case _Campus():
return $default(_that.name,_that.shortName,_that.latitude,_that.longitude,_that.uid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? shortName,  double? latitude,  double? longitude,  String? uid)?  $default,) {final _that = this;
switch (_that) {
case _Campus() when $default != null:
return $default(_that.name,_that.shortName,_that.latitude,_that.longitude,_that.uid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Campus implements Campus {
  const _Campus({required this.name, this.shortName, this.latitude, this.longitude, this.uid}): assert(latitude == null && longitude == null || latitude != null && longitude != null, 'Latitude and longitude must be both null or both not null');
  factory _Campus.fromJson(Map<String, dynamic> json) => _$CampusFromJson(json);

@override final  String name;
@override final  String? shortName;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? uid;

/// Create a copy of Campus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampusCopyWith<_Campus> get copyWith => __$CampusCopyWithImpl<_Campus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Campus&&(identical(other.name, name) || other.name == name)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.uid, uid) || other.uid == uid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,shortName,latitude,longitude,uid);

@override
String toString() {
  return 'Campus(name: $name, shortName: $shortName, latitude: $latitude, longitude: $longitude, uid: $uid)';
}


}

/// @nodoc
abstract mixin class _$CampusCopyWith<$Res> implements $CampusCopyWith<$Res> {
  factory _$CampusCopyWith(_Campus value, $Res Function(_Campus) _then) = __$CampusCopyWithImpl;
@override @useResult
$Res call({
 String name, String? shortName, double? latitude, double? longitude, String? uid
});




}
/// @nodoc
class __$CampusCopyWithImpl<$Res>
    implements _$CampusCopyWith<$Res> {
  __$CampusCopyWithImpl(this._self, this._then);

  final _Campus _self;
  final $Res Function(_Campus) _then;

/// Create a copy of Campus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? shortName = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? uid = freezed,}) {
  return _then(_Campus(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
