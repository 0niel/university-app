// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArticleState {

 ArticleStatus get status; String? get title;@NewsBlocksConverter() List<NewsBlock> get content; int get contentSeenCount;@NewsBlocksConverter() List<NewsBlock> get relatedArticles; Uri? get uri; bool get hasReachedArticleViewsLimit; bool get showInterstitialAd;
/// Create a copy of ArticleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleStateCopyWith<ArticleState> get copyWith => _$ArticleStateCopyWithImpl<ArticleState>(this as ArticleState, _$identity);

  /// Serializes this ArticleState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticleState&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.contentSeenCount, contentSeenCount) || other.contentSeenCount == contentSeenCount)&&const DeepCollectionEquality().equals(other.relatedArticles, relatedArticles)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.hasReachedArticleViewsLimit, hasReachedArticleViewsLimit) || other.hasReachedArticleViewsLimit == hasReachedArticleViewsLimit)&&(identical(other.showInterstitialAd, showInterstitialAd) || other.showInterstitialAd == showInterstitialAd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,title,const DeepCollectionEquality().hash(content),contentSeenCount,const DeepCollectionEquality().hash(relatedArticles),uri,hasReachedArticleViewsLimit,showInterstitialAd);

@override
String toString() {
  return 'ArticleState(status: $status, title: $title, content: $content, contentSeenCount: $contentSeenCount, relatedArticles: $relatedArticles, uri: $uri, hasReachedArticleViewsLimit: $hasReachedArticleViewsLimit, showInterstitialAd: $showInterstitialAd)';
}


}

/// @nodoc
abstract mixin class $ArticleStateCopyWith<$Res>  {
  factory $ArticleStateCopyWith(ArticleState value, $Res Function(ArticleState) _then) = _$ArticleStateCopyWithImpl;
@useResult
$Res call({
 ArticleStatus status, String? title,@NewsBlocksConverter() List<NewsBlock> content, int contentSeenCount,@NewsBlocksConverter() List<NewsBlock> relatedArticles, Uri? uri, bool hasReachedArticleViewsLimit, bool showInterstitialAd
});




}
/// @nodoc
class _$ArticleStateCopyWithImpl<$Res>
    implements $ArticleStateCopyWith<$Res> {
  _$ArticleStateCopyWithImpl(this._self, this._then);

  final ArticleState _self;
  final $Res Function(ArticleState) _then;

/// Create a copy of ArticleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? title = freezed,Object? content = null,Object? contentSeenCount = null,Object? relatedArticles = null,Object? uri = freezed,Object? hasReachedArticleViewsLimit = null,Object? showInterstitialAd = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ArticleStatus,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,contentSeenCount: null == contentSeenCount ? _self.contentSeenCount : contentSeenCount // ignore: cast_nullable_to_non_nullable
as int,relatedArticles: null == relatedArticles ? _self.relatedArticles : relatedArticles // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as Uri?,hasReachedArticleViewsLimit: null == hasReachedArticleViewsLimit ? _self.hasReachedArticleViewsLimit : hasReachedArticleViewsLimit // ignore: cast_nullable_to_non_nullable
as bool,showInterstitialAd: null == showInterstitialAd ? _self.showInterstitialAd : showInterstitialAd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ArticleState].
extension ArticleStatePatterns on ArticleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArticleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArticleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArticleState value)  $default,){
final _that = this;
switch (_that) {
case _ArticleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArticleState value)?  $default,){
final _that = this;
switch (_that) {
case _ArticleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ArticleStatus status,  String? title, @NewsBlocksConverter()  List<NewsBlock> content,  int contentSeenCount, @NewsBlocksConverter()  List<NewsBlock> relatedArticles,  Uri? uri,  bool hasReachedArticleViewsLimit,  bool showInterstitialAd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArticleState() when $default != null:
return $default(_that.status,_that.title,_that.content,_that.contentSeenCount,_that.relatedArticles,_that.uri,_that.hasReachedArticleViewsLimit,_that.showInterstitialAd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ArticleStatus status,  String? title, @NewsBlocksConverter()  List<NewsBlock> content,  int contentSeenCount, @NewsBlocksConverter()  List<NewsBlock> relatedArticles,  Uri? uri,  bool hasReachedArticleViewsLimit,  bool showInterstitialAd)  $default,) {final _that = this;
switch (_that) {
case _ArticleState():
return $default(_that.status,_that.title,_that.content,_that.contentSeenCount,_that.relatedArticles,_that.uri,_that.hasReachedArticleViewsLimit,_that.showInterstitialAd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ArticleStatus status,  String? title, @NewsBlocksConverter()  List<NewsBlock> content,  int contentSeenCount, @NewsBlocksConverter()  List<NewsBlock> relatedArticles,  Uri? uri,  bool hasReachedArticleViewsLimit,  bool showInterstitialAd)?  $default,) {final _that = this;
switch (_that) {
case _ArticleState() when $default != null:
return $default(_that.status,_that.title,_that.content,_that.contentSeenCount,_that.relatedArticles,_that.uri,_that.hasReachedArticleViewsLimit,_that.showInterstitialAd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArticleState implements ArticleState {
  const _ArticleState({this.status = ArticleStatus.initial, this.title, @NewsBlocksConverter() final  List<NewsBlock> content = const <NewsBlock>[], this.contentSeenCount = 0, @NewsBlocksConverter() final  List<NewsBlock> relatedArticles = const <NewsBlock>[], this.uri, this.hasReachedArticleViewsLimit = false, this.showInterstitialAd = false}): _content = content,_relatedArticles = relatedArticles;
  factory _ArticleState.fromJson(Map<String, dynamic> json) => _$ArticleStateFromJson(json);

@override@JsonKey() final  ArticleStatus status;
@override final  String? title;
 final  List<NewsBlock> _content;
@override@JsonKey()@NewsBlocksConverter() List<NewsBlock> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override@JsonKey() final  int contentSeenCount;
 final  List<NewsBlock> _relatedArticles;
@override@JsonKey()@NewsBlocksConverter() List<NewsBlock> get relatedArticles {
  if (_relatedArticles is EqualUnmodifiableListView) return _relatedArticles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedArticles);
}

@override final  Uri? uri;
@override@JsonKey() final  bool hasReachedArticleViewsLimit;
@override@JsonKey() final  bool showInterstitialAd;

/// Create a copy of ArticleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleStateCopyWith<_ArticleState> get copyWith => __$ArticleStateCopyWithImpl<_ArticleState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArticleStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArticleState&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._content, _content)&&(identical(other.contentSeenCount, contentSeenCount) || other.contentSeenCount == contentSeenCount)&&const DeepCollectionEquality().equals(other._relatedArticles, _relatedArticles)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.hasReachedArticleViewsLimit, hasReachedArticleViewsLimit) || other.hasReachedArticleViewsLimit == hasReachedArticleViewsLimit)&&(identical(other.showInterstitialAd, showInterstitialAd) || other.showInterstitialAd == showInterstitialAd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,title,const DeepCollectionEquality().hash(_content),contentSeenCount,const DeepCollectionEquality().hash(_relatedArticles),uri,hasReachedArticleViewsLimit,showInterstitialAd);

@override
String toString() {
  return 'ArticleState(status: $status, title: $title, content: $content, contentSeenCount: $contentSeenCount, relatedArticles: $relatedArticles, uri: $uri, hasReachedArticleViewsLimit: $hasReachedArticleViewsLimit, showInterstitialAd: $showInterstitialAd)';
}


}

/// @nodoc
abstract mixin class _$ArticleStateCopyWith<$Res> implements $ArticleStateCopyWith<$Res> {
  factory _$ArticleStateCopyWith(_ArticleState value, $Res Function(_ArticleState) _then) = __$ArticleStateCopyWithImpl;
@override @useResult
$Res call({
 ArticleStatus status, String? title,@NewsBlocksConverter() List<NewsBlock> content, int contentSeenCount,@NewsBlocksConverter() List<NewsBlock> relatedArticles, Uri? uri, bool hasReachedArticleViewsLimit, bool showInterstitialAd
});




}
/// @nodoc
class __$ArticleStateCopyWithImpl<$Res>
    implements _$ArticleStateCopyWith<$Res> {
  __$ArticleStateCopyWithImpl(this._self, this._then);

  final _ArticleState _self;
  final $Res Function(_ArticleState) _then;

/// Create a copy of ArticleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? title = freezed,Object? content = null,Object? contentSeenCount = null,Object? relatedArticles = null,Object? uri = freezed,Object? hasReachedArticleViewsLimit = null,Object? showInterstitialAd = null,}) {
  return _then(_ArticleState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ArticleStatus,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,contentSeenCount: null == contentSeenCount ? _self.contentSeenCount : contentSeenCount // ignore: cast_nullable_to_non_nullable
as int,relatedArticles: null == relatedArticles ? _self._relatedArticles : relatedArticles // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as Uri?,hasReachedArticleViewsLimit: null == hasReachedArticleViewsLimit ? _self.hasReachedArticleViewsLimit : hasReachedArticleViewsLimit // ignore: cast_nullable_to_non_nullable
as bool,showInterstitialAd: null == showInterstitialAd ? _self.showInterstitialAd : showInterstitialAd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
