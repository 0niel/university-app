// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthenticationUser {

 String get id; String? get email; String? get name; String? get photo; bool get isNewUser; bool get isGuest;
/// Create a copy of AuthenticationUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationUserCopyWith<AuthenticationUser> get copyWith => _$AuthenticationUserCopyWithImpl<AuthenticationUser>(this as AuthenticationUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser)&&(identical(other.isGuest, isGuest) || other.isGuest == isGuest));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,name,photo,isNewUser,isGuest);

@override
String toString() {
  return 'AuthenticationUser(id: $id, email: $email, name: $name, photo: $photo, isNewUser: $isNewUser, isGuest: $isGuest)';
}


}

/// @nodoc
abstract mixin class $AuthenticationUserCopyWith<$Res>  {
  factory $AuthenticationUserCopyWith(AuthenticationUser value, $Res Function(AuthenticationUser) _then) = _$AuthenticationUserCopyWithImpl;
@useResult
$Res call({
 String id, String? email, String? name, String? photo, bool isNewUser, bool isGuest
});




}
/// @nodoc
class _$AuthenticationUserCopyWithImpl<$Res>
    implements $AuthenticationUserCopyWith<$Res> {
  _$AuthenticationUserCopyWithImpl(this._self, this._then);

  final AuthenticationUser _self;
  final $Res Function(AuthenticationUser) _then;

/// Create a copy of AuthenticationUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = freezed,Object? name = freezed,Object? photo = freezed,Object? isNewUser = null,Object? isGuest = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,isGuest: null == isGuest ? _self.isGuest : isGuest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthenticationUser].
extension AuthenticationUserPatterns on AuthenticationUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthenticationUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthenticationUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthenticationUser value)  $default,){
final _that = this;
switch (_that) {
case _AuthenticationUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthenticationUser value)?  $default,){
final _that = this;
switch (_that) {
case _AuthenticationUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? email,  String? name,  String? photo,  bool isNewUser,  bool isGuest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthenticationUser() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.photo,_that.isNewUser,_that.isGuest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? email,  String? name,  String? photo,  bool isNewUser,  bool isGuest)  $default,) {final _that = this;
switch (_that) {
case _AuthenticationUser():
return $default(_that.id,_that.email,_that.name,_that.photo,_that.isNewUser,_that.isGuest);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? email,  String? name,  String? photo,  bool isNewUser,  bool isGuest)?  $default,) {final _that = this;
switch (_that) {
case _AuthenticationUser() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.photo,_that.isNewUser,_that.isGuest);case _:
  return null;

}
}

}

/// @nodoc


class _AuthenticationUser extends AuthenticationUser {
  const _AuthenticationUser({required this.id, this.email, this.name, this.photo, this.isNewUser = true, this.isGuest = false}): super._();


@override final  String id;
@override final  String? email;
@override final  String? name;
@override final  String? photo;
@override@JsonKey() final  bool isNewUser;
@override@JsonKey() final  bool isGuest;

/// Create a copy of AuthenticationUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticationUserCopyWith<_AuthenticationUser> get copyWith => __$AuthenticationUserCopyWithImpl<_AuthenticationUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthenticationUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser)&&(identical(other.isGuest, isGuest) || other.isGuest == isGuest));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,name,photo,isNewUser,isGuest);

@override
String toString() {
  return 'AuthenticationUser(id: $id, email: $email, name: $name, photo: $photo, isNewUser: $isNewUser, isGuest: $isGuest)';
}


}

/// @nodoc
abstract mixin class _$AuthenticationUserCopyWith<$Res> implements $AuthenticationUserCopyWith<$Res> {
  factory _$AuthenticationUserCopyWith(_AuthenticationUser value, $Res Function(_AuthenticationUser) _then) = __$AuthenticationUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String? email, String? name, String? photo, bool isNewUser, bool isGuest
});




}
/// @nodoc
class __$AuthenticationUserCopyWithImpl<$Res>
    implements _$AuthenticationUserCopyWith<$Res> {
  __$AuthenticationUserCopyWithImpl(this._self, this._then);

  final _AuthenticationUser _self;
  final $Res Function(_AuthenticationUser) _then;

/// Create a copy of AuthenticationUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = freezed,Object? name = freezed,Object? photo = freezed,Object? isNewUser = null,Object? isGuest = null,}) {
  return _then(_AuthenticationUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,isGuest: null == isGuest ? _self.isGuest : isGuest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
