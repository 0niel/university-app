// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_location_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendLocationUpdate {

@JsonKey(name: 'user_id') String get userId; double get latitude; double get longitude; int? get battery; String get mood;@JsonKey(name: 'is_ghost') bool get isGhost;@JsonKey(name: 'updated_at', fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson) DateTime? get updatedAt;
/// Create a copy of FriendLocationUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendLocationUpdateCopyWith<FriendLocationUpdate> get copyWith => _$FriendLocationUpdateCopyWithImpl<FriendLocationUpdate>(this as FriendLocationUpdate, _$identity);

  /// Serializes this FriendLocationUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendLocationUpdate&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.battery, battery) || other.battery == battery)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.isGhost, isGhost) || other.isGhost == isGhost)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,latitude,longitude,battery,mood,isGhost,updatedAt);

@override
String toString() {
  return 'FriendLocationUpdate(userId: $userId, latitude: $latitude, longitude: $longitude, battery: $battery, mood: $mood, isGhost: $isGhost, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FriendLocationUpdateCopyWith<$Res>  {
  factory $FriendLocationUpdateCopyWith(FriendLocationUpdate value, $Res Function(FriendLocationUpdate) _then) = _$FriendLocationUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId, double latitude, double longitude, int? battery, String mood,@JsonKey(name: 'is_ghost') bool isGhost,@JsonKey(name: 'updated_at', fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class _$FriendLocationUpdateCopyWithImpl<$Res>
    implements $FriendLocationUpdateCopyWith<$Res> {
  _$FriendLocationUpdateCopyWithImpl(this._self, this._then);

  final FriendLocationUpdate _self;
  final $Res Function(FriendLocationUpdate) _then;

/// Create a copy of FriendLocationUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? latitude = null,Object? longitude = null,Object? battery = freezed,Object? mood = null,Object? isGhost = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,battery: freezed == battery ? _self.battery : battery // ignore: cast_nullable_to_non_nullable
as int?,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,isGhost: null == isGhost ? _self.isGhost : isGhost // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FriendLocationUpdate].
extension FriendLocationUpdatePatterns on FriendLocationUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendLocationUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendLocationUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendLocationUpdate value)  $default,){
final _that = this;
switch (_that) {
case _FriendLocationUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendLocationUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _FriendLocationUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  double latitude,  double longitude,  int? battery,  String mood, @JsonKey(name: 'is_ghost')  bool isGhost, @JsonKey(name: 'updated_at', fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendLocationUpdate() when $default != null:
return $default(_that.userId,_that.latitude,_that.longitude,_that.battery,_that.mood,_that.isGhost,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId,  double latitude,  double longitude,  int? battery,  String mood, @JsonKey(name: 'is_ghost')  bool isGhost, @JsonKey(name: 'updated_at', fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FriendLocationUpdate():
return $default(_that.userId,_that.latitude,_that.longitude,_that.battery,_that.mood,_that.isGhost,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId,  double latitude,  double longitude,  int? battery,  String mood, @JsonKey(name: 'is_ghost')  bool isGhost, @JsonKey(name: 'updated_at', fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FriendLocationUpdate() when $default != null:
return $default(_that.userId,_that.latitude,_that.longitude,_that.battery,_that.mood,_that.isGhost,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendLocationUpdate extends FriendLocationUpdate {
  const _FriendLocationUpdate({@JsonKey(name: 'user_id') required this.userId, required this.latitude, required this.longitude, this.battery, this.mood = '', @JsonKey(name: 'is_ghost') this.isGhost = false, @JsonKey(name: 'updated_at', fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson) this.updatedAt}): super._();
  factory _FriendLocationUpdate.fromJson(Map<String, dynamic> json) => _$FriendLocationUpdateFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override final  double latitude;
@override final  double longitude;
@override final  int? battery;
@override@JsonKey() final  String mood;
@override@JsonKey(name: 'is_ghost') final  bool isGhost;
@override@JsonKey(name: 'updated_at', fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson) final  DateTime? updatedAt;

/// Create a copy of FriendLocationUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendLocationUpdateCopyWith<_FriendLocationUpdate> get copyWith => __$FriendLocationUpdateCopyWithImpl<_FriendLocationUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendLocationUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendLocationUpdate&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.battery, battery) || other.battery == battery)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.isGhost, isGhost) || other.isGhost == isGhost)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,latitude,longitude,battery,mood,isGhost,updatedAt);

@override
String toString() {
  return 'FriendLocationUpdate(userId: $userId, latitude: $latitude, longitude: $longitude, battery: $battery, mood: $mood, isGhost: $isGhost, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FriendLocationUpdateCopyWith<$Res> implements $FriendLocationUpdateCopyWith<$Res> {
  factory _$FriendLocationUpdateCopyWith(_FriendLocationUpdate value, $Res Function(_FriendLocationUpdate) _then) = __$FriendLocationUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId, double latitude, double longitude, int? battery, String mood,@JsonKey(name: 'is_ghost') bool isGhost,@JsonKey(name: 'updated_at', fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class __$FriendLocationUpdateCopyWithImpl<$Res>
    implements _$FriendLocationUpdateCopyWith<$Res> {
  __$FriendLocationUpdateCopyWithImpl(this._self, this._then);

  final _FriendLocationUpdate _self;
  final $Res Function(_FriendLocationUpdate) _then;

/// Create a copy of FriendLocationUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? latitude = null,Object? longitude = null,Object? battery = freezed,Object? mood = null,Object? isGhost = null,Object? updatedAt = freezed,}) {
  return _then(_FriendLocationUpdate(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,battery: freezed == battery ? _self.battery : battery // ignore: cast_nullable_to_non_nullable
as int?,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,isGhost: null == isGhost ? _self.isGhost : isGhost // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
