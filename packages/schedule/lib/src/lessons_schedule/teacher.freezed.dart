// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Teacher {

 String get name; String? get uid; String? get photoUrl; String? get email; String? get phone; String? get post; String? get department;
/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherCopyWith<Teacher> get copyWith => _$TeacherCopyWithImpl<Teacher>(this as Teacher, _$identity);

  /// Serializes this Teacher to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Teacher&&(identical(other.name, name) || other.name == name)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.post, post) || other.post == post)&&(identical(other.department, department) || other.department == department));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,uid,photoUrl,email,phone,post,department);

@override
String toString() {
  return 'Teacher(name: $name, uid: $uid, photoUrl: $photoUrl, email: $email, phone: $phone, post: $post, department: $department)';
}


}

/// @nodoc
abstract mixin class $TeacherCopyWith<$Res>  {
  factory $TeacherCopyWith(Teacher value, $Res Function(Teacher) _then) = _$TeacherCopyWithImpl;
@useResult
$Res call({
 String name, String? uid, String? photoUrl, String? email, String? phone, String? post, String? department
});




}
/// @nodoc
class _$TeacherCopyWithImpl<$Res>
    implements $TeacherCopyWith<$Res> {
  _$TeacherCopyWithImpl(this._self, this._then);

  final Teacher _self;
  final $Res Function(Teacher) _then;

/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? uid = freezed,Object? photoUrl = freezed,Object? email = freezed,Object? phone = freezed,Object? post = freezed,Object? department = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Teacher].
extension TeacherPatterns on Teacher {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Teacher value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Teacher() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Teacher value)  $default,){
final _that = this;
switch (_that) {
case _Teacher():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Teacher value)?  $default,){
final _that = this;
switch (_that) {
case _Teacher() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? uid,  String? photoUrl,  String? email,  String? phone,  String? post,  String? department)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Teacher() when $default != null:
return $default(_that.name,_that.uid,_that.photoUrl,_that.email,_that.phone,_that.post,_that.department);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? uid,  String? photoUrl,  String? email,  String? phone,  String? post,  String? department)  $default,) {final _that = this;
switch (_that) {
case _Teacher():
return $default(_that.name,_that.uid,_that.photoUrl,_that.email,_that.phone,_that.post,_that.department);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? uid,  String? photoUrl,  String? email,  String? phone,  String? post,  String? department)?  $default,) {final _that = this;
switch (_that) {
case _Teacher() when $default != null:
return $default(_that.name,_that.uid,_that.photoUrl,_that.email,_that.phone,_that.post,_that.department);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Teacher implements Teacher {
  const _Teacher({required this.name, this.uid, this.photoUrl, this.email, this.phone, this.post, this.department});
  factory _Teacher.fromJson(Map<String, dynamic> json) => _$TeacherFromJson(json);

@override final  String name;
@override final  String? uid;
@override final  String? photoUrl;
@override final  String? email;
@override final  String? phone;
@override final  String? post;
@override final  String? department;

/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherCopyWith<_Teacher> get copyWith => __$TeacherCopyWithImpl<_Teacher>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Teacher&&(identical(other.name, name) || other.name == name)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.post, post) || other.post == post)&&(identical(other.department, department) || other.department == department));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,uid,photoUrl,email,phone,post,department);

@override
String toString() {
  return 'Teacher(name: $name, uid: $uid, photoUrl: $photoUrl, email: $email, phone: $phone, post: $post, department: $department)';
}


}

/// @nodoc
abstract mixin class _$TeacherCopyWith<$Res> implements $TeacherCopyWith<$Res> {
  factory _$TeacherCopyWith(_Teacher value, $Res Function(_Teacher) _then) = __$TeacherCopyWithImpl;
@override @useResult
$Res call({
 String name, String? uid, String? photoUrl, String? email, String? phone, String? post, String? department
});




}
/// @nodoc
class __$TeacherCopyWithImpl<$Res>
    implements _$TeacherCopyWith<$Res> {
  __$TeacherCopyWithImpl(this._self, this._then);

  final _Teacher _self;
  final $Res Function(_Teacher) _then;

/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? uid = freezed,Object? photoUrl = freezed,Object? email = freezed,Object? phone = freezed,Object? post = freezed,Object? department = freezed,}) {
  return _then(_Teacher(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as String?,department: freezed == department ? _self.department : department // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
