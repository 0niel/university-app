// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupNote {

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get title;@JsonKey(defaultValue: '') String get authorName; String get body;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt; bool get isPinned; bool get isMine; int get likes; bool get likedByMe; int get commentsCount;
/// Create a copy of GroupNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupNoteCopyWith<GroupNote> get copyWith => _$GroupNoteCopyWithImpl<GroupNote>(this as GroupNote, _$identity);

  /// Serializes this GroupNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupNote&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.likedByMe, likedByMe) || other.likedByMe == likedByMe)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,authorName,body,createdAt,isPinned,isMine,likes,likedByMe,commentsCount);

@override
String toString() {
  return 'GroupNote(id: $id, title: $title, authorName: $authorName, body: $body, createdAt: $createdAt, isPinned: $isPinned, isMine: $isMine, likes: $likes, likedByMe: $likedByMe, commentsCount: $commentsCount)';
}


}

/// @nodoc
abstract mixin class $GroupNoteCopyWith<$Res>  {
  factory $GroupNoteCopyWith(GroupNote value, $Res Function(GroupNote) _then) = _$GroupNoteCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title,@JsonKey(defaultValue: '') String authorName, String body,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isPinned, bool isMine, int likes, bool likedByMe, int commentsCount
});




}
/// @nodoc
class _$GroupNoteCopyWithImpl<$Res>
    implements $GroupNoteCopyWith<$Res> {
  _$GroupNoteCopyWithImpl(this._self, this._then);

  final GroupNote _self;
  final $Res Function(GroupNote) _then;

/// Create a copy of GroupNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? authorName = null,Object? body = null,Object? createdAt = freezed,Object? isPinned = null,Object? isMine = null,Object? likes = null,Object? likedByMe = null,Object? commentsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupNote].
extension GroupNotePatterns on GroupNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupNote value)  $default,){
final _that = this;
switch (_that) {
case _GroupNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupNote value)?  $default,){
final _that = this;
switch (_that) {
case _GroupNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title, @JsonKey(defaultValue: '')  String authorName,  String body, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isPinned,  bool isMine,  int likes,  bool likedByMe,  int commentsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupNote() when $default != null:
return $default(_that.id,_that.title,_that.authorName,_that.body,_that.createdAt,_that.isPinned,_that.isMine,_that.likes,_that.likedByMe,_that.commentsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title, @JsonKey(defaultValue: '')  String authorName,  String body, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isPinned,  bool isMine,  int likes,  bool likedByMe,  int commentsCount)  $default,) {final _that = this;
switch (_that) {
case _GroupNote():
return $default(_that.id,_that.title,_that.authorName,_that.body,_that.createdAt,_that.isPinned,_that.isMine,_that.likes,_that.likedByMe,_that.commentsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title, @JsonKey(defaultValue: '')  String authorName,  String body, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isPinned,  bool isMine,  int likes,  bool likedByMe,  int commentsCount)?  $default,) {final _that = this;
switch (_that) {
case _GroupNote() when $default != null:
return $default(_that.id,_that.title,_that.authorName,_that.body,_that.createdAt,_that.isPinned,_that.isMine,_that.likes,_that.likedByMe,_that.commentsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupNote implements GroupNote {
  const _GroupNote({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.title, @JsonKey(defaultValue: '') required this.authorName, this.body = '', @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt, this.isPinned = false, this.isMine = false, this.likes = 0, this.likedByMe = false, this.commentsCount = 0});
  factory _GroupNote.fromJson(Map<String, dynamic> json) => _$GroupNoteFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String title;
@override@JsonKey(defaultValue: '') final  String authorName;
@override@JsonKey() final  String body;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey() final  bool isPinned;
@override@JsonKey() final  bool isMine;
@override@JsonKey() final  int likes;
@override@JsonKey() final  bool likedByMe;
@override@JsonKey() final  int commentsCount;

/// Create a copy of GroupNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupNoteCopyWith<_GroupNote> get copyWith => __$GroupNoteCopyWithImpl<_GroupNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupNoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupNote&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.likedByMe, likedByMe) || other.likedByMe == likedByMe)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,authorName,body,createdAt,isPinned,isMine,likes,likedByMe,commentsCount);

@override
String toString() {
  return 'GroupNote(id: $id, title: $title, authorName: $authorName, body: $body, createdAt: $createdAt, isPinned: $isPinned, isMine: $isMine, likes: $likes, likedByMe: $likedByMe, commentsCount: $commentsCount)';
}


}

/// @nodoc
abstract mixin class _$GroupNoteCopyWith<$Res> implements $GroupNoteCopyWith<$Res> {
  factory _$GroupNoteCopyWith(_GroupNote value, $Res Function(_GroupNote) _then) = __$GroupNoteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title,@JsonKey(defaultValue: '') String authorName, String body,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isPinned, bool isMine, int likes, bool likedByMe, int commentsCount
});




}
/// @nodoc
class __$GroupNoteCopyWithImpl<$Res>
    implements _$GroupNoteCopyWith<$Res> {
  __$GroupNoteCopyWithImpl(this._self, this._then);

  final _GroupNote _self;
  final $Res Function(_GroupNote) _then;

/// Create a copy of GroupNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? authorName = null,Object? body = null,Object? createdAt = freezed,Object? isPinned = null,Object? isMine = null,Object? likes = null,Object? likedByMe = null,Object? commentsCount = null,}) {
  return _then(_GroupNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
