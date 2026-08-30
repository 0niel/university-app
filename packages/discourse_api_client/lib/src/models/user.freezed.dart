// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 int get id; String get username; String? get name;@JsonKey(name: 'avatar_template') String get avatarTemplate;@JsonKey(name: 'trust_level') int get trustLevel; bool? get admin; bool? get moderator;@JsonKey(name: 'custom_fields') Map<String, dynamic>? get customFields;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate)&&(identical(other.trustLevel, trustLevel) || other.trustLevel == trustLevel)&&(identical(other.admin, admin) || other.admin == admin)&&(identical(other.moderator, moderator) || other.moderator == moderator)&&const DeepCollectionEquality().equals(other.customFields, customFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,name,avatarTemplate,trustLevel,admin,moderator,const DeepCollectionEquality().hash(customFields));

@override
String toString() {
  return 'User(id: $id, username: $username, name: $name, avatarTemplate: $avatarTemplate, trustLevel: $trustLevel, admin: $admin, moderator: $moderator, customFields: $customFields)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 int id, String username, String? name,@JsonKey(name: 'avatar_template') String avatarTemplate,@JsonKey(name: 'trust_level') int trustLevel, bool? admin, bool? moderator,@JsonKey(name: 'custom_fields') Map<String, dynamic>? customFields
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? name = freezed,Object? avatarTemplate = null,Object? trustLevel = null,Object? admin = freezed,Object? moderator = freezed,Object? customFields = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,trustLevel: null == trustLevel ? _self.trustLevel : trustLevel // ignore: cast_nullable_to_non_nullable
as int,admin: freezed == admin ? _self.admin : admin // ignore: cast_nullable_to_non_nullable
as bool?,moderator: freezed == moderator ? _self.moderator : moderator // ignore: cast_nullable_to_non_nullable
as bool?,customFields: freezed == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String username,  String? name, @JsonKey(name: 'avatar_template')  String avatarTemplate, @JsonKey(name: 'trust_level')  int trustLevel,  bool? admin,  bool? moderator, @JsonKey(name: 'custom_fields')  Map<String, dynamic>? customFields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.username,_that.name,_that.avatarTemplate,_that.trustLevel,_that.admin,_that.moderator,_that.customFields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String username,  String? name, @JsonKey(name: 'avatar_template')  String avatarTemplate, @JsonKey(name: 'trust_level')  int trustLevel,  bool? admin,  bool? moderator, @JsonKey(name: 'custom_fields')  Map<String, dynamic>? customFields)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.username,_that.name,_that.avatarTemplate,_that.trustLevel,_that.admin,_that.moderator,_that.customFields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String username,  String? name, @JsonKey(name: 'avatar_template')  String avatarTemplate, @JsonKey(name: 'trust_level')  int trustLevel,  bool? admin,  bool? moderator, @JsonKey(name: 'custom_fields')  Map<String, dynamic>? customFields)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.username,_that.name,_that.avatarTemplate,_that.trustLevel,_that.admin,_that.moderator,_that.customFields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.id, required this.username, required this.name, @JsonKey(name: 'avatar_template') required this.avatarTemplate, @JsonKey(name: 'trust_level') required this.trustLevel, this.admin, this.moderator, @JsonKey(name: 'custom_fields') final  Map<String, dynamic>? customFields}): _customFields = customFields;
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  int id;
@override final  String username;
@override final  String? name;
@override@JsonKey(name: 'avatar_template') final  String avatarTemplate;
@override@JsonKey(name: 'trust_level') final  int trustLevel;
@override final  bool? admin;
@override final  bool? moderator;
 final  Map<String, dynamic>? _customFields;
@override@JsonKey(name: 'custom_fields') Map<String, dynamic>? get customFields {
  final value = _customFields;
  if (value == null) return null;
  if (_customFields is EqualUnmodifiableMapView) return _customFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarTemplate, avatarTemplate) || other.avatarTemplate == avatarTemplate)&&(identical(other.trustLevel, trustLevel) || other.trustLevel == trustLevel)&&(identical(other.admin, admin) || other.admin == admin)&&(identical(other.moderator, moderator) || other.moderator == moderator)&&const DeepCollectionEquality().equals(other._customFields, _customFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,name,avatarTemplate,trustLevel,admin,moderator,const DeepCollectionEquality().hash(_customFields));

@override
String toString() {
  return 'User(id: $id, username: $username, name: $name, avatarTemplate: $avatarTemplate, trustLevel: $trustLevel, admin: $admin, moderator: $moderator, customFields: $customFields)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 int id, String username, String? name,@JsonKey(name: 'avatar_template') String avatarTemplate,@JsonKey(name: 'trust_level') int trustLevel, bool? admin, bool? moderator,@JsonKey(name: 'custom_fields') Map<String, dynamic>? customFields
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? name = freezed,Object? avatarTemplate = null,Object? trustLevel = null,Object? admin = freezed,Object? moderator = freezed,Object? customFields = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,avatarTemplate: null == avatarTemplate ? _self.avatarTemplate : avatarTemplate // ignore: cast_nullable_to_non_nullable
as String,trustLevel: null == trustLevel ? _self.trustLevel : trustLevel // ignore: cast_nullable_to_non_nullable
as int,admin: freezed == admin ? _self.admin : admin // ignore: cast_nullable_to_non_nullable
as bool?,moderator: freezed == moderator ? _self.moderator : moderator // ignore: cast_nullable_to_non_nullable
as bool?,customFields: freezed == customFields ? _self._customFields : customFields // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
