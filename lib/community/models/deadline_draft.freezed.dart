// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deadline_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeadlineDraft {

 String get title; DateTime get dueAt; DeadlineSource get source; String get subjectName; DeadlinePriority get priority; bool get remind; int get remindMinutes;
/// Create a copy of DeadlineDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeadlineDraftCopyWith<DeadlineDraft> get copyWith => _$DeadlineDraftCopyWithImpl<DeadlineDraft>(this as DeadlineDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeadlineDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.remind, remind) || other.remind == remind)&&(identical(other.remindMinutes, remindMinutes) || other.remindMinutes == remindMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,title,dueAt,source,subjectName,priority,remind,remindMinutes);

@override
String toString() {
  return 'DeadlineDraft(title: $title, dueAt: $dueAt, source: $source, subjectName: $subjectName, priority: $priority, remind: $remind, remindMinutes: $remindMinutes)';
}


}

/// @nodoc
abstract mixin class $DeadlineDraftCopyWith<$Res>  {
  factory $DeadlineDraftCopyWith(DeadlineDraft value, $Res Function(DeadlineDraft) _then) = _$DeadlineDraftCopyWithImpl;
@useResult
$Res call({
 String title, DateTime dueAt, DeadlineSource source, String subjectName, DeadlinePriority priority, bool remind, int remindMinutes
});




}
/// @nodoc
class _$DeadlineDraftCopyWithImpl<$Res>
    implements $DeadlineDraftCopyWith<$Res> {
  _$DeadlineDraftCopyWithImpl(this._self, this._then);

  final DeadlineDraft _self;
  final $Res Function(DeadlineDraft) _then;

/// Create a copy of DeadlineDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? dueAt = null,Object? source = null,Object? subjectName = null,Object? priority = null,Object? remind = null,Object? remindMinutes = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DeadlineSource,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as DeadlinePriority,remind: null == remind ? _self.remind : remind // ignore: cast_nullable_to_non_nullable
as bool,remindMinutes: null == remindMinutes ? _self.remindMinutes : remindMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeadlineDraft].
extension DeadlineDraftPatterns on DeadlineDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeadlineDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeadlineDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeadlineDraft value)  $default,){
final _that = this;
switch (_that) {
case _DeadlineDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeadlineDraft value)?  $default,){
final _that = this;
switch (_that) {
case _DeadlineDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  DateTime dueAt,  DeadlineSource source,  String subjectName,  DeadlinePriority priority,  bool remind,  int remindMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeadlineDraft() when $default != null:
return $default(_that.title,_that.dueAt,_that.source,_that.subjectName,_that.priority,_that.remind,_that.remindMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  DateTime dueAt,  DeadlineSource source,  String subjectName,  DeadlinePriority priority,  bool remind,  int remindMinutes)  $default,) {final _that = this;
switch (_that) {
case _DeadlineDraft():
return $default(_that.title,_that.dueAt,_that.source,_that.subjectName,_that.priority,_that.remind,_that.remindMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  DateTime dueAt,  DeadlineSource source,  String subjectName,  DeadlinePriority priority,  bool remind,  int remindMinutes)?  $default,) {final _that = this;
switch (_that) {
case _DeadlineDraft() when $default != null:
return $default(_that.title,_that.dueAt,_that.source,_that.subjectName,_that.priority,_that.remind,_that.remindMinutes);case _:
  return null;

}
}

}

/// @nodoc


class _DeadlineDraft implements DeadlineDraft {
  const _DeadlineDraft({required this.title, required this.dueAt, required this.source, this.subjectName = '', this.priority = DeadlinePriority.medium, this.remind = true, this.remindMinutes = 60});


@override final  String title;
@override final  DateTime dueAt;
@override final  DeadlineSource source;
@override@JsonKey() final  String subjectName;
@override@JsonKey() final  DeadlinePriority priority;
@override@JsonKey() final  bool remind;
@override@JsonKey() final  int remindMinutes;

/// Create a copy of DeadlineDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeadlineDraftCopyWith<_DeadlineDraft> get copyWith => __$DeadlineDraftCopyWithImpl<_DeadlineDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeadlineDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.remind, remind) || other.remind == remind)&&(identical(other.remindMinutes, remindMinutes) || other.remindMinutes == remindMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,title,dueAt,source,subjectName,priority,remind,remindMinutes);

@override
String toString() {
  return 'DeadlineDraft(title: $title, dueAt: $dueAt, source: $source, subjectName: $subjectName, priority: $priority, remind: $remind, remindMinutes: $remindMinutes)';
}


}

/// @nodoc
abstract mixin class _$DeadlineDraftCopyWith<$Res> implements $DeadlineDraftCopyWith<$Res> {
  factory _$DeadlineDraftCopyWith(_DeadlineDraft value, $Res Function(_DeadlineDraft) _then) = __$DeadlineDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, DateTime dueAt, DeadlineSource source, String subjectName, DeadlinePriority priority, bool remind, int remindMinutes
});




}
/// @nodoc
class __$DeadlineDraftCopyWithImpl<$Res>
    implements _$DeadlineDraftCopyWith<$Res> {
  __$DeadlineDraftCopyWithImpl(this._self, this._then);

  final _DeadlineDraft _self;
  final $Res Function(_DeadlineDraft) _then;

/// Create a copy of DeadlineDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? dueAt = null,Object? source = null,Object? subjectName = null,Object? priority = null,Object? remind = null,Object? remindMinutes = null,}) {
  return _then(_DeadlineDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DeadlineSource,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as DeadlinePriority,remind: null == remind ? _self.remind : remind // ignore: cast_nullable_to_non_nullable
as bool,remindMinutes: null == remindMinutes ? _self.remindMinutes : remindMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
