// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_apps_moderation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MiniAppsModerationState {

 MiniAppsModerationStatus get status; MiniAppsModerationQueue get queue; String? get processingAppId;
/// Create a copy of MiniAppsModerationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppsModerationStateCopyWith<MiniAppsModerationState> get copyWith => _$MiniAppsModerationStateCopyWithImpl<MiniAppsModerationState>(this as MiniAppsModerationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppsModerationState&&(identical(other.status, status) || other.status == status)&&(identical(other.queue, queue) || other.queue == queue)&&(identical(other.processingAppId, processingAppId) || other.processingAppId == processingAppId));
}


@override
int get hashCode => Object.hash(runtimeType,status,queue,processingAppId);

@override
String toString() {
  return 'MiniAppsModerationState(status: $status, queue: $queue, processingAppId: $processingAppId)';
}


}

/// @nodoc
abstract mixin class $MiniAppsModerationStateCopyWith<$Res>  {
  factory $MiniAppsModerationStateCopyWith(MiniAppsModerationState value, $Res Function(MiniAppsModerationState) _then) = _$MiniAppsModerationStateCopyWithImpl;
@useResult
$Res call({
 MiniAppsModerationStatus status, MiniAppsModerationQueue queue, String? processingAppId
});


$MiniAppsModerationQueueCopyWith<$Res> get queue;

}
/// @nodoc
class _$MiniAppsModerationStateCopyWithImpl<$Res>
    implements $MiniAppsModerationStateCopyWith<$Res> {
  _$MiniAppsModerationStateCopyWithImpl(this._self, this._then);

  final MiniAppsModerationState _self;
  final $Res Function(MiniAppsModerationState) _then;

/// Create a copy of MiniAppsModerationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? queue = null,Object? processingAppId = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppsModerationStatus,queue: null == queue ? _self.queue : queue // ignore: cast_nullable_to_non_nullable
as MiniAppsModerationQueue,processingAppId: freezed == processingAppId ? _self.processingAppId : processingAppId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MiniAppsModerationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MiniAppsModerationQueueCopyWith<$Res> get queue {

  return $MiniAppsModerationQueueCopyWith<$Res>(_self.queue, (value) {
    return _then(_self.copyWith(queue: value));
  });
}
}


/// Adds pattern-matching-related methods to [MiniAppsModerationState].
extension MiniAppsModerationStatePatterns on MiniAppsModerationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppsModerationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppsModerationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppsModerationState value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppsModerationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppsModerationState value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppsModerationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MiniAppsModerationStatus status,  MiniAppsModerationQueue queue,  String? processingAppId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppsModerationState() when $default != null:
return $default(_that.status,_that.queue,_that.processingAppId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MiniAppsModerationStatus status,  MiniAppsModerationQueue queue,  String? processingAppId)  $default,) {final _that = this;
switch (_that) {
case _MiniAppsModerationState():
return $default(_that.status,_that.queue,_that.processingAppId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MiniAppsModerationStatus status,  MiniAppsModerationQueue queue,  String? processingAppId)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppsModerationState() when $default != null:
return $default(_that.status,_that.queue,_that.processingAppId);case _:
  return null;

}
}

}

/// @nodoc


class _MiniAppsModerationState implements MiniAppsModerationState {
  const _MiniAppsModerationState({this.status = MiniAppsModerationStatus.initial, this.queue = const MiniAppsModerationQueue(), this.processingAppId});


@override@JsonKey() final  MiniAppsModerationStatus status;
@override@JsonKey() final  MiniAppsModerationQueue queue;
@override final  String? processingAppId;

/// Create a copy of MiniAppsModerationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppsModerationStateCopyWith<_MiniAppsModerationState> get copyWith => __$MiniAppsModerationStateCopyWithImpl<_MiniAppsModerationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppsModerationState&&(identical(other.status, status) || other.status == status)&&(identical(other.queue, queue) || other.queue == queue)&&(identical(other.processingAppId, processingAppId) || other.processingAppId == processingAppId));
}


@override
int get hashCode => Object.hash(runtimeType,status,queue,processingAppId);

@override
String toString() {
  return 'MiniAppsModerationState(status: $status, queue: $queue, processingAppId: $processingAppId)';
}


}

/// @nodoc
abstract mixin class _$MiniAppsModerationStateCopyWith<$Res> implements $MiniAppsModerationStateCopyWith<$Res> {
  factory _$MiniAppsModerationStateCopyWith(_MiniAppsModerationState value, $Res Function(_MiniAppsModerationState) _then) = __$MiniAppsModerationStateCopyWithImpl;
@override @useResult
$Res call({
 MiniAppsModerationStatus status, MiniAppsModerationQueue queue, String? processingAppId
});


@override $MiniAppsModerationQueueCopyWith<$Res> get queue;

}
/// @nodoc
class __$MiniAppsModerationStateCopyWithImpl<$Res>
    implements _$MiniAppsModerationStateCopyWith<$Res> {
  __$MiniAppsModerationStateCopyWithImpl(this._self, this._then);

  final _MiniAppsModerationState _self;
  final $Res Function(_MiniAppsModerationState) _then;

/// Create a copy of MiniAppsModerationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? queue = null,Object? processingAppId = freezed,}) {
  return _then(_MiniAppsModerationState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppsModerationStatus,queue: null == queue ? _self.queue : queue // ignore: cast_nullable_to_non_nullable
as MiniAppsModerationQueue,processingAppId: freezed == processingAppId ? _self.processingAppId : processingAppId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MiniAppsModerationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MiniAppsModerationQueueCopyWith<$Res> get queue {

  return $MiniAppsModerationQueueCopyWith<$Res>(_self.queue, (value) {
    return _then(_self.copyWith(queue: value));
  });
}
}

// dart format on
