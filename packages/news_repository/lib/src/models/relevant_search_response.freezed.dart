// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relevant_search_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RelevantSearchResponse {

 List<NewsBlock> get articles; List<String> get topics;
/// Create a copy of RelevantSearchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelevantSearchResponseCopyWith<RelevantSearchResponse> get copyWith => _$RelevantSearchResponseCopyWithImpl<RelevantSearchResponse>(this as RelevantSearchResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RelevantSearchResponse&&const DeepCollectionEquality().equals(other.articles, articles)&&const DeepCollectionEquality().equals(other.topics, topics));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(articles),const DeepCollectionEquality().hash(topics));

@override
String toString() {
  return 'RelevantSearchResponse(articles: $articles, topics: $topics)';
}


}

/// @nodoc
abstract mixin class $RelevantSearchResponseCopyWith<$Res>  {
  factory $RelevantSearchResponseCopyWith(RelevantSearchResponse value, $Res Function(RelevantSearchResponse) _then) = _$RelevantSearchResponseCopyWithImpl;
@useResult
$Res call({
 List<NewsBlock> articles, List<String> topics
});




}
/// @nodoc
class _$RelevantSearchResponseCopyWithImpl<$Res>
    implements $RelevantSearchResponseCopyWith<$Res> {
  _$RelevantSearchResponseCopyWithImpl(this._self, this._then);

  final RelevantSearchResponse _self;
  final $Res Function(RelevantSearchResponse) _then;

/// Create a copy of RelevantSearchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articles = null,Object? topics = null,}) {
  return _then(_self.copyWith(
articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [RelevantSearchResponse].
extension RelevantSearchResponsePatterns on RelevantSearchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RelevantSearchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RelevantSearchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RelevantSearchResponse value)  $default,){
final _that = this;
switch (_that) {
case _RelevantSearchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RelevantSearchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RelevantSearchResponse() when $default != null:
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
case _RelevantSearchResponse() when $default != null:
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
case _RelevantSearchResponse():
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
case _RelevantSearchResponse() when $default != null:
return $default(_that.articles,_that.topics);case _:
  return null;

}
}

}

/// @nodoc


class _RelevantSearchResponse implements RelevantSearchResponse {
  const _RelevantSearchResponse({required final  List<NewsBlock> articles, required final  List<String> topics}): _articles = articles,_topics = topics;


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


/// Create a copy of RelevantSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RelevantSearchResponseCopyWith<_RelevantSearchResponse> get copyWith => __$RelevantSearchResponseCopyWithImpl<_RelevantSearchResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RelevantSearchResponse&&const DeepCollectionEquality().equals(other._articles, _articles)&&const DeepCollectionEquality().equals(other._topics, _topics));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_articles),const DeepCollectionEquality().hash(_topics));

@override
String toString() {
  return 'RelevantSearchResponse(articles: $articles, topics: $topics)';
}


}

/// @nodoc
abstract mixin class _$RelevantSearchResponseCopyWith<$Res> implements $RelevantSearchResponseCopyWith<$Res> {
  factory _$RelevantSearchResponseCopyWith(_RelevantSearchResponse value, $Res Function(_RelevantSearchResponse) _then) = __$RelevantSearchResponseCopyWithImpl;
@override @useResult
$Res call({
 List<NewsBlock> articles, List<String> topics
});




}
/// @nodoc
class __$RelevantSearchResponseCopyWithImpl<$Res>
    implements _$RelevantSearchResponseCopyWith<$Res> {
  __$RelevantSearchResponseCopyWithImpl(this._self, this._then);

  final _RelevantSearchResponse _self;
  final $Res Function(_RelevantSearchResponse) _then;

/// Create a copy of RelevantSearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articles = null,Object? topics = null,}) {
  return _then(_RelevantSearchResponse(
articles: null == articles ? _self._articles : articles // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
