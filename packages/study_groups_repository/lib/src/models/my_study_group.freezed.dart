// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_study_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyStudyGroup {

 bool get hasGroup; bool get isOwner;@JsonKey(fromJson: _groupFromJson, toJson: _groupToJson) StudyGroup? get group;@JsonKey(fromJson: _membersFromJson, toJson: _membersToJson) List<StudyGroupMember> get members;@JsonKey(fromJson: _invitesFromJson, toJson: _invitesToJson) List<StudyGroupInvite> get incomingInvites;@JsonKey(fromJson: _requestsFromJson, toJson: _requestsToJson) List<StudyGroupJoinRequest> get pendingRequests;
/// Create a copy of MyStudyGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyStudyGroupCopyWith<MyStudyGroup> get copyWith => _$MyStudyGroupCopyWithImpl<MyStudyGroup>(this as MyStudyGroup, _$identity);

  /// Serializes this MyStudyGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyStudyGroup&&(identical(other.hasGroup, hasGroup) || other.hasGroup == hasGroup)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.group, group) || other.group == group)&&const DeepCollectionEquality().equals(other.members, members)&&const DeepCollectionEquality().equals(other.incomingInvites, incomingInvites)&&const DeepCollectionEquality().equals(other.pendingRequests, pendingRequests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasGroup,isOwner,group,const DeepCollectionEquality().hash(members),const DeepCollectionEquality().hash(incomingInvites),const DeepCollectionEquality().hash(pendingRequests));

@override
String toString() {
  return 'MyStudyGroup(hasGroup: $hasGroup, isOwner: $isOwner, group: $group, members: $members, incomingInvites: $incomingInvites, pendingRequests: $pendingRequests)';
}


}

/// @nodoc
abstract mixin class $MyStudyGroupCopyWith<$Res>  {
  factory $MyStudyGroupCopyWith(MyStudyGroup value, $Res Function(MyStudyGroup) _then) = _$MyStudyGroupCopyWithImpl;
@useResult
$Res call({
 bool hasGroup, bool isOwner,@JsonKey(fromJson: _groupFromJson, toJson: _groupToJson) StudyGroup? group,@JsonKey(fromJson: _membersFromJson, toJson: _membersToJson) List<StudyGroupMember> members,@JsonKey(fromJson: _invitesFromJson, toJson: _invitesToJson) List<StudyGroupInvite> incomingInvites,@JsonKey(fromJson: _requestsFromJson, toJson: _requestsToJson) List<StudyGroupJoinRequest> pendingRequests
});


$StudyGroupCopyWith<$Res>? get group;

}
/// @nodoc
class _$MyStudyGroupCopyWithImpl<$Res>
    implements $MyStudyGroupCopyWith<$Res> {
  _$MyStudyGroupCopyWithImpl(this._self, this._then);

  final MyStudyGroup _self;
  final $Res Function(MyStudyGroup) _then;

/// Create a copy of MyStudyGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasGroup = null,Object? isOwner = null,Object? group = freezed,Object? members = null,Object? incomingInvites = null,Object? pendingRequests = null,}) {
  return _then(_self.copyWith(
hasGroup: null == hasGroup ? _self.hasGroup : hasGroup // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as StudyGroup?,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<StudyGroupMember>,incomingInvites: null == incomingInvites ? _self.incomingInvites : incomingInvites // ignore: cast_nullable_to_non_nullable
as List<StudyGroupInvite>,pendingRequests: null == pendingRequests ? _self.pendingRequests : pendingRequests // ignore: cast_nullable_to_non_nullable
as List<StudyGroupJoinRequest>,
  ));
}
/// Create a copy of MyStudyGroup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudyGroupCopyWith<$Res>? get group {
    if (_self.group == null) {
    return null;
  }

  return $StudyGroupCopyWith<$Res>(_self.group!, (value) {
    return _then(_self.copyWith(group: value));
  });
}
}


/// Adds pattern-matching-related methods to [MyStudyGroup].
extension MyStudyGroupPatterns on MyStudyGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyStudyGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyStudyGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyStudyGroup value)  $default,){
final _that = this;
switch (_that) {
case _MyStudyGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyStudyGroup value)?  $default,){
final _that = this;
switch (_that) {
case _MyStudyGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasGroup,  bool isOwner, @JsonKey(fromJson: _groupFromJson, toJson: _groupToJson)  StudyGroup? group, @JsonKey(fromJson: _membersFromJson, toJson: _membersToJson)  List<StudyGroupMember> members, @JsonKey(fromJson: _invitesFromJson, toJson: _invitesToJson)  List<StudyGroupInvite> incomingInvites, @JsonKey(fromJson: _requestsFromJson, toJson: _requestsToJson)  List<StudyGroupJoinRequest> pendingRequests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyStudyGroup() when $default != null:
return $default(_that.hasGroup,_that.isOwner,_that.group,_that.members,_that.incomingInvites,_that.pendingRequests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasGroup,  bool isOwner, @JsonKey(fromJson: _groupFromJson, toJson: _groupToJson)  StudyGroup? group, @JsonKey(fromJson: _membersFromJson, toJson: _membersToJson)  List<StudyGroupMember> members, @JsonKey(fromJson: _invitesFromJson, toJson: _invitesToJson)  List<StudyGroupInvite> incomingInvites, @JsonKey(fromJson: _requestsFromJson, toJson: _requestsToJson)  List<StudyGroupJoinRequest> pendingRequests)  $default,) {final _that = this;
switch (_that) {
case _MyStudyGroup():
return $default(_that.hasGroup,_that.isOwner,_that.group,_that.members,_that.incomingInvites,_that.pendingRequests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasGroup,  bool isOwner, @JsonKey(fromJson: _groupFromJson, toJson: _groupToJson)  StudyGroup? group, @JsonKey(fromJson: _membersFromJson, toJson: _membersToJson)  List<StudyGroupMember> members, @JsonKey(fromJson: _invitesFromJson, toJson: _invitesToJson)  List<StudyGroupInvite> incomingInvites, @JsonKey(fromJson: _requestsFromJson, toJson: _requestsToJson)  List<StudyGroupJoinRequest> pendingRequests)?  $default,) {final _that = this;
switch (_that) {
case _MyStudyGroup() when $default != null:
return $default(_that.hasGroup,_that.isOwner,_that.group,_that.members,_that.incomingInvites,_that.pendingRequests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyStudyGroup extends MyStudyGroup {
  const _MyStudyGroup({this.hasGroup = false, this.isOwner = false, @JsonKey(fromJson: _groupFromJson, toJson: _groupToJson) this.group, @JsonKey(fromJson: _membersFromJson, toJson: _membersToJson) final  List<StudyGroupMember> members = const <StudyGroupMember>[], @JsonKey(fromJson: _invitesFromJson, toJson: _invitesToJson) final  List<StudyGroupInvite> incomingInvites = const <StudyGroupInvite>[], @JsonKey(fromJson: _requestsFromJson, toJson: _requestsToJson) final  List<StudyGroupJoinRequest> pendingRequests = const <StudyGroupJoinRequest>[]}): _members = members,_incomingInvites = incomingInvites,_pendingRequests = pendingRequests,super._();
  factory _MyStudyGroup.fromJson(Map<String, dynamic> json) => _$MyStudyGroupFromJson(json);

@override@JsonKey() final  bool hasGroup;
@override@JsonKey() final  bool isOwner;
@override@JsonKey(fromJson: _groupFromJson, toJson: _groupToJson) final  StudyGroup? group;
 final  List<StudyGroupMember> _members;
@override@JsonKey(fromJson: _membersFromJson, toJson: _membersToJson) List<StudyGroupMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<StudyGroupInvite> _incomingInvites;
@override@JsonKey(fromJson: _invitesFromJson, toJson: _invitesToJson) List<StudyGroupInvite> get incomingInvites {
  if (_incomingInvites is EqualUnmodifiableListView) return _incomingInvites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomingInvites);
}

 final  List<StudyGroupJoinRequest> _pendingRequests;
@override@JsonKey(fromJson: _requestsFromJson, toJson: _requestsToJson) List<StudyGroupJoinRequest> get pendingRequests {
  if (_pendingRequests is EqualUnmodifiableListView) return _pendingRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingRequests);
}


/// Create a copy of MyStudyGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyStudyGroupCopyWith<_MyStudyGroup> get copyWith => __$MyStudyGroupCopyWithImpl<_MyStudyGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyStudyGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyStudyGroup&&(identical(other.hasGroup, hasGroup) || other.hasGroup == hasGroup)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.group, group) || other.group == group)&&const DeepCollectionEquality().equals(other._members, _members)&&const DeepCollectionEquality().equals(other._incomingInvites, _incomingInvites)&&const DeepCollectionEquality().equals(other._pendingRequests, _pendingRequests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasGroup,isOwner,group,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_incomingInvites),const DeepCollectionEquality().hash(_pendingRequests));

@override
String toString() {
  return 'MyStudyGroup(hasGroup: $hasGroup, isOwner: $isOwner, group: $group, members: $members, incomingInvites: $incomingInvites, pendingRequests: $pendingRequests)';
}


}

/// @nodoc
abstract mixin class _$MyStudyGroupCopyWith<$Res> implements $MyStudyGroupCopyWith<$Res> {
  factory _$MyStudyGroupCopyWith(_MyStudyGroup value, $Res Function(_MyStudyGroup) _then) = __$MyStudyGroupCopyWithImpl;
@override @useResult
$Res call({
 bool hasGroup, bool isOwner,@JsonKey(fromJson: _groupFromJson, toJson: _groupToJson) StudyGroup? group,@JsonKey(fromJson: _membersFromJson, toJson: _membersToJson) List<StudyGroupMember> members,@JsonKey(fromJson: _invitesFromJson, toJson: _invitesToJson) List<StudyGroupInvite> incomingInvites,@JsonKey(fromJson: _requestsFromJson, toJson: _requestsToJson) List<StudyGroupJoinRequest> pendingRequests
});


@override $StudyGroupCopyWith<$Res>? get group;

}
/// @nodoc
class __$MyStudyGroupCopyWithImpl<$Res>
    implements _$MyStudyGroupCopyWith<$Res> {
  __$MyStudyGroupCopyWithImpl(this._self, this._then);

  final _MyStudyGroup _self;
  final $Res Function(_MyStudyGroup) _then;

/// Create a copy of MyStudyGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasGroup = null,Object? isOwner = null,Object? group = freezed,Object? members = null,Object? incomingInvites = null,Object? pendingRequests = null,}) {
  return _then(_MyStudyGroup(
hasGroup: null == hasGroup ? _self.hasGroup : hasGroup // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as StudyGroup?,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<StudyGroupMember>,incomingInvites: null == incomingInvites ? _self._incomingInvites : incomingInvites // ignore: cast_nullable_to_non_nullable
as List<StudyGroupInvite>,pendingRequests: null == pendingRequests ? _self._pendingRequests : pendingRequests // ignore: cast_nullable_to_non_nullable
as List<StudyGroupJoinRequest>,
  ));
}

/// Create a copy of MyStudyGroup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudyGroupCopyWith<$Res>? get group {
    if (_self.group == null) {
    return null;
  }

  return $StudyGroupCopyWith<$Res>(_self.group!, (value) {
    return _then(_self.copyWith(group: value));
  });
}
}

// dart format on
