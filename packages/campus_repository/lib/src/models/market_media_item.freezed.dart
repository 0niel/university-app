// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_media_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketMediaItem {

 String get path; MarketMediaKind get kind; int get width; int get height; int get duration;@JsonKey(includeFromJson: false, includeToJson: false) String get url;
/// Create a copy of MarketMediaItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketMediaItemCopyWith<MarketMediaItem> get copyWith => _$MarketMediaItemCopyWithImpl<MarketMediaItem>(this as MarketMediaItem, _$identity);

  /// Serializes this MarketMediaItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketMediaItem&&(identical(other.path, path) || other.path == path)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,kind,width,height,duration,url);

@override
String toString() {
  return 'MarketMediaItem(path: $path, kind: $kind, width: $width, height: $height, duration: $duration, url: $url)';
}


}

/// @nodoc
abstract mixin class $MarketMediaItemCopyWith<$Res>  {
  factory $MarketMediaItemCopyWith(MarketMediaItem value, $Res Function(MarketMediaItem) _then) = _$MarketMediaItemCopyWithImpl;
@useResult
$Res call({
 String path, MarketMediaKind kind, int width, int height, int duration,@JsonKey(includeFromJson: false, includeToJson: false) String url
});




}
/// @nodoc
class _$MarketMediaItemCopyWithImpl<$Res>
    implements $MarketMediaItemCopyWith<$Res> {
  _$MarketMediaItemCopyWithImpl(this._self, this._then);

  final MarketMediaItem _self;
  final $Res Function(MarketMediaItem) _then;

/// Create a copy of MarketMediaItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? kind = null,Object? width = null,Object? height = null,Object? duration = null,Object? url = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MarketMediaKind,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketMediaItem].
extension MarketMediaItemPatterns on MarketMediaItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketMediaItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketMediaItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketMediaItem value)  $default,){
final _that = this;
switch (_that) {
case _MarketMediaItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketMediaItem value)?  $default,){
final _that = this;
switch (_that) {
case _MarketMediaItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  MarketMediaKind kind,  int width,  int height,  int duration, @JsonKey(includeFromJson: false, includeToJson: false)  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketMediaItem() when $default != null:
return $default(_that.path,_that.kind,_that.width,_that.height,_that.duration,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  MarketMediaKind kind,  int width,  int height,  int duration, @JsonKey(includeFromJson: false, includeToJson: false)  String url)  $default,) {final _that = this;
switch (_that) {
case _MarketMediaItem():
return $default(_that.path,_that.kind,_that.width,_that.height,_that.duration,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  MarketMediaKind kind,  int width,  int height,  int duration, @JsonKey(includeFromJson: false, includeToJson: false)  String url)?  $default,) {final _that = this;
switch (_that) {
case _MarketMediaItem() when $default != null:
return $default(_that.path,_that.kind,_that.width,_that.height,_that.duration,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketMediaItem extends MarketMediaItem {
  const _MarketMediaItem({required this.path, required this.kind, this.width = 0, this.height = 0, this.duration = 0, @JsonKey(includeFromJson: false, includeToJson: false) this.url = ''}): super._();
  factory _MarketMediaItem.fromJson(Map<String, dynamic> json) => _$MarketMediaItemFromJson(json);

@override final  String path;
@override final  MarketMediaKind kind;
@override@JsonKey() final  int width;
@override@JsonKey() final  int height;
@override@JsonKey() final  int duration;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String url;

/// Create a copy of MarketMediaItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketMediaItemCopyWith<_MarketMediaItem> get copyWith => __$MarketMediaItemCopyWithImpl<_MarketMediaItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketMediaItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketMediaItem&&(identical(other.path, path) || other.path == path)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,kind,width,height,duration,url);

@override
String toString() {
  return 'MarketMediaItem(path: $path, kind: $kind, width: $width, height: $height, duration: $duration, url: $url)';
}


}

/// @nodoc
abstract mixin class _$MarketMediaItemCopyWith<$Res> implements $MarketMediaItemCopyWith<$Res> {
  factory _$MarketMediaItemCopyWith(_MarketMediaItem value, $Res Function(_MarketMediaItem) _then) = __$MarketMediaItemCopyWithImpl;
@override @useResult
$Res call({
 String path, MarketMediaKind kind, int width, int height, int duration,@JsonKey(includeFromJson: false, includeToJson: false) String url
});




}
/// @nodoc
class __$MarketMediaItemCopyWithImpl<$Res>
    implements _$MarketMediaItemCopyWith<$Res> {
  __$MarketMediaItemCopyWithImpl(this._self, this._then);

  final _MarketMediaItem _self;
  final $Res Function(_MarketMediaItem) _then;

/// Create a copy of MarketMediaItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? kind = null,Object? width = null,Object? height = null,Object? duration = null,Object? url = null,}) {
  return _then(_MarketMediaItem(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MarketMediaKind,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
