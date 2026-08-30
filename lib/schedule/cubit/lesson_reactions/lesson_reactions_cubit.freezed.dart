// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_reactions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonReactionsState {

 List<LessonReactionSummary> get summaries;
/// Create a copy of LessonReactionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonReactionsStateCopyWith<LessonReactionsState> get copyWith => _$LessonReactionsStateCopyWithImpl<LessonReactionsState>(this as LessonReactionsState, _$identity);

  /// Serializes this LessonReactionsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonReactionsState&&const DeepCollectionEquality().equals(other.summaries, summaries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(summaries));

@override
String toString() {
  return 'LessonReactionsState(summaries: $summaries)';
}


}

/// @nodoc
abstract mixin class $LessonReactionsStateCopyWith<$Res>  {
  factory $LessonReactionsStateCopyWith(LessonReactionsState value, $Res Function(LessonReactionsState) _then) = _$LessonReactionsStateCopyWithImpl;
@useResult
$Res call({
 List<LessonReactionSummary> summaries
});




}
/// @nodoc
class _$LessonReactionsStateCopyWithImpl<$Res>
    implements $LessonReactionsStateCopyWith<$Res> {
  _$LessonReactionsStateCopyWithImpl(this._self, this._then);

  final LessonReactionsState _self;
  final $Res Function(LessonReactionsState) _then;

/// Create a copy of LessonReactionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summaries = null,}) {
  return _then(_self.copyWith(
summaries: null == summaries ? _self.summaries : summaries // ignore: cast_nullable_to_non_nullable
as List<LessonReactionSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonReactionsState].
extension LessonReactionsStatePatterns on LessonReactionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonReactionsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonReactionsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonReactionsState value)  $default,){
final _that = this;
switch (_that) {
case _LessonReactionsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonReactionsState value)?  $default,){
final _that = this;
switch (_that) {
case _LessonReactionsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LessonReactionSummary> summaries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonReactionsState() when $default != null:
return $default(_that.summaries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LessonReactionSummary> summaries)  $default,) {final _that = this;
switch (_that) {
case _LessonReactionsState():
return $default(_that.summaries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LessonReactionSummary> summaries)?  $default,) {final _that = this;
switch (_that) {
case _LessonReactionsState() when $default != null:
return $default(_that.summaries);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonReactionsState implements LessonReactionsState {
  const _LessonReactionsState({final  List<LessonReactionSummary> summaries = const []}): _summaries = summaries;
  factory _LessonReactionsState.fromJson(Map<String, dynamic> json) => _$LessonReactionsStateFromJson(json);

 final  List<LessonReactionSummary> _summaries;
@override@JsonKey() List<LessonReactionSummary> get summaries {
  if (_summaries is EqualUnmodifiableListView) return _summaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_summaries);
}


/// Create a copy of LessonReactionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonReactionsStateCopyWith<_LessonReactionsState> get copyWith => __$LessonReactionsStateCopyWithImpl<_LessonReactionsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonReactionsStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonReactionsState&&const DeepCollectionEquality().equals(other._summaries, _summaries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_summaries));

@override
String toString() {
  return 'LessonReactionsState(summaries: $summaries)';
}


}

/// @nodoc
abstract mixin class _$LessonReactionsStateCopyWith<$Res> implements $LessonReactionsStateCopyWith<$Res> {
  factory _$LessonReactionsStateCopyWith(_LessonReactionsState value, $Res Function(_LessonReactionsState) _then) = __$LessonReactionsStateCopyWithImpl;
@override @useResult
$Res call({
 List<LessonReactionSummary> summaries
});




}
/// @nodoc
class __$LessonReactionsStateCopyWithImpl<$Res>
    implements _$LessonReactionsStateCopyWith<$Res> {
  __$LessonReactionsStateCopyWithImpl(this._self, this._then);

  final _LessonReactionsState _self;
  final $Res Function(_LessonReactionsState) _then;

/// Create a copy of LessonReactionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summaries = null,}) {
  return _then(_LessonReactionsState(
summaries: null == summaries ? _self._summaries : summaries // ignore: cast_nullable_to_non_nullable
as List<LessonReactionSummary>,
  ));
}


}

// dart format on
