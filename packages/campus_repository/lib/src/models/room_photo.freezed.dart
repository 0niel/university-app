// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomPhoto {

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get path;@JsonKey(defaultValue: '') String get createdBy;@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime get createdAt; int? get width; int? get height; String get authorName; bool get isMine; String get url;
/// Create a copy of RoomPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomPhotoCopyWith<RoomPhoto> get copyWith => _$RoomPhotoCopyWithImpl<RoomPhoto>(this as RoomPhoto, _$identity);

  /// Serializes this RoomPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,path,createdBy,createdAt,width,height,authorName,isMine,url);

@override
String toString() {
  return 'RoomPhoto(id: $id, path: $path, createdBy: $createdBy, createdAt: $createdAt, width: $width, height: $height, authorName: $authorName, isMine: $isMine, url: $url)';
}


}

/// @nodoc
abstract mixin class $RoomPhotoCopyWith<$Res>  {
  factory $RoomPhotoCopyWith(RoomPhoto value, $Res Function(RoomPhoto) _then) = _$RoomPhotoCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String path,@JsonKey(defaultValue: '') String createdBy,@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime createdAt, int? width, int? height, String authorName, bool isMine, String url
});




}
/// @nodoc
class _$RoomPhotoCopyWithImpl<$Res>
    implements $RoomPhotoCopyWith<$Res> {
  _$RoomPhotoCopyWithImpl(this._self, this._then);

  final RoomPhoto _self;
  final $Res Function(RoomPhoto) _then;

/// Create a copy of RoomPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? path = null,Object? createdBy = null,Object? createdAt = null,Object? width = freezed,Object? height = freezed,Object? authorName = null,Object? isMine = null,Object? url = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomPhoto].
extension RoomPhotoPatterns on RoomPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomPhoto value)  $default,){
final _that = this;
switch (_that) {
case _RoomPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _RoomPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String path, @JsonKey(defaultValue: '')  String createdBy, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime createdAt,  int? width,  int? height,  String authorName,  bool isMine,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomPhoto() when $default != null:
return $default(_that.id,_that.path,_that.createdBy,_that.createdAt,_that.width,_that.height,_that.authorName,_that.isMine,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String path, @JsonKey(defaultValue: '')  String createdBy, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime createdAt,  int? width,  int? height,  String authorName,  bool isMine,  String url)  $default,) {final _that = this;
switch (_that) {
case _RoomPhoto():
return $default(_that.id,_that.path,_that.createdBy,_that.createdAt,_that.width,_that.height,_that.authorName,_that.isMine,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String path, @JsonKey(defaultValue: '')  String createdBy, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime createdAt,  int? width,  int? height,  String authorName,  bool isMine,  String url)?  $default,) {final _that = this;
switch (_that) {
case _RoomPhoto() when $default != null:
return $default(_that.id,_that.path,_that.createdBy,_that.createdAt,_that.width,_that.height,_that.authorName,_that.isMine,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomPhoto implements RoomPhoto {
  const _RoomPhoto({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.path, @JsonKey(defaultValue: '') required this.createdBy, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) required this.createdAt, this.width, this.height, this.authorName = '', this.isMine = false, this.url = ''});
  factory _RoomPhoto.fromJson(Map<String, dynamic> json) => _$RoomPhotoFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String path;
@override@JsonKey(defaultValue: '') final  String createdBy;
@override@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) final  DateTime createdAt;
@override final  int? width;
@override final  int? height;
@override@JsonKey() final  String authorName;
@override@JsonKey() final  bool isMine;
@override@JsonKey() final  String url;

/// Create a copy of RoomPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomPhotoCopyWith<_RoomPhoto> get copyWith => __$RoomPhotoCopyWithImpl<_RoomPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,path,createdBy,createdAt,width,height,authorName,isMine,url);

@override
String toString() {
  return 'RoomPhoto(id: $id, path: $path, createdBy: $createdBy, createdAt: $createdAt, width: $width, height: $height, authorName: $authorName, isMine: $isMine, url: $url)';
}


}

/// @nodoc
abstract mixin class _$RoomPhotoCopyWith<$Res> implements $RoomPhotoCopyWith<$Res> {
  factory _$RoomPhotoCopyWith(_RoomPhoto value, $Res Function(_RoomPhoto) _then) = __$RoomPhotoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String path,@JsonKey(defaultValue: '') String createdBy,@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime createdAt, int? width, int? height, String authorName, bool isMine, String url
});




}
/// @nodoc
class __$RoomPhotoCopyWithImpl<$Res>
    implements _$RoomPhotoCopyWith<$Res> {
  __$RoomPhotoCopyWithImpl(this._self, this._then);

  final _RoomPhoto _self;
  final $Res Function(_RoomPhoto) _then;

/// Create a copy of RoomPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? path = null,Object? createdBy = null,Object? createdAt = null,Object? width = freezed,Object? height = freezed,Object? authorName = null,Object? isMine = null,Object? url = null,}) {
  return _then(_RoomPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
