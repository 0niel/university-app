// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_app_stats_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MiniAppStatsState {

 MiniAppStatsStatus get status; MiniAppStatsRange get range; List<MiniAppDailyStat> get stats;
/// Create a copy of MiniAppStatsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppStatsStateCopyWith<MiniAppStatsState> get copyWith => _$MiniAppStatsStateCopyWithImpl<MiniAppStatsState>(this as MiniAppStatsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppStatsState&&(identical(other.status, status) || other.status == status)&&(identical(other.range, range) || other.range == range)&&const DeepCollectionEquality().equals(other.stats, stats));
}


@override
int get hashCode => Object.hash(runtimeType,status,range,const DeepCollectionEquality().hash(stats));

@override
String toString() {
  return 'MiniAppStatsState(status: $status, range: $range, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $MiniAppStatsStateCopyWith<$Res>  {
  factory $MiniAppStatsStateCopyWith(MiniAppStatsState value, $Res Function(MiniAppStatsState) _then) = _$MiniAppStatsStateCopyWithImpl;
@useResult
$Res call({
 MiniAppStatsStatus status, MiniAppStatsRange range, List<MiniAppDailyStat> stats
});




}
/// @nodoc
class _$MiniAppStatsStateCopyWithImpl<$Res>
    implements $MiniAppStatsStateCopyWith<$Res> {
  _$MiniAppStatsStateCopyWithImpl(this._self, this._then);

  final MiniAppStatsState _self;
  final $Res Function(MiniAppStatsState) _then;

/// Create a copy of MiniAppStatsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? range = null,Object? stats = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppStatsStatus,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as MiniAppStatsRange,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as List<MiniAppDailyStat>,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppStatsState].
extension MiniAppStatsStatePatterns on MiniAppStatsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppStatsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppStatsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppStatsState value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppStatsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppStatsState value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppStatsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MiniAppStatsStatus status,  MiniAppStatsRange range,  List<MiniAppDailyStat> stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppStatsState() when $default != null:
return $default(_that.status,_that.range,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MiniAppStatsStatus status,  MiniAppStatsRange range,  List<MiniAppDailyStat> stats)  $default,) {final _that = this;
switch (_that) {
case _MiniAppStatsState():
return $default(_that.status,_that.range,_that.stats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MiniAppStatsStatus status,  MiniAppStatsRange range,  List<MiniAppDailyStat> stats)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppStatsState() when $default != null:
return $default(_that.status,_that.range,_that.stats);case _:
  return null;

}
}

}

/// @nodoc


class _MiniAppStatsState implements MiniAppStatsState {
  const _MiniAppStatsState({this.status = MiniAppStatsStatus.initial, this.range = MiniAppStatsRange.month, final  List<MiniAppDailyStat> stats = const <MiniAppDailyStat>[]}): _stats = stats;


@override@JsonKey() final  MiniAppStatsStatus status;
@override@JsonKey() final  MiniAppStatsRange range;
 final  List<MiniAppDailyStat> _stats;
@override@JsonKey() List<MiniAppDailyStat> get stats {
  if (_stats is EqualUnmodifiableListView) return _stats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stats);
}


/// Create a copy of MiniAppStatsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppStatsStateCopyWith<_MiniAppStatsState> get copyWith => __$MiniAppStatsStateCopyWithImpl<_MiniAppStatsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppStatsState&&(identical(other.status, status) || other.status == status)&&(identical(other.range, range) || other.range == range)&&const DeepCollectionEquality().equals(other._stats, _stats));
}


@override
int get hashCode => Object.hash(runtimeType,status,range,const DeepCollectionEquality().hash(_stats));

@override
String toString() {
  return 'MiniAppStatsState(status: $status, range: $range, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$MiniAppStatsStateCopyWith<$Res> implements $MiniAppStatsStateCopyWith<$Res> {
  factory _$MiniAppStatsStateCopyWith(_MiniAppStatsState value, $Res Function(_MiniAppStatsState) _then) = __$MiniAppStatsStateCopyWithImpl;
@override @useResult
$Res call({
 MiniAppStatsStatus status, MiniAppStatsRange range, List<MiniAppDailyStat> stats
});




}
/// @nodoc
class __$MiniAppStatsStateCopyWithImpl<$Res>
    implements _$MiniAppStatsStateCopyWith<$Res> {
  __$MiniAppStatsStateCopyWithImpl(this._self, this._then);

  final _MiniAppStatsState _self;
  final $Res Function(_MiniAppStatsState) _then;

/// Create a copy of MiniAppStatsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? range = null,Object? stats = null,}) {
  return _then(_MiniAppStatsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppStatsStatus,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as MiniAppStatsRange,stats: null == stats ? _self._stats : stats // ignore: cast_nullable_to_non_nullable
as List<MiniAppDailyStat>,
  ));
}


}

// dart format on
