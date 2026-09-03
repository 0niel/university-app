// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventDraft {

 String get title; DateTime get startsAt; String get emoji; EventCategory get category; DateTime? get endsAt; String get place; String get description;
/// Create a copy of EventDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDraftCopyWith<EventDraft> get copyWith => _$EventDraftCopyWithImpl<EventDraft>(this as EventDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.category, category) || other.category == category)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.place, place) || other.place == place)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,title,startsAt,emoji,category,endsAt,place,description);

@override
String toString() {
  return 'EventDraft(title: $title, startsAt: $startsAt, emoji: $emoji, category: $category, endsAt: $endsAt, place: $place, description: $description)';
}


}

/// @nodoc
abstract mixin class $EventDraftCopyWith<$Res>  {
  factory $EventDraftCopyWith(EventDraft value, $Res Function(EventDraft) _then) = _$EventDraftCopyWithImpl;
@useResult
$Res call({
 String title, DateTime startsAt, String emoji, EventCategory category, DateTime? endsAt, String place, String description
});




}
/// @nodoc
class _$EventDraftCopyWithImpl<$Res>
    implements $EventDraftCopyWith<$Res> {
  _$EventDraftCopyWithImpl(this._self, this._then);

  final EventDraft _self;
  final $Res Function(EventDraft) _then;

/// Create a copy of EventDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? startsAt = null,Object? emoji = null,Object? category = null,Object? endsAt = freezed,Object? place = null,Object? description = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EventDraft].
extension EventDraftPatterns on EventDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDraft value)  $default,){
final _that = this;
switch (_that) {
case _EventDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDraft value)?  $default,){
final _that = this;
switch (_that) {
case _EventDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  DateTime startsAt,  String emoji,  EventCategory category,  DateTime? endsAt,  String place,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDraft() when $default != null:
return $default(_that.title,_that.startsAt,_that.emoji,_that.category,_that.endsAt,_that.place,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  DateTime startsAt,  String emoji,  EventCategory category,  DateTime? endsAt,  String place,  String description)  $default,) {final _that = this;
switch (_that) {
case _EventDraft():
return $default(_that.title,_that.startsAt,_that.emoji,_that.category,_that.endsAt,_that.place,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  DateTime startsAt,  String emoji,  EventCategory category,  DateTime? endsAt,  String place,  String description)?  $default,) {final _that = this;
switch (_that) {
case _EventDraft() when $default != null:
return $default(_that.title,_that.startsAt,_that.emoji,_that.category,_that.endsAt,_that.place,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _EventDraft implements EventDraft {
  const _EventDraft({required this.title, required this.startsAt, required this.emoji, required this.category, this.endsAt, this.place = '', this.description = ''});


@override final  String title;
@override final  DateTime startsAt;
@override final  String emoji;
@override final  EventCategory category;
@override final  DateTime? endsAt;
@override@JsonKey() final  String place;
@override@JsonKey() final  String description;

/// Create a copy of EventDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDraftCopyWith<_EventDraft> get copyWith => __$EventDraftCopyWithImpl<_EventDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.category, category) || other.category == category)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.place, place) || other.place == place)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,title,startsAt,emoji,category,endsAt,place,description);

@override
String toString() {
  return 'EventDraft(title: $title, startsAt: $startsAt, emoji: $emoji, category: $category, endsAt: $endsAt, place: $place, description: $description)';
}


}

/// @nodoc
abstract mixin class _$EventDraftCopyWith<$Res> implements $EventDraftCopyWith<$Res> {
  factory _$EventDraftCopyWith(_EventDraft value, $Res Function(_EventDraft) _then) = __$EventDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, DateTime startsAt, String emoji, EventCategory category, DateTime? endsAt, String place, String description
});




}
/// @nodoc
class __$EventDraftCopyWithImpl<$Res>
    implements _$EventDraftCopyWith<$Res> {
  __$EventDraftCopyWithImpl(this._self, this._then);

  final _EventDraft _self;
  final $Res Function(_EventDraft) _then;

/// Create a copy of EventDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? startsAt = null,Object? emoji = null,Object? category = null,Object? endsAt = freezed,Object? place = null,Object? description = null,}) {
  return _then(_EventDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
