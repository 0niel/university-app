// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_large_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostLargeBlock {

 String get id; String get categoryId; String get author; DateTime get publishedAt; String get imageUrl; String get title; String? get description;@BlockActionConverter() BlockAction? get action; bool get isContentOverlaid; String get type;
/// Create a copy of PostLargeBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostLargeBlockCopyWith<PostLargeBlock> get copyWith => _$PostLargeBlockCopyWithImpl<PostLargeBlock>(this as PostLargeBlock, _$identity);

  /// Serializes this PostLargeBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostLargeBlock&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.author, author) || other.author == author)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.action, action) || other.action == action)&&(identical(other.isContentOverlaid, isContentOverlaid) || other.isContentOverlaid == isContentOverlaid)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,author,publishedAt,imageUrl,title,description,action,isContentOverlaid,type);

@override
String toString() {
  return 'PostLargeBlock(id: $id, categoryId: $categoryId, author: $author, publishedAt: $publishedAt, imageUrl: $imageUrl, title: $title, description: $description, action: $action, isContentOverlaid: $isContentOverlaid, type: $type)';
}


}

/// @nodoc
abstract mixin class $PostLargeBlockCopyWith<$Res>  {
  factory $PostLargeBlockCopyWith(PostLargeBlock value, $Res Function(PostLargeBlock) _then) = _$PostLargeBlockCopyWithImpl;
@useResult
$Res call({
 String id, String categoryId, String author, DateTime publishedAt, String imageUrl, String title, String? description,@BlockActionConverter() BlockAction? action, bool isContentOverlaid, String type
});




}
/// @nodoc
class _$PostLargeBlockCopyWithImpl<$Res>
    implements $PostLargeBlockCopyWith<$Res> {
  _$PostLargeBlockCopyWithImpl(this._self, this._then);

  final PostLargeBlock _self;
  final $Res Function(PostLargeBlock) _then;

/// Create a copy of PostLargeBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? categoryId = null,Object? author = null,Object? publishedAt = null,Object? imageUrl = null,Object? title = null,Object? description = freezed,Object? action = freezed,Object? isContentOverlaid = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BlockAction?,isContentOverlaid: null == isContentOverlaid ? _self.isContentOverlaid : isContentOverlaid // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PostLargeBlock].
extension PostLargeBlockPatterns on PostLargeBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostLargeBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostLargeBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostLargeBlock value)  $default,){
final _that = this;
switch (_that) {
case _PostLargeBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostLargeBlock value)?  $default,){
final _that = this;
switch (_that) {
case _PostLargeBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String categoryId,  String author,  DateTime publishedAt,  String imageUrl,  String title,  String? description, @BlockActionConverter()  BlockAction? action,  bool isContentOverlaid,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostLargeBlock() when $default != null:
return $default(_that.id,_that.categoryId,_that.author,_that.publishedAt,_that.imageUrl,_that.title,_that.description,_that.action,_that.isContentOverlaid,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String categoryId,  String author,  DateTime publishedAt,  String imageUrl,  String title,  String? description, @BlockActionConverter()  BlockAction? action,  bool isContentOverlaid,  String type)  $default,) {final _that = this;
switch (_that) {
case _PostLargeBlock():
return $default(_that.id,_that.categoryId,_that.author,_that.publishedAt,_that.imageUrl,_that.title,_that.description,_that.action,_that.isContentOverlaid,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String categoryId,  String author,  DateTime publishedAt,  String imageUrl,  String title,  String? description, @BlockActionConverter()  BlockAction? action,  bool isContentOverlaid,  String type)?  $default,) {final _that = this;
switch (_that) {
case _PostLargeBlock() when $default != null:
return $default(_that.id,_that.categoryId,_that.author,_that.publishedAt,_that.imageUrl,_that.title,_that.description,_that.action,_that.isContentOverlaid,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostLargeBlock implements PostLargeBlock {
  const _PostLargeBlock({required this.id, required this.categoryId, required this.author, required this.publishedAt, required this.imageUrl, required this.title, this.description, @BlockActionConverter() this.action, this.isContentOverlaid = false, this.type = PostLargeBlock.identifier});
  factory _PostLargeBlock.fromJson(Map<String, dynamic> json) => _$PostLargeBlockFromJson(json);

@override final  String id;
@override final  String categoryId;
@override final  String author;
@override final  DateTime publishedAt;
@override final  String imageUrl;
@override final  String title;
@override final  String? description;
@override@BlockActionConverter() final  BlockAction? action;
@override@JsonKey() final  bool isContentOverlaid;
@override@JsonKey() final  String type;

/// Create a copy of PostLargeBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostLargeBlockCopyWith<_PostLargeBlock> get copyWith => __$PostLargeBlockCopyWithImpl<_PostLargeBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostLargeBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostLargeBlock&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.author, author) || other.author == author)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.action, action) || other.action == action)&&(identical(other.isContentOverlaid, isContentOverlaid) || other.isContentOverlaid == isContentOverlaid)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,categoryId,author,publishedAt,imageUrl,title,description,action,isContentOverlaid,type);

@override
String toString() {
  return 'PostLargeBlock(id: $id, categoryId: $categoryId, author: $author, publishedAt: $publishedAt, imageUrl: $imageUrl, title: $title, description: $description, action: $action, isContentOverlaid: $isContentOverlaid, type: $type)';
}


}

/// @nodoc
abstract mixin class _$PostLargeBlockCopyWith<$Res> implements $PostLargeBlockCopyWith<$Res> {
  factory _$PostLargeBlockCopyWith(_PostLargeBlock value, $Res Function(_PostLargeBlock) _then) = __$PostLargeBlockCopyWithImpl;
@override @useResult
$Res call({
 String id, String categoryId, String author, DateTime publishedAt, String imageUrl, String title, String? description,@BlockActionConverter() BlockAction? action, bool isContentOverlaid, String type
});




}
/// @nodoc
class __$PostLargeBlockCopyWithImpl<$Res>
    implements _$PostLargeBlockCopyWith<$Res> {
  __$PostLargeBlockCopyWithImpl(this._self, this._then);

  final _PostLargeBlock _self;
  final $Res Function(_PostLargeBlock) _then;

/// Create a copy of PostLargeBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? categoryId = null,Object? author = null,Object? publishedAt = null,Object? imageUrl = null,Object? title = null,Object? description = freezed,Object? action = freezed,Object? isContentOverlaid = null,Object? type = null,}) {
  return _then(_PostLargeBlock(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BlockAction?,isContentOverlaid: null == isContentOverlaid ? _self.isContentOverlaid : isContentOverlaid // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
