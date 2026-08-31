// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preference_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserPreferenceEntry {

 String get key; Map<String, dynamic> get value; int get revision; DateTime get updatedAt;
/// Create a copy of UserPreferenceEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPreferenceEntryCopyWith<UserPreferenceEntry> get copyWith => _$UserPreferenceEntryCopyWithImpl<UserPreferenceEntry>(this as UserPreferenceEntry, _$identity);

  /// Serializes this UserPreferenceEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPreferenceEntry&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(value),revision,updatedAt);

@override
String toString() {
  return 'UserPreferenceEntry(key: $key, value: $value, revision: $revision, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserPreferenceEntryCopyWith<$Res>  {
  factory $UserPreferenceEntryCopyWith(UserPreferenceEntry value, $Res Function(UserPreferenceEntry) _then) = _$UserPreferenceEntryCopyWithImpl;
@useResult
$Res call({
 String key, Map<String, dynamic> value, int revision, DateTime updatedAt
});




}
/// @nodoc
class _$UserPreferenceEntryCopyWithImpl<$Res>
    implements $UserPreferenceEntryCopyWith<$Res> {
  _$UserPreferenceEntryCopyWithImpl(this._self, this._then);

  final UserPreferenceEntry _self;
  final $Res Function(UserPreferenceEntry) _then;

/// Create a copy of UserPreferenceEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? value = null,Object? revision = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPreferenceEntry].
extension UserPreferenceEntryPatterns on UserPreferenceEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPreferenceEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPreferenceEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPreferenceEntry value)  $default,){
final _that = this;
switch (_that) {
case _UserPreferenceEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPreferenceEntry value)?  $default,){
final _that = this;
switch (_that) {
case _UserPreferenceEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  Map<String, dynamic> value,  int revision,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPreferenceEntry() when $default != null:
return $default(_that.key,_that.value,_that.revision,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  Map<String, dynamic> value,  int revision,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserPreferenceEntry():
return $default(_that.key,_that.value,_that.revision,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  Map<String, dynamic> value,  int revision,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserPreferenceEntry() when $default != null:
return $default(_that.key,_that.value,_that.revision,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserPreferenceEntry implements UserPreferenceEntry {
  const _UserPreferenceEntry({required this.key, required final  Map<String, dynamic> value, required this.revision, required this.updatedAt}): _value = value;
  factory _UserPreferenceEntry.fromJson(Map<String, dynamic> json) => _$UserPreferenceEntryFromJson(json);

@override final  String key;
 final  Map<String, dynamic> _value;
@override Map<String, dynamic> get value {
  if (_value is EqualUnmodifiableMapView) return _value;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_value);
}

@override final  int revision;
@override final  DateTime updatedAt;

/// Create a copy of UserPreferenceEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPreferenceEntryCopyWith<_UserPreferenceEntry> get copyWith => __$UserPreferenceEntryCopyWithImpl<_UserPreferenceEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserPreferenceEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPreferenceEntry&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other._value, _value)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(_value),revision,updatedAt);

@override
String toString() {
  return 'UserPreferenceEntry(key: $key, value: $value, revision: $revision, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserPreferenceEntryCopyWith<$Res> implements $UserPreferenceEntryCopyWith<$Res> {
  factory _$UserPreferenceEntryCopyWith(_UserPreferenceEntry value, $Res Function(_UserPreferenceEntry) _then) = __$UserPreferenceEntryCopyWithImpl;
@override @useResult
$Res call({
 String key, Map<String, dynamic> value, int revision, DateTime updatedAt
});




}
/// @nodoc
class __$UserPreferenceEntryCopyWithImpl<$Res>
    implements _$UserPreferenceEntryCopyWith<$Res> {
  __$UserPreferenceEntryCopyWithImpl(this._self, this._then);

  final _UserPreferenceEntry _self;
  final $Res Function(_UserPreferenceEntry) _then;

/// Create a copy of UserPreferenceEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = null,Object? revision = null,Object? updatedAt = null,}) {
  return _then(_UserPreferenceEntry(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self._value : value // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
