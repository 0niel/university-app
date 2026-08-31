// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonReview {

 String get id; String get body; bool get isAnonymous; int get likeCount; String get authorName; DateTime get createdAt; int? get rating;
/// Create a copy of LessonReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonReviewCopyWith<LessonReview> get copyWith => _$LessonReviewCopyWithImpl<LessonReview>(this as LessonReview, _$identity);

  /// Serializes this LessonReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonReview&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,body,isAnonymous,likeCount,authorName,createdAt,rating);

@override
String toString() {
  return 'LessonReview(id: $id, body: $body, isAnonymous: $isAnonymous, likeCount: $likeCount, authorName: $authorName, createdAt: $createdAt, rating: $rating)';
}


}

/// @nodoc
abstract mixin class $LessonReviewCopyWith<$Res>  {
  factory $LessonReviewCopyWith(LessonReview value, $Res Function(LessonReview) _then) = _$LessonReviewCopyWithImpl;
@useResult
$Res call({
 String id, String body, bool isAnonymous, int likeCount, String authorName, DateTime createdAt, int? rating
});




}
/// @nodoc
class _$LessonReviewCopyWithImpl<$Res>
    implements $LessonReviewCopyWith<$Res> {
  _$LessonReviewCopyWithImpl(this._self, this._then);

  final LessonReview _self;
  final $Res Function(LessonReview) _then;

/// Create a copy of LessonReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? body = null,Object? isAnonymous = null,Object? likeCount = null,Object? authorName = null,Object? createdAt = null,Object? rating = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonReview].
extension LessonReviewPatterns on LessonReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonReview value)  $default,){
final _that = this;
switch (_that) {
case _LessonReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonReview value)?  $default,){
final _that = this;
switch (_that) {
case _LessonReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String body,  bool isAnonymous,  int likeCount,  String authorName,  DateTime createdAt,  int? rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonReview() when $default != null:
return $default(_that.id,_that.body,_that.isAnonymous,_that.likeCount,_that.authorName,_that.createdAt,_that.rating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String body,  bool isAnonymous,  int likeCount,  String authorName,  DateTime createdAt,  int? rating)  $default,) {final _that = this;
switch (_that) {
case _LessonReview():
return $default(_that.id,_that.body,_that.isAnonymous,_that.likeCount,_that.authorName,_that.createdAt,_that.rating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String body,  bool isAnonymous,  int likeCount,  String authorName,  DateTime createdAt,  int? rating)?  $default,) {final _that = this;
switch (_that) {
case _LessonReview() when $default != null:
return $default(_that.id,_that.body,_that.isAnonymous,_that.likeCount,_that.authorName,_that.createdAt,_that.rating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonReview implements LessonReview {
  const _LessonReview({required this.id, required this.body, required this.isAnonymous, required this.likeCount, required this.authorName, required this.createdAt, this.rating});
  factory _LessonReview.fromJson(Map<String, dynamic> json) => _$LessonReviewFromJson(json);

@override final  String id;
@override final  String body;
@override final  bool isAnonymous;
@override final  int likeCount;
@override final  String authorName;
@override final  DateTime createdAt;
@override final  int? rating;

/// Create a copy of LessonReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonReviewCopyWith<_LessonReview> get copyWith => __$LessonReviewCopyWithImpl<_LessonReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonReview&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,body,isAnonymous,likeCount,authorName,createdAt,rating);

@override
String toString() {
  return 'LessonReview(id: $id, body: $body, isAnonymous: $isAnonymous, likeCount: $likeCount, authorName: $authorName, createdAt: $createdAt, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$LessonReviewCopyWith<$Res> implements $LessonReviewCopyWith<$Res> {
  factory _$LessonReviewCopyWith(_LessonReview value, $Res Function(_LessonReview) _then) = __$LessonReviewCopyWithImpl;
@override @useResult
$Res call({
 String id, String body, bool isAnonymous, int likeCount, String authorName, DateTime createdAt, int? rating
});




}
/// @nodoc
class __$LessonReviewCopyWithImpl<$Res>
    implements _$LessonReviewCopyWith<$Res> {
  __$LessonReviewCopyWithImpl(this._self, this._then);

  final _LessonReview _self;
  final $Res Function(_LessonReview) _then;

/// Create a copy of LessonReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? body = null,Object? isAnonymous = null,Object? likeCount = null,Object? authorName = null,Object? createdAt = null,Object? rating = freezed,}) {
  return _then(_LessonReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
