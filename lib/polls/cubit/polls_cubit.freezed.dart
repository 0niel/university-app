// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'polls_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PollsState {

 PollsStatus get status; List<Poll> get polls; PollFilter get filter; PollCategory? get category; String get query;
/// Create a copy of PollsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollsStateCopyWith<PollsState> get copyWith => _$PollsStateCopyWithImpl<PollsState>(this as PollsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.polls, polls)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.category, category) || other.category == category)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(polls),filter,category,query);

@override
String toString() {
  return 'PollsState(status: $status, polls: $polls, filter: $filter, category: $category, query: $query)';
}


}

/// @nodoc
abstract mixin class $PollsStateCopyWith<$Res>  {
  factory $PollsStateCopyWith(PollsState value, $Res Function(PollsState) _then) = _$PollsStateCopyWithImpl;
@useResult
$Res call({
 PollsStatus status, List<Poll> polls, PollFilter filter, PollCategory? category, String query
});




}
/// @nodoc
class _$PollsStateCopyWithImpl<$Res>
    implements $PollsStateCopyWith<$Res> {
  _$PollsStateCopyWithImpl(this._self, this._then);

  final PollsState _self;
  final $Res Function(PollsState) _then;

/// Create a copy of PollsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? polls = null,Object? filter = null,Object? category = freezed,Object? query = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PollsStatus,polls: null == polls ? _self.polls : polls // ignore: cast_nullable_to_non_nullable
as List<Poll>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as PollFilter,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PollCategory?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PollsState].
extension PollsStatePatterns on PollsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollsState value)  $default,){
final _that = this;
switch (_that) {
case _PollsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollsState value)?  $default,){
final _that = this;
switch (_that) {
case _PollsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PollsStatus status,  List<Poll> polls,  PollFilter filter,  PollCategory? category,  String query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollsState() when $default != null:
return $default(_that.status,_that.polls,_that.filter,_that.category,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PollsStatus status,  List<Poll> polls,  PollFilter filter,  PollCategory? category,  String query)  $default,) {final _that = this;
switch (_that) {
case _PollsState():
return $default(_that.status,_that.polls,_that.filter,_that.category,_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PollsStatus status,  List<Poll> polls,  PollFilter filter,  PollCategory? category,  String query)?  $default,) {final _that = this;
switch (_that) {
case _PollsState() when $default != null:
return $default(_that.status,_that.polls,_that.filter,_that.category,_that.query);case _:
  return null;

}
}

}

/// @nodoc


class _PollsState extends PollsState {
  const _PollsState({this.status = PollsStatus.initial, final  List<Poll> polls = const <Poll>[], this.filter = PollFilter.all, this.category, this.query = ''}): _polls = polls,super._();


@override@JsonKey() final  PollsStatus status;
 final  List<Poll> _polls;
@override@JsonKey() List<Poll> get polls {
  if (_polls is EqualUnmodifiableListView) return _polls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_polls);
}

@override@JsonKey() final  PollFilter filter;
@override final  PollCategory? category;
@override@JsonKey() final  String query;

/// Create a copy of PollsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollsStateCopyWith<_PollsState> get copyWith => __$PollsStateCopyWithImpl<_PollsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._polls, _polls)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.category, category) || other.category == category)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_polls),filter,category,query);

@override
String toString() {
  return 'PollsState(status: $status, polls: $polls, filter: $filter, category: $category, query: $query)';
}


}

/// @nodoc
abstract mixin class _$PollsStateCopyWith<$Res> implements $PollsStateCopyWith<$Res> {
  factory _$PollsStateCopyWith(_PollsState value, $Res Function(_PollsState) _then) = __$PollsStateCopyWithImpl;
@override @useResult
$Res call({
 PollsStatus status, List<Poll> polls, PollFilter filter, PollCategory? category, String query
});




}
/// @nodoc
class __$PollsStateCopyWithImpl<$Res>
    implements _$PollsStateCopyWith<$Res> {
  __$PollsStateCopyWithImpl(this._self, this._then);

  final _PollsState _self;
  final $Res Function(_PollsState) _then;

/// Create a copy of PollsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? polls = null,Object? filter = null,Object? category = freezed,Object? query = null,}) {
  return _then(_PollsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PollsStatus,polls: null == polls ? _self._polls : polls // ignore: cast_nullable_to_non_nullable
as List<Poll>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as PollFilter,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PollCategory?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
