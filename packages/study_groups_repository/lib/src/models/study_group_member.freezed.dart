// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_group_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudyGroupMember {

 String get userId; String get fullName; String? get handle; String get role; bool get isOwner; bool get isMe; bool get isFriend; String? get friendshipStatus;
/// Create a copy of StudyGroupMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyGroupMemberCopyWith<StudyGroupMember> get copyWith => _$StudyGroupMemberCopyWithImpl<StudyGroupMember>(this as StudyGroupMember, _$identity);

  /// Serializes this StudyGroupMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyGroupMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.role, role) || other.role == role)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.isFriend, isFriend) || other.isFriend == isFriend)&&(identical(other.friendshipStatus, friendshipStatus) || other.friendshipStatus == friendshipStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,handle,role,isOwner,isMe,isFriend,friendshipStatus);

@override
String toString() {
  return 'StudyGroupMember(userId: $userId, fullName: $fullName, handle: $handle, role: $role, isOwner: $isOwner, isMe: $isMe, isFriend: $isFriend, friendshipStatus: $friendshipStatus)';
}


}

/// @nodoc
abstract mixin class $StudyGroupMemberCopyWith<$Res>  {
  factory $StudyGroupMemberCopyWith(StudyGroupMember value, $Res Function(StudyGroupMember) _then) = _$StudyGroupMemberCopyWithImpl;
@useResult
$Res call({
 String userId, String fullName, String? handle, String role, bool isOwner, bool isMe, bool isFriend, String? friendshipStatus
});




}
/// @nodoc
class _$StudyGroupMemberCopyWithImpl<$Res>
    implements $StudyGroupMemberCopyWith<$Res> {
  _$StudyGroupMemberCopyWithImpl(this._self, this._then);

  final StudyGroupMember _self;
  final $Res Function(StudyGroupMember) _then;

/// Create a copy of StudyGroupMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? role = null,Object? isOwner = null,Object? isMe = null,Object? isFriend = null,Object? friendshipStatus = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,isFriend: null == isFriend ? _self.isFriend : isFriend // ignore: cast_nullable_to_non_nullable
as bool,friendshipStatus: freezed == friendshipStatus ? _self.friendshipStatus : friendshipStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyGroupMember].
extension StudyGroupMemberPatterns on StudyGroupMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyGroupMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyGroupMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyGroupMember value)  $default,){
final _that = this;
switch (_that) {
case _StudyGroupMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyGroupMember value)?  $default,){
final _that = this;
switch (_that) {
case _StudyGroupMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String fullName,  String? handle,  String role,  bool isOwner,  bool isMe,  bool isFriend,  String? friendshipStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyGroupMember() when $default != null:
return $default(_that.userId,_that.fullName,_that.handle,_that.role,_that.isOwner,_that.isMe,_that.isFriend,_that.friendshipStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String fullName,  String? handle,  String role,  bool isOwner,  bool isMe,  bool isFriend,  String? friendshipStatus)  $default,) {final _that = this;
switch (_that) {
case _StudyGroupMember():
return $default(_that.userId,_that.fullName,_that.handle,_that.role,_that.isOwner,_that.isMe,_that.isFriend,_that.friendshipStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String fullName,  String? handle,  String role,  bool isOwner,  bool isMe,  bool isFriend,  String? friendshipStatus)?  $default,) {final _that = this;
switch (_that) {
case _StudyGroupMember() when $default != null:
return $default(_that.userId,_that.fullName,_that.handle,_that.role,_that.isOwner,_that.isMe,_that.isFriend,_that.friendshipStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyGroupMember implements StudyGroupMember {
  const _StudyGroupMember({required this.userId, required this.fullName, this.handle, this.role = 'member', this.isOwner = false, this.isMe = false, this.isFriend = false, this.friendshipStatus});
  factory _StudyGroupMember.fromJson(Map<String, dynamic> json) => _$StudyGroupMemberFromJson(json);

@override final  String userId;
@override final  String fullName;
@override final  String? handle;
@override@JsonKey() final  String role;
@override@JsonKey() final  bool isOwner;
@override@JsonKey() final  bool isMe;
@override@JsonKey() final  bool isFriend;
@override final  String? friendshipStatus;

/// Create a copy of StudyGroupMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyGroupMemberCopyWith<_StudyGroupMember> get copyWith => __$StudyGroupMemberCopyWithImpl<_StudyGroupMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyGroupMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyGroupMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.role, role) || other.role == role)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.isFriend, isFriend) || other.isFriend == isFriend)&&(identical(other.friendshipStatus, friendshipStatus) || other.friendshipStatus == friendshipStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,handle,role,isOwner,isMe,isFriend,friendshipStatus);

@override
String toString() {
  return 'StudyGroupMember(userId: $userId, fullName: $fullName, handle: $handle, role: $role, isOwner: $isOwner, isMe: $isMe, isFriend: $isFriend, friendshipStatus: $friendshipStatus)';
}


}

/// @nodoc
abstract mixin class _$StudyGroupMemberCopyWith<$Res> implements $StudyGroupMemberCopyWith<$Res> {
  factory _$StudyGroupMemberCopyWith(_StudyGroupMember value, $Res Function(_StudyGroupMember) _then) = __$StudyGroupMemberCopyWithImpl;
@override @useResult
$Res call({
 String userId, String fullName, String? handle, String role, bool isOwner, bool isMe, bool isFriend, String? friendshipStatus
});




}
/// @nodoc
class __$StudyGroupMemberCopyWithImpl<$Res>
    implements _$StudyGroupMemberCopyWith<$Res> {
  __$StudyGroupMemberCopyWithImpl(this._self, this._then);

  final _StudyGroupMember _self;
  final $Res Function(_StudyGroupMember) _then;

/// Create a copy of StudyGroupMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? role = null,Object? isOwner = null,Object? isMe = null,Object? isFriend = null,Object? friendshipStatus = freezed,}) {
  return _then(_StudyGroupMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,isFriend: null == isFriend ? _self.isFriend : isFriend // ignore: cast_nullable_to_non_nullable
as bool,friendshipStatus: freezed == friendshipStatus ? _self.friendshipStatus : friendshipStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
