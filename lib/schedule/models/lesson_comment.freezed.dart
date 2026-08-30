// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonComment {

 String get subjectName; DateTime get lessonDate; LessonBells get lessonBells; String get text; bool get isSharedWithGroup;
/// Create a copy of LessonComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCommentCopyWith<LessonComment> get copyWith => _$LessonCommentCopyWithImpl<LessonComment>(this as LessonComment, _$identity);

  /// Serializes this LessonComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonComment&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells)&&(identical(other.text, text) || other.text == text)&&(identical(other.isSharedWithGroup, isSharedWithGroup) || other.isSharedWithGroup == isSharedWithGroup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectName,lessonDate,lessonBells,text,isSharedWithGroup);

@override
String toString() {
  return 'LessonComment(subjectName: $subjectName, lessonDate: $lessonDate, lessonBells: $lessonBells, text: $text, isSharedWithGroup: $isSharedWithGroup)';
}


}

/// @nodoc
abstract mixin class $LessonCommentCopyWith<$Res>  {
  factory $LessonCommentCopyWith(LessonComment value, $Res Function(LessonComment) _then) = _$LessonCommentCopyWithImpl;
@useResult
$Res call({
 String subjectName, DateTime lessonDate, LessonBells lessonBells, String text, bool isSharedWithGroup
});


$LessonBellsCopyWith<$Res> get lessonBells;

}
/// @nodoc
class _$LessonCommentCopyWithImpl<$Res>
    implements $LessonCommentCopyWith<$Res> {
  _$LessonCommentCopyWithImpl(this._self, this._then);

  final LessonComment _self;
  final $Res Function(LessonComment) _then;

/// Create a copy of LessonComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectName = null,Object? lessonDate = null,Object? lessonBells = null,Object? text = null,Object? isSharedWithGroup = null,}) {
  return _then(_self.copyWith(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,lessonBells: null == lessonBells ? _self.lessonBells : lessonBells // ignore: cast_nullable_to_non_nullable
as LessonBells,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isSharedWithGroup: null == isSharedWithGroup ? _self.isSharedWithGroup : isSharedWithGroup // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LessonComment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonBellsCopyWith<$Res> get lessonBells {

  return $LessonBellsCopyWith<$Res>(_self.lessonBells, (value) {
    return _then(_self.copyWith(lessonBells: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonComment].
extension LessonCommentPatterns on LessonComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonComment value)  $default,){
final _that = this;
switch (_that) {
case _LessonComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonComment value)?  $default,){
final _that = this;
switch (_that) {
case _LessonComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subjectName,  DateTime lessonDate,  LessonBells lessonBells,  String text,  bool isSharedWithGroup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonComment() when $default != null:
return $default(_that.subjectName,_that.lessonDate,_that.lessonBells,_that.text,_that.isSharedWithGroup);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subjectName,  DateTime lessonDate,  LessonBells lessonBells,  String text,  bool isSharedWithGroup)  $default,) {final _that = this;
switch (_that) {
case _LessonComment():
return $default(_that.subjectName,_that.lessonDate,_that.lessonBells,_that.text,_that.isSharedWithGroup);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subjectName,  DateTime lessonDate,  LessonBells lessonBells,  String text,  bool isSharedWithGroup)?  $default,) {final _that = this;
switch (_that) {
case _LessonComment() when $default != null:
return $default(_that.subjectName,_that.lessonDate,_that.lessonBells,_that.text,_that.isSharedWithGroup);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true, explicitToJson: true)
class _LessonComment implements LessonComment {
  const _LessonComment({required this.subjectName, required this.lessonDate, required this.lessonBells, required this.text, this.isSharedWithGroup = false});
  factory _LessonComment.fromJson(Map<String, dynamic> json) => _$LessonCommentFromJson(json);

@override final  String subjectName;
@override final  DateTime lessonDate;
@override final  LessonBells lessonBells;
@override final  String text;
@override@JsonKey() final  bool isSharedWithGroup;

/// Create a copy of LessonComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonCommentCopyWith<_LessonComment> get copyWith => __$LessonCommentCopyWithImpl<_LessonComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonComment&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells)&&(identical(other.text, text) || other.text == text)&&(identical(other.isSharedWithGroup, isSharedWithGroup) || other.isSharedWithGroup == isSharedWithGroup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectName,lessonDate,lessonBells,text,isSharedWithGroup);

@override
String toString() {
  return 'LessonComment(subjectName: $subjectName, lessonDate: $lessonDate, lessonBells: $lessonBells, text: $text, isSharedWithGroup: $isSharedWithGroup)';
}


}

/// @nodoc
abstract mixin class _$LessonCommentCopyWith<$Res> implements $LessonCommentCopyWith<$Res> {
  factory _$LessonCommentCopyWith(_LessonComment value, $Res Function(_LessonComment) _then) = __$LessonCommentCopyWithImpl;
@override @useResult
$Res call({
 String subjectName, DateTime lessonDate, LessonBells lessonBells, String text, bool isSharedWithGroup
});


@override $LessonBellsCopyWith<$Res> get lessonBells;

}
/// @nodoc
class __$LessonCommentCopyWithImpl<$Res>
    implements _$LessonCommentCopyWith<$Res> {
  __$LessonCommentCopyWithImpl(this._self, this._then);

  final _LessonComment _self;
  final $Res Function(_LessonComment) _then;

/// Create a copy of LessonComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectName = null,Object? lessonDate = null,Object? lessonBells = null,Object? text = null,Object? isSharedWithGroup = null,}) {
  return _then(_LessonComment(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,lessonBells: null == lessonBells ? _self.lessonBells : lessonBells // ignore: cast_nullable_to_non_nullable
as LessonBells,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isSharedWithGroup: null == isSharedWithGroup ? _self.isSharedWithGroup : isSharedWithGroup // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LessonComment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonBellsCopyWith<$Res> get lessonBells {

  return $LessonBellsCopyWith<$Res>(_self.lessonBells, (value) {
    return _then(_self.copyWith(lessonBells: value));
  });
}
}

// dart format on
