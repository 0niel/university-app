// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_space.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupSpace {

 String? get group; String get emoji;@JsonKey(readValue: _readHasGroup) bool get hasGroup; bool get isOwner; int get memberCount;@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get memberNames;@JsonKey(fromJson: _linksFromJson, toJson: _linksToJson) List<GroupLink> get links;@JsonKey(fromJson: _announcementFromJson, toJson: _announcementToJson) GroupAnnouncement? get announcement;@JsonKey(fromJson: _notesFromJson, toJson: _notesToJson) List<GroupNote> get notes;@JsonKey(fromJson: _birthdaysFromJson, toJson: _birthdaysToJson) List<GroupBirthday> get birthdays;
/// Create a copy of GroupSpace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupSpaceCopyWith<GroupSpace> get copyWith => _$GroupSpaceCopyWithImpl<GroupSpace>(this as GroupSpace, _$identity);

  /// Serializes this GroupSpace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupSpace&&(identical(other.group, group) || other.group == group)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.hasGroup, hasGroup) || other.hasGroup == hasGroup)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other.memberNames, memberNames)&&const DeepCollectionEquality().equals(other.links, links)&&(identical(other.announcement, announcement) || other.announcement == announcement)&&const DeepCollectionEquality().equals(other.notes, notes)&&const DeepCollectionEquality().equals(other.birthdays, birthdays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,group,emoji,hasGroup,isOwner,memberCount,const DeepCollectionEquality().hash(memberNames),const DeepCollectionEquality().hash(links),announcement,const DeepCollectionEquality().hash(notes),const DeepCollectionEquality().hash(birthdays));

@override
String toString() {
  return 'GroupSpace(group: $group, emoji: $emoji, hasGroup: $hasGroup, isOwner: $isOwner, memberCount: $memberCount, memberNames: $memberNames, links: $links, announcement: $announcement, notes: $notes, birthdays: $birthdays)';
}


}

/// @nodoc
abstract mixin class $GroupSpaceCopyWith<$Res>  {
  factory $GroupSpaceCopyWith(GroupSpace value, $Res Function(GroupSpace) _then) = _$GroupSpaceCopyWithImpl;
@useResult
$Res call({
 String? group, String emoji,@JsonKey(readValue: _readHasGroup) bool hasGroup, bool isOwner, int memberCount,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> memberNames,@JsonKey(fromJson: _linksFromJson, toJson: _linksToJson) List<GroupLink> links,@JsonKey(fromJson: _announcementFromJson, toJson: _announcementToJson) GroupAnnouncement? announcement,@JsonKey(fromJson: _notesFromJson, toJson: _notesToJson) List<GroupNote> notes,@JsonKey(fromJson: _birthdaysFromJson, toJson: _birthdaysToJson) List<GroupBirthday> birthdays
});


$GroupAnnouncementCopyWith<$Res>? get announcement;

}
/// @nodoc
class _$GroupSpaceCopyWithImpl<$Res>
    implements $GroupSpaceCopyWith<$Res> {
  _$GroupSpaceCopyWithImpl(this._self, this._then);

  final GroupSpace _self;
  final $Res Function(GroupSpace) _then;

/// Create a copy of GroupSpace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? group = freezed,Object? emoji = null,Object? hasGroup = null,Object? isOwner = null,Object? memberCount = null,Object? memberNames = null,Object? links = null,Object? announcement = freezed,Object? notes = null,Object? birthdays = null,}) {
  return _then(_self.copyWith(
group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,hasGroup: null == hasGroup ? _self.hasGroup : hasGroup // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,memberNames: null == memberNames ? _self.memberNames : memberNames // ignore: cast_nullable_to_non_nullable
as List<String>,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<GroupLink>,announcement: freezed == announcement ? _self.announcement : announcement // ignore: cast_nullable_to_non_nullable
as GroupAnnouncement?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<GroupNote>,birthdays: null == birthdays ? _self.birthdays : birthdays // ignore: cast_nullable_to_non_nullable
as List<GroupBirthday>,
  ));
}
/// Create a copy of GroupSpace
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupAnnouncementCopyWith<$Res>? get announcement {
    if (_self.announcement == null) {
    return null;
  }

  return $GroupAnnouncementCopyWith<$Res>(_self.announcement!, (value) {
    return _then(_self.copyWith(announcement: value));
  });
}
}


/// Adds pattern-matching-related methods to [GroupSpace].
extension GroupSpacePatterns on GroupSpace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupSpace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupSpace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupSpace value)  $default,){
final _that = this;
switch (_that) {
case _GroupSpace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupSpace value)?  $default,){
final _that = this;
switch (_that) {
case _GroupSpace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? group,  String emoji, @JsonKey(readValue: _readHasGroup)  bool hasGroup,  bool isOwner,  int memberCount, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> memberNames, @JsonKey(fromJson: _linksFromJson, toJson: _linksToJson)  List<GroupLink> links, @JsonKey(fromJson: _announcementFromJson, toJson: _announcementToJson)  GroupAnnouncement? announcement, @JsonKey(fromJson: _notesFromJson, toJson: _notesToJson)  List<GroupNote> notes, @JsonKey(fromJson: _birthdaysFromJson, toJson: _birthdaysToJson)  List<GroupBirthday> birthdays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupSpace() when $default != null:
return $default(_that.group,_that.emoji,_that.hasGroup,_that.isOwner,_that.memberCount,_that.memberNames,_that.links,_that.announcement,_that.notes,_that.birthdays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? group,  String emoji, @JsonKey(readValue: _readHasGroup)  bool hasGroup,  bool isOwner,  int memberCount, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> memberNames, @JsonKey(fromJson: _linksFromJson, toJson: _linksToJson)  List<GroupLink> links, @JsonKey(fromJson: _announcementFromJson, toJson: _announcementToJson)  GroupAnnouncement? announcement, @JsonKey(fromJson: _notesFromJson, toJson: _notesToJson)  List<GroupNote> notes, @JsonKey(fromJson: _birthdaysFromJson, toJson: _birthdaysToJson)  List<GroupBirthday> birthdays)  $default,) {final _that = this;
switch (_that) {
case _GroupSpace():
return $default(_that.group,_that.emoji,_that.hasGroup,_that.isOwner,_that.memberCount,_that.memberNames,_that.links,_that.announcement,_that.notes,_that.birthdays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? group,  String emoji, @JsonKey(readValue: _readHasGroup)  bool hasGroup,  bool isOwner,  int memberCount, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> memberNames, @JsonKey(fromJson: _linksFromJson, toJson: _linksToJson)  List<GroupLink> links, @JsonKey(fromJson: _announcementFromJson, toJson: _announcementToJson)  GroupAnnouncement? announcement, @JsonKey(fromJson: _notesFromJson, toJson: _notesToJson)  List<GroupNote> notes, @JsonKey(fromJson: _birthdaysFromJson, toJson: _birthdaysToJson)  List<GroupBirthday> birthdays)?  $default,) {final _that = this;
switch (_that) {
case _GroupSpace() when $default != null:
return $default(_that.group,_that.emoji,_that.hasGroup,_that.isOwner,_that.memberCount,_that.memberNames,_that.links,_that.announcement,_that.notes,_that.birthdays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupSpace extends GroupSpace {
  const _GroupSpace({this.group, this.emoji = '🎓', @JsonKey(readValue: _readHasGroup) this.hasGroup = false, this.isOwner = false, this.memberCount = 0, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) final  List<String> memberNames = const <String>[], @JsonKey(fromJson: _linksFromJson, toJson: _linksToJson) final  List<GroupLink> links = const <GroupLink>[], @JsonKey(fromJson: _announcementFromJson, toJson: _announcementToJson) this.announcement, @JsonKey(fromJson: _notesFromJson, toJson: _notesToJson) final  List<GroupNote> notes = const <GroupNote>[], @JsonKey(fromJson: _birthdaysFromJson, toJson: _birthdaysToJson) final  List<GroupBirthday> birthdays = const <GroupBirthday>[]}): _memberNames = memberNames,_links = links,_notes = notes,_birthdays = birthdays,super._();
  factory _GroupSpace.fromJson(Map<String, dynamic> json) => _$GroupSpaceFromJson(json);

@override final  String? group;
@override@JsonKey() final  String emoji;
@override@JsonKey(readValue: _readHasGroup) final  bool hasGroup;
@override@JsonKey() final  bool isOwner;
@override@JsonKey() final  int memberCount;
 final  List<String> _memberNames;
@override@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get memberNames {
  if (_memberNames is EqualUnmodifiableListView) return _memberNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberNames);
}

 final  List<GroupLink> _links;
@override@JsonKey(fromJson: _linksFromJson, toJson: _linksToJson) List<GroupLink> get links {
  if (_links is EqualUnmodifiableListView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_links);
}

@override@JsonKey(fromJson: _announcementFromJson, toJson: _announcementToJson) final  GroupAnnouncement? announcement;
 final  List<GroupNote> _notes;
@override@JsonKey(fromJson: _notesFromJson, toJson: _notesToJson) List<GroupNote> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}

 final  List<GroupBirthday> _birthdays;
@override@JsonKey(fromJson: _birthdaysFromJson, toJson: _birthdaysToJson) List<GroupBirthday> get birthdays {
  if (_birthdays is EqualUnmodifiableListView) return _birthdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_birthdays);
}


/// Create a copy of GroupSpace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupSpaceCopyWith<_GroupSpace> get copyWith => __$GroupSpaceCopyWithImpl<_GroupSpace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupSpaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupSpace&&(identical(other.group, group) || other.group == group)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.hasGroup, hasGroup) || other.hasGroup == hasGroup)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&const DeepCollectionEquality().equals(other._memberNames, _memberNames)&&const DeepCollectionEquality().equals(other._links, _links)&&(identical(other.announcement, announcement) || other.announcement == announcement)&&const DeepCollectionEquality().equals(other._notes, _notes)&&const DeepCollectionEquality().equals(other._birthdays, _birthdays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,group,emoji,hasGroup,isOwner,memberCount,const DeepCollectionEquality().hash(_memberNames),const DeepCollectionEquality().hash(_links),announcement,const DeepCollectionEquality().hash(_notes),const DeepCollectionEquality().hash(_birthdays));

@override
String toString() {
  return 'GroupSpace(group: $group, emoji: $emoji, hasGroup: $hasGroup, isOwner: $isOwner, memberCount: $memberCount, memberNames: $memberNames, links: $links, announcement: $announcement, notes: $notes, birthdays: $birthdays)';
}


}

/// @nodoc
abstract mixin class _$GroupSpaceCopyWith<$Res> implements $GroupSpaceCopyWith<$Res> {
  factory _$GroupSpaceCopyWith(_GroupSpace value, $Res Function(_GroupSpace) _then) = __$GroupSpaceCopyWithImpl;
@override @useResult
$Res call({
 String? group, String emoji,@JsonKey(readValue: _readHasGroup) bool hasGroup, bool isOwner, int memberCount,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> memberNames,@JsonKey(fromJson: _linksFromJson, toJson: _linksToJson) List<GroupLink> links,@JsonKey(fromJson: _announcementFromJson, toJson: _announcementToJson) GroupAnnouncement? announcement,@JsonKey(fromJson: _notesFromJson, toJson: _notesToJson) List<GroupNote> notes,@JsonKey(fromJson: _birthdaysFromJson, toJson: _birthdaysToJson) List<GroupBirthday> birthdays
});


@override $GroupAnnouncementCopyWith<$Res>? get announcement;

}
/// @nodoc
class __$GroupSpaceCopyWithImpl<$Res>
    implements _$GroupSpaceCopyWith<$Res> {
  __$GroupSpaceCopyWithImpl(this._self, this._then);

  final _GroupSpace _self;
  final $Res Function(_GroupSpace) _then;

/// Create a copy of GroupSpace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? group = freezed,Object? emoji = null,Object? hasGroup = null,Object? isOwner = null,Object? memberCount = null,Object? memberNames = null,Object? links = null,Object? announcement = freezed,Object? notes = null,Object? birthdays = null,}) {
  return _then(_GroupSpace(
group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,hasGroup: null == hasGroup ? _self.hasGroup : hasGroup // ignore: cast_nullable_to_non_nullable
as bool,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,memberNames: null == memberNames ? _self._memberNames : memberNames // ignore: cast_nullable_to_non_nullable
as List<String>,links: null == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as List<GroupLink>,announcement: freezed == announcement ? _self.announcement : announcement // ignore: cast_nullable_to_non_nullable
as GroupAnnouncement?,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<GroupNote>,birthdays: null == birthdays ? _self._birthdays : birthdays // ignore: cast_nullable_to_non_nullable
as List<GroupBirthday>,
  ));
}

/// Create a copy of GroupSpace
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupAnnouncementCopyWith<$Res>? get announcement {
    if (_self.announcement == null) {
    return null;
  }

  return $GroupAnnouncementCopyWith<$Res>(_self.announcement!, (value) {
    return _then(_self.copyWith(announcement: value));
  });
}
}

// dart format on
