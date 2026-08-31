// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_announcement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupAnnouncement {

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get title;@JsonKey(defaultValue: '') String get body;@JsonKey(defaultValue: '') String get authorName;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt; bool get isMine;
/// Create a copy of GroupAnnouncement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupAnnouncementCopyWith<GroupAnnouncement> get copyWith => _$GroupAnnouncementCopyWithImpl<GroupAnnouncement>(this as GroupAnnouncement, _$identity);

  /// Serializes this GroupAnnouncement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupAnnouncement&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,authorName,createdAt,isMine);

@override
String toString() {
  return 'GroupAnnouncement(id: $id, title: $title, body: $body, authorName: $authorName, createdAt: $createdAt, isMine: $isMine)';
}


}

/// @nodoc
abstract mixin class $GroupAnnouncementCopyWith<$Res>  {
  factory $GroupAnnouncementCopyWith(GroupAnnouncement value, $Res Function(GroupAnnouncement) _then) = _$GroupAnnouncementCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title,@JsonKey(defaultValue: '') String body,@JsonKey(defaultValue: '') String authorName,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isMine
});




}
/// @nodoc
class _$GroupAnnouncementCopyWithImpl<$Res>
    implements $GroupAnnouncementCopyWith<$Res> {
  _$GroupAnnouncementCopyWithImpl(this._self, this._then);

  final GroupAnnouncement _self;
  final $Res Function(GroupAnnouncement) _then;

/// Create a copy of GroupAnnouncement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? authorName = null,Object? createdAt = freezed,Object? isMine = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupAnnouncement].
extension GroupAnnouncementPatterns on GroupAnnouncement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupAnnouncement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupAnnouncement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupAnnouncement value)  $default,){
final _that = this;
switch (_that) {
case _GroupAnnouncement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupAnnouncement value)?  $default,){
final _that = this;
switch (_that) {
case _GroupAnnouncement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title, @JsonKey(defaultValue: '')  String body, @JsonKey(defaultValue: '')  String authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupAnnouncement() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.authorName,_that.createdAt,_that.isMine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title, @JsonKey(defaultValue: '')  String body, @JsonKey(defaultValue: '')  String authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine)  $default,) {final _that = this;
switch (_that) {
case _GroupAnnouncement():
return $default(_that.id,_that.title,_that.body,_that.authorName,_that.createdAt,_that.isMine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title, @JsonKey(defaultValue: '')  String body, @JsonKey(defaultValue: '')  String authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isMine)?  $default,) {final _that = this;
switch (_that) {
case _GroupAnnouncement() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.authorName,_that.createdAt,_that.isMine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupAnnouncement implements GroupAnnouncement {
  const _GroupAnnouncement({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.title, @JsonKey(defaultValue: '') required this.body, @JsonKey(defaultValue: '') required this.authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt, this.isMine = false});
  factory _GroupAnnouncement.fromJson(Map<String, dynamic> json) => _$GroupAnnouncementFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String title;
@override@JsonKey(defaultValue: '') final  String body;
@override@JsonKey(defaultValue: '') final  String authorName;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey() final  bool isMine;

/// Create a copy of GroupAnnouncement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupAnnouncementCopyWith<_GroupAnnouncement> get copyWith => __$GroupAnnouncementCopyWithImpl<_GroupAnnouncement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupAnnouncementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupAnnouncement&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isMine, isMine) || other.isMine == isMine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,authorName,createdAt,isMine);

@override
String toString() {
  return 'GroupAnnouncement(id: $id, title: $title, body: $body, authorName: $authorName, createdAt: $createdAt, isMine: $isMine)';
}


}

/// @nodoc
abstract mixin class _$GroupAnnouncementCopyWith<$Res> implements $GroupAnnouncementCopyWith<$Res> {
  factory _$GroupAnnouncementCopyWith(_GroupAnnouncement value, $Res Function(_GroupAnnouncement) _then) = __$GroupAnnouncementCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title,@JsonKey(defaultValue: '') String body,@JsonKey(defaultValue: '') String authorName,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isMine
});




}
/// @nodoc
class __$GroupAnnouncementCopyWithImpl<$Res>
    implements _$GroupAnnouncementCopyWith<$Res> {
  __$GroupAnnouncementCopyWithImpl(this._self, this._then);

  final _GroupAnnouncement _self;
  final $Res Function(_GroupAnnouncement) _then;

/// Create a copy of GroupAnnouncement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? authorName = null,Object? createdAt = freezed,Object? isMine = null,}) {
  return _then(_GroupAnnouncement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
