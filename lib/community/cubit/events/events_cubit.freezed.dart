// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'events_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventsState {

 EventsStatus get status; List<CampusEvent> get events; EventCategory get category; Set<String> get pendingRsvps; bool get isCreating;
/// Create a copy of EventsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventsStateCopyWith<EventsState> get copyWith => _$EventsStateCopyWithImpl<EventsState>(this as EventsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.pendingRsvps, pendingRsvps)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(events),category,const DeepCollectionEquality().hash(pendingRsvps),isCreating);

@override
String toString() {
  return 'EventsState(status: $status, events: $events, category: $category, pendingRsvps: $pendingRsvps, isCreating: $isCreating)';
}


}

/// @nodoc
abstract mixin class $EventsStateCopyWith<$Res>  {
  factory $EventsStateCopyWith(EventsState value, $Res Function(EventsState) _then) = _$EventsStateCopyWithImpl;
@useResult
$Res call({
 EventsStatus status, List<CampusEvent> events, EventCategory category, Set<String> pendingRsvps, bool isCreating
});




}
/// @nodoc
class _$EventsStateCopyWithImpl<$Res>
    implements $EventsStateCopyWith<$Res> {
  _$EventsStateCopyWithImpl(this._self, this._then);

  final EventsState _self;
  final $Res Function(EventsState) _then;

/// Create a copy of EventsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? events = null,Object? category = null,Object? pendingRsvps = null,Object? isCreating = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventsStatus,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<CampusEvent>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory,pendingRsvps: null == pendingRsvps ? _self.pendingRsvps : pendingRsvps // ignore: cast_nullable_to_non_nullable
as Set<String>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EventsState].
extension EventsStatePatterns on EventsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventsState value)  $default,){
final _that = this;
switch (_that) {
case _EventsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventsState value)?  $default,){
final _that = this;
switch (_that) {
case _EventsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EventsStatus status,  List<CampusEvent> events,  EventCategory category,  Set<String> pendingRsvps,  bool isCreating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventsState() when $default != null:
return $default(_that.status,_that.events,_that.category,_that.pendingRsvps,_that.isCreating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EventsStatus status,  List<CampusEvent> events,  EventCategory category,  Set<String> pendingRsvps,  bool isCreating)  $default,) {final _that = this;
switch (_that) {
case _EventsState():
return $default(_that.status,_that.events,_that.category,_that.pendingRsvps,_that.isCreating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EventsStatus status,  List<CampusEvent> events,  EventCategory category,  Set<String> pendingRsvps,  bool isCreating)?  $default,) {final _that = this;
switch (_that) {
case _EventsState() when $default != null:
return $default(_that.status,_that.events,_that.category,_that.pendingRsvps,_that.isCreating);case _:
  return null;

}
}

}

/// @nodoc


class _EventsState extends EventsState {
  const _EventsState({this.status = EventsStatus.initial, final  List<CampusEvent> events = const <CampusEvent>[], this.category = EventCategory.all, final  Set<String> pendingRsvps = const <String>{}, this.isCreating = false}): _events = events,_pendingRsvps = pendingRsvps,super._();


@override@JsonKey() final  EventsStatus status;
 final  List<CampusEvent> _events;
@override@JsonKey() List<CampusEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override@JsonKey() final  EventCategory category;
 final  Set<String> _pendingRsvps;
@override@JsonKey() Set<String> get pendingRsvps {
  if (_pendingRsvps is EqualUnmodifiableSetView) return _pendingRsvps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingRsvps);
}

@override@JsonKey() final  bool isCreating;

/// Create a copy of EventsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventsStateCopyWith<_EventsState> get copyWith => __$EventsStateCopyWithImpl<_EventsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._pendingRsvps, _pendingRsvps)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_events),category,const DeepCollectionEquality().hash(_pendingRsvps),isCreating);

@override
String toString() {
  return 'EventsState(status: $status, events: $events, category: $category, pendingRsvps: $pendingRsvps, isCreating: $isCreating)';
}


}

/// @nodoc
abstract mixin class _$EventsStateCopyWith<$Res> implements $EventsStateCopyWith<$Res> {
  factory _$EventsStateCopyWith(_EventsState value, $Res Function(_EventsState) _then) = __$EventsStateCopyWithImpl;
@override @useResult
$Res call({
 EventsStatus status, List<CampusEvent> events, EventCategory category, Set<String> pendingRsvps, bool isCreating
});




}
/// @nodoc
class __$EventsStateCopyWithImpl<$Res>
    implements _$EventsStateCopyWith<$Res> {
  __$EventsStateCopyWithImpl(this._self, this._then);

  final _EventsState _self;
  final $Res Function(_EventsState) _then;

/// Create a copy of EventsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? events = null,Object? category = null,Object? pendingRsvps = null,Object? isCreating = null,}) {
  return _then(_EventsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventsStatus,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<CampusEvent>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory,pendingRsvps: null == pendingRsvps ? _self._pendingRsvps : pendingRsvps // ignore: cast_nullable_to_non_nullable
as Set<String>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
