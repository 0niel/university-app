// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_space_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupSpaceMember {

@JsonKey(defaultValue: '') String get userId;@JsonKey(defaultValue: '') String get fullName; String? get handle; String get role; bool get isOwner; bool get isMe;
/// Create a copy of GroupSpaceMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupSpaceMemberCopyWith<GroupSpaceMember> get copyWith => _$GroupSpaceMemberCopyWithImpl<GroupSpaceMember>(this as GroupSpaceMember, _$identity);

  /// Serializes this GroupSpaceMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupSpaceMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.role, role) || other.role == role)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.isMe, isMe) || other.isMe == isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,handle,role,isOwner,isMe);

@override
String toString() {
  return 'GroupSpaceMember(userId: $userId, fullName: $fullName, handle: $handle, role: $role, isOwner: $isOwner, isMe: $isMe)';
}


}

/// @nodoc
abstract mixin class $GroupSpaceMemberCopyWith<$Res>  {
  factory $GroupSpaceMemberCopyWith(GroupSpaceMember value, $Res Function(GroupSpaceMember) _then) = _$GroupSpaceMemberCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String userId,@JsonKey(defaultValue: '') String fullName, String? handle, String role, bool isOwner, bool isMe
});




}
/// @nodoc
class _$GroupSpaceMemberCopyWithImpl<$Res>
    implements $GroupSpaceMemberCopyWith<$Res> {
  _$GroupSpaceMemberCopyWithImpl(this._self, this._then);

  final GroupSpaceMember _self;
  final $Res Function(GroupSpaceMember) _then;

/// Create a copy of GroupSpaceMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? role = null,Object? isOwner = null,Object? isMe = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupSpaceMember].
extension GroupSpaceMemberPatterns on GroupSpaceMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupSpaceMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupSpaceMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupSpaceMember value)  $default,){
final _that = this;
switch (_that) {
case _GroupSpaceMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupSpaceMember value)?  $default,){
final _that = this;
switch (_that) {
case _GroupSpaceMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String userId, @JsonKey(defaultValue: '')  String fullName,  String? handle,  String role,  bool isOwner,  bool isMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupSpaceMember() when $default != null:
return $default(_that.userId,_that.fullName,_that.handle,_that.role,_that.isOwner,_that.isMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String userId, @JsonKey(defaultValue: '')  String fullName,  String? handle,  String role,  bool isOwner,  bool isMe)  $default,) {final _that = this;
switch (_that) {
case _GroupSpaceMember():
return $default(_that.userId,_that.fullName,_that.handle,_that.role,_that.isOwner,_that.isMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String userId, @JsonKey(defaultValue: '')  String fullName,  String? handle,  String role,  bool isOwner,  bool isMe)?  $default,) {final _that = this;
switch (_that) {
case _GroupSpaceMember() when $default != null:
return $default(_that.userId,_that.fullName,_that.handle,_that.role,_that.isOwner,_that.isMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupSpaceMember implements GroupSpaceMember {
  const _GroupSpaceMember({@JsonKey(defaultValue: '') required this.userId, @JsonKey(defaultValue: '') required this.fullName, this.handle, this.role = 'member', this.isOwner = false, this.isMe = false});
  factory _GroupSpaceMember.fromJson(Map<String, dynamic> json) => _$GroupSpaceMemberFromJson(json);

@override@JsonKey(defaultValue: '') final  String userId;
@override@JsonKey(defaultValue: '') final  String fullName;
@override final  String? handle;
@override@JsonKey() final  String role;
@override@JsonKey() final  bool isOwner;
@override@JsonKey() final  bool isMe;

/// Create a copy of GroupSpaceMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupSpaceMemberCopyWith<_GroupSpaceMember> get copyWith => __$GroupSpaceMemberCopyWithImpl<_GroupSpaceMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupSpaceMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupSpaceMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.role, role) || other.role == role)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.isMe, isMe) || other.isMe == isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,handle,role,isOwner,isMe);

@override
String toString() {
  return 'GroupSpaceMember(userId: $userId, fullName: $fullName, handle: $handle, role: $role, isOwner: $isOwner, isMe: $isMe)';
}


}

/// @nodoc
abstract mixin class _$GroupSpaceMemberCopyWith<$Res> implements $GroupSpaceMemberCopyWith<$Res> {
  factory _$GroupSpaceMemberCopyWith(_GroupSpaceMember value, $Res Function(_GroupSpaceMember) _then) = __$GroupSpaceMemberCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String userId,@JsonKey(defaultValue: '') String fullName, String? handle, String role, bool isOwner, bool isMe
});




}
/// @nodoc
class __$GroupSpaceMemberCopyWithImpl<$Res>
    implements _$GroupSpaceMemberCopyWith<$Res> {
  __$GroupSpaceMemberCopyWithImpl(this._self, this._then);

  final _GroupSpaceMember _self;
  final $Res Function(_GroupSpaceMember) _then;

/// Create a copy of GroupSpaceMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? role = null,Object? isOwner = null,Object? isMe = null,}) {
  return _then(_GroupSpaceMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
