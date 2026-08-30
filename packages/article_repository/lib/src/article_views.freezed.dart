// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_views.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArticleViews {

 int get views; DateTime? get resetAt;
/// Create a copy of ArticleViews
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleViewsCopyWith<ArticleViews> get copyWith => _$ArticleViewsCopyWithImpl<ArticleViews>(this as ArticleViews, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticleViews&&(identical(other.views, views) || other.views == views)&&(identical(other.resetAt, resetAt) || other.resetAt == resetAt));
}


@override
int get hashCode => Object.hash(runtimeType,views,resetAt);

@override
String toString() {
  return 'ArticleViews(views: $views, resetAt: $resetAt)';
}


}

/// @nodoc
abstract mixin class $ArticleViewsCopyWith<$Res>  {
  factory $ArticleViewsCopyWith(ArticleViews value, $Res Function(ArticleViews) _then) = _$ArticleViewsCopyWithImpl;
@useResult
$Res call({
 int views, DateTime? resetAt
});




}
/// @nodoc
class _$ArticleViewsCopyWithImpl<$Res>
    implements $ArticleViewsCopyWith<$Res> {
  _$ArticleViewsCopyWithImpl(this._self, this._then);

  final ArticleViews _self;
  final $Res Function(ArticleViews) _then;

/// Create a copy of ArticleViews
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? views = null,Object? resetAt = freezed,}) {
  return _then(_self.copyWith(
views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,resetAt: freezed == resetAt ? _self.resetAt : resetAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ArticleViews].
extension ArticleViewsPatterns on ArticleViews {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArticleViews value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArticleViews() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArticleViews value)  $default,){
final _that = this;
switch (_that) {
case _ArticleViews():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArticleViews value)?  $default,){
final _that = this;
switch (_that) {
case _ArticleViews() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int views,  DateTime? resetAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArticleViews() when $default != null:
return $default(_that.views,_that.resetAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int views,  DateTime? resetAt)  $default,) {final _that = this;
switch (_that) {
case _ArticleViews():
return $default(_that.views,_that.resetAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int views,  DateTime? resetAt)?  $default,) {final _that = this;
switch (_that) {
case _ArticleViews() when $default != null:
return $default(_that.views,_that.resetAt);case _:
  return null;

}
}

}

/// @nodoc


class _ArticleViews implements ArticleViews {
  const _ArticleViews({required this.views, required this.resetAt});


@override final  int views;
@override final  DateTime? resetAt;

/// Create a copy of ArticleViews
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleViewsCopyWith<_ArticleViews> get copyWith => __$ArticleViewsCopyWithImpl<_ArticleViews>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArticleViews&&(identical(other.views, views) || other.views == views)&&(identical(other.resetAt, resetAt) || other.resetAt == resetAt));
}


@override
int get hashCode => Object.hash(runtimeType,views,resetAt);

@override
String toString() {
  return 'ArticleViews(views: $views, resetAt: $resetAt)';
}


}

/// @nodoc
abstract mixin class _$ArticleViewsCopyWith<$Res> implements $ArticleViewsCopyWith<$Res> {
  factory _$ArticleViewsCopyWith(_ArticleViews value, $Res Function(_ArticleViews) _then) = __$ArticleViewsCopyWithImpl;
@override @useResult
$Res call({
 int views, DateTime? resetAt
});




}
/// @nodoc
class __$ArticleViewsCopyWithImpl<$Res>
    implements _$ArticleViewsCopyWith<$Res> {
  __$ArticleViewsCopyWithImpl(this._self, this._then);

  final _ArticleViews _self;
  final $Res Function(_ArticleViews) _then;

/// Create a copy of ArticleViews
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? views = null,Object? resetAt = freezed,}) {
  return _then(_ArticleViews(
views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,resetAt: freezed == resetAt ? _self.resetAt : resetAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
