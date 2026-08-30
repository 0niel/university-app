// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleComment {

 String get scheduleName; String get text;
/// Create a copy of ScheduleComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCommentCopyWith<ScheduleComment> get copyWith => _$ScheduleCommentCopyWithImpl<ScheduleComment>(this as ScheduleComment, _$identity);

  /// Serializes this ScheduleComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleComment&&(identical(other.scheduleName, scheduleName) || other.scheduleName == scheduleName)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scheduleName,text);

@override
String toString() {
  return 'ScheduleComment(scheduleName: $scheduleName, text: $text)';
}


}

/// @nodoc
abstract mixin class $ScheduleCommentCopyWith<$Res>  {
  factory $ScheduleCommentCopyWith(ScheduleComment value, $Res Function(ScheduleComment) _then) = _$ScheduleCommentCopyWithImpl;
@useResult
$Res call({
 String scheduleName, String text
});




}
/// @nodoc
class _$ScheduleCommentCopyWithImpl<$Res>
    implements $ScheduleCommentCopyWith<$Res> {
  _$ScheduleCommentCopyWithImpl(this._self, this._then);

  final ScheduleComment _self;
  final $Res Function(ScheduleComment) _then;

/// Create a copy of ScheduleComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleName = null,Object? text = null,}) {
  return _then(_self.copyWith(
scheduleName: null == scheduleName ? _self.scheduleName : scheduleName // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleComment].
extension ScheduleCommentPatterns on ScheduleComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleComment value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleComment value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String scheduleName,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleComment() when $default != null:
return $default(_that.scheduleName,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String scheduleName,  String text)  $default,) {final _that = this;
switch (_that) {
case _ScheduleComment():
return $default(_that.scheduleName,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String scheduleName,  String text)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleComment() when $default != null:
return $default(_that.scheduleName,_that.text);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true)
class _ScheduleComment implements ScheduleComment {
  const _ScheduleComment({required this.scheduleName, required this.text});
  factory _ScheduleComment.fromJson(Map<String, dynamic> json) => _$ScheduleCommentFromJson(json);

@override final  String scheduleName;
@override final  String text;

/// Create a copy of ScheduleComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCommentCopyWith<_ScheduleComment> get copyWith => __$ScheduleCommentCopyWithImpl<_ScheduleComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleComment&&(identical(other.scheduleName, scheduleName) || other.scheduleName == scheduleName)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scheduleName,text);

@override
String toString() {
  return 'ScheduleComment(scheduleName: $scheduleName, text: $text)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCommentCopyWith<$Res> implements $ScheduleCommentCopyWith<$Res> {
  factory _$ScheduleCommentCopyWith(_ScheduleComment value, $Res Function(_ScheduleComment) _then) = __$ScheduleCommentCopyWithImpl;
@override @useResult
$Res call({
 String scheduleName, String text
});




}
/// @nodoc
class __$ScheduleCommentCopyWithImpl<$Res>
    implements _$ScheduleCommentCopyWith<$Res> {
  __$ScheduleCommentCopyWithImpl(this._self, this._then);

  final _ScheduleComment _self;
  final $Res Function(_ScheduleComment) _then;

/// Create a copy of ScheduleComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleName = null,Object? text = null,}) {
  return _then(_ScheduleComment(
scheduleName: null == scheduleName ? _self.scheduleName : scheduleName // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
