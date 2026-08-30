// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggested_friend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SuggestedFriend {

 String get userId;@JsonKey(defaultValue: 'Студент') String get fullName; String? get handle; String? get group; int get mutualCount;
/// Create a copy of SuggestedFriend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuggestedFriendCopyWith<SuggestedFriend> get copyWith => _$SuggestedFriendCopyWithImpl<SuggestedFriend>(this as SuggestedFriend, _$identity);

  /// Serializes this SuggestedFriend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuggestedFriend&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.group, group) || other.group == group)&&(identical(other.mutualCount, mutualCount) || other.mutualCount == mutualCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,handle,group,mutualCount);

@override
String toString() {
  return 'SuggestedFriend(userId: $userId, fullName: $fullName, handle: $handle, group: $group, mutualCount: $mutualCount)';
}


}

/// @nodoc
abstract mixin class $SuggestedFriendCopyWith<$Res>  {
  factory $SuggestedFriendCopyWith(SuggestedFriend value, $Res Function(SuggestedFriend) _then) = _$SuggestedFriendCopyWithImpl;
@useResult
$Res call({
 String userId,@JsonKey(defaultValue: 'Студент') String fullName, String? handle, String? group, int mutualCount
});




}
/// @nodoc
class _$SuggestedFriendCopyWithImpl<$Res>
    implements $SuggestedFriendCopyWith<$Res> {
  _$SuggestedFriendCopyWithImpl(this._self, this._then);

  final SuggestedFriend _self;
  final $Res Function(SuggestedFriend) _then;

/// Create a copy of SuggestedFriend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? group = freezed,Object? mutualCount = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,mutualCount: null == mutualCount ? _self.mutualCount : mutualCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SuggestedFriend].
extension SuggestedFriendPatterns on SuggestedFriend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuggestedFriend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuggestedFriend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuggestedFriend value)  $default,){
final _that = this;
switch (_that) {
case _SuggestedFriend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuggestedFriend value)?  $default,){
final _that = this;
switch (_that) {
case _SuggestedFriend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId, @JsonKey(defaultValue: 'Студент')  String fullName,  String? handle,  String? group,  int mutualCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuggestedFriend() when $default != null:
return $default(_that.userId,_that.fullName,_that.handle,_that.group,_that.mutualCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId, @JsonKey(defaultValue: 'Студент')  String fullName,  String? handle,  String? group,  int mutualCount)  $default,) {final _that = this;
switch (_that) {
case _SuggestedFriend():
return $default(_that.userId,_that.fullName,_that.handle,_that.group,_that.mutualCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId, @JsonKey(defaultValue: 'Студент')  String fullName,  String? handle,  String? group,  int mutualCount)?  $default,) {final _that = this;
switch (_that) {
case _SuggestedFriend() when $default != null:
return $default(_that.userId,_that.fullName,_that.handle,_that.group,_that.mutualCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SuggestedFriend implements SuggestedFriend {
  const _SuggestedFriend({required this.userId, @JsonKey(defaultValue: 'Студент') required this.fullName, this.handle, this.group, this.mutualCount = 0});
  factory _SuggestedFriend.fromJson(Map<String, dynamic> json) => _$SuggestedFriendFromJson(json);

@override final  String userId;
@override@JsonKey(defaultValue: 'Студент') final  String fullName;
@override final  String? handle;
@override final  String? group;
@override@JsonKey() final  int mutualCount;

/// Create a copy of SuggestedFriend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuggestedFriendCopyWith<_SuggestedFriend> get copyWith => __$SuggestedFriendCopyWithImpl<_SuggestedFriend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuggestedFriendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuggestedFriend&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.group, group) || other.group == group)&&(identical(other.mutualCount, mutualCount) || other.mutualCount == mutualCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,handle,group,mutualCount);

@override
String toString() {
  return 'SuggestedFriend(userId: $userId, fullName: $fullName, handle: $handle, group: $group, mutualCount: $mutualCount)';
}


}

/// @nodoc
abstract mixin class _$SuggestedFriendCopyWith<$Res> implements $SuggestedFriendCopyWith<$Res> {
  factory _$SuggestedFriendCopyWith(_SuggestedFriend value, $Res Function(_SuggestedFriend) _then) = __$SuggestedFriendCopyWithImpl;
@override @useResult
$Res call({
 String userId,@JsonKey(defaultValue: 'Студент') String fullName, String? handle, String? group, int mutualCount
});




}
/// @nodoc
class __$SuggestedFriendCopyWithImpl<$Res>
    implements _$SuggestedFriendCopyWith<$Res> {
  __$SuggestedFriendCopyWithImpl(this._self, this._then);

  final _SuggestedFriend _self;
  final $Res Function(_SuggestedFriend) _then;

/// Create a copy of SuggestedFriend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? group = freezed,Object? mutualCount = null,}) {
  return _then(_SuggestedFriend(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,mutualCount: null == mutualCount ? _self.mutualCount : mutualCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
