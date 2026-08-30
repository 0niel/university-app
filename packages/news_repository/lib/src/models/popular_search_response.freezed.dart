// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'popular_search_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PopularSearchResponse {

 List<NewsBlock> get articles; List<String> get topics;
/// Create a copy of PopularSearchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PopularSearchResponseCopyWith<PopularSearchResponse> get copyWith => _$PopularSearchResponseCopyWithImpl<PopularSearchResponse>(this as PopularSearchResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PopularSearchResponse&&const DeepCollectionEquality().equals(other.articles, articles)&&const DeepCollectionEquality().equals(other.topics, topics));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(articles),const DeepCollectionEquality().hash(topics));

@override
String toString() {
  return 'PopularSearchResponse(articles: $articles, topics: $topics)';
}


}

/// @nodoc
abstract mixin class $PopularSearchResponseCopyWith<$Res>  {
  factory $PopularSearchResponseCopyWith(PopularSearchResponse value, $Res Function(PopularSearchResponse) _then) = _$PopularSearchResponseCopyWithImpl;
@useResult
$Res call({
 List<NewsBlock> articles, List<String> topics
});




}
/// @nodoc
class _$PopularSearchResponseCopyWithImpl<$Res>
    implements $PopularSearchResponseCopyWith<$Res> {
  _$PopularSearchResponseCopyWithImpl(this._self, this._then);

  final PopularSearchResponse _self;
  final $Res Function(PopularSearchResponse) _then;

/// Create a copy of PopularSearchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articles = null,Object? topics = null,}) {
  return _then(_self.copyWith(
articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PopularSearchResponse].
extension PopularSearchResponsePatterns on PopularSearchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PopularSearchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PopularSearchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PopularSearchResponse value)  $default,){
final _that = this;
switch (_that) {
case _PopularSearchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PopularSearchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PopularSearchResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NewsBlock> articles,  List<String> topics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PopularSearchResponse() when $default != null:
return $default(_that.articles,_that.topics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NewsBlock> articles,  List<String> topics)  $default,) {final _that = this;
switch (_that) {
case _PopularSearchResponse():
return $default(_that.articles,_that.topics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NewsBlock> articles,  List<String> topics)?  $default,) {final _that = this;
switch (_that) {
case _PopularSearchResponse() when $default != null:
return $default(_that.articles,_that.topics);case _:
  return null;

}
}

}

/// @nodoc


class _PopularSearchResponse implements PopularSearchResponse {
  const _PopularSearchResponse({required final  List<NewsBlock> articles, required final  List<String> topics}): _articles = articles,_topics = topics;


 final  List<NewsBlock> _articles;
@override List<NewsBlock> get articles {
  if (_articles is EqualUnmodifiableListView) return _articles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_articles);
}

 final  List<String> _topics;
@override List<String> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}


/// Create a copy of PopularSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PopularSearchResponseCopyWith<_PopularSearchResponse> get copyWith => __$PopularSearchResponseCopyWithImpl<_PopularSearchResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PopularSearchResponse&&const DeepCollectionEquality().equals(other._articles, _articles)&&const DeepCollectionEquality().equals(other._topics, _topics));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_articles),const DeepCollectionEquality().hash(_topics));

@override
String toString() {
  return 'PopularSearchResponse(articles: $articles, topics: $topics)';
}


}

/// @nodoc
abstract mixin class _$PopularSearchResponseCopyWith<$Res> implements $PopularSearchResponseCopyWith<$Res> {
  factory _$PopularSearchResponseCopyWith(_PopularSearchResponse value, $Res Function(_PopularSearchResponse) _then) = __$PopularSearchResponseCopyWithImpl;
@override @useResult
$Res call({
 List<NewsBlock> articles, List<String> topics
});




}
/// @nodoc
class __$PopularSearchResponseCopyWithImpl<$Res>
    implements _$PopularSearchResponseCopyWith<$Res> {
  __$PopularSearchResponseCopyWithImpl(this._self, this._then);

  final _PopularSearchResponse _self;
  final $Res Function(_PopularSearchResponse) _then;

/// Create a copy of PopularSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articles = null,Object? topics = null,}) {
  return _then(_PopularSearchResponse(
articles: null == articles ? _self._articles : articles // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
