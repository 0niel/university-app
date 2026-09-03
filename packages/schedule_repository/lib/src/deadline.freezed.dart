// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deadline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Deadline {

@_NonEmptyStringConverter() String get id;@_NonEmptyStringConverter() String get title;@_LocalDateTimeConverter() DateTime get dueAt;@JsonKey(unknownEnumValue: DeadlineSource.me) DeadlineSource get source; String get subjectName;@_DeadlineProgressConverter() int get progress; bool get isDone; bool get isMine;@JsonKey(unknownEnumValue: DeadlinePriority.medium) DeadlinePriority get priority; bool get remind; int get remindMinutes;
/// Create a copy of Deadline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeadlineCopyWith<Deadline> get copyWith => _$DeadlineCopyWithImpl<Deadline>(this as Deadline, _$identity);

  /// Serializes this Deadline to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Deadline&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.remind, remind) || other.remind == remind)&&(identical(other.remindMinutes, remindMinutes) || other.remindMinutes == remindMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,dueAt,source,subjectName,progress,isDone,isMine,priority,remind,remindMinutes);

@override
String toString() {
  return 'Deadline(id: $id, title: $title, dueAt: $dueAt, source: $source, subjectName: $subjectName, progress: $progress, isDone: $isDone, isMine: $isMine, priority: $priority, remind: $remind, remindMinutes: $remindMinutes)';
}


}

/// @nodoc
abstract mixin class $DeadlineCopyWith<$Res>  {
  factory $DeadlineCopyWith(Deadline value, $Res Function(Deadline) _then) = _$DeadlineCopyWithImpl;
@useResult
$Res call({
@_NonEmptyStringConverter() String id,@_NonEmptyStringConverter() String title,@_LocalDateTimeConverter() DateTime dueAt,@JsonKey(unknownEnumValue: DeadlineSource.me) DeadlineSource source, String subjectName,@_DeadlineProgressConverter() int progress, bool isDone, bool isMine,@JsonKey(unknownEnumValue: DeadlinePriority.medium) DeadlinePriority priority, bool remind, int remindMinutes
});




}
/// @nodoc
class _$DeadlineCopyWithImpl<$Res>
    implements $DeadlineCopyWith<$Res> {
  _$DeadlineCopyWithImpl(this._self, this._then);

  final Deadline _self;
  final $Res Function(Deadline) _then;

/// Create a copy of Deadline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? dueAt = null,Object? source = null,Object? subjectName = null,Object? progress = null,Object? isDone = null,Object? isMine = null,Object? priority = null,Object? remind = null,Object? remindMinutes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DeadlineSource,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as DeadlinePriority,remind: null == remind ? _self.remind : remind // ignore: cast_nullable_to_non_nullable
as bool,remindMinutes: null == remindMinutes ? _self.remindMinutes : remindMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Deadline].
extension DeadlinePatterns on Deadline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Deadline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Deadline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Deadline value)  $default,){
final _that = this;
switch (_that) {
case _Deadline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Deadline value)?  $default,){
final _that = this;
switch (_that) {
case _Deadline() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@_NonEmptyStringConverter()  String id, @_NonEmptyStringConverter()  String title, @_LocalDateTimeConverter()  DateTime dueAt, @JsonKey(unknownEnumValue: DeadlineSource.me)  DeadlineSource source,  String subjectName, @_DeadlineProgressConverter()  int progress,  bool isDone,  bool isMine, @JsonKey(unknownEnumValue: DeadlinePriority.medium)  DeadlinePriority priority,  bool remind,  int remindMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Deadline() when $default != null:
return $default(_that.id,_that.title,_that.dueAt,_that.source,_that.subjectName,_that.progress,_that.isDone,_that.isMine,_that.priority,_that.remind,_that.remindMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@_NonEmptyStringConverter()  String id, @_NonEmptyStringConverter()  String title, @_LocalDateTimeConverter()  DateTime dueAt, @JsonKey(unknownEnumValue: DeadlineSource.me)  DeadlineSource source,  String subjectName, @_DeadlineProgressConverter()  int progress,  bool isDone,  bool isMine, @JsonKey(unknownEnumValue: DeadlinePriority.medium)  DeadlinePriority priority,  bool remind,  int remindMinutes)  $default,) {final _that = this;
switch (_that) {
case _Deadline():
return $default(_that.id,_that.title,_that.dueAt,_that.source,_that.subjectName,_that.progress,_that.isDone,_that.isMine,_that.priority,_that.remind,_that.remindMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@_NonEmptyStringConverter()  String id, @_NonEmptyStringConverter()  String title, @_LocalDateTimeConverter()  DateTime dueAt, @JsonKey(unknownEnumValue: DeadlineSource.me)  DeadlineSource source,  String subjectName, @_DeadlineProgressConverter()  int progress,  bool isDone,  bool isMine, @JsonKey(unknownEnumValue: DeadlinePriority.medium)  DeadlinePriority priority,  bool remind,  int remindMinutes)?  $default,) {final _that = this;
switch (_that) {
case _Deadline() when $default != null:
return $default(_that.id,_that.title,_that.dueAt,_that.source,_that.subjectName,_that.progress,_that.isDone,_that.isMine,_that.priority,_that.remind,_that.remindMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Deadline extends Deadline {
  const _Deadline({@_NonEmptyStringConverter() required this.id, @_NonEmptyStringConverter() required this.title, @_LocalDateTimeConverter() required this.dueAt, @JsonKey(unknownEnumValue: DeadlineSource.me) required this.source, this.subjectName = '', @_DeadlineProgressConverter() this.progress = 0, this.isDone = false, this.isMine = false, @JsonKey(unknownEnumValue: DeadlinePriority.medium) this.priority = DeadlinePriority.medium, this.remind = true, this.remindMinutes = 60}): super._();
  factory _Deadline.fromJson(Map<String, dynamic> json) => _$DeadlineFromJson(json);

@override@_NonEmptyStringConverter() final  String id;
@override@_NonEmptyStringConverter() final  String title;
@override@_LocalDateTimeConverter() final  DateTime dueAt;
@override@JsonKey(unknownEnumValue: DeadlineSource.me) final  DeadlineSource source;
@override@JsonKey() final  String subjectName;
@override@JsonKey()@_DeadlineProgressConverter() final  int progress;
@override@JsonKey() final  bool isDone;
@override@JsonKey() final  bool isMine;
@override@JsonKey(unknownEnumValue: DeadlinePriority.medium) final  DeadlinePriority priority;
@override@JsonKey() final  bool remind;
@override@JsonKey() final  int remindMinutes;

/// Create a copy of Deadline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeadlineCopyWith<_Deadline> get copyWith => __$DeadlineCopyWithImpl<_Deadline>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeadlineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Deadline&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.remind, remind) || other.remind == remind)&&(identical(other.remindMinutes, remindMinutes) || other.remindMinutes == remindMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,dueAt,source,subjectName,progress,isDone,isMine,priority,remind,remindMinutes);

@override
String toString() {
  return 'Deadline(id: $id, title: $title, dueAt: $dueAt, source: $source, subjectName: $subjectName, progress: $progress, isDone: $isDone, isMine: $isMine, priority: $priority, remind: $remind, remindMinutes: $remindMinutes)';
}


}

/// @nodoc
abstract mixin class _$DeadlineCopyWith<$Res> implements $DeadlineCopyWith<$Res> {
  factory _$DeadlineCopyWith(_Deadline value, $Res Function(_Deadline) _then) = __$DeadlineCopyWithImpl;
@override @useResult
$Res call({
@_NonEmptyStringConverter() String id,@_NonEmptyStringConverter() String title,@_LocalDateTimeConverter() DateTime dueAt,@JsonKey(unknownEnumValue: DeadlineSource.me) DeadlineSource source, String subjectName,@_DeadlineProgressConverter() int progress, bool isDone, bool isMine,@JsonKey(unknownEnumValue: DeadlinePriority.medium) DeadlinePriority priority, bool remind, int remindMinutes
});




}
/// @nodoc
class __$DeadlineCopyWithImpl<$Res>
    implements _$DeadlineCopyWith<$Res> {
  __$DeadlineCopyWithImpl(this._self, this._then);

  final _Deadline _self;
  final $Res Function(_Deadline) _then;

/// Create a copy of Deadline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? dueAt = null,Object? source = null,Object? subjectName = null,Object? progress = null,Object? isDone = null,Object? isMine = null,Object? priority = null,Object? remind = null,Object? remindMinutes = null,}) {
  return _then(_Deadline(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DeadlineSource,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as DeadlinePriority,remind: null == remind ? _self.remind : remind // ignore: cast_nullable_to_non_nullable
as bool,remindMinutes: null == remindMinutes ? _self.remindMinutes : remindMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
