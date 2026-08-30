// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_introduction_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArticleIntroductionBlock {

 String get categoryId; String get author; DateTime get publishedAt; String get title; String? get imageUrl; String get type;
/// Create a copy of ArticleIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleIntroductionBlockCopyWith<ArticleIntroductionBlock> get copyWith => _$ArticleIntroductionBlockCopyWithImpl<ArticleIntroductionBlock>(this as ArticleIntroductionBlock, _$identity);

  /// Serializes this ArticleIntroductionBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticleIntroductionBlock&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.author, author) || other.author == author)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,author,publishedAt,title,imageUrl,type);

@override
String toString() {
  return 'ArticleIntroductionBlock(categoryId: $categoryId, author: $author, publishedAt: $publishedAt, title: $title, imageUrl: $imageUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class $ArticleIntroductionBlockCopyWith<$Res>  {
  factory $ArticleIntroductionBlockCopyWith(ArticleIntroductionBlock value, $Res Function(ArticleIntroductionBlock) _then) = _$ArticleIntroductionBlockCopyWithImpl;
@useResult
$Res call({
 String categoryId, String author, DateTime publishedAt, String title, String? imageUrl, String type
});




}
/// @nodoc
class _$ArticleIntroductionBlockCopyWithImpl<$Res>
    implements $ArticleIntroductionBlockCopyWith<$Res> {
  _$ArticleIntroductionBlockCopyWithImpl(this._self, this._then);

  final ArticleIntroductionBlock _self;
  final $Res Function(ArticleIntroductionBlock) _then;

/// Create a copy of ArticleIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? author = null,Object? publishedAt = null,Object? title = null,Object? imageUrl = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ArticleIntroductionBlock].
extension ArticleIntroductionBlockPatterns on ArticleIntroductionBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArticleIntroductionBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArticleIntroductionBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArticleIntroductionBlock value)  $default,){
final _that = this;
switch (_that) {
case _ArticleIntroductionBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArticleIntroductionBlock value)?  $default,){
final _that = this;
switch (_that) {
case _ArticleIntroductionBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId,  String author,  DateTime publishedAt,  String title,  String? imageUrl,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArticleIntroductionBlock() when $default != null:
return $default(_that.categoryId,_that.author,_that.publishedAt,_that.title,_that.imageUrl,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId,  String author,  DateTime publishedAt,  String title,  String? imageUrl,  String type)  $default,) {final _that = this;
switch (_that) {
case _ArticleIntroductionBlock():
return $default(_that.categoryId,_that.author,_that.publishedAt,_that.title,_that.imageUrl,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId,  String author,  DateTime publishedAt,  String title,  String? imageUrl,  String type)?  $default,) {final _that = this;
switch (_that) {
case _ArticleIntroductionBlock() when $default != null:
return $default(_that.categoryId,_that.author,_that.publishedAt,_that.title,_that.imageUrl,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArticleIntroductionBlock implements ArticleIntroductionBlock {
  const _ArticleIntroductionBlock({required this.categoryId, required this.author, required this.publishedAt, required this.title, this.imageUrl, this.type = ArticleIntroductionBlock.identifier});
  factory _ArticleIntroductionBlock.fromJson(Map<String, dynamic> json) => _$ArticleIntroductionBlockFromJson(json);

@override final  String categoryId;
@override final  String author;
@override final  DateTime publishedAt;
@override final  String title;
@override final  String? imageUrl;
@override@JsonKey() final  String type;

/// Create a copy of ArticleIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleIntroductionBlockCopyWith<_ArticleIntroductionBlock> get copyWith => __$ArticleIntroductionBlockCopyWithImpl<_ArticleIntroductionBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArticleIntroductionBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArticleIntroductionBlock&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.author, author) || other.author == author)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,author,publishedAt,title,imageUrl,type);

@override
String toString() {
  return 'ArticleIntroductionBlock(categoryId: $categoryId, author: $author, publishedAt: $publishedAt, title: $title, imageUrl: $imageUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class _$ArticleIntroductionBlockCopyWith<$Res> implements $ArticleIntroductionBlockCopyWith<$Res> {
  factory _$ArticleIntroductionBlockCopyWith(_ArticleIntroductionBlock value, $Res Function(_ArticleIntroductionBlock) _then) = __$ArticleIntroductionBlockCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String author, DateTime publishedAt, String title, String? imageUrl, String type
});




}
/// @nodoc
class __$ArticleIntroductionBlockCopyWithImpl<$Res>
    implements _$ArticleIntroductionBlockCopyWith<$Res> {
  __$ArticleIntroductionBlockCopyWithImpl(this._self, this._then);

  final _ArticleIntroductionBlock _self;
  final $Res Function(_ArticleIntroductionBlock) _then;

/// Create a copy of ArticleIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? author = null,Object? publishedAt = null,Object? title = null,Object? imageUrl = freezed,Object? type = null,}) {
  return _then(_ArticleIntroductionBlock(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
