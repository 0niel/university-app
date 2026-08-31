// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserActivity {

 String get id; UserActivityType get type; String get title; DateTime get startsAt; String? get place; String? get subtitle; String? get lessonUid; DateTime? get endsAt;
/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserActivityCopyWith<UserActivity> get copyWith => _$UserActivityCopyWithImpl<UserActivity>(this as UserActivity, _$identity);

  /// Serializes this UserActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.place, place) || other.place == place)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.lessonUid, lessonUid) || other.lessonUid == lessonUid)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,startsAt,place,subtitle,lessonUid,endsAt);

@override
String toString() {
  return 'UserActivity(id: $id, type: $type, title: $title, startsAt: $startsAt, place: $place, subtitle: $subtitle, lessonUid: $lessonUid, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $UserActivityCopyWith<$Res>  {
  factory $UserActivityCopyWith(UserActivity value, $Res Function(UserActivity) _then) = _$UserActivityCopyWithImpl;
@useResult
$Res call({
 String id, UserActivityType type, String title, DateTime startsAt, String? place, String? subtitle, String? lessonUid, DateTime? endsAt
});




}
/// @nodoc
class _$UserActivityCopyWithImpl<$Res>
    implements $UserActivityCopyWith<$Res> {
  _$UserActivityCopyWithImpl(this._self, this._then);

  final UserActivity _self;
  final $Res Function(UserActivity) _then;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? startsAt = null,Object? place = freezed,Object? subtitle = freezed,Object? lessonUid = freezed,Object? endsAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as UserActivityType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,lessonUid: freezed == lessonUid ? _self.lessonUid : lessonUid // ignore: cast_nullable_to_non_nullable
as String?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserActivity].
extension UserActivityPatterns on UserActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserActivity value)  $default,){
final _that = this;
switch (_that) {
case _UserActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserActivity value)?  $default,){
final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  UserActivityType type,  String title,  DateTime startsAt,  String? place,  String? subtitle,  String? lessonUid,  DateTime? endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.startsAt,_that.place,_that.subtitle,_that.lessonUid,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  UserActivityType type,  String title,  DateTime startsAt,  String? place,  String? subtitle,  String? lessonUid,  DateTime? endsAt)  $default,) {final _that = this;
switch (_that) {
case _UserActivity():
return $default(_that.id,_that.type,_that.title,_that.startsAt,_that.place,_that.subtitle,_that.lessonUid,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  UserActivityType type,  String title,  DateTime startsAt,  String? place,  String? subtitle,  String? lessonUid,  DateTime? endsAt)?  $default,) {final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.startsAt,_that.place,_that.subtitle,_that.lessonUid,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserActivity implements UserActivity {
  const _UserActivity({required this.id, required this.type, required this.title, required this.startsAt, this.place, this.subtitle, this.lessonUid, this.endsAt});
  factory _UserActivity.fromJson(Map<String, dynamic> json) => _$UserActivityFromJson(json);

@override final  String id;
@override final  UserActivityType type;
@override final  String title;
@override final  DateTime startsAt;
@override final  String? place;
@override final  String? subtitle;
@override final  String? lessonUid;
@override final  DateTime? endsAt;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserActivityCopyWith<_UserActivity> get copyWith => __$UserActivityCopyWithImpl<_UserActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.place, place) || other.place == place)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.lessonUid, lessonUid) || other.lessonUid == lessonUid)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,startsAt,place,subtitle,lessonUid,endsAt);

@override
String toString() {
  return 'UserActivity(id: $id, type: $type, title: $title, startsAt: $startsAt, place: $place, subtitle: $subtitle, lessonUid: $lessonUid, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$UserActivityCopyWith<$Res> implements $UserActivityCopyWith<$Res> {
  factory _$UserActivityCopyWith(_UserActivity value, $Res Function(_UserActivity) _then) = __$UserActivityCopyWithImpl;
@override @useResult
$Res call({
 String id, UserActivityType type, String title, DateTime startsAt, String? place, String? subtitle, String? lessonUid, DateTime? endsAt
});




}
/// @nodoc
class __$UserActivityCopyWithImpl<$Res>
    implements _$UserActivityCopyWith<$Res> {
  __$UserActivityCopyWithImpl(this._self, this._then);

  final _UserActivity _self;
  final $Res Function(_UserActivity) _then;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? startsAt = null,Object? place = freezed,Object? subtitle = freezed,Object? lessonUid = freezed,Object? endsAt = freezed,}) {
  return _then(_UserActivity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as UserActivityType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,lessonUid: freezed == lessonUid ? _self.lessonUid : lessonUid // ignore: cast_nullable_to_non_nullable
as String?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$UpsertUserActivityRequest {

 UserActivityType get type; String get title; DateTime get startsAt; String? get id; String? get place; String? get subtitle; String? get lessonUid; DateTime? get endsAt;
/// Create a copy of UpsertUserActivityRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpsertUserActivityRequestCopyWith<UpsertUserActivityRequest> get copyWith => _$UpsertUserActivityRequestCopyWithImpl<UpsertUserActivityRequest>(this as UpsertUserActivityRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpsertUserActivityRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.id, id) || other.id == id)&&(identical(other.place, place) || other.place == place)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.lessonUid, lessonUid) || other.lessonUid == lessonUid)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,title,startsAt,id,place,subtitle,lessonUid,endsAt);

@override
String toString() {
  return 'UpsertUserActivityRequest(type: $type, title: $title, startsAt: $startsAt, id: $id, place: $place, subtitle: $subtitle, lessonUid: $lessonUid, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $UpsertUserActivityRequestCopyWith<$Res>  {
  factory $UpsertUserActivityRequestCopyWith(UpsertUserActivityRequest value, $Res Function(UpsertUserActivityRequest) _then) = _$UpsertUserActivityRequestCopyWithImpl;
@useResult
$Res call({
 UserActivityType type, String title, DateTime startsAt, String? id, String? place, String? subtitle, String? lessonUid, DateTime? endsAt
});




}
/// @nodoc
class _$UpsertUserActivityRequestCopyWithImpl<$Res>
    implements $UpsertUserActivityRequestCopyWith<$Res> {
  _$UpsertUserActivityRequestCopyWithImpl(this._self, this._then);

  final UpsertUserActivityRequest _self;
  final $Res Function(UpsertUserActivityRequest) _then;

/// Create a copy of UpsertUserActivityRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = null,Object? startsAt = null,Object? id = freezed,Object? place = freezed,Object? subtitle = freezed,Object? lessonUid = freezed,Object? endsAt = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as UserActivityType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,lessonUid: freezed == lessonUid ? _self.lessonUid : lessonUid // ignore: cast_nullable_to_non_nullable
as String?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpsertUserActivityRequest].
extension UpsertUserActivityRequestPatterns on UpsertUserActivityRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpsertUserActivityRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpsertUserActivityRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpsertUserActivityRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpsertUserActivityRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpsertUserActivityRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpsertUserActivityRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserActivityType type,  String title,  DateTime startsAt,  String? id,  String? place,  String? subtitle,  String? lessonUid,  DateTime? endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpsertUserActivityRequest() when $default != null:
return $default(_that.type,_that.title,_that.startsAt,_that.id,_that.place,_that.subtitle,_that.lessonUid,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserActivityType type,  String title,  DateTime startsAt,  String? id,  String? place,  String? subtitle,  String? lessonUid,  DateTime? endsAt)  $default,) {final _that = this;
switch (_that) {
case _UpsertUserActivityRequest():
return $default(_that.type,_that.title,_that.startsAt,_that.id,_that.place,_that.subtitle,_that.lessonUid,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserActivityType type,  String title,  DateTime startsAt,  String? id,  String? place,  String? subtitle,  String? lessonUid,  DateTime? endsAt)?  $default,) {final _that = this;
switch (_that) {
case _UpsertUserActivityRequest() when $default != null:
return $default(_that.type,_that.title,_that.startsAt,_that.id,_that.place,_that.subtitle,_that.lessonUid,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc


class _UpsertUserActivityRequest implements UpsertUserActivityRequest {
  const _UpsertUserActivityRequest({required this.type, required this.title, required this.startsAt, this.id, this.place, this.subtitle, this.lessonUid, this.endsAt});


@override final  UserActivityType type;
@override final  String title;
@override final  DateTime startsAt;
@override final  String? id;
@override final  String? place;
@override final  String? subtitle;
@override final  String? lessonUid;
@override final  DateTime? endsAt;

/// Create a copy of UpsertUserActivityRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpsertUserActivityRequestCopyWith<_UpsertUserActivityRequest> get copyWith => __$UpsertUserActivityRequestCopyWithImpl<_UpsertUserActivityRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpsertUserActivityRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.id, id) || other.id == id)&&(identical(other.place, place) || other.place == place)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.lessonUid, lessonUid) || other.lessonUid == lessonUid)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}


@override
int get hashCode => Object.hash(runtimeType,type,title,startsAt,id,place,subtitle,lessonUid,endsAt);

@override
String toString() {
  return 'UpsertUserActivityRequest(type: $type, title: $title, startsAt: $startsAt, id: $id, place: $place, subtitle: $subtitle, lessonUid: $lessonUid, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$UpsertUserActivityRequestCopyWith<$Res> implements $UpsertUserActivityRequestCopyWith<$Res> {
  factory _$UpsertUserActivityRequestCopyWith(_UpsertUserActivityRequest value, $Res Function(_UpsertUserActivityRequest) _then) = __$UpsertUserActivityRequestCopyWithImpl;
@override @useResult
$Res call({
 UserActivityType type, String title, DateTime startsAt, String? id, String? place, String? subtitle, String? lessonUid, DateTime? endsAt
});




}
/// @nodoc
class __$UpsertUserActivityRequestCopyWithImpl<$Res>
    implements _$UpsertUserActivityRequestCopyWith<$Res> {
  __$UpsertUserActivityRequestCopyWithImpl(this._self, this._then);

  final _UpsertUserActivityRequest _self;
  final $Res Function(_UpsertUserActivityRequest) _then;

/// Create a copy of UpsertUserActivityRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = null,Object? startsAt = null,Object? id = freezed,Object? place = freezed,Object? subtitle = freezed,Object? lessonUid = freezed,Object? endsAt = freezed,}) {
  return _then(_UpsertUserActivityRequest(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as UserActivityType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,lessonUid: freezed == lessonUid ? _self.lessonUid : lessonUid // ignore: cast_nullable_to_non_nullable
as String?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
