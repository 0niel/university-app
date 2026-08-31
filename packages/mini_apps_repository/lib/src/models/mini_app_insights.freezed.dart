// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_app_insights.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MiniAppDailyStat {

@JsonKey(fromJson: _dayFromJson, toJson: _dateToJson) DateTime get day;@JsonKey(fromJson: _intFromJson) int get launches;@JsonKey(fromJson: _intFromJson) int get uniqueUsers;
/// Create a copy of MiniAppDailyStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppDailyStatCopyWith<MiniAppDailyStat> get copyWith => _$MiniAppDailyStatCopyWithImpl<MiniAppDailyStat>(this as MiniAppDailyStat, _$identity);

  /// Serializes this MiniAppDailyStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppDailyStat&&(identical(other.day, day) || other.day == day)&&(identical(other.launches, launches) || other.launches == launches)&&(identical(other.uniqueUsers, uniqueUsers) || other.uniqueUsers == uniqueUsers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,launches,uniqueUsers);

@override
String toString() {
  return 'MiniAppDailyStat(day: $day, launches: $launches, uniqueUsers: $uniqueUsers)';
}


}

/// @nodoc
abstract mixin class $MiniAppDailyStatCopyWith<$Res>  {
  factory $MiniAppDailyStatCopyWith(MiniAppDailyStat value, $Res Function(MiniAppDailyStat) _then) = _$MiniAppDailyStatCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _dayFromJson, toJson: _dateToJson) DateTime day,@JsonKey(fromJson: _intFromJson) int launches,@JsonKey(fromJson: _intFromJson) int uniqueUsers
});




}
/// @nodoc
class _$MiniAppDailyStatCopyWithImpl<$Res>
    implements $MiniAppDailyStatCopyWith<$Res> {
  _$MiniAppDailyStatCopyWithImpl(this._self, this._then);

  final MiniAppDailyStat _self;
  final $Res Function(MiniAppDailyStat) _then;

/// Create a copy of MiniAppDailyStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? launches = null,Object? uniqueUsers = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,launches: null == launches ? _self.launches : launches // ignore: cast_nullable_to_non_nullable
as int,uniqueUsers: null == uniqueUsers ? _self.uniqueUsers : uniqueUsers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppDailyStat].
extension MiniAppDailyStatPatterns on MiniAppDailyStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppDailyStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppDailyStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppDailyStat value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppDailyStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppDailyStat value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppDailyStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _dayFromJson, toJson: _dateToJson)  DateTime day, @JsonKey(fromJson: _intFromJson)  int launches, @JsonKey(fromJson: _intFromJson)  int uniqueUsers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppDailyStat() when $default != null:
return $default(_that.day,_that.launches,_that.uniqueUsers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _dayFromJson, toJson: _dateToJson)  DateTime day, @JsonKey(fromJson: _intFromJson)  int launches, @JsonKey(fromJson: _intFromJson)  int uniqueUsers)  $default,) {final _that = this;
switch (_that) {
case _MiniAppDailyStat():
return $default(_that.day,_that.launches,_that.uniqueUsers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _dayFromJson, toJson: _dateToJson)  DateTime day, @JsonKey(fromJson: _intFromJson)  int launches, @JsonKey(fromJson: _intFromJson)  int uniqueUsers)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppDailyStat() when $default != null:
return $default(_that.day,_that.launches,_that.uniqueUsers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiniAppDailyStat implements MiniAppDailyStat {
  const _MiniAppDailyStat({@JsonKey(fromJson: _dayFromJson, toJson: _dateToJson) required this.day, @JsonKey(fromJson: _intFromJson) this.launches = 0, @JsonKey(fromJson: _intFromJson) this.uniqueUsers = 0});
  factory _MiniAppDailyStat.fromJson(Map<String, dynamic> json) => _$MiniAppDailyStatFromJson(json);

@override@JsonKey(fromJson: _dayFromJson, toJson: _dateToJson) final  DateTime day;
@override@JsonKey(fromJson: _intFromJson) final  int launches;
@override@JsonKey(fromJson: _intFromJson) final  int uniqueUsers;

/// Create a copy of MiniAppDailyStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppDailyStatCopyWith<_MiniAppDailyStat> get copyWith => __$MiniAppDailyStatCopyWithImpl<_MiniAppDailyStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiniAppDailyStatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppDailyStat&&(identical(other.day, day) || other.day == day)&&(identical(other.launches, launches) || other.launches == launches)&&(identical(other.uniqueUsers, uniqueUsers) || other.uniqueUsers == uniqueUsers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,launches,uniqueUsers);

@override
String toString() {
  return 'MiniAppDailyStat(day: $day, launches: $launches, uniqueUsers: $uniqueUsers)';
}


}

/// @nodoc
abstract mixin class _$MiniAppDailyStatCopyWith<$Res> implements $MiniAppDailyStatCopyWith<$Res> {
  factory _$MiniAppDailyStatCopyWith(_MiniAppDailyStat value, $Res Function(_MiniAppDailyStat) _then) = __$MiniAppDailyStatCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _dayFromJson, toJson: _dateToJson) DateTime day,@JsonKey(fromJson: _intFromJson) int launches,@JsonKey(fromJson: _intFromJson) int uniqueUsers
});




}
/// @nodoc
class __$MiniAppDailyStatCopyWithImpl<$Res>
    implements _$MiniAppDailyStatCopyWith<$Res> {
  __$MiniAppDailyStatCopyWithImpl(this._self, this._then);

  final _MiniAppDailyStat _self;
  final $Res Function(_MiniAppDailyStat) _then;

/// Create a copy of MiniAppDailyStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? launches = null,Object? uniqueUsers = null,}) {
  return _then(_MiniAppDailyStat(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,launches: null == launches ? _self.launches : launches // ignore: cast_nullable_to_non_nullable
as int,uniqueUsers: null == uniqueUsers ? _self.uniqueUsers : uniqueUsers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MiniAppRevision {

@JsonKey(fromJson: _intFromJson) int get version;@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? get createdAt; List<MiniAppScreen> get screens;
/// Create a copy of MiniAppRevision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppRevisionCopyWith<MiniAppRevision> get copyWith => _$MiniAppRevisionCopyWithImpl<MiniAppRevision>(this as MiniAppRevision, _$identity);

  /// Serializes this MiniAppRevision to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppRevision&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.screens, screens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,createdAt,const DeepCollectionEquality().hash(screens));

@override
String toString() {
  return 'MiniAppRevision(version: $version, createdAt: $createdAt, screens: $screens)';
}


}

/// @nodoc
abstract mixin class $MiniAppRevisionCopyWith<$Res>  {
  factory $MiniAppRevisionCopyWith(MiniAppRevision value, $Res Function(MiniAppRevision) _then) = _$MiniAppRevisionCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int version,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? createdAt, List<MiniAppScreen> screens
});




}
/// @nodoc
class _$MiniAppRevisionCopyWithImpl<$Res>
    implements $MiniAppRevisionCopyWith<$Res> {
  _$MiniAppRevisionCopyWithImpl(this._self, this._then);

  final MiniAppRevision _self;
  final $Res Function(MiniAppRevision) _then;

/// Create a copy of MiniAppRevision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? createdAt = freezed,Object? screens = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,screens: null == screens ? _self.screens : screens // ignore: cast_nullable_to_non_nullable
as List<MiniAppScreen>,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppRevision].
extension MiniAppRevisionPatterns on MiniAppRevision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppRevision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppRevision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppRevision value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppRevision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppRevision value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppRevision() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int version, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt,  List<MiniAppScreen> screens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppRevision() when $default != null:
return $default(_that.version,_that.createdAt,_that.screens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int version, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt,  List<MiniAppScreen> screens)  $default,) {final _that = this;
switch (_that) {
case _MiniAppRevision():
return $default(_that.version,_that.createdAt,_that.screens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int version, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt,  List<MiniAppScreen> screens)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppRevision() when $default != null:
return $default(_that.version,_that.createdAt,_that.screens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiniAppRevision extends MiniAppRevision {
  const _MiniAppRevision({@JsonKey(fromJson: _intFromJson) this.version = 0, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) this.createdAt, final  List<MiniAppScreen> screens = const <MiniAppScreen>[]}): _screens = screens,super._();
  factory _MiniAppRevision.fromJson(Map<String, dynamic> json) => _$MiniAppRevisionFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int version;
@override@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) final  DateTime? createdAt;
 final  List<MiniAppScreen> _screens;
@override@JsonKey() List<MiniAppScreen> get screens {
  if (_screens is EqualUnmodifiableListView) return _screens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_screens);
}


/// Create a copy of MiniAppRevision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppRevisionCopyWith<_MiniAppRevision> get copyWith => __$MiniAppRevisionCopyWithImpl<_MiniAppRevision>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiniAppRevisionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppRevision&&(identical(other.version, version) || other.version == version)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._screens, _screens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,createdAt,const DeepCollectionEquality().hash(_screens));

@override
String toString() {
  return 'MiniAppRevision(version: $version, createdAt: $createdAt, screens: $screens)';
}


}

/// @nodoc
abstract mixin class _$MiniAppRevisionCopyWith<$Res> implements $MiniAppRevisionCopyWith<$Res> {
  factory _$MiniAppRevisionCopyWith(_MiniAppRevision value, $Res Function(_MiniAppRevision) _then) = __$MiniAppRevisionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int version,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? createdAt, List<MiniAppScreen> screens
});




}
/// @nodoc
class __$MiniAppRevisionCopyWithImpl<$Res>
    implements _$MiniAppRevisionCopyWith<$Res> {
  __$MiniAppRevisionCopyWithImpl(this._self, this._then);

  final _MiniAppRevision _self;
  final $Res Function(_MiniAppRevision) _then;

/// Create a copy of MiniAppRevision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? createdAt = freezed,Object? screens = null,}) {
  return _then(_MiniAppRevision(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,screens: null == screens ? _self._screens : screens // ignore: cast_nullable_to_non_nullable
as List<MiniAppScreen>,
  ));
}


}


/// @nodoc
mixin _$MiniAppDeployToken {

 String get id; String get name;@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? get createdAt;@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? get lastUsedAt;
/// Create a copy of MiniAppDeployToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppDeployTokenCopyWith<MiniAppDeployToken> get copyWith => _$MiniAppDeployTokenCopyWithImpl<MiniAppDeployToken>(this as MiniAppDeployToken, _$identity);

  /// Serializes this MiniAppDeployToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppDeployToken&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,lastUsedAt);

@override
String toString() {
  return 'MiniAppDeployToken(id: $id, name: $name, createdAt: $createdAt, lastUsedAt: $lastUsedAt)';
}


}

/// @nodoc
abstract mixin class $MiniAppDeployTokenCopyWith<$Res>  {
  factory $MiniAppDeployTokenCopyWith(MiniAppDeployToken value, $Res Function(MiniAppDeployToken) _then) = _$MiniAppDeployTokenCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? createdAt,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? lastUsedAt
});




}
/// @nodoc
class _$MiniAppDeployTokenCopyWithImpl<$Res>
    implements $MiniAppDeployTokenCopyWith<$Res> {
  _$MiniAppDeployTokenCopyWithImpl(this._self, this._then);

  final MiniAppDeployToken _self;
  final $Res Function(MiniAppDeployToken) _then;

/// Create a copy of MiniAppDeployToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? createdAt = freezed,Object? lastUsedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUsedAt: freezed == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppDeployToken].
extension MiniAppDeployTokenPatterns on MiniAppDeployToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppDeployToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppDeployToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppDeployToken value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppDeployToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppDeployToken value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppDeployToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? lastUsedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppDeployToken() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.lastUsedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? lastUsedAt)  $default,) {final _that = this;
switch (_that) {
case _MiniAppDeployToken():
return $default(_that.id,_that.name,_that.createdAt,_that.lastUsedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? lastUsedAt)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppDeployToken() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.lastUsedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiniAppDeployToken implements MiniAppDeployToken {
  const _MiniAppDeployToken({this.id = '', this.name = '', @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) this.createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) this.lastUsedAt});
  factory _MiniAppDeployToken.fromJson(Map<String, dynamic> json) => _$MiniAppDeployTokenFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) final  DateTime? lastUsedAt;

/// Create a copy of MiniAppDeployToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppDeployTokenCopyWith<_MiniAppDeployToken> get copyWith => __$MiniAppDeployTokenCopyWithImpl<_MiniAppDeployToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiniAppDeployTokenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppDeployToken&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,lastUsedAt);

@override
String toString() {
  return 'MiniAppDeployToken(id: $id, name: $name, createdAt: $createdAt, lastUsedAt: $lastUsedAt)';
}


}

/// @nodoc
abstract mixin class _$MiniAppDeployTokenCopyWith<$Res> implements $MiniAppDeployTokenCopyWith<$Res> {
  factory _$MiniAppDeployTokenCopyWith(_MiniAppDeployToken value, $Res Function(_MiniAppDeployToken) _then) = __$MiniAppDeployTokenCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? createdAt,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? lastUsedAt
});




}
/// @nodoc
class __$MiniAppDeployTokenCopyWithImpl<$Res>
    implements _$MiniAppDeployTokenCopyWith<$Res> {
  __$MiniAppDeployTokenCopyWithImpl(this._self, this._then);

  final _MiniAppDeployToken _self;
  final $Res Function(_MiniAppDeployToken) _then;

/// Create a copy of MiniAppDeployToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? createdAt = freezed,Object? lastUsedAt = freezed,}) {
  return _then(_MiniAppDeployToken(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUsedAt: freezed == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$CreatedMiniAppDeployToken {

 String get id; String get token;
/// Create a copy of CreatedMiniAppDeployToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatedMiniAppDeployTokenCopyWith<CreatedMiniAppDeployToken> get copyWith => _$CreatedMiniAppDeployTokenCopyWithImpl<CreatedMiniAppDeployToken>(this as CreatedMiniAppDeployToken, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatedMiniAppDeployToken&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,id,token);

@override
String toString() {
  return 'CreatedMiniAppDeployToken(id: $id, token: $token)';
}


}

/// @nodoc
abstract mixin class $CreatedMiniAppDeployTokenCopyWith<$Res>  {
  factory $CreatedMiniAppDeployTokenCopyWith(CreatedMiniAppDeployToken value, $Res Function(CreatedMiniAppDeployToken) _then) = _$CreatedMiniAppDeployTokenCopyWithImpl;
@useResult
$Res call({
 String id, String token
});




}
/// @nodoc
class _$CreatedMiniAppDeployTokenCopyWithImpl<$Res>
    implements $CreatedMiniAppDeployTokenCopyWith<$Res> {
  _$CreatedMiniAppDeployTokenCopyWithImpl(this._self, this._then);

  final CreatedMiniAppDeployToken _self;
  final $Res Function(CreatedMiniAppDeployToken) _then;

/// Create a copy of CreatedMiniAppDeployToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? token = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatedMiniAppDeployToken].
extension CreatedMiniAppDeployTokenPatterns on CreatedMiniAppDeployToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatedMiniAppDeployToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatedMiniAppDeployToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatedMiniAppDeployToken value)  $default,){
final _that = this;
switch (_that) {
case _CreatedMiniAppDeployToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatedMiniAppDeployToken value)?  $default,){
final _that = this;
switch (_that) {
case _CreatedMiniAppDeployToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatedMiniAppDeployToken() when $default != null:
return $default(_that.id,_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String token)  $default,) {final _that = this;
switch (_that) {
case _CreatedMiniAppDeployToken():
return $default(_that.id,_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String token)?  $default,) {final _that = this;
switch (_that) {
case _CreatedMiniAppDeployToken() when $default != null:
return $default(_that.id,_that.token);case _:
  return null;

}
}

}

/// @nodoc


class _CreatedMiniAppDeployToken implements CreatedMiniAppDeployToken {
  const _CreatedMiniAppDeployToken({required this.id, required this.token});


@override final  String id;
@override final  String token;

/// Create a copy of CreatedMiniAppDeployToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedMiniAppDeployTokenCopyWith<_CreatedMiniAppDeployToken> get copyWith => __$CreatedMiniAppDeployTokenCopyWithImpl<_CreatedMiniAppDeployToken>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatedMiniAppDeployToken&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,id,token);

@override
String toString() {
  return 'CreatedMiniAppDeployToken(id: $id, token: $token)';
}


}

/// @nodoc
abstract mixin class _$CreatedMiniAppDeployTokenCopyWith<$Res> implements $CreatedMiniAppDeployTokenCopyWith<$Res> {
  factory _$CreatedMiniAppDeployTokenCopyWith(_CreatedMiniAppDeployToken value, $Res Function(_CreatedMiniAppDeployToken) _then) = __$CreatedMiniAppDeployTokenCopyWithImpl;
@override @useResult
$Res call({
 String id, String token
});




}
/// @nodoc
class __$CreatedMiniAppDeployTokenCopyWithImpl<$Res>
    implements _$CreatedMiniAppDeployTokenCopyWith<$Res> {
  __$CreatedMiniAppDeployTokenCopyWithImpl(this._self, this._then);

  final _CreatedMiniAppDeployToken _self;
  final $Res Function(_CreatedMiniAppDeployToken) _then;

/// Create a copy of CreatedMiniAppDeployToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? token = null,}) {
  return _then(_CreatedMiniAppDeployToken(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MiniAppSigningSecretInfo {

 bool get hasSecret; String? get fingerprint;@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? get createdAt;@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? get rotatedAt; bool get previousActive;@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? get previousExpiresAt;
/// Create a copy of MiniAppSigningSecretInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppSigningSecretInfoCopyWith<MiniAppSigningSecretInfo> get copyWith => _$MiniAppSigningSecretInfoCopyWithImpl<MiniAppSigningSecretInfo>(this as MiniAppSigningSecretInfo, _$identity);

  /// Serializes this MiniAppSigningSecretInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppSigningSecretInfo&&(identical(other.hasSecret, hasSecret) || other.hasSecret == hasSecret)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.rotatedAt, rotatedAt) || other.rotatedAt == rotatedAt)&&(identical(other.previousActive, previousActive) || other.previousActive == previousActive)&&(identical(other.previousExpiresAt, previousExpiresAt) || other.previousExpiresAt == previousExpiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasSecret,fingerprint,createdAt,rotatedAt,previousActive,previousExpiresAt);

@override
String toString() {
  return 'MiniAppSigningSecretInfo(hasSecret: $hasSecret, fingerprint: $fingerprint, createdAt: $createdAt, rotatedAt: $rotatedAt, previousActive: $previousActive, previousExpiresAt: $previousExpiresAt)';
}


}

/// @nodoc
abstract mixin class $MiniAppSigningSecretInfoCopyWith<$Res>  {
  factory $MiniAppSigningSecretInfoCopyWith(MiniAppSigningSecretInfo value, $Res Function(MiniAppSigningSecretInfo) _then) = _$MiniAppSigningSecretInfoCopyWithImpl;
@useResult
$Res call({
 bool hasSecret, String? fingerprint,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? createdAt,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? rotatedAt, bool previousActive,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? previousExpiresAt
});




}
/// @nodoc
class _$MiniAppSigningSecretInfoCopyWithImpl<$Res>
    implements $MiniAppSigningSecretInfoCopyWith<$Res> {
  _$MiniAppSigningSecretInfoCopyWithImpl(this._self, this._then);

  final MiniAppSigningSecretInfo _self;
  final $Res Function(MiniAppSigningSecretInfo) _then;

/// Create a copy of MiniAppSigningSecretInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasSecret = null,Object? fingerprint = freezed,Object? createdAt = freezed,Object? rotatedAt = freezed,Object? previousActive = null,Object? previousExpiresAt = freezed,}) {
  return _then(_self.copyWith(
hasSecret: null == hasSecret ? _self.hasSecret : hasSecret // ignore: cast_nullable_to_non_nullable
as bool,fingerprint: freezed == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rotatedAt: freezed == rotatedAt ? _self.rotatedAt : rotatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,previousActive: null == previousActive ? _self.previousActive : previousActive // ignore: cast_nullable_to_non_nullable
as bool,previousExpiresAt: freezed == previousExpiresAt ? _self.previousExpiresAt : previousExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppSigningSecretInfo].
extension MiniAppSigningSecretInfoPatterns on MiniAppSigningSecretInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppSigningSecretInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppSigningSecretInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppSigningSecretInfo value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppSigningSecretInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppSigningSecretInfo value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppSigningSecretInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasSecret,  String? fingerprint, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? rotatedAt,  bool previousActive, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? previousExpiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppSigningSecretInfo() when $default != null:
return $default(_that.hasSecret,_that.fingerprint,_that.createdAt,_that.rotatedAt,_that.previousActive,_that.previousExpiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasSecret,  String? fingerprint, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? rotatedAt,  bool previousActive, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? previousExpiresAt)  $default,) {final _that = this;
switch (_that) {
case _MiniAppSigningSecretInfo():
return $default(_that.hasSecret,_that.fingerprint,_that.createdAt,_that.rotatedAt,_that.previousActive,_that.previousExpiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasSecret,  String? fingerprint, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? rotatedAt,  bool previousActive, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson)  DateTime? previousExpiresAt)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppSigningSecretInfo() when $default != null:
return $default(_that.hasSecret,_that.fingerprint,_that.createdAt,_that.rotatedAt,_that.previousActive,_that.previousExpiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiniAppSigningSecretInfo implements MiniAppSigningSecretInfo {
  const _MiniAppSigningSecretInfo({this.hasSecret = false, this.fingerprint, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) this.createdAt, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) this.rotatedAt, this.previousActive = false, @JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) this.previousExpiresAt});
  factory _MiniAppSigningSecretInfo.fromJson(Map<String, dynamic> json) => _$MiniAppSigningSecretInfoFromJson(json);

@override@JsonKey() final  bool hasSecret;
@override final  String? fingerprint;
@override@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) final  DateTime? rotatedAt;
@override@JsonKey() final  bool previousActive;
@override@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) final  DateTime? previousExpiresAt;

/// Create a copy of MiniAppSigningSecretInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppSigningSecretInfoCopyWith<_MiniAppSigningSecretInfo> get copyWith => __$MiniAppSigningSecretInfoCopyWithImpl<_MiniAppSigningSecretInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiniAppSigningSecretInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppSigningSecretInfo&&(identical(other.hasSecret, hasSecret) || other.hasSecret == hasSecret)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.rotatedAt, rotatedAt) || other.rotatedAt == rotatedAt)&&(identical(other.previousActive, previousActive) || other.previousActive == previousActive)&&(identical(other.previousExpiresAt, previousExpiresAt) || other.previousExpiresAt == previousExpiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasSecret,fingerprint,createdAt,rotatedAt,previousActive,previousExpiresAt);

@override
String toString() {
  return 'MiniAppSigningSecretInfo(hasSecret: $hasSecret, fingerprint: $fingerprint, createdAt: $createdAt, rotatedAt: $rotatedAt, previousActive: $previousActive, previousExpiresAt: $previousExpiresAt)';
}


}

/// @nodoc
abstract mixin class _$MiniAppSigningSecretInfoCopyWith<$Res> implements $MiniAppSigningSecretInfoCopyWith<$Res> {
  factory _$MiniAppSigningSecretInfoCopyWith(_MiniAppSigningSecretInfo value, $Res Function(_MiniAppSigningSecretInfo) _then) = __$MiniAppSigningSecretInfoCopyWithImpl;
@override @useResult
$Res call({
 bool hasSecret, String? fingerprint,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? createdAt,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? rotatedAt, bool previousActive,@JsonKey(fromJson: _localDateFromJson, toJson: _dateToJson) DateTime? previousExpiresAt
});




}
/// @nodoc
class __$MiniAppSigningSecretInfoCopyWithImpl<$Res>
    implements _$MiniAppSigningSecretInfoCopyWith<$Res> {
  __$MiniAppSigningSecretInfoCopyWithImpl(this._self, this._then);

  final _MiniAppSigningSecretInfo _self;
  final $Res Function(_MiniAppSigningSecretInfo) _then;

/// Create a copy of MiniAppSigningSecretInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasSecret = null,Object? fingerprint = freezed,Object? createdAt = freezed,Object? rotatedAt = freezed,Object? previousActive = null,Object? previousExpiresAt = freezed,}) {
  return _then(_MiniAppSigningSecretInfo(
hasSecret: null == hasSecret ? _self.hasSecret : hasSecret // ignore: cast_nullable_to_non_nullable
as bool,fingerprint: freezed == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rotatedAt: freezed == rotatedAt ? _self.rotatedAt : rotatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,previousActive: null == previousActive ? _self.previousActive : previousActive // ignore: cast_nullable_to_non_nullable
as bool,previousExpiresAt: freezed == previousExpiresAt ? _self.previousExpiresAt : previousExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$CreatedMiniAppSigningSecret {

 String get secret; String get fingerprint;
/// Create a copy of CreatedMiniAppSigningSecret
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatedMiniAppSigningSecretCopyWith<CreatedMiniAppSigningSecret> get copyWith => _$CreatedMiniAppSigningSecretCopyWithImpl<CreatedMiniAppSigningSecret>(this as CreatedMiniAppSigningSecret, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatedMiniAppSigningSecret&&(identical(other.secret, secret) || other.secret == secret)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint));
}


@override
int get hashCode => Object.hash(runtimeType,secret,fingerprint);

@override
String toString() {
  return 'CreatedMiniAppSigningSecret(secret: $secret, fingerprint: $fingerprint)';
}


}

/// @nodoc
abstract mixin class $CreatedMiniAppSigningSecretCopyWith<$Res>  {
  factory $CreatedMiniAppSigningSecretCopyWith(CreatedMiniAppSigningSecret value, $Res Function(CreatedMiniAppSigningSecret) _then) = _$CreatedMiniAppSigningSecretCopyWithImpl;
@useResult
$Res call({
 String secret, String fingerprint
});




}
/// @nodoc
class _$CreatedMiniAppSigningSecretCopyWithImpl<$Res>
    implements $CreatedMiniAppSigningSecretCopyWith<$Res> {
  _$CreatedMiniAppSigningSecretCopyWithImpl(this._self, this._then);

  final CreatedMiniAppSigningSecret _self;
  final $Res Function(CreatedMiniAppSigningSecret) _then;

/// Create a copy of CreatedMiniAppSigningSecret
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? secret = null,Object? fingerprint = null,}) {
  return _then(_self.copyWith(
secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as String,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatedMiniAppSigningSecret].
extension CreatedMiniAppSigningSecretPatterns on CreatedMiniAppSigningSecret {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatedMiniAppSigningSecret value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatedMiniAppSigningSecret() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatedMiniAppSigningSecret value)  $default,){
final _that = this;
switch (_that) {
case _CreatedMiniAppSigningSecret():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatedMiniAppSigningSecret value)?  $default,){
final _that = this;
switch (_that) {
case _CreatedMiniAppSigningSecret() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String secret,  String fingerprint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatedMiniAppSigningSecret() when $default != null:
return $default(_that.secret,_that.fingerprint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String secret,  String fingerprint)  $default,) {final _that = this;
switch (_that) {
case _CreatedMiniAppSigningSecret():
return $default(_that.secret,_that.fingerprint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String secret,  String fingerprint)?  $default,) {final _that = this;
switch (_that) {
case _CreatedMiniAppSigningSecret() when $default != null:
return $default(_that.secret,_that.fingerprint);case _:
  return null;

}
}

}

/// @nodoc


class _CreatedMiniAppSigningSecret implements CreatedMiniAppSigningSecret {
  const _CreatedMiniAppSigningSecret({required this.secret, required this.fingerprint});


@override final  String secret;
@override final  String fingerprint;

/// Create a copy of CreatedMiniAppSigningSecret
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedMiniAppSigningSecretCopyWith<_CreatedMiniAppSigningSecret> get copyWith => __$CreatedMiniAppSigningSecretCopyWithImpl<_CreatedMiniAppSigningSecret>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatedMiniAppSigningSecret&&(identical(other.secret, secret) || other.secret == secret)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint));
}


@override
int get hashCode => Object.hash(runtimeType,secret,fingerprint);

@override
String toString() {
  return 'CreatedMiniAppSigningSecret(secret: $secret, fingerprint: $fingerprint)';
}


}

/// @nodoc
abstract mixin class _$CreatedMiniAppSigningSecretCopyWith<$Res> implements $CreatedMiniAppSigningSecretCopyWith<$Res> {
  factory _$CreatedMiniAppSigningSecretCopyWith(_CreatedMiniAppSigningSecret value, $Res Function(_CreatedMiniAppSigningSecret) _then) = __$CreatedMiniAppSigningSecretCopyWithImpl;
@override @useResult
$Res call({
 String secret, String fingerprint
});




}
/// @nodoc
class __$CreatedMiniAppSigningSecretCopyWithImpl<$Res>
    implements _$CreatedMiniAppSigningSecretCopyWith<$Res> {
  __$CreatedMiniAppSigningSecretCopyWithImpl(this._self, this._then);

  final _CreatedMiniAppSigningSecret _self;
  final $Res Function(_CreatedMiniAppSigningSecret) _then;

/// Create a copy of CreatedMiniAppSigningSecret
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? secret = null,Object? fingerprint = null,}) {
  return _then(_CreatedMiniAppSigningSecret(
secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as String,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MiniAppValidation {

@JsonKey(fromJson: _stringsFromJson) List<String> get unknownWidgets;@JsonKey(fromJson: _stringsFromJson) List<String> get unknownActions;
/// Create a copy of MiniAppValidation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppValidationCopyWith<MiniAppValidation> get copyWith => _$MiniAppValidationCopyWithImpl<MiniAppValidation>(this as MiniAppValidation, _$identity);

  /// Serializes this MiniAppValidation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppValidation&&const DeepCollectionEquality().equals(other.unknownWidgets, unknownWidgets)&&const DeepCollectionEquality().equals(other.unknownActions, unknownActions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(unknownWidgets),const DeepCollectionEquality().hash(unknownActions));

@override
String toString() {
  return 'MiniAppValidation(unknownWidgets: $unknownWidgets, unknownActions: $unknownActions)';
}


}

/// @nodoc
abstract mixin class $MiniAppValidationCopyWith<$Res>  {
  factory $MiniAppValidationCopyWith(MiniAppValidation value, $Res Function(MiniAppValidation) _then) = _$MiniAppValidationCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _stringsFromJson) List<String> unknownWidgets,@JsonKey(fromJson: _stringsFromJson) List<String> unknownActions
});




}
/// @nodoc
class _$MiniAppValidationCopyWithImpl<$Res>
    implements $MiniAppValidationCopyWith<$Res> {
  _$MiniAppValidationCopyWithImpl(this._self, this._then);

  final MiniAppValidation _self;
  final $Res Function(MiniAppValidation) _then;

/// Create a copy of MiniAppValidation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unknownWidgets = null,Object? unknownActions = null,}) {
  return _then(_self.copyWith(
unknownWidgets: null == unknownWidgets ? _self.unknownWidgets : unknownWidgets // ignore: cast_nullable_to_non_nullable
as List<String>,unknownActions: null == unknownActions ? _self.unknownActions : unknownActions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppValidation].
extension MiniAppValidationPatterns on MiniAppValidation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppValidation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppValidation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppValidation value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppValidation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppValidation value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppValidation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _stringsFromJson)  List<String> unknownWidgets, @JsonKey(fromJson: _stringsFromJson)  List<String> unknownActions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppValidation() when $default != null:
return $default(_that.unknownWidgets,_that.unknownActions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _stringsFromJson)  List<String> unknownWidgets, @JsonKey(fromJson: _stringsFromJson)  List<String> unknownActions)  $default,) {final _that = this;
switch (_that) {
case _MiniAppValidation():
return $default(_that.unknownWidgets,_that.unknownActions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _stringsFromJson)  List<String> unknownWidgets, @JsonKey(fromJson: _stringsFromJson)  List<String> unknownActions)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppValidation() when $default != null:
return $default(_that.unknownWidgets,_that.unknownActions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiniAppValidation extends MiniAppValidation {
  const _MiniAppValidation({@JsonKey(fromJson: _stringsFromJson) final  List<String> unknownWidgets = const <String>[], @JsonKey(fromJson: _stringsFromJson) final  List<String> unknownActions = const <String>[]}): _unknownWidgets = unknownWidgets,_unknownActions = unknownActions,super._();
  factory _MiniAppValidation.fromJson(Map<String, dynamic> json) => _$MiniAppValidationFromJson(json);

 final  List<String> _unknownWidgets;
@override@JsonKey(fromJson: _stringsFromJson) List<String> get unknownWidgets {
  if (_unknownWidgets is EqualUnmodifiableListView) return _unknownWidgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unknownWidgets);
}

 final  List<String> _unknownActions;
@override@JsonKey(fromJson: _stringsFromJson) List<String> get unknownActions {
  if (_unknownActions is EqualUnmodifiableListView) return _unknownActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_unknownActions);
}


/// Create a copy of MiniAppValidation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppValidationCopyWith<_MiniAppValidation> get copyWith => __$MiniAppValidationCopyWithImpl<_MiniAppValidation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiniAppValidationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppValidation&&const DeepCollectionEquality().equals(other._unknownWidgets, _unknownWidgets)&&const DeepCollectionEquality().equals(other._unknownActions, _unknownActions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_unknownWidgets),const DeepCollectionEquality().hash(_unknownActions));

@override
String toString() {
  return 'MiniAppValidation(unknownWidgets: $unknownWidgets, unknownActions: $unknownActions)';
}


}

/// @nodoc
abstract mixin class _$MiniAppValidationCopyWith<$Res> implements $MiniAppValidationCopyWith<$Res> {
  factory _$MiniAppValidationCopyWith(_MiniAppValidation value, $Res Function(_MiniAppValidation) _then) = __$MiniAppValidationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _stringsFromJson) List<String> unknownWidgets,@JsonKey(fromJson: _stringsFromJson) List<String> unknownActions
});




}
/// @nodoc
class __$MiniAppValidationCopyWithImpl<$Res>
    implements _$MiniAppValidationCopyWith<$Res> {
  __$MiniAppValidationCopyWithImpl(this._self, this._then);

  final _MiniAppValidation _self;
  final $Res Function(_MiniAppValidation) _then;

/// Create a copy of MiniAppValidation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unknownWidgets = null,Object? unknownActions = null,}) {
  return _then(_MiniAppValidation(
unknownWidgets: null == unknownWidgets ? _self._unknownWidgets : unknownWidgets // ignore: cast_nullable_to_non_nullable
as List<String>,unknownActions: null == unknownActions ? _self._unknownActions : unknownActions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
