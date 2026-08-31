// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'related_articles_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RelatedArticlesResponse {

 List<NewsBlock> get relatedArticles; int get totalCount;
/// Create a copy of RelatedArticlesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelatedArticlesResponseCopyWith<RelatedArticlesResponse> get copyWith => _$RelatedArticlesResponseCopyWithImpl<RelatedArticlesResponse>(this as RelatedArticlesResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RelatedArticlesResponse&&const DeepCollectionEquality().equals(other.relatedArticles, relatedArticles)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(relatedArticles),totalCount);

@override
String toString() {
  return 'RelatedArticlesResponse(relatedArticles: $relatedArticles, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class $RelatedArticlesResponseCopyWith<$Res>  {
  factory $RelatedArticlesResponseCopyWith(RelatedArticlesResponse value, $Res Function(RelatedArticlesResponse) _then) = _$RelatedArticlesResponseCopyWithImpl;
@useResult
$Res call({
 List<NewsBlock> relatedArticles, int totalCount
});




}
/// @nodoc
class _$RelatedArticlesResponseCopyWithImpl<$Res>
    implements $RelatedArticlesResponseCopyWith<$Res> {
  _$RelatedArticlesResponseCopyWithImpl(this._self, this._then);

  final RelatedArticlesResponse _self;
  final $Res Function(RelatedArticlesResponse) _then;

/// Create a copy of RelatedArticlesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? relatedArticles = null,Object? totalCount = null,}) {
  return _then(_self.copyWith(
relatedArticles: null == relatedArticles ? _self.relatedArticles : relatedArticles // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RelatedArticlesResponse].
extension RelatedArticlesResponsePatterns on RelatedArticlesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RelatedArticlesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RelatedArticlesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RelatedArticlesResponse value)  $default,){
final _that = this;
switch (_that) {
case _RelatedArticlesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RelatedArticlesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RelatedArticlesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NewsBlock> relatedArticles,  int totalCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RelatedArticlesResponse() when $default != null:
return $default(_that.relatedArticles,_that.totalCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NewsBlock> relatedArticles,  int totalCount)  $default,) {final _that = this;
switch (_that) {
case _RelatedArticlesResponse():
return $default(_that.relatedArticles,_that.totalCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NewsBlock> relatedArticles,  int totalCount)?  $default,) {final _that = this;
switch (_that) {
case _RelatedArticlesResponse() when $default != null:
return $default(_that.relatedArticles,_that.totalCount);case _:
  return null;

}
}

}

/// @nodoc


class _RelatedArticlesResponse implements RelatedArticlesResponse {
  const _RelatedArticlesResponse({required final  List<NewsBlock> relatedArticles, required this.totalCount}): _relatedArticles = relatedArticles;


 final  List<NewsBlock> _relatedArticles;
@override List<NewsBlock> get relatedArticles {
  if (_relatedArticles is EqualUnmodifiableListView) return _relatedArticles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedArticles);
}

@override final  int totalCount;

/// Create a copy of RelatedArticlesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RelatedArticlesResponseCopyWith<_RelatedArticlesResponse> get copyWith => __$RelatedArticlesResponseCopyWithImpl<_RelatedArticlesResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RelatedArticlesResponse&&const DeepCollectionEquality().equals(other._relatedArticles, _relatedArticles)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_relatedArticles),totalCount);

@override
String toString() {
  return 'RelatedArticlesResponse(relatedArticles: $relatedArticles, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class _$RelatedArticlesResponseCopyWith<$Res> implements $RelatedArticlesResponseCopyWith<$Res> {
  factory _$RelatedArticlesResponseCopyWith(_RelatedArticlesResponse value, $Res Function(_RelatedArticlesResponse) _then) = __$RelatedArticlesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<NewsBlock> relatedArticles, int totalCount
});




}
/// @nodoc
class __$RelatedArticlesResponseCopyWithImpl<$Res>
    implements _$RelatedArticlesResponseCopyWith<$Res> {
  __$RelatedArticlesResponseCopyWithImpl(this._self, this._then);

  final _RelatedArticlesResponse _self;
  final $Res Function(_RelatedArticlesResponse) _then;

/// Create a copy of RelatedArticlesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? relatedArticles = null,Object? totalCount = null,}) {
  return _then(_RelatedArticlesResponse(
relatedArticles: null == relatedArticles ? _self._relatedArticles : relatedArticles // ignore: cast_nullable_to_non_nullable
as List<NewsBlock>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
