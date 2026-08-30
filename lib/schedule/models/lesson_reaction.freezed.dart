// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_reaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonReaction {

 String get subjectName; DateTime get lessonDate; LessonBells get lessonBells; ReactionType get reactionType; DateTime get createdAt;
/// Create a copy of LessonReaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonReactionCopyWith<LessonReaction> get copyWith => _$LessonReactionCopyWithImpl<LessonReaction>(this as LessonReaction, _$identity);

  /// Serializes this LessonReaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonReaction&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells)&&(identical(other.reactionType, reactionType) || other.reactionType == reactionType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectName,lessonDate,lessonBells,reactionType,createdAt);

@override
String toString() {
  return 'LessonReaction(subjectName: $subjectName, lessonDate: $lessonDate, lessonBells: $lessonBells, reactionType: $reactionType, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LessonReactionCopyWith<$Res>  {
  factory $LessonReactionCopyWith(LessonReaction value, $Res Function(LessonReaction) _then) = _$LessonReactionCopyWithImpl;
@useResult
$Res call({
 String subjectName, DateTime lessonDate, LessonBells lessonBells, ReactionType reactionType, DateTime createdAt
});


$LessonBellsCopyWith<$Res> get lessonBells;

}
/// @nodoc
class _$LessonReactionCopyWithImpl<$Res>
    implements $LessonReactionCopyWith<$Res> {
  _$LessonReactionCopyWithImpl(this._self, this._then);

  final LessonReaction _self;
  final $Res Function(LessonReaction) _then;

/// Create a copy of LessonReaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectName = null,Object? lessonDate = null,Object? lessonBells = null,Object? reactionType = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,lessonBells: null == lessonBells ? _self.lessonBells : lessonBells // ignore: cast_nullable_to_non_nullable
as LessonBells,reactionType: null == reactionType ? _self.reactionType : reactionType // ignore: cast_nullable_to_non_nullable
as ReactionType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of LessonReaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonBellsCopyWith<$Res> get lessonBells {

  return $LessonBellsCopyWith<$Res>(_self.lessonBells, (value) {
    return _then(_self.copyWith(lessonBells: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonReaction].
extension LessonReactionPatterns on LessonReaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonReaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonReaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonReaction value)  $default,){
final _that = this;
switch (_that) {
case _LessonReaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonReaction value)?  $default,){
final _that = this;
switch (_that) {
case _LessonReaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subjectName,  DateTime lessonDate,  LessonBells lessonBells,  ReactionType reactionType,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonReaction() when $default != null:
return $default(_that.subjectName,_that.lessonDate,_that.lessonBells,_that.reactionType,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subjectName,  DateTime lessonDate,  LessonBells lessonBells,  ReactionType reactionType,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _LessonReaction():
return $default(_that.subjectName,_that.lessonDate,_that.lessonBells,_that.reactionType,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subjectName,  DateTime lessonDate,  LessonBells lessonBells,  ReactionType reactionType,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LessonReaction() when $default != null:
return $default(_that.subjectName,_that.lessonDate,_that.lessonBells,_that.reactionType,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true, explicitToJson: true)
class _LessonReaction implements LessonReaction {
  const _LessonReaction({required this.subjectName, required this.lessonDate, required this.lessonBells, required this.reactionType, required this.createdAt});
  factory _LessonReaction.fromJson(Map<String, dynamic> json) => _$LessonReactionFromJson(json);

@override final  String subjectName;
@override final  DateTime lessonDate;
@override final  LessonBells lessonBells;
@override final  ReactionType reactionType;
@override final  DateTime createdAt;

/// Create a copy of LessonReaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonReactionCopyWith<_LessonReaction> get copyWith => __$LessonReactionCopyWithImpl<_LessonReaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonReactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonReaction&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells)&&(identical(other.reactionType, reactionType) || other.reactionType == reactionType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectName,lessonDate,lessonBells,reactionType,createdAt);

@override
String toString() {
  return 'LessonReaction(subjectName: $subjectName, lessonDate: $lessonDate, lessonBells: $lessonBells, reactionType: $reactionType, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LessonReactionCopyWith<$Res> implements $LessonReactionCopyWith<$Res> {
  factory _$LessonReactionCopyWith(_LessonReaction value, $Res Function(_LessonReaction) _then) = __$LessonReactionCopyWithImpl;
@override @useResult
$Res call({
 String subjectName, DateTime lessonDate, LessonBells lessonBells, ReactionType reactionType, DateTime createdAt
});


@override $LessonBellsCopyWith<$Res> get lessonBells;

}
/// @nodoc
class __$LessonReactionCopyWithImpl<$Res>
    implements _$LessonReactionCopyWith<$Res> {
  __$LessonReactionCopyWithImpl(this._self, this._then);

  final _LessonReaction _self;
  final $Res Function(_LessonReaction) _then;

/// Create a copy of LessonReaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectName = null,Object? lessonDate = null,Object? lessonBells = null,Object? reactionType = null,Object? createdAt = null,}) {
  return _then(_LessonReaction(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,lessonBells: null == lessonBells ? _self.lessonBells : lessonBells // ignore: cast_nullable_to_non_nullable
as LessonBells,reactionType: null == reactionType ? _self.reactionType : reactionType // ignore: cast_nullable_to_non_nullable
as ReactionType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of LessonReaction
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
