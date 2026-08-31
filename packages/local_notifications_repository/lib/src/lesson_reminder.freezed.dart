// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonReminder {

 int get id; String get title; String get body; DateTime get when;
/// Create a copy of LessonReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonReminderCopyWith<LessonReminder> get copyWith => _$LessonReminderCopyWithImpl<LessonReminder>(this as LessonReminder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonReminder&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.when, when) || other.when == when));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,body,when);

@override
String toString() {
  return 'LessonReminder(id: $id, title: $title, body: $body, when: $when)';
}


}

/// @nodoc
abstract mixin class $LessonReminderCopyWith<$Res>  {
  factory $LessonReminderCopyWith(LessonReminder value, $Res Function(LessonReminder) _then) = _$LessonReminderCopyWithImpl;
@useResult
$Res call({
 int id, String title, String body, DateTime when
});




}
/// @nodoc
class _$LessonReminderCopyWithImpl<$Res>
    implements $LessonReminderCopyWith<$Res> {
  _$LessonReminderCopyWithImpl(this._self, this._then);

  final LessonReminder _self;
  final $Res Function(LessonReminder) _then;

/// Create a copy of LessonReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? when = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,when: null == when ? _self.when : when // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonReminder].
extension LessonReminderPatterns on LessonReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonReminder value)  $default,){
final _that = this;
switch (_that) {
case _LessonReminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonReminder value)?  $default,){
final _that = this;
switch (_that) {
case _LessonReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String body,  DateTime when)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonReminder() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.when);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String body,  DateTime when)  $default,) {final _that = this;
switch (_that) {
case _LessonReminder():
return $default(_that.id,_that.title,_that.body,_that.when);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String body,  DateTime when)?  $default,) {final _that = this;
switch (_that) {
case _LessonReminder() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.when);case _:
  return null;

}
}

}

/// @nodoc


class _LessonReminder implements LessonReminder {
  const _LessonReminder({required this.id, required this.title, required this.body, required this.when});


@override final  int id;
@override final  String title;
@override final  String body;
@override final  DateTime when;

/// Create a copy of LessonReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonReminderCopyWith<_LessonReminder> get copyWith => __$LessonReminderCopyWithImpl<_LessonReminder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonReminder&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.when, when) || other.when == when));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,body,when);

@override
String toString() {
  return 'LessonReminder(id: $id, title: $title, body: $body, when: $when)';
}


}

/// @nodoc
abstract mixin class _$LessonReminderCopyWith<$Res> implements $LessonReminderCopyWith<$Res> {
  factory _$LessonReminderCopyWith(_LessonReminder value, $Res Function(_LessonReminder) _then) = __$LessonReminderCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String body, DateTime when
});




}
/// @nodoc
class __$LessonReminderCopyWithImpl<$Res>
    implements _$LessonReminderCopyWith<$Res> {
  __$LessonReminderCopyWithImpl(this._self, this._then);

  final _LessonReminder _self;
  final $Res Function(_LessonReminder) _then;

/// Create a copy of LessonReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? when = null,}) {
  return _then(_LessonReminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,when: null == when ? _self.when : when // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
