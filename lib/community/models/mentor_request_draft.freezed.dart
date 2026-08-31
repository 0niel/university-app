// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentor_request_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MentorRequestDraft {

 String get mentorUserId; String get topic; MentorWhenSlot get whenSlot; String get message;
/// Create a copy of MentorRequestDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MentorRequestDraftCopyWith<MentorRequestDraft> get copyWith => _$MentorRequestDraftCopyWithImpl<MentorRequestDraft>(this as MentorRequestDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MentorRequestDraft&&(identical(other.mentorUserId, mentorUserId) || other.mentorUserId == mentorUserId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.whenSlot, whenSlot) || other.whenSlot == whenSlot)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,mentorUserId,topic,whenSlot,message);

@override
String toString() {
  return 'MentorRequestDraft(mentorUserId: $mentorUserId, topic: $topic, whenSlot: $whenSlot, message: $message)';
}


}

/// @nodoc
abstract mixin class $MentorRequestDraftCopyWith<$Res>  {
  factory $MentorRequestDraftCopyWith(MentorRequestDraft value, $Res Function(MentorRequestDraft) _then) = _$MentorRequestDraftCopyWithImpl;
@useResult
$Res call({
 String mentorUserId, String topic, MentorWhenSlot whenSlot, String message
});




}
/// @nodoc
class _$MentorRequestDraftCopyWithImpl<$Res>
    implements $MentorRequestDraftCopyWith<$Res> {
  _$MentorRequestDraftCopyWithImpl(this._self, this._then);

  final MentorRequestDraft _self;
  final $Res Function(MentorRequestDraft) _then;

/// Create a copy of MentorRequestDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mentorUserId = null,Object? topic = null,Object? whenSlot = null,Object? message = null,}) {
  return _then(_self.copyWith(
mentorUserId: null == mentorUserId ? _self.mentorUserId : mentorUserId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,whenSlot: null == whenSlot ? _self.whenSlot : whenSlot // ignore: cast_nullable_to_non_nullable
as MentorWhenSlot,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MentorRequestDraft].
extension MentorRequestDraftPatterns on MentorRequestDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MentorRequestDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MentorRequestDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MentorRequestDraft value)  $default,){
final _that = this;
switch (_that) {
case _MentorRequestDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MentorRequestDraft value)?  $default,){
final _that = this;
switch (_that) {
case _MentorRequestDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mentorUserId,  String topic,  MentorWhenSlot whenSlot,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MentorRequestDraft() when $default != null:
return $default(_that.mentorUserId,_that.topic,_that.whenSlot,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mentorUserId,  String topic,  MentorWhenSlot whenSlot,  String message)  $default,) {final _that = this;
switch (_that) {
case _MentorRequestDraft():
return $default(_that.mentorUserId,_that.topic,_that.whenSlot,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mentorUserId,  String topic,  MentorWhenSlot whenSlot,  String message)?  $default,) {final _that = this;
switch (_that) {
case _MentorRequestDraft() when $default != null:
return $default(_that.mentorUserId,_that.topic,_that.whenSlot,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _MentorRequestDraft implements MentorRequestDraft {
  const _MentorRequestDraft({required this.mentorUserId, this.topic = '', this.whenSlot = MentorWhenSlot.week, this.message = ''});


@override final  String mentorUserId;
@override@JsonKey() final  String topic;
@override@JsonKey() final  MentorWhenSlot whenSlot;
@override@JsonKey() final  String message;

/// Create a copy of MentorRequestDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MentorRequestDraftCopyWith<_MentorRequestDraft> get copyWith => __$MentorRequestDraftCopyWithImpl<_MentorRequestDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MentorRequestDraft&&(identical(other.mentorUserId, mentorUserId) || other.mentorUserId == mentorUserId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.whenSlot, whenSlot) || other.whenSlot == whenSlot)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,mentorUserId,topic,whenSlot,message);

@override
String toString() {
  return 'MentorRequestDraft(mentorUserId: $mentorUserId, topic: $topic, whenSlot: $whenSlot, message: $message)';
}


}

/// @nodoc
abstract mixin class _$MentorRequestDraftCopyWith<$Res> implements $MentorRequestDraftCopyWith<$Res> {
  factory _$MentorRequestDraftCopyWith(_MentorRequestDraft value, $Res Function(_MentorRequestDraft) _then) = __$MentorRequestDraftCopyWithImpl;
@override @useResult
$Res call({
 String mentorUserId, String topic, MentorWhenSlot whenSlot, String message
});




}
/// @nodoc
class __$MentorRequestDraftCopyWithImpl<$Res>
    implements _$MentorRequestDraftCopyWith<$Res> {
  __$MentorRequestDraftCopyWithImpl(this._self, this._then);

  final _MentorRequestDraft _self;
  final $Res Function(_MentorRequestDraft) _then;

/// Create a copy of MentorRequestDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mentorUserId = null,Object? topic = null,Object? whenSlot = null,Object? message = null,}) {
  return _then(_MentorRequestDraft(
mentorUserId: null == mentorUserId ? _self.mentorUserId : mentorUserId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,whenSlot: null == whenSlot ? _self.whenSlot : whenSlot // ignore: cast_nullable_to_non_nullable
as MentorWhenSlot,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
