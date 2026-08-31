// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_groups_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchGroupsResponse {

 List<domain.Group> get results;
/// Create a copy of SearchGroupsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchGroupsResponseCopyWith<SearchGroupsResponse> get copyWith => _$SearchGroupsResponseCopyWithImpl<SearchGroupsResponse>(this as SearchGroupsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchGroupsResponse&&const DeepCollectionEquality().equals(other.results, results));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'SearchGroupsResponse(results: $results)';
}


}

/// @nodoc
abstract mixin class $SearchGroupsResponseCopyWith<$Res>  {
  factory $SearchGroupsResponseCopyWith(SearchGroupsResponse value, $Res Function(SearchGroupsResponse) _then) = _$SearchGroupsResponseCopyWithImpl;
@useResult
$Res call({
 List<domain.Group> results
});




}
/// @nodoc
class _$SearchGroupsResponseCopyWithImpl<$Res>
    implements $SearchGroupsResponseCopyWith<$Res> {
  _$SearchGroupsResponseCopyWithImpl(this._self, this._then);

  final SearchGroupsResponse _self;
  final $Res Function(SearchGroupsResponse) _then;

/// Create a copy of SearchGroupsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<domain.Group>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchGroupsResponse].
extension SearchGroupsResponsePatterns on SearchGroupsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchGroupsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchGroupsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchGroupsResponse value)  $default,){
final _that = this;
switch (_that) {
case _SearchGroupsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchGroupsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SearchGroupsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<domain.Group> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchGroupsResponse() when $default != null:
return $default(_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<domain.Group> results)  $default,) {final _that = this;
switch (_that) {
case _SearchGroupsResponse():
return $default(_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<domain.Group> results)?  $default,) {final _that = this;
switch (_that) {
case _SearchGroupsResponse() when $default != null:
return $default(_that.results);case _:
  return null;

}
}

}

/// @nodoc


class _SearchGroupsResponse implements SearchGroupsResponse {
  const _SearchGroupsResponse({required final  List<domain.Group> results}): _results = results;


 final  List<domain.Group> _results;
@override List<domain.Group> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SearchGroupsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchGroupsResponseCopyWith<_SearchGroupsResponse> get copyWith => __$SearchGroupsResponseCopyWithImpl<_SearchGroupsResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchGroupsResponse&&const DeepCollectionEquality().equals(other._results, _results));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'SearchGroupsResponse(results: $results)';
}


}

/// @nodoc
abstract mixin class _$SearchGroupsResponseCopyWith<$Res> implements $SearchGroupsResponseCopyWith<$Res> {
  factory _$SearchGroupsResponseCopyWith(_SearchGroupsResponse value, $Res Function(_SearchGroupsResponse) _then) = __$SearchGroupsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<domain.Group> results
});




}
/// @nodoc
class __$SearchGroupsResponseCopyWithImpl<$Res>
    implements _$SearchGroupsResponseCopyWith<$Res> {
  __$SearchGroupsResponseCopyWithImpl(this._self, this._then);

  final _SearchGroupsResponse _self;
  final $Res Function(_SearchGroupsResponse) _then;

/// Create a copy of SearchGroupsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,}) {
  return _then(_SearchGroupsResponse(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<domain.Group>,
  ));
}


}

// dart format on
