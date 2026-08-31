// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Friend {

 String get friendshipId; String get userId;@JsonKey(defaultValue: 'Студент') String get fullName; String? get handle; String? get group; double? get latitude; double? get longitude; int? get battery; String get mood; bool get isGhost;@JsonKey(fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson) DateTime? get locationUpdatedAt;
/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendCopyWith<Friend> get copyWith => _$FriendCopyWithImpl<Friend>(this as Friend, _$identity);

  /// Serializes this Friend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Friend&&(identical(other.friendshipId, friendshipId) || other.friendshipId == friendshipId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.group, group) || other.group == group)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.battery, battery) || other.battery == battery)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.isGhost, isGhost) || other.isGhost == isGhost)&&(identical(other.locationUpdatedAt, locationUpdatedAt) || other.locationUpdatedAt == locationUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,friendshipId,userId,fullName,handle,group,latitude,longitude,battery,mood,isGhost,locationUpdatedAt);

@override
String toString() {
  return 'Friend(friendshipId: $friendshipId, userId: $userId, fullName: $fullName, handle: $handle, group: $group, latitude: $latitude, longitude: $longitude, battery: $battery, mood: $mood, isGhost: $isGhost, locationUpdatedAt: $locationUpdatedAt)';
}


}

/// @nodoc
abstract mixin class $FriendCopyWith<$Res>  {
  factory $FriendCopyWith(Friend value, $Res Function(Friend) _then) = _$FriendCopyWithImpl;
@useResult
$Res call({
 String friendshipId, String userId,@JsonKey(defaultValue: 'Студент') String fullName, String? handle, String? group, double? latitude, double? longitude, int? battery, String mood, bool isGhost,@JsonKey(fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson) DateTime? locationUpdatedAt
});




}
/// @nodoc
class _$FriendCopyWithImpl<$Res>
    implements $FriendCopyWith<$Res> {
  _$FriendCopyWithImpl(this._self, this._then);

  final Friend _self;
  final $Res Function(Friend) _then;

/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? friendshipId = null,Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? group = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? battery = freezed,Object? mood = null,Object? isGhost = null,Object? locationUpdatedAt = freezed,}) {
  return _then(_self.copyWith(
friendshipId: null == friendshipId ? _self.friendshipId : friendshipId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,battery: freezed == battery ? _self.battery : battery // ignore: cast_nullable_to_non_nullable
as int?,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,isGhost: null == isGhost ? _self.isGhost : isGhost // ignore: cast_nullable_to_non_nullable
as bool,locationUpdatedAt: freezed == locationUpdatedAt ? _self.locationUpdatedAt : locationUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Friend].
extension FriendPatterns on Friend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Friend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Friend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Friend value)  $default,){
final _that = this;
switch (_that) {
case _Friend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Friend value)?  $default,){
final _that = this;
switch (_that) {
case _Friend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String friendshipId,  String userId, @JsonKey(defaultValue: 'Студент')  String fullName,  String? handle,  String? group,  double? latitude,  double? longitude,  int? battery,  String mood,  bool isGhost, @JsonKey(fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson)  DateTime? locationUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Friend() when $default != null:
return $default(_that.friendshipId,_that.userId,_that.fullName,_that.handle,_that.group,_that.latitude,_that.longitude,_that.battery,_that.mood,_that.isGhost,_that.locationUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String friendshipId,  String userId, @JsonKey(defaultValue: 'Студент')  String fullName,  String? handle,  String? group,  double? latitude,  double? longitude,  int? battery,  String mood,  bool isGhost, @JsonKey(fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson)  DateTime? locationUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _Friend():
return $default(_that.friendshipId,_that.userId,_that.fullName,_that.handle,_that.group,_that.latitude,_that.longitude,_that.battery,_that.mood,_that.isGhost,_that.locationUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String friendshipId,  String userId, @JsonKey(defaultValue: 'Студент')  String fullName,  String? handle,  String? group,  double? latitude,  double? longitude,  int? battery,  String mood,  bool isGhost, @JsonKey(fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson)  DateTime? locationUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Friend() when $default != null:
return $default(_that.friendshipId,_that.userId,_that.fullName,_that.handle,_that.group,_that.latitude,_that.longitude,_that.battery,_that.mood,_that.isGhost,_that.locationUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Friend extends Friend {
  const _Friend({required this.friendshipId, required this.userId, @JsonKey(defaultValue: 'Студент') required this.fullName, this.handle, this.group, this.latitude, this.longitude, this.battery, this.mood = '', this.isGhost = false, @JsonKey(fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson) this.locationUpdatedAt}): super._();
  factory _Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

@override final  String friendshipId;
@override final  String userId;
@override@JsonKey(defaultValue: 'Студент') final  String fullName;
@override final  String? handle;
@override final  String? group;
@override final  double? latitude;
@override final  double? longitude;
@override final  int? battery;
@override@JsonKey() final  String mood;
@override@JsonKey() final  bool isGhost;
@override@JsonKey(fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson) final  DateTime? locationUpdatedAt;

/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendCopyWith<_Friend> get copyWith => __$FriendCopyWithImpl<_Friend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Friend&&(identical(other.friendshipId, friendshipId) || other.friendshipId == friendshipId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.group, group) || other.group == group)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.battery, battery) || other.battery == battery)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.isGhost, isGhost) || other.isGhost == isGhost)&&(identical(other.locationUpdatedAt, locationUpdatedAt) || other.locationUpdatedAt == locationUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,friendshipId,userId,fullName,handle,group,latitude,longitude,battery,mood,isGhost,locationUpdatedAt);

@override
String toString() {
  return 'Friend(friendshipId: $friendshipId, userId: $userId, fullName: $fullName, handle: $handle, group: $group, latitude: $latitude, longitude: $longitude, battery: $battery, mood: $mood, isGhost: $isGhost, locationUpdatedAt: $locationUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$FriendCopyWith<$Res> implements $FriendCopyWith<$Res> {
  factory _$FriendCopyWith(_Friend value, $Res Function(_Friend) _then) = __$FriendCopyWithImpl;
@override @useResult
$Res call({
 String friendshipId, String userId,@JsonKey(defaultValue: 'Студент') String fullName, String? handle, String? group, double? latitude, double? longitude, int? battery, String mood, bool isGhost,@JsonKey(fromJson: optionalDateTimeFromJson, toJson: optionalDateTimeToJson) DateTime? locationUpdatedAt
});




}
/// @nodoc
class __$FriendCopyWithImpl<$Res>
    implements _$FriendCopyWith<$Res> {
  __$FriendCopyWithImpl(this._self, this._then);

  final _Friend _self;
  final $Res Function(_Friend) _then;

/// Create a copy of Friend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? friendshipId = null,Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? group = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? battery = freezed,Object? mood = null,Object? isGhost = null,Object? locationUpdatedAt = freezed,}) {
  return _then(_Friend(
friendshipId: null == friendshipId ? _self.friendshipId : friendshipId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,battery: freezed == battery ? _self.battery : battery // ignore: cast_nullable_to_non_nullable
as int?,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,isGhost: null == isGhost ? _self.isGhost : isGhost // ignore: cast_nullable_to_non_nullable
as bool,locationUpdatedAt: freezed == locationUpdatedAt ? _self.locationUpdatedAt : locationUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
