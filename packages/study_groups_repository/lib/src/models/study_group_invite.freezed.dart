// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_group_invite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudyGroupInvite {

 String get id; String get groupId; String get groupName; String get groupEmoji; int get memberCount; String get invitedByName;
/// Create a copy of StudyGroupInvite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyGroupInviteCopyWith<StudyGroupInvite> get copyWith => _$StudyGroupInviteCopyWithImpl<StudyGroupInvite>(this as StudyGroupInvite, _$identity);

  /// Serializes this StudyGroupInvite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyGroupInvite&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.groupEmoji, groupEmoji) || other.groupEmoji == groupEmoji)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.invitedByName, invitedByName) || other.invitedByName == invitedByName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,groupName,groupEmoji,memberCount,invitedByName);

@override
String toString() {
  return 'StudyGroupInvite(id: $id, groupId: $groupId, groupName: $groupName, groupEmoji: $groupEmoji, memberCount: $memberCount, invitedByName: $invitedByName)';
}


}

/// @nodoc
abstract mixin class $StudyGroupInviteCopyWith<$Res>  {
  factory $StudyGroupInviteCopyWith(StudyGroupInvite value, $Res Function(StudyGroupInvite) _then) = _$StudyGroupInviteCopyWithImpl;
@useResult
$Res call({
 String id, String groupId, String groupName, String groupEmoji, int memberCount, String invitedByName
});




}
/// @nodoc
class _$StudyGroupInviteCopyWithImpl<$Res>
    implements $StudyGroupInviteCopyWith<$Res> {
  _$StudyGroupInviteCopyWithImpl(this._self, this._then);

  final StudyGroupInvite _self;
  final $Res Function(StudyGroupInvite) _then;

/// Create a copy of StudyGroupInvite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groupId = null,Object? groupName = null,Object? groupEmoji = null,Object? memberCount = null,Object? invitedByName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,groupEmoji: null == groupEmoji ? _self.groupEmoji : groupEmoji // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,invitedByName: null == invitedByName ? _self.invitedByName : invitedByName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyGroupInvite].
extension StudyGroupInvitePatterns on StudyGroupInvite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyGroupInvite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyGroupInvite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyGroupInvite value)  $default,){
final _that = this;
switch (_that) {
case _StudyGroupInvite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyGroupInvite value)?  $default,){
final _that = this;
switch (_that) {
case _StudyGroupInvite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groupId,  String groupName,  String groupEmoji,  int memberCount,  String invitedByName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyGroupInvite() when $default != null:
return $default(_that.id,_that.groupId,_that.groupName,_that.groupEmoji,_that.memberCount,_that.invitedByName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groupId,  String groupName,  String groupEmoji,  int memberCount,  String invitedByName)  $default,) {final _that = this;
switch (_that) {
case _StudyGroupInvite():
return $default(_that.id,_that.groupId,_that.groupName,_that.groupEmoji,_that.memberCount,_that.invitedByName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groupId,  String groupName,  String groupEmoji,  int memberCount,  String invitedByName)?  $default,) {final _that = this;
switch (_that) {
case _StudyGroupInvite() when $default != null:
return $default(_that.id,_that.groupId,_that.groupName,_that.groupEmoji,_that.memberCount,_that.invitedByName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyGroupInvite implements StudyGroupInvite {
  const _StudyGroupInvite({required this.id, required this.groupId, required this.groupName, this.groupEmoji = '🎓', this.memberCount = 0, this.invitedByName = ''});
  factory _StudyGroupInvite.fromJson(Map<String, dynamic> json) => _$StudyGroupInviteFromJson(json);

@override final  String id;
@override final  String groupId;
@override final  String groupName;
@override@JsonKey() final  String groupEmoji;
@override@JsonKey() final  int memberCount;
@override@JsonKey() final  String invitedByName;

/// Create a copy of StudyGroupInvite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyGroupInviteCopyWith<_StudyGroupInvite> get copyWith => __$StudyGroupInviteCopyWithImpl<_StudyGroupInvite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyGroupInviteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyGroupInvite&&(identical(other.id, id) || other.id == id)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.groupEmoji, groupEmoji) || other.groupEmoji == groupEmoji)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.invitedByName, invitedByName) || other.invitedByName == invitedByName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groupId,groupName,groupEmoji,memberCount,invitedByName);

@override
String toString() {
  return 'StudyGroupInvite(id: $id, groupId: $groupId, groupName: $groupName, groupEmoji: $groupEmoji, memberCount: $memberCount, invitedByName: $invitedByName)';
}


}

/// @nodoc
abstract mixin class _$StudyGroupInviteCopyWith<$Res> implements $StudyGroupInviteCopyWith<$Res> {
  factory _$StudyGroupInviteCopyWith(_StudyGroupInvite value, $Res Function(_StudyGroupInvite) _then) = __$StudyGroupInviteCopyWithImpl;
@override @useResult
$Res call({
 String id, String groupId, String groupName, String groupEmoji, int memberCount, String invitedByName
});




}
/// @nodoc
class __$StudyGroupInviteCopyWithImpl<$Res>
    implements _$StudyGroupInviteCopyWith<$Res> {
  __$StudyGroupInviteCopyWithImpl(this._self, this._then);

  final _StudyGroupInvite _self;
  final $Res Function(_StudyGroupInvite) _then;

/// Create a copy of StudyGroupInvite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groupId = null,Object? groupName = null,Object? groupEmoji = null,Object? memberCount = null,Object? invitedByName = null,}) {
  return _then(_StudyGroupInvite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,groupEmoji: null == groupEmoji ? _self.groupEmoji : groupEmoji // ignore: cast_nullable_to_non_nullable
as String,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,invitedByName: null == invitedByName ? _self.invitedByName : invitedByName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
