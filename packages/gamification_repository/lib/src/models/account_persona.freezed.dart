// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_persona.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountPersona {

 AccountRole get role; String? get teacherId; String? get teacherName; bool get teacherAvailable; int get revision;
/// Create a copy of AccountPersona
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountPersonaCopyWith<AccountPersona> get copyWith => _$AccountPersonaCopyWithImpl<AccountPersona>(this as AccountPersona, _$identity);

  /// Serializes this AccountPersona to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountPersona&&(identical(other.role, role) || other.role == role)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.teacherName, teacherName) || other.teacherName == teacherName)&&(identical(other.teacherAvailable, teacherAvailable) || other.teacherAvailable == teacherAvailable)&&(identical(other.revision, revision) || other.revision == revision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,teacherId,teacherName,teacherAvailable,revision);

@override
String toString() {
  return 'AccountPersona(role: $role, teacherId: $teacherId, teacherName: $teacherName, teacherAvailable: $teacherAvailable, revision: $revision)';
}


}

/// @nodoc
abstract mixin class $AccountPersonaCopyWith<$Res>  {
  factory $AccountPersonaCopyWith(AccountPersona value, $Res Function(AccountPersona) _then) = _$AccountPersonaCopyWithImpl;
@useResult
$Res call({
 AccountRole role, String? teacherId, String? teacherName, bool teacherAvailable, int revision
});




}
/// @nodoc
class _$AccountPersonaCopyWithImpl<$Res>
    implements $AccountPersonaCopyWith<$Res> {
  _$AccountPersonaCopyWithImpl(this._self, this._then);

  final AccountPersona _self;
  final $Res Function(AccountPersona) _then;

/// Create a copy of AccountPersona
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? teacherId = freezed,Object? teacherName = freezed,Object? teacherAvailable = null,Object? revision = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,teacherName: freezed == teacherName ? _self.teacherName : teacherName // ignore: cast_nullable_to_non_nullable
as String?,teacherAvailable: null == teacherAvailable ? _self.teacherAvailable : teacherAvailable // ignore: cast_nullable_to_non_nullable
as bool,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountPersona].
extension AccountPersonaPatterns on AccountPersona {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountPersona value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountPersona() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountPersona value)  $default,){
final _that = this;
switch (_that) {
case _AccountPersona():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountPersona value)?  $default,){
final _that = this;
switch (_that) {
case _AccountPersona() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccountRole role,  String? teacherId,  String? teacherName,  bool teacherAvailable,  int revision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountPersona() when $default != null:
return $default(_that.role,_that.teacherId,_that.teacherName,_that.teacherAvailable,_that.revision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccountRole role,  String? teacherId,  String? teacherName,  bool teacherAvailable,  int revision)  $default,) {final _that = this;
switch (_that) {
case _AccountPersona():
return $default(_that.role,_that.teacherId,_that.teacherName,_that.teacherAvailable,_that.revision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccountRole role,  String? teacherId,  String? teacherName,  bool teacherAvailable,  int revision)?  $default,) {final _that = this;
switch (_that) {
case _AccountPersona() when $default != null:
return $default(_that.role,_that.teacherId,_that.teacherName,_that.teacherAvailable,_that.revision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccountPersona implements AccountPersona {
  const _AccountPersona({this.role = AccountRole.student, this.teacherId, this.teacherName, this.teacherAvailable = false, this.revision = 0});
  factory _AccountPersona.fromJson(Map<String, dynamic> json) => _$AccountPersonaFromJson(json);

@override@JsonKey() final  AccountRole role;
@override final  String? teacherId;
@override final  String? teacherName;
@override@JsonKey() final  bool teacherAvailable;
@override@JsonKey() final  int revision;

/// Create a copy of AccountPersona
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountPersonaCopyWith<_AccountPersona> get copyWith => __$AccountPersonaCopyWithImpl<_AccountPersona>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountPersonaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountPersona&&(identical(other.role, role) || other.role == role)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.teacherName, teacherName) || other.teacherName == teacherName)&&(identical(other.teacherAvailable, teacherAvailable) || other.teacherAvailable == teacherAvailable)&&(identical(other.revision, revision) || other.revision == revision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,teacherId,teacherName,teacherAvailable,revision);

@override
String toString() {
  return 'AccountPersona(role: $role, teacherId: $teacherId, teacherName: $teacherName, teacherAvailable: $teacherAvailable, revision: $revision)';
}


}

/// @nodoc
abstract mixin class _$AccountPersonaCopyWith<$Res> implements $AccountPersonaCopyWith<$Res> {
  factory _$AccountPersonaCopyWith(_AccountPersona value, $Res Function(_AccountPersona) _then) = __$AccountPersonaCopyWithImpl;
@override @useResult
$Res call({
 AccountRole role, String? teacherId, String? teacherName, bool teacherAvailable, int revision
});




}
/// @nodoc
class __$AccountPersonaCopyWithImpl<$Res>
    implements _$AccountPersonaCopyWith<$Res> {
  __$AccountPersonaCopyWithImpl(this._self, this._then);

  final _AccountPersona _self;
  final $Res Function(_AccountPersona) _then;

/// Create a copy of AccountPersona
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? teacherId = freezed,Object? teacherName = freezed,Object? teacherAvailable = null,Object? revision = null,}) {
  return _then(_AccountPersona(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,teacherName: freezed == teacherName ? _self.teacherName : teacherName // ignore: cast_nullable_to_non_nullable
as String?,teacherAvailable: null == teacherAvailable ? _self.teacherAvailable : teacherAvailable // ignore: cast_nullable_to_non_nullable
as bool,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
