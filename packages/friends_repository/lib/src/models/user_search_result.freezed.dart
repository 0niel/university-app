// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSearchResult {

 String get userId;@JsonKey(defaultValue: 'Студент') String get fullName; String? get handle; String? get group; String? get friendshipId; String? get friendshipStatus; bool get isIncoming;
/// Create a copy of UserSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSearchResultCopyWith<UserSearchResult> get copyWith => _$UserSearchResultCopyWithImpl<UserSearchResult>(this as UserSearchResult, _$identity);

  /// Serializes this UserSearchResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSearchResult&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.group, group) || other.group == group)&&(identical(other.friendshipId, friendshipId) || other.friendshipId == friendshipId)&&(identical(other.friendshipStatus, friendshipStatus) || other.friendshipStatus == friendshipStatus)&&(identical(other.isIncoming, isIncoming) || other.isIncoming == isIncoming));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,handle,group,friendshipId,friendshipStatus,isIncoming);

@override
String toString() {
  return 'UserSearchResult(userId: $userId, fullName: $fullName, handle: $handle, group: $group, friendshipId: $friendshipId, friendshipStatus: $friendshipStatus, isIncoming: $isIncoming)';
}


}

/// @nodoc
abstract mixin class $UserSearchResultCopyWith<$Res>  {
  factory $UserSearchResultCopyWith(UserSearchResult value, $Res Function(UserSearchResult) _then) = _$UserSearchResultCopyWithImpl;
@useResult
$Res call({
 String userId,@JsonKey(defaultValue: 'Студент') String fullName, String? handle, String? group, String? friendshipId, String? friendshipStatus, bool isIncoming
});




}
/// @nodoc
class _$UserSearchResultCopyWithImpl<$Res>
    implements $UserSearchResultCopyWith<$Res> {
  _$UserSearchResultCopyWithImpl(this._self, this._then);

  final UserSearchResult _self;
  final $Res Function(UserSearchResult) _then;

/// Create a copy of UserSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? group = freezed,Object? friendshipId = freezed,Object? friendshipStatus = freezed,Object? isIncoming = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,friendshipId: freezed == friendshipId ? _self.friendshipId : friendshipId // ignore: cast_nullable_to_non_nullable
as String?,friendshipStatus: freezed == friendshipStatus ? _self.friendshipStatus : friendshipStatus // ignore: cast_nullable_to_non_nullable
as String?,isIncoming: null == isIncoming ? _self.isIncoming : isIncoming // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSearchResult].
extension UserSearchResultPatterns on UserSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _UserSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _UserSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId, @JsonKey(defaultValue: 'Студент')  String fullName,  String? handle,  String? group,  String? friendshipId,  String? friendshipStatus,  bool isIncoming)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSearchResult() when $default != null:
return $default(_that.userId,_that.fullName,_that.handle,_that.group,_that.friendshipId,_that.friendshipStatus,_that.isIncoming);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId, @JsonKey(defaultValue: 'Студент')  String fullName,  String? handle,  String? group,  String? friendshipId,  String? friendshipStatus,  bool isIncoming)  $default,) {final _that = this;
switch (_that) {
case _UserSearchResult():
return $default(_that.userId,_that.fullName,_that.handle,_that.group,_that.friendshipId,_that.friendshipStatus,_that.isIncoming);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId, @JsonKey(defaultValue: 'Студент')  String fullName,  String? handle,  String? group,  String? friendshipId,  String? friendshipStatus,  bool isIncoming)?  $default,) {final _that = this;
switch (_that) {
case _UserSearchResult() when $default != null:
return $default(_that.userId,_that.fullName,_that.handle,_that.group,_that.friendshipId,_that.friendshipStatus,_that.isIncoming);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSearchResult implements UserSearchResult {
  const _UserSearchResult({required this.userId, @JsonKey(defaultValue: 'Студент') required this.fullName, this.handle, this.group, this.friendshipId, this.friendshipStatus, this.isIncoming = false});
  factory _UserSearchResult.fromJson(Map<String, dynamic> json) => _$UserSearchResultFromJson(json);

@override final  String userId;
@override@JsonKey(defaultValue: 'Студент') final  String fullName;
@override final  String? handle;
@override final  String? group;
@override final  String? friendshipId;
@override final  String? friendshipStatus;
@override@JsonKey() final  bool isIncoming;

/// Create a copy of UserSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSearchResultCopyWith<_UserSearchResult> get copyWith => __$UserSearchResultCopyWithImpl<_UserSearchResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSearchResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSearchResult&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.group, group) || other.group == group)&&(identical(other.friendshipId, friendshipId) || other.friendshipId == friendshipId)&&(identical(other.friendshipStatus, friendshipStatus) || other.friendshipStatus == friendshipStatus)&&(identical(other.isIncoming, isIncoming) || other.isIncoming == isIncoming));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,handle,group,friendshipId,friendshipStatus,isIncoming);

@override
String toString() {
  return 'UserSearchResult(userId: $userId, fullName: $fullName, handle: $handle, group: $group, friendshipId: $friendshipId, friendshipStatus: $friendshipStatus, isIncoming: $isIncoming)';
}


}

/// @nodoc
abstract mixin class _$UserSearchResultCopyWith<$Res> implements $UserSearchResultCopyWith<$Res> {
  factory _$UserSearchResultCopyWith(_UserSearchResult value, $Res Function(_UserSearchResult) _then) = __$UserSearchResultCopyWithImpl;
@override @useResult
$Res call({
 String userId,@JsonKey(defaultValue: 'Студент') String fullName, String? handle, String? group, String? friendshipId, String? friendshipStatus, bool isIncoming
});




}
/// @nodoc
class __$UserSearchResultCopyWithImpl<$Res>
    implements _$UserSearchResultCopyWith<$Res> {
  __$UserSearchResultCopyWithImpl(this._self, this._then);

  final _UserSearchResult _self;
  final $Res Function(_UserSearchResult) _then;

/// Create a copy of UserSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? group = freezed,Object? friendshipId = freezed,Object? friendshipStatus = freezed,Object? isIncoming = null,}) {
  return _then(_UserSearchResult(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,friendshipId: freezed == friendshipId ? _self.friendshipId : friendshipId // ignore: cast_nullable_to_non_nullable
as String?,friendshipStatus: freezed == friendshipStatus ? _self.friendshipStatus : friendshipStatus // ignore: cast_nullable_to_non_nullable
as String?,isIncoming: null == isIncoming ? _self.isIncoming : isIncoming // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
