// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_comments_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonCommentsState {

 List<LessonComment> get comments; List<ScheduleComment> get scheduleComments;
/// Create a copy of LessonCommentsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCommentsStateCopyWith<LessonCommentsState> get copyWith => _$LessonCommentsStateCopyWithImpl<LessonCommentsState>(this as LessonCommentsState, _$identity);

  /// Serializes this LessonCommentsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonCommentsState&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.scheduleComments, scheduleComments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(scheduleComments));

@override
String toString() {
  return 'LessonCommentsState(comments: $comments, scheduleComments: $scheduleComments)';
}


}

/// @nodoc
abstract mixin class $LessonCommentsStateCopyWith<$Res>  {
  factory $LessonCommentsStateCopyWith(LessonCommentsState value, $Res Function(LessonCommentsState) _then) = _$LessonCommentsStateCopyWithImpl;
@useResult
$Res call({
 List<LessonComment> comments, List<ScheduleComment> scheduleComments
});




}
/// @nodoc
class _$LessonCommentsStateCopyWithImpl<$Res>
    implements $LessonCommentsStateCopyWith<$Res> {
  _$LessonCommentsStateCopyWithImpl(this._self, this._then);

  final LessonCommentsState _self;
  final $Res Function(LessonCommentsState) _then;

/// Create a copy of LessonCommentsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comments = null,Object? scheduleComments = null,}) {
  return _then(_self.copyWith(
comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<LessonComment>,scheduleComments: null == scheduleComments ? _self.scheduleComments : scheduleComments // ignore: cast_nullable_to_non_nullable
as List<ScheduleComment>,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonCommentsState].
extension LessonCommentsStatePatterns on LessonCommentsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonCommentsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonCommentsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonCommentsState value)  $default,){
final _that = this;
switch (_that) {
case _LessonCommentsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonCommentsState value)?  $default,){
final _that = this;
switch (_that) {
case _LessonCommentsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LessonComment> comments,  List<ScheduleComment> scheduleComments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonCommentsState() when $default != null:
return $default(_that.comments,_that.scheduleComments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LessonComment> comments,  List<ScheduleComment> scheduleComments)  $default,) {final _that = this;
switch (_that) {
case _LessonCommentsState():
return $default(_that.comments,_that.scheduleComments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LessonComment> comments,  List<ScheduleComment> scheduleComments)?  $default,) {final _that = this;
switch (_that) {
case _LessonCommentsState() when $default != null:
return $default(_that.comments,_that.scheduleComments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonCommentsState implements LessonCommentsState {
  const _LessonCommentsState({final  List<LessonComment> comments = const [], final  List<ScheduleComment> scheduleComments = const []}): _comments = comments,_scheduleComments = scheduleComments;
  factory _LessonCommentsState.fromJson(Map<String, dynamic> json) => _$LessonCommentsStateFromJson(json);

 final  List<LessonComment> _comments;
@override@JsonKey() List<LessonComment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

 final  List<ScheduleComment> _scheduleComments;
@override@JsonKey() List<ScheduleComment> get scheduleComments {
  if (_scheduleComments is EqualUnmodifiableListView) return _scheduleComments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scheduleComments);
}


/// Create a copy of LessonCommentsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonCommentsStateCopyWith<_LessonCommentsState> get copyWith => __$LessonCommentsStateCopyWithImpl<_LessonCommentsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonCommentsStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonCommentsState&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._scheduleComments, _scheduleComments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_scheduleComments));

@override
String toString() {
  return 'LessonCommentsState(comments: $comments, scheduleComments: $scheduleComments)';
}


}

/// @nodoc
abstract mixin class _$LessonCommentsStateCopyWith<$Res> implements $LessonCommentsStateCopyWith<$Res> {
  factory _$LessonCommentsStateCopyWith(_LessonCommentsState value, $Res Function(_LessonCommentsState) _then) = __$LessonCommentsStateCopyWithImpl;
@override @useResult
$Res call({
 List<LessonComment> comments, List<ScheduleComment> scheduleComments
});




}
/// @nodoc
class __$LessonCommentsStateCopyWithImpl<$Res>
    implements _$LessonCommentsStateCopyWith<$Res> {
  __$LessonCommentsStateCopyWithImpl(this._self, this._then);

  final _LessonCommentsState _self;
  final $Res Function(_LessonCommentsState) _then;

/// Create a copy of LessonCommentsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comments = null,Object? scheduleComments = null,}) {
  return _then(_LessonCommentsState(
comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<LessonComment>,scheduleComments: null == scheduleComments ? _self._scheduleComments : scheduleComments // ignore: cast_nullable_to_non_nullable
as List<ScheduleComment>,
  ));
}


}

// dart format on
