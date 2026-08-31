// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupLink {

 String get id; String get title; String get url; String get emoji; String get kind; String get addedBy; bool get isMine;
/// Create a copy of GroupLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupLinkCopyWith<GroupLink> get copyWith => _$GroupLinkCopyWithImpl<GroupLink>(this as GroupLink, _$identity);

  /// Serializes this GroupLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupLink&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.isMine, isMine) || other.isMine == isMine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,url,emoji,kind,addedBy,isMine);

@override
String toString() {
  return 'GroupLink(id: $id, title: $title, url: $url, emoji: $emoji, kind: $kind, addedBy: $addedBy, isMine: $isMine)';
}


}

/// @nodoc
abstract mixin class $GroupLinkCopyWith<$Res>  {
  factory $GroupLinkCopyWith(GroupLink value, $Res Function(GroupLink) _then) = _$GroupLinkCopyWithImpl;
@useResult
$Res call({
 String id, String title, String url, String emoji, String kind, String addedBy, bool isMine
});




}
/// @nodoc
class _$GroupLinkCopyWithImpl<$Res>
    implements $GroupLinkCopyWith<$Res> {
  _$GroupLinkCopyWithImpl(this._self, this._then);

  final GroupLink _self;
  final $Res Function(GroupLink) _then;

/// Create a copy of GroupLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? url = null,Object? emoji = null,Object? kind = null,Object? addedBy = null,Object? isMine = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,addedBy: null == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupLink].
extension GroupLinkPatterns on GroupLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupLink value)  $default,){
final _that = this;
switch (_that) {
case _GroupLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupLink value)?  $default,){
final _that = this;
switch (_that) {
case _GroupLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String url,  String emoji,  String kind,  String addedBy,  bool isMine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupLink() when $default != null:
return $default(_that.id,_that.title,_that.url,_that.emoji,_that.kind,_that.addedBy,_that.isMine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String url,  String emoji,  String kind,  String addedBy,  bool isMine)  $default,) {final _that = this;
switch (_that) {
case _GroupLink():
return $default(_that.id,_that.title,_that.url,_that.emoji,_that.kind,_that.addedBy,_that.isMine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String url,  String emoji,  String kind,  String addedBy,  bool isMine)?  $default,) {final _that = this;
switch (_that) {
case _GroupLink() when $default != null:
return $default(_that.id,_that.title,_that.url,_that.emoji,_that.kind,_that.addedBy,_that.isMine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupLink extends GroupLink {
  const _GroupLink({required this.id, required this.title, required this.url, this.emoji = '🔗', this.kind = 'link', this.addedBy = '', this.isMine = false}): super._();
  factory _GroupLink.fromJson(Map<String, dynamic> json) => _$GroupLinkFromJson(json);

@override final  String id;
@override final  String title;
@override final  String url;
@override@JsonKey() final  String emoji;
@override@JsonKey() final  String kind;
@override@JsonKey() final  String addedBy;
@override@JsonKey() final  bool isMine;

/// Create a copy of GroupLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupLinkCopyWith<_GroupLink> get copyWith => __$GroupLinkCopyWithImpl<_GroupLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupLinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupLink&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.isMine, isMine) || other.isMine == isMine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,url,emoji,kind,addedBy,isMine);

@override
String toString() {
  return 'GroupLink(id: $id, title: $title, url: $url, emoji: $emoji, kind: $kind, addedBy: $addedBy, isMine: $isMine)';
}


}

/// @nodoc
abstract mixin class _$GroupLinkCopyWith<$Res> implements $GroupLinkCopyWith<$Res> {
  factory _$GroupLinkCopyWith(_GroupLink value, $Res Function(_GroupLink) _then) = __$GroupLinkCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String url, String emoji, String kind, String addedBy, bool isMine
});




}
/// @nodoc
class __$GroupLinkCopyWithImpl<$Res>
    implements _$GroupLinkCopyWith<$Res> {
  __$GroupLinkCopyWithImpl(this._self, this._then);

  final _GroupLink _self;
  final $Res Function(_GroupLink) _then;

/// Create a copy of GroupLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? url = null,Object? emoji = null,Object? kind = null,Object? addedBy = null,Object? isMine = null,}) {
  return _then(_GroupLink(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,addedBy: null == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
