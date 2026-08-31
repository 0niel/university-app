// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upsert_lesson_review_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpsertLessonReviewRequest {

 String get subjectName; DateTime get lessonDate; int get lessonBellsNumber; String get body; bool get isAnonymous; String? get lessonUid; int? get rating;
/// Create a copy of UpsertLessonReviewRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpsertLessonReviewRequestCopyWith<UpsertLessonReviewRequest> get copyWith => _$UpsertLessonReviewRequestCopyWithImpl<UpsertLessonReviewRequest>(this as UpsertLessonReviewRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpsertLessonReviewRequest&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.lessonBellsNumber, lessonBellsNumber) || other.lessonBellsNumber == lessonBellsNumber)&&(identical(other.body, body) || other.body == body)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.lessonUid, lessonUid) || other.lessonUid == lessonUid)&&(identical(other.rating, rating) || other.rating == rating));
}


@override
int get hashCode => Object.hash(runtimeType,subjectName,lessonDate,lessonBellsNumber,body,isAnonymous,lessonUid,rating);

@override
String toString() {
  return 'UpsertLessonReviewRequest(subjectName: $subjectName, lessonDate: $lessonDate, lessonBellsNumber: $lessonBellsNumber, body: $body, isAnonymous: $isAnonymous, lessonUid: $lessonUid, rating: $rating)';
}


}

/// @nodoc
abstract mixin class $UpsertLessonReviewRequestCopyWith<$Res>  {
  factory $UpsertLessonReviewRequestCopyWith(UpsertLessonReviewRequest value, $Res Function(UpsertLessonReviewRequest) _then) = _$UpsertLessonReviewRequestCopyWithImpl;
@useResult
$Res call({
 String subjectName, DateTime lessonDate, int lessonBellsNumber, String body, bool isAnonymous, String? lessonUid, int? rating
});




}
/// @nodoc
class _$UpsertLessonReviewRequestCopyWithImpl<$Res>
    implements $UpsertLessonReviewRequestCopyWith<$Res> {
  _$UpsertLessonReviewRequestCopyWithImpl(this._self, this._then);

  final UpsertLessonReviewRequest _self;
  final $Res Function(UpsertLessonReviewRequest) _then;

/// Create a copy of UpsertLessonReviewRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectName = null,Object? lessonDate = null,Object? lessonBellsNumber = null,Object? body = null,Object? isAnonymous = null,Object? lessonUid = freezed,Object? rating = freezed,}) {
  return _then(_self.copyWith(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,lessonBellsNumber: null == lessonBellsNumber ? _self.lessonBellsNumber : lessonBellsNumber // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,lessonUid: freezed == lessonUid ? _self.lessonUid : lessonUid // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpsertLessonReviewRequest].
extension UpsertLessonReviewRequestPatterns on UpsertLessonReviewRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpsertLessonReviewRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpsertLessonReviewRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpsertLessonReviewRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpsertLessonReviewRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpsertLessonReviewRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpsertLessonReviewRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subjectName,  DateTime lessonDate,  int lessonBellsNumber,  String body,  bool isAnonymous,  String? lessonUid,  int? rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpsertLessonReviewRequest() when $default != null:
return $default(_that.subjectName,_that.lessonDate,_that.lessonBellsNumber,_that.body,_that.isAnonymous,_that.lessonUid,_that.rating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subjectName,  DateTime lessonDate,  int lessonBellsNumber,  String body,  bool isAnonymous,  String? lessonUid,  int? rating)  $default,) {final _that = this;
switch (_that) {
case _UpsertLessonReviewRequest():
return $default(_that.subjectName,_that.lessonDate,_that.lessonBellsNumber,_that.body,_that.isAnonymous,_that.lessonUid,_that.rating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subjectName,  DateTime lessonDate,  int lessonBellsNumber,  String body,  bool isAnonymous,  String? lessonUid,  int? rating)?  $default,) {final _that = this;
switch (_that) {
case _UpsertLessonReviewRequest() when $default != null:
return $default(_that.subjectName,_that.lessonDate,_that.lessonBellsNumber,_that.body,_that.isAnonymous,_that.lessonUid,_that.rating);case _:
  return null;

}
}

}

/// @nodoc


class _UpsertLessonReviewRequest implements UpsertLessonReviewRequest {
  const _UpsertLessonReviewRequest({required this.subjectName, required this.lessonDate, required this.lessonBellsNumber, required this.body, required this.isAnonymous, this.lessonUid, this.rating});


@override final  String subjectName;
@override final  DateTime lessonDate;
@override final  int lessonBellsNumber;
@override final  String body;
@override final  bool isAnonymous;
@override final  String? lessonUid;
@override final  int? rating;

/// Create a copy of UpsertLessonReviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpsertLessonReviewRequestCopyWith<_UpsertLessonReviewRequest> get copyWith => __$UpsertLessonReviewRequestCopyWithImpl<_UpsertLessonReviewRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpsertLessonReviewRequest&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.lessonBellsNumber, lessonBellsNumber) || other.lessonBellsNumber == lessonBellsNumber)&&(identical(other.body, body) || other.body == body)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.lessonUid, lessonUid) || other.lessonUid == lessonUid)&&(identical(other.rating, rating) || other.rating == rating));
}


@override
int get hashCode => Object.hash(runtimeType,subjectName,lessonDate,lessonBellsNumber,body,isAnonymous,lessonUid,rating);

@override
String toString() {
  return 'UpsertLessonReviewRequest(subjectName: $subjectName, lessonDate: $lessonDate, lessonBellsNumber: $lessonBellsNumber, body: $body, isAnonymous: $isAnonymous, lessonUid: $lessonUid, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$UpsertLessonReviewRequestCopyWith<$Res> implements $UpsertLessonReviewRequestCopyWith<$Res> {
  factory _$UpsertLessonReviewRequestCopyWith(_UpsertLessonReviewRequest value, $Res Function(_UpsertLessonReviewRequest) _then) = __$UpsertLessonReviewRequestCopyWithImpl;
@override @useResult
$Res call({
 String subjectName, DateTime lessonDate, int lessonBellsNumber, String body, bool isAnonymous, String? lessonUid, int? rating
});




}
/// @nodoc
class __$UpsertLessonReviewRequestCopyWithImpl<$Res>
    implements _$UpsertLessonReviewRequestCopyWith<$Res> {
  __$UpsertLessonReviewRequestCopyWithImpl(this._self, this._then);

  final _UpsertLessonReviewRequest _self;
  final $Res Function(_UpsertLessonReviewRequest) _then;

/// Create a copy of UpsertLessonReviewRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectName = null,Object? lessonDate = null,Object? lessonBellsNumber = null,Object? body = null,Object? isAnonymous = null,Object? lessonUid = freezed,Object? rating = freezed,}) {
  return _then(_UpsertLessonReviewRequest(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,lessonBellsNumber: null == lessonBellsNumber ? _self.lessonBellsNumber : lessonBellsNumber // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,lessonUid: freezed == lessonUid ? _self.lessonUid : lessonUid // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
