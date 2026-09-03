// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friends_map_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FriendsMapState {

 FriendsMapStatus get status; List<Friend> get friends; List<FriendRequest> get requests; double? get myLatitude; double? get myLongitude; bool get isGhost; bool get locationPermissionDenied; bool get privacySyncFailed; bool get privacyBusy; GeoSharingSettings get geoSettings; Set<String> get pendingResponseIds;
/// Create a copy of FriendsMapState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendsMapStateCopyWith<FriendsMapState> get copyWith => _$FriendsMapStateCopyWithImpl<FriendsMapState>(this as FriendsMapState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendsMapState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.friends, friends)&&const DeepCollectionEquality().equals(other.requests, requests)&&(identical(other.myLatitude, myLatitude) || other.myLatitude == myLatitude)&&(identical(other.myLongitude, myLongitude) || other.myLongitude == myLongitude)&&(identical(other.isGhost, isGhost) || other.isGhost == isGhost)&&(identical(other.locationPermissionDenied, locationPermissionDenied) || other.locationPermissionDenied == locationPermissionDenied)&&(identical(other.privacySyncFailed, privacySyncFailed) || other.privacySyncFailed == privacySyncFailed)&&(identical(other.privacyBusy, privacyBusy) || other.privacyBusy == privacyBusy)&&(identical(other.geoSettings, geoSettings) || other.geoSettings == geoSettings)&&const DeepCollectionEquality().equals(other.pendingResponseIds, pendingResponseIds));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(friends),const DeepCollectionEquality().hash(requests),myLatitude,myLongitude,isGhost,locationPermissionDenied,privacySyncFailed,privacyBusy,geoSettings,const DeepCollectionEquality().hash(pendingResponseIds));

@override
String toString() {
  return 'FriendsMapState(status: $status, friends: $friends, requests: $requests, myLatitude: $myLatitude, myLongitude: $myLongitude, isGhost: $isGhost, locationPermissionDenied: $locationPermissionDenied, privacySyncFailed: $privacySyncFailed, privacyBusy: $privacyBusy, geoSettings: $geoSettings, pendingResponseIds: $pendingResponseIds)';
}


}

/// @nodoc
abstract mixin class $FriendsMapStateCopyWith<$Res>  {
  factory $FriendsMapStateCopyWith(FriendsMapState value, $Res Function(FriendsMapState) _then) = _$FriendsMapStateCopyWithImpl;
@useResult
$Res call({
 FriendsMapStatus status, List<Friend> friends, List<FriendRequest> requests, double? myLatitude, double? myLongitude, bool isGhost, bool locationPermissionDenied, bool privacySyncFailed, bool privacyBusy, GeoSharingSettings geoSettings, Set<String> pendingResponseIds
});


$GeoSharingSettingsCopyWith<$Res> get geoSettings;

}
/// @nodoc
class _$FriendsMapStateCopyWithImpl<$Res>
    implements $FriendsMapStateCopyWith<$Res> {
  _$FriendsMapStateCopyWithImpl(this._self, this._then);

  final FriendsMapState _self;
  final $Res Function(FriendsMapState) _then;

/// Create a copy of FriendsMapState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? friends = null,Object? requests = null,Object? myLatitude = freezed,Object? myLongitude = freezed,Object? isGhost = null,Object? locationPermissionDenied = null,Object? privacySyncFailed = null,Object? privacyBusy = null,Object? geoSettings = null,Object? pendingResponseIds = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FriendsMapStatus,friends: null == friends ? _self.friends : friends // ignore: cast_nullable_to_non_nullable
as List<Friend>,requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as List<FriendRequest>,myLatitude: freezed == myLatitude ? _self.myLatitude : myLatitude // ignore: cast_nullable_to_non_nullable
as double?,myLongitude: freezed == myLongitude ? _self.myLongitude : myLongitude // ignore: cast_nullable_to_non_nullable
as double?,isGhost: null == isGhost ? _self.isGhost : isGhost // ignore: cast_nullable_to_non_nullable
as bool,locationPermissionDenied: null == locationPermissionDenied ? _self.locationPermissionDenied : locationPermissionDenied // ignore: cast_nullable_to_non_nullable
as bool,privacySyncFailed: null == privacySyncFailed ? _self.privacySyncFailed : privacySyncFailed // ignore: cast_nullable_to_non_nullable
as bool,privacyBusy: null == privacyBusy ? _self.privacyBusy : privacyBusy // ignore: cast_nullable_to_non_nullable
as bool,geoSettings: null == geoSettings ? _self.geoSettings : geoSettings // ignore: cast_nullable_to_non_nullable
as GeoSharingSettings,pendingResponseIds: null == pendingResponseIds ? _self.pendingResponseIds : pendingResponseIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}
/// Create a copy of FriendsMapState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoSharingSettingsCopyWith<$Res> get geoSettings {

  return $GeoSharingSettingsCopyWith<$Res>(_self.geoSettings, (value) {
    return _then(_self.copyWith(geoSettings: value));
  });
}
}


/// Adds pattern-matching-related methods to [FriendsMapState].
extension FriendsMapStatePatterns on FriendsMapState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendsMapState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendsMapState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendsMapState value)  $default,){
final _that = this;
switch (_that) {
case _FriendsMapState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendsMapState value)?  $default,){
final _that = this;
switch (_that) {
case _FriendsMapState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FriendsMapStatus status,  List<Friend> friends,  List<FriendRequest> requests,  double? myLatitude,  double? myLongitude,  bool isGhost,  bool locationPermissionDenied,  bool privacySyncFailed,  bool privacyBusy,  GeoSharingSettings geoSettings,  Set<String> pendingResponseIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendsMapState() when $default != null:
return $default(_that.status,_that.friends,_that.requests,_that.myLatitude,_that.myLongitude,_that.isGhost,_that.locationPermissionDenied,_that.privacySyncFailed,_that.privacyBusy,_that.geoSettings,_that.pendingResponseIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FriendsMapStatus status,  List<Friend> friends,  List<FriendRequest> requests,  double? myLatitude,  double? myLongitude,  bool isGhost,  bool locationPermissionDenied,  bool privacySyncFailed,  bool privacyBusy,  GeoSharingSettings geoSettings,  Set<String> pendingResponseIds)  $default,) {final _that = this;
switch (_that) {
case _FriendsMapState():
return $default(_that.status,_that.friends,_that.requests,_that.myLatitude,_that.myLongitude,_that.isGhost,_that.locationPermissionDenied,_that.privacySyncFailed,_that.privacyBusy,_that.geoSettings,_that.pendingResponseIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FriendsMapStatus status,  List<Friend> friends,  List<FriendRequest> requests,  double? myLatitude,  double? myLongitude,  bool isGhost,  bool locationPermissionDenied,  bool privacySyncFailed,  bool privacyBusy,  GeoSharingSettings geoSettings,  Set<String> pendingResponseIds)?  $default,) {final _that = this;
switch (_that) {
case _FriendsMapState() when $default != null:
return $default(_that.status,_that.friends,_that.requests,_that.myLatitude,_that.myLongitude,_that.isGhost,_that.locationPermissionDenied,_that.privacySyncFailed,_that.privacyBusy,_that.geoSettings,_that.pendingResponseIds);case _:
  return null;

}
}

}

/// @nodoc


class _FriendsMapState extends FriendsMapState {
  const _FriendsMapState({this.status = FriendsMapStatus.initial, final  List<Friend> friends = const <Friend>[], final  List<FriendRequest> requests = const <FriendRequest>[], this.myLatitude, this.myLongitude, this.isGhost = false, this.locationPermissionDenied = false, this.privacySyncFailed = false, this.privacyBusy = false, this.geoSettings = const GeoSharingSettings(), final  Set<String> pendingResponseIds = const <String>{}}): _friends = friends,_requests = requests,_pendingResponseIds = pendingResponseIds,super._();


@override@JsonKey() final  FriendsMapStatus status;
 final  List<Friend> _friends;
@override@JsonKey() List<Friend> get friends {
  if (_friends is EqualUnmodifiableListView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friends);
}

 final  List<FriendRequest> _requests;
@override@JsonKey() List<FriendRequest> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}

@override final  double? myLatitude;
@override final  double? myLongitude;
@override@JsonKey() final  bool isGhost;
@override@JsonKey() final  bool locationPermissionDenied;
@override@JsonKey() final  bool privacySyncFailed;
@override@JsonKey() final  bool privacyBusy;
@override@JsonKey() final  GeoSharingSettings geoSettings;
 final  Set<String> _pendingResponseIds;
@override@JsonKey() Set<String> get pendingResponseIds {
  if (_pendingResponseIds is EqualUnmodifiableSetView) return _pendingResponseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingResponseIds);
}


/// Create a copy of FriendsMapState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendsMapStateCopyWith<_FriendsMapState> get copyWith => __$FriendsMapStateCopyWithImpl<_FriendsMapState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendsMapState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._friends, _friends)&&const DeepCollectionEquality().equals(other._requests, _requests)&&(identical(other.myLatitude, myLatitude) || other.myLatitude == myLatitude)&&(identical(other.myLongitude, myLongitude) || other.myLongitude == myLongitude)&&(identical(other.isGhost, isGhost) || other.isGhost == isGhost)&&(identical(other.locationPermissionDenied, locationPermissionDenied) || other.locationPermissionDenied == locationPermissionDenied)&&(identical(other.privacySyncFailed, privacySyncFailed) || other.privacySyncFailed == privacySyncFailed)&&(identical(other.privacyBusy, privacyBusy) || other.privacyBusy == privacyBusy)&&(identical(other.geoSettings, geoSettings) || other.geoSettings == geoSettings)&&const DeepCollectionEquality().equals(other._pendingResponseIds, _pendingResponseIds));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_friends),const DeepCollectionEquality().hash(_requests),myLatitude,myLongitude,isGhost,locationPermissionDenied,privacySyncFailed,privacyBusy,geoSettings,const DeepCollectionEquality().hash(_pendingResponseIds));

@override
String toString() {
  return 'FriendsMapState(status: $status, friends: $friends, requests: $requests, myLatitude: $myLatitude, myLongitude: $myLongitude, isGhost: $isGhost, locationPermissionDenied: $locationPermissionDenied, privacySyncFailed: $privacySyncFailed, privacyBusy: $privacyBusy, geoSettings: $geoSettings, pendingResponseIds: $pendingResponseIds)';
}


}

/// @nodoc
abstract mixin class _$FriendsMapStateCopyWith<$Res> implements $FriendsMapStateCopyWith<$Res> {
  factory _$FriendsMapStateCopyWith(_FriendsMapState value, $Res Function(_FriendsMapState) _then) = __$FriendsMapStateCopyWithImpl;
@override @useResult
$Res call({
 FriendsMapStatus status, List<Friend> friends, List<FriendRequest> requests, double? myLatitude, double? myLongitude, bool isGhost, bool locationPermissionDenied, bool privacySyncFailed, bool privacyBusy, GeoSharingSettings geoSettings, Set<String> pendingResponseIds
});


@override $GeoSharingSettingsCopyWith<$Res> get geoSettings;

}
/// @nodoc
class __$FriendsMapStateCopyWithImpl<$Res>
    implements _$FriendsMapStateCopyWith<$Res> {
  __$FriendsMapStateCopyWithImpl(this._self, this._then);

  final _FriendsMapState _self;
  final $Res Function(_FriendsMapState) _then;

/// Create a copy of FriendsMapState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? friends = null,Object? requests = null,Object? myLatitude = freezed,Object? myLongitude = freezed,Object? isGhost = null,Object? locationPermissionDenied = null,Object? privacySyncFailed = null,Object? privacyBusy = null,Object? geoSettings = null,Object? pendingResponseIds = null,}) {
  return _then(_FriendsMapState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FriendsMapStatus,friends: null == friends ? _self._friends : friends // ignore: cast_nullable_to_non_nullable
as List<Friend>,requests: null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<FriendRequest>,myLatitude: freezed == myLatitude ? _self.myLatitude : myLatitude // ignore: cast_nullable_to_non_nullable
as double?,myLongitude: freezed == myLongitude ? _self.myLongitude : myLongitude // ignore: cast_nullable_to_non_nullable
as double?,isGhost: null == isGhost ? _self.isGhost : isGhost // ignore: cast_nullable_to_non_nullable
as bool,locationPermissionDenied: null == locationPermissionDenied ? _self.locationPermissionDenied : locationPermissionDenied // ignore: cast_nullable_to_non_nullable
as bool,privacySyncFailed: null == privacySyncFailed ? _self.privacySyncFailed : privacySyncFailed // ignore: cast_nullable_to_non_nullable
as bool,privacyBusy: null == privacyBusy ? _self.privacyBusy : privacyBusy // ignore: cast_nullable_to_non_nullable
as bool,geoSettings: null == geoSettings ? _self.geoSettings : geoSettings // ignore: cast_nullable_to_non_nullable
as GeoSharingSettings,pendingResponseIds: null == pendingResponseIds ? _self._pendingResponseIds : pendingResponseIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

/// Create a copy of FriendsMapState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoSharingSettingsCopyWith<$Res> get geoSettings {

  return $GeoSharingSettingsCopyWith<$Res>(_self.geoSettings, (value) {
    return _then(_self.copyWith(geoSettings: value));
  });
}
}


/// @nodoc
mixin _$GeoSharingSettings {

 bool get sharing;@JsonKey(unknownEnumValue: GeoVisibility.none) GeoVisibility get visibility;@JsonKey(unknownEnumValue: GeoPrecision.exact) GeoPrecision get precision; bool get privacyForcedGhost;
/// Create a copy of GeoSharingSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoSharingSettingsCopyWith<GeoSharingSettings> get copyWith => _$GeoSharingSettingsCopyWithImpl<GeoSharingSettings>(this as GeoSharingSettings, _$identity);

  /// Serializes this GeoSharingSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoSharingSettings&&(identical(other.sharing, sharing) || other.sharing == sharing)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.precision, precision) || other.precision == precision)&&(identical(other.privacyForcedGhost, privacyForcedGhost) || other.privacyForcedGhost == privacyForcedGhost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sharing,visibility,precision,privacyForcedGhost);

@override
String toString() {
  return 'GeoSharingSettings(sharing: $sharing, visibility: $visibility, precision: $precision, privacyForcedGhost: $privacyForcedGhost)';
}


}

/// @nodoc
abstract mixin class $GeoSharingSettingsCopyWith<$Res>  {
  factory $GeoSharingSettingsCopyWith(GeoSharingSettings value, $Res Function(GeoSharingSettings) _then) = _$GeoSharingSettingsCopyWithImpl;
@useResult
$Res call({
 bool sharing,@JsonKey(unknownEnumValue: GeoVisibility.none) GeoVisibility visibility,@JsonKey(unknownEnumValue: GeoPrecision.exact) GeoPrecision precision, bool privacyForcedGhost
});




}
/// @nodoc
class _$GeoSharingSettingsCopyWithImpl<$Res>
    implements $GeoSharingSettingsCopyWith<$Res> {
  _$GeoSharingSettingsCopyWithImpl(this._self, this._then);

  final GeoSharingSettings _self;
  final $Res Function(GeoSharingSettings) _then;

/// Create a copy of GeoSharingSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sharing = null,Object? visibility = null,Object? precision = null,Object? privacyForcedGhost = null,}) {
  return _then(_self.copyWith(
sharing: null == sharing ? _self.sharing : sharing // ignore: cast_nullable_to_non_nullable
as bool,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as GeoVisibility,precision: null == precision ? _self.precision : precision // ignore: cast_nullable_to_non_nullable
as GeoPrecision,privacyForcedGhost: null == privacyForcedGhost ? _self.privacyForcedGhost : privacyForcedGhost // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoSharingSettings].
extension GeoSharingSettingsPatterns on GeoSharingSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoSharingSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoSharingSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoSharingSettings value)  $default,){
final _that = this;
switch (_that) {
case _GeoSharingSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoSharingSettings value)?  $default,){
final _that = this;
switch (_that) {
case _GeoSharingSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool sharing, @JsonKey(unknownEnumValue: GeoVisibility.none)  GeoVisibility visibility, @JsonKey(unknownEnumValue: GeoPrecision.exact)  GeoPrecision precision,  bool privacyForcedGhost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoSharingSettings() when $default != null:
return $default(_that.sharing,_that.visibility,_that.precision,_that.privacyForcedGhost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool sharing, @JsonKey(unknownEnumValue: GeoVisibility.none)  GeoVisibility visibility, @JsonKey(unknownEnumValue: GeoPrecision.exact)  GeoPrecision precision,  bool privacyForcedGhost)  $default,) {final _that = this;
switch (_that) {
case _GeoSharingSettings():
return $default(_that.sharing,_that.visibility,_that.precision,_that.privacyForcedGhost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool sharing, @JsonKey(unknownEnumValue: GeoVisibility.none)  GeoVisibility visibility, @JsonKey(unknownEnumValue: GeoPrecision.exact)  GeoPrecision precision,  bool privacyForcedGhost)?  $default,) {final _that = this;
switch (_that) {
case _GeoSharingSettings() when $default != null:
return $default(_that.sharing,_that.visibility,_that.precision,_that.privacyForcedGhost);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _GeoSharingSettings implements GeoSharingSettings {
  const _GeoSharingSettings({this.sharing = false, @JsonKey(unknownEnumValue: GeoVisibility.none) this.visibility = GeoVisibility.all, @JsonKey(unknownEnumValue: GeoPrecision.exact) this.precision = GeoPrecision.exact, this.privacyForcedGhost = false});
  factory _GeoSharingSettings.fromJson(Map<String, dynamic> json) => _$GeoSharingSettingsFromJson(json);

@override@JsonKey() final  bool sharing;
@override@JsonKey(unknownEnumValue: GeoVisibility.none) final  GeoVisibility visibility;
@override@JsonKey(unknownEnumValue: GeoPrecision.exact) final  GeoPrecision precision;
@override@JsonKey() final  bool privacyForcedGhost;

/// Create a copy of GeoSharingSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoSharingSettingsCopyWith<_GeoSharingSettings> get copyWith => __$GeoSharingSettingsCopyWithImpl<_GeoSharingSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoSharingSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoSharingSettings&&(identical(other.sharing, sharing) || other.sharing == sharing)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.precision, precision) || other.precision == precision)&&(identical(other.privacyForcedGhost, privacyForcedGhost) || other.privacyForcedGhost == privacyForcedGhost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sharing,visibility,precision,privacyForcedGhost);

@override
String toString() {
  return 'GeoSharingSettings(sharing: $sharing, visibility: $visibility, precision: $precision, privacyForcedGhost: $privacyForcedGhost)';
}


}

/// @nodoc
abstract mixin class _$GeoSharingSettingsCopyWith<$Res> implements $GeoSharingSettingsCopyWith<$Res> {
  factory _$GeoSharingSettingsCopyWith(_GeoSharingSettings value, $Res Function(_GeoSharingSettings) _then) = __$GeoSharingSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool sharing,@JsonKey(unknownEnumValue: GeoVisibility.none) GeoVisibility visibility,@JsonKey(unknownEnumValue: GeoPrecision.exact) GeoPrecision precision, bool privacyForcedGhost
});




}
/// @nodoc
class __$GeoSharingSettingsCopyWithImpl<$Res>
    implements _$GeoSharingSettingsCopyWith<$Res> {
  __$GeoSharingSettingsCopyWithImpl(this._self, this._then);

  final _GeoSharingSettings _self;
  final $Res Function(_GeoSharingSettings) _then;

/// Create a copy of GeoSharingSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sharing = null,Object? visibility = null,Object? precision = null,Object? privacyForcedGhost = null,}) {
  return _then(_GeoSharingSettings(
sharing: null == sharing ? _self.sharing : sharing // ignore: cast_nullable_to_non_nullable
as bool,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as GeoVisibility,precision: null == precision ? _self.precision : precision // ignore: cast_nullable_to_non_nullable
as GeoPrecision,privacyForcedGhost: null == privacyForcedGhost ? _self.privacyForcedGhost : privacyForcedGhost // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
