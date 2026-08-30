// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trending_search.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrendingSearch {

@JsonKey(defaultValue: '') String get query; int get count;
/// Create a copy of TrendingSearch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendingSearchCopyWith<TrendingSearch> get copyWith => _$TrendingSearchCopyWithImpl<TrendingSearch>(this as TrendingSearch, _$identity);

  /// Serializes this TrendingSearch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendingSearch&&(identical(other.query, query) || other.query == query)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,count);

@override
String toString() {
  return 'TrendingSearch(query: $query, count: $count)';
}


}

/// @nodoc
abstract mixin class $TrendingSearchCopyWith<$Res>  {
  factory $TrendingSearchCopyWith(TrendingSearch value, $Res Function(TrendingSearch) _then) = _$TrendingSearchCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String query, int count
});




}
/// @nodoc
class _$TrendingSearchCopyWithImpl<$Res>
    implements $TrendingSearchCopyWith<$Res> {
  _$TrendingSearchCopyWithImpl(this._self, this._then);

  final TrendingSearch _self;
  final $Res Function(TrendingSearch) _then;

/// Create a copy of TrendingSearch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? count = null,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TrendingSearch].
extension TrendingSearchPatterns on TrendingSearch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendingSearch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendingSearch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendingSearch value)  $default,){
final _that = this;
switch (_that) {
case _TrendingSearch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendingSearch value)?  $default,){
final _that = this;
switch (_that) {
case _TrendingSearch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String query,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendingSearch() when $default != null:
return $default(_that.query,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String query,  int count)  $default,) {final _that = this;
switch (_that) {
case _TrendingSearch():
return $default(_that.query,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String query,  int count)?  $default,) {final _that = this;
switch (_that) {
case _TrendingSearch() when $default != null:
return $default(_that.query,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrendingSearch implements TrendingSearch {
  const _TrendingSearch({@JsonKey(defaultValue: '') required this.query, this.count = 0});
  factory _TrendingSearch.fromJson(Map<String, dynamic> json) => _$TrendingSearchFromJson(json);

@override@JsonKey(defaultValue: '') final  String query;
@override@JsonKey() final  int count;

/// Create a copy of TrendingSearch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendingSearchCopyWith<_TrendingSearch> get copyWith => __$TrendingSearchCopyWithImpl<_TrendingSearch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrendingSearchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendingSearch&&(identical(other.query, query) || other.query == query)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,count);

@override
String toString() {
  return 'TrendingSearch(query: $query, count: $count)';
}


}

/// @nodoc
abstract mixin class _$TrendingSearchCopyWith<$Res> implements $TrendingSearchCopyWith<$Res> {
  factory _$TrendingSearchCopyWith(_TrendingSearch value, $Res Function(_TrendingSearch) _then) = __$TrendingSearchCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String query, int count
});




}
/// @nodoc
class __$TrendingSearchCopyWithImpl<$Res>
    implements _$TrendingSearchCopyWith<$Res> {
  __$TrendingSearchCopyWithImpl(this._self, this._then);

  final _TrendingSearch _self;
  final $Res Function(_TrendingSearch) _then;

/// Create a copy of TrendingSearch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? count = null,}) {
  return _then(_TrendingSearch(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
