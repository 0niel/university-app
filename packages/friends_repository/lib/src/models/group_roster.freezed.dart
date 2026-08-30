// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_roster.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupRoster {

 String? get group; List<GroupMember> get members;
/// Create a copy of GroupRoster
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupRosterCopyWith<GroupRoster> get copyWith => _$GroupRosterCopyWithImpl<GroupRoster>(this as GroupRoster, _$identity);

  /// Serializes this GroupRoster to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupRoster&&(identical(other.group, group) || other.group == group)&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,group,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'GroupRoster(group: $group, members: $members)';
}


}

/// @nodoc
abstract mixin class $GroupRosterCopyWith<$Res>  {
  factory $GroupRosterCopyWith(GroupRoster value, $Res Function(GroupRoster) _then) = _$GroupRosterCopyWithImpl;
@useResult
$Res call({
 String? group, List<GroupMember> members
});




}
/// @nodoc
class _$GroupRosterCopyWithImpl<$Res>
    implements $GroupRosterCopyWith<$Res> {
  _$GroupRosterCopyWithImpl(this._self, this._then);

  final GroupRoster _self;
  final $Res Function(GroupRoster) _then;

/// Create a copy of GroupRoster
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? group = freezed,Object? members = null,}) {
  return _then(_self.copyWith(
group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<GroupMember>,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupRoster].
extension GroupRosterPatterns on GroupRoster {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupRoster value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupRoster() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupRoster value)  $default,){
final _that = this;
switch (_that) {
case _GroupRoster():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupRoster value)?  $default,){
final _that = this;
switch (_that) {
case _GroupRoster() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? group,  List<GroupMember> members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupRoster() when $default != null:
return $default(_that.group,_that.members);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? group,  List<GroupMember> members)  $default,) {final _that = this;
switch (_that) {
case _GroupRoster():
return $default(_that.group,_that.members);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? group,  List<GroupMember> members)?  $default,) {final _that = this;
switch (_that) {
case _GroupRoster() when $default != null:
return $default(_that.group,_that.members);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GroupRoster implements GroupRoster {
  const _GroupRoster({this.group, final  List<GroupMember> members = const <GroupMember>[]}): _members = members;
  factory _GroupRoster.fromJson(Map<String, dynamic> json) => _$GroupRosterFromJson(json);

@override final  String? group;
 final  List<GroupMember> _members;
@override@JsonKey() List<GroupMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}


/// Create a copy of GroupRoster
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupRosterCopyWith<_GroupRoster> get copyWith => __$GroupRosterCopyWithImpl<_GroupRoster>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupRosterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupRoster&&(identical(other.group, group) || other.group == group)&&const DeepCollectionEquality().equals(other._members, _members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,group,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'GroupRoster(group: $group, members: $members)';
}


}

/// @nodoc
abstract mixin class _$GroupRosterCopyWith<$Res> implements $GroupRosterCopyWith<$Res> {
  factory _$GroupRosterCopyWith(_GroupRoster value, $Res Function(_GroupRoster) _then) = __$GroupRosterCopyWithImpl;
@override @useResult
$Res call({
 String? group, List<GroupMember> members
});




}
/// @nodoc
class __$GroupRosterCopyWithImpl<$Res>
    implements _$GroupRosterCopyWith<$Res> {
  __$GroupRosterCopyWithImpl(this._self, this._then);

  final _GroupRoster _self;
  final $Res Function(_GroupRoster) _then;

/// Create a copy of GroupRoster
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? group = freezed,Object? members = null,}) {
  return _then(_GroupRoster(
group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<GroupMember>,
  ));
}


}

// dart format on
