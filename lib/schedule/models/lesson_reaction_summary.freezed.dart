// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_reaction_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonReactionSummary {

 String get subjectName; DateTime get lessonDate; LessonBells get lessonBells; ReactionCounts get reactionCounts; ReactionType? get userReaction;
/// Create a copy of LessonReactionSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonReactionSummaryCopyWith<LessonReactionSummary> get copyWith => _$LessonReactionSummaryCopyWithImpl<LessonReactionSummary>(this as LessonReactionSummary, _$identity);

  /// Serializes this LessonReactionSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonReactionSummary&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells)&&(identical(other.reactionCounts, reactionCounts) || other.reactionCounts == reactionCounts)&&(identical(other.userReaction, userReaction) || other.userReaction == userReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectName,lessonDate,lessonBells,reactionCounts,userReaction);

@override
String toString() {
  return 'LessonReactionSummary(subjectName: $subjectName, lessonDate: $lessonDate, lessonBells: $lessonBells, reactionCounts: $reactionCounts, userReaction: $userReaction)';
}


}

/// @nodoc
abstract mixin class $LessonReactionSummaryCopyWith<$Res>  {
  factory $LessonReactionSummaryCopyWith(LessonReactionSummary value, $Res Function(LessonReactionSummary) _then) = _$LessonReactionSummaryCopyWithImpl;
@useResult
$Res call({
 String subjectName, DateTime lessonDate, LessonBells lessonBells, ReactionCounts reactionCounts, ReactionType? userReaction
});


$LessonBellsCopyWith<$Res> get lessonBells;$ReactionCountsCopyWith<$Res> get reactionCounts;

}
/// @nodoc
class _$LessonReactionSummaryCopyWithImpl<$Res>
    implements $LessonReactionSummaryCopyWith<$Res> {
  _$LessonReactionSummaryCopyWithImpl(this._self, this._then);

  final LessonReactionSummary _self;
  final $Res Function(LessonReactionSummary) _then;

/// Create a copy of LessonReactionSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectName = null,Object? lessonDate = null,Object? lessonBells = null,Object? reactionCounts = null,Object? userReaction = freezed,}) {
  return _then(_self.copyWith(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,lessonBells: null == lessonBells ? _self.lessonBells : lessonBells // ignore: cast_nullable_to_non_nullable
as LessonBells,reactionCounts: null == reactionCounts ? _self.reactionCounts : reactionCounts // ignore: cast_nullable_to_non_nullable
as ReactionCounts,userReaction: freezed == userReaction ? _self.userReaction : userReaction // ignore: cast_nullable_to_non_nullable
as ReactionType?,
  ));
}
/// Create a copy of LessonReactionSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonBellsCopyWith<$Res> get lessonBells {

  return $LessonBellsCopyWith<$Res>(_self.lessonBells, (value) {
    return _then(_self.copyWith(lessonBells: value));
  });
}/// Create a copy of LessonReactionSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReactionCountsCopyWith<$Res> get reactionCounts {

  return $ReactionCountsCopyWith<$Res>(_self.reactionCounts, (value) {
    return _then(_self.copyWith(reactionCounts: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonReactionSummary].
extension LessonReactionSummaryPatterns on LessonReactionSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonReactionSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonReactionSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonReactionSummary value)  $default,){
final _that = this;
switch (_that) {
case _LessonReactionSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonReactionSummary value)?  $default,){
final _that = this;
switch (_that) {
case _LessonReactionSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subjectName,  DateTime lessonDate,  LessonBells lessonBells,  ReactionCounts reactionCounts,  ReactionType? userReaction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonReactionSummary() when $default != null:
return $default(_that.subjectName,_that.lessonDate,_that.lessonBells,_that.reactionCounts,_that.userReaction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subjectName,  DateTime lessonDate,  LessonBells lessonBells,  ReactionCounts reactionCounts,  ReactionType? userReaction)  $default,) {final _that = this;
switch (_that) {
case _LessonReactionSummary():
return $default(_that.subjectName,_that.lessonDate,_that.lessonBells,_that.reactionCounts,_that.userReaction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subjectName,  DateTime lessonDate,  LessonBells lessonBells,  ReactionCounts reactionCounts,  ReactionType? userReaction)?  $default,) {final _that = this;
switch (_that) {
case _LessonReactionSummary() when $default != null:
return $default(_that.subjectName,_that.lessonDate,_that.lessonBells,_that.reactionCounts,_that.userReaction);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true, explicitToJson: true)
class _LessonReactionSummary extends LessonReactionSummary {
  const _LessonReactionSummary({required this.subjectName, required this.lessonDate, required this.lessonBells, this.reactionCounts = const ReactionCounts(), this.userReaction}): super._();
  factory _LessonReactionSummary.fromJson(Map<String, dynamic> json) => _$LessonReactionSummaryFromJson(json);

@override final  String subjectName;
@override final  DateTime lessonDate;
@override final  LessonBells lessonBells;
@override@JsonKey() final  ReactionCounts reactionCounts;
@override final  ReactionType? userReaction;

/// Create a copy of LessonReactionSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonReactionSummaryCopyWith<_LessonReactionSummary> get copyWith => __$LessonReactionSummaryCopyWithImpl<_LessonReactionSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonReactionSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonReactionSummary&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells)&&(identical(other.reactionCounts, reactionCounts) || other.reactionCounts == reactionCounts)&&(identical(other.userReaction, userReaction) || other.userReaction == userReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectName,lessonDate,lessonBells,reactionCounts,userReaction);

@override
String toString() {
  return 'LessonReactionSummary(subjectName: $subjectName, lessonDate: $lessonDate, lessonBells: $lessonBells, reactionCounts: $reactionCounts, userReaction: $userReaction)';
}


}

/// @nodoc
abstract mixin class _$LessonReactionSummaryCopyWith<$Res> implements $LessonReactionSummaryCopyWith<$Res> {
  factory _$LessonReactionSummaryCopyWith(_LessonReactionSummary value, $Res Function(_LessonReactionSummary) _then) = __$LessonReactionSummaryCopyWithImpl;
@override @useResult
$Res call({
 String subjectName, DateTime lessonDate, LessonBells lessonBells, ReactionCounts reactionCounts, ReactionType? userReaction
});


@override $LessonBellsCopyWith<$Res> get lessonBells;@override $ReactionCountsCopyWith<$Res> get reactionCounts;

}
/// @nodoc
class __$LessonReactionSummaryCopyWithImpl<$Res>
    implements _$LessonReactionSummaryCopyWith<$Res> {
  __$LessonReactionSummaryCopyWithImpl(this._self, this._then);

  final _LessonReactionSummary _self;
  final $Res Function(_LessonReactionSummary) _then;

/// Create a copy of LessonReactionSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectName = null,Object? lessonDate = null,Object? lessonBells = null,Object? reactionCounts = null,Object? userReaction = freezed,}) {
  return _then(_LessonReactionSummary(
subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,lessonBells: null == lessonBells ? _self.lessonBells : lessonBells // ignore: cast_nullable_to_non_nullable
as LessonBells,reactionCounts: null == reactionCounts ? _self.reactionCounts : reactionCounts // ignore: cast_nullable_to_non_nullable
as ReactionCounts,userReaction: freezed == userReaction ? _self.userReaction : userReaction // ignore: cast_nullable_to_non_nullable
as ReactionType?,
  ));
}

/// Create a copy of LessonReactionSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonBellsCopyWith<$Res> get lessonBells {

  return $LessonBellsCopyWith<$Res>(_self.lessonBells, (value) {
    return _then(_self.copyWith(lessonBells: value));
  });
}/// Create a copy of LessonReactionSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReactionCountsCopyWith<$Res> get reactionCounts {

  return $ReactionCountsCopyWith<$Res>(_self.reactionCounts, (value) {
    return _then(_self.copyWith(reactionCounts: value));
  });
}
}

// dart format on
