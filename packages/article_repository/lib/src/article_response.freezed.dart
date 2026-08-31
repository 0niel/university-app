// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArticleResponse {

 String get title; List<NewsBlock> get content; Uri get url;
/// Create a copy of ArticleResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleResponseCopyWith<ArticleResponse> get copyWith => _$ArticleResponseCopyWithImpl<ArticleResponse>(this as ArticleResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticleResponse&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(content),url);

@override
String toString() {
  return 'ArticleResponse(title: $title, content: $content, url: $url)';
}


}

/// @nodoc
abstract mixin class $ArticleResponseCopyWith<$Res>  {
  factory $ArticleResponseCopyWith(ArticleResponse value, $Res Function(ArticleResponse) _then) = _$ArticleResponseCopyWithImpl;
@useResult
$Res call({
 String title, List<NewsBlock> content, Uri url
});




}
/// @nodoc
class _$ArticleResponseCopyWithImpl<$Res>
    implements $ArticleResponseCopyWith<$Res> {
  _$ArticleResponseCopyWithImpl(this._self, this._then);

  final ArticleResponse _self;
  final $Res Function(ArticleResponse) _then;

/// Create a copy of ArticleResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? content = null,Object? url = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}

}


/// Adds pattern-matching-related methods to [ArticleResponse].
extension ArticleResponsePatterns on ArticleResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArticleResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArticleResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArticleResponse value)  $default,){
final _that = this;
switch (_that) {
case _ArticleResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArticleResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ArticleResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  List<NewsBlock> content,  Uri url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArticleResponse() when $default != null:
return $default(_that.title,_that.content,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  List<NewsBlock> content,  Uri url)  $default,) {final _that = this;
switch (_that) {
case _ArticleResponse():
return $default(_that.title,_that.content,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  List<NewsBlock> content,  Uri url)?  $default,) {final _that = this;
switch (_that) {
case _ArticleResponse() when $default != null:
return $default(_that.title,_that.content,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _ArticleResponse implements ArticleResponse {
  const _ArticleResponse({required this.title, required final  List<NewsBlock> content, required this.url}): _content = content;


@override final  String title;
 final  List<NewsBlock> _content;
@override List<NewsBlock> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override final  Uri url;

/// Create a copy of ArticleResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleResponseCopyWith<_ArticleResponse> get copyWith => __$ArticleResponseCopyWithImpl<_ArticleResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArticleResponse&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._content, _content)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_content),url);

@override
String toString() {
  return 'ArticleResponse(title: $title, content: $content, url: $url)';
}


}

/// @nodoc
abstract mixin class _$ArticleResponseCopyWith<$Res> implements $ArticleResponseCopyWith<$Res> {
  factory _$ArticleResponseCopyWith(_ArticleResponse value, $Res Function(_ArticleResponse) _then) = __$ArticleResponseCopyWithImpl;
@override @useResult
$Res call({
 String title, List<NewsBlock> content, Uri url
});




}
/// @nodoc
class __$ArticleResponseCopyWithImpl<$Res>
    implements _$ArticleResponseCopyWith<$Res> {
  __$ArticleResponseCopyWithImpl(this._self, this._then);

  final _ArticleResponse _self;
  final $Res Function(_ArticleResponse) _then;

/// Create a copy of ArticleResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? content = null,Object? url = null,}) {
  return _then(_ArticleResponse(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}


}

// dart format on
