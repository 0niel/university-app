// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_post_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupPostSearchResult {

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get title; String get body; String get kind; bool get isPinned; String get authorName;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt;
/// Create a copy of GroupPostSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupPostSearchResultCopyWith<GroupPostSearchResult> get copyWith => _$GroupPostSearchResultCopyWithImpl<GroupPostSearchResult>(this as GroupPostSearchResult, _$identity);

  /// Serializes this GroupPostSearchResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupPostSearchResult&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,kind,isPinned,authorName,createdAt);

@override
String toString() {
  return 'GroupPostSearchResult(id: $id, title: $title, body: $body, kind: $kind, isPinned: $isPinned, authorName: $authorName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $GroupPostSearchResultCopyWith<$Res>  {
  factory $GroupPostSearchResultCopyWith(GroupPostSearchResult value, $Res Function(GroupPostSearchResult) _then) = _$GroupPostSearchResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title, String body, String kind, bool isPinned, String authorName,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class _$GroupPostSearchResultCopyWithImpl<$Res>
    implements $GroupPostSearchResultCopyWith<$Res> {
  _$GroupPostSearchResultCopyWithImpl(this._self, this._then);

  final GroupPostSearchResult _self;
  final $Res Function(GroupPostSearchResult) _then;

/// Create a copy of GroupPostSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? kind = null,Object? isPinned = null,Object? authorName = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupPostSearchResult].
extension GroupPostSearchResultPatterns on GroupPostSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupPostSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupPostSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupPostSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _GroupPostSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupPostSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _GroupPostSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String body,  String kind,  bool isPinned,  String authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupPostSearchResult() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.kind,_that.isPinned,_that.authorName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String body,  String kind,  bool isPinned,  String authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _GroupPostSearchResult():
return $default(_that.id,_that.title,_that.body,_that.kind,_that.isPinned,_that.authorName,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String body,  String kind,  bool isPinned,  String authorName, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupPostSearchResult() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.kind,_that.isPinned,_that.authorName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupPostSearchResult implements GroupPostSearchResult {
  const _GroupPostSearchResult({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.title, this.body = '', this.kind = 'note', this.isPinned = false, this.authorName = '', @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt});
  factory _GroupPostSearchResult.fromJson(Map<String, dynamic> json) => _$GroupPostSearchResultFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String title;
@override@JsonKey() final  String body;
@override@JsonKey() final  String kind;
@override@JsonKey() final  bool isPinned;
@override@JsonKey() final  String authorName;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;

/// Create a copy of GroupPostSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupPostSearchResultCopyWith<_GroupPostSearchResult> get copyWith => __$GroupPostSearchResultCopyWithImpl<_GroupPostSearchResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupPostSearchResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupPostSearchResult&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,kind,isPinned,authorName,createdAt);

@override
String toString() {
  return 'GroupPostSearchResult(id: $id, title: $title, body: $body, kind: $kind, isPinned: $isPinned, authorName: $authorName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$GroupPostSearchResultCopyWith<$Res> implements $GroupPostSearchResultCopyWith<$Res> {
  factory _$GroupPostSearchResultCopyWith(_GroupPostSearchResult value, $Res Function(_GroupPostSearchResult) _then) = __$GroupPostSearchResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title, String body, String kind, bool isPinned, String authorName,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class __$GroupPostSearchResultCopyWithImpl<$Res>
    implements _$GroupPostSearchResultCopyWith<$Res> {
  __$GroupPostSearchResultCopyWithImpl(this._self, this._then);

  final _GroupPostSearchResult _self;
  final $Res Function(_GroupPostSearchResult) _then;

/// Create a copy of GroupPostSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? kind = null,Object? isPinned = null,Object? authorName = null,Object? createdAt = freezed,}) {
  return _then(_GroupPostSearchResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
