// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_readiness_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExamReadinessState {

 List<ExamReadiness> get entries; ExamReadinessStatus get status;
/// Create a copy of ExamReadinessState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamReadinessStateCopyWith<ExamReadinessState> get copyWith => _$ExamReadinessStateCopyWithImpl<ExamReadinessState>(this as ExamReadinessState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamReadinessState&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(entries),status);

@override
String toString() {
  return 'ExamReadinessState(entries: $entries, status: $status)';
}


}

/// @nodoc
abstract mixin class $ExamReadinessStateCopyWith<$Res>  {
  factory $ExamReadinessStateCopyWith(ExamReadinessState value, $Res Function(ExamReadinessState) _then) = _$ExamReadinessStateCopyWithImpl;
@useResult
$Res call({
 List<ExamReadiness> entries, ExamReadinessStatus status
});




}
/// @nodoc
class _$ExamReadinessStateCopyWithImpl<$Res>
    implements $ExamReadinessStateCopyWith<$Res> {
  _$ExamReadinessStateCopyWithImpl(this._self, this._then);

  final ExamReadinessState _self;
  final $Res Function(ExamReadinessState) _then;

/// Create a copy of ExamReadinessState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? status = null,}) {
  return _then(_self.copyWith(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<ExamReadiness>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExamReadinessStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamReadinessState].
extension ExamReadinessStatePatterns on ExamReadinessState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamReadinessState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamReadinessState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamReadinessState value)  $default,){
final _that = this;
switch (_that) {
case _ExamReadinessState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamReadinessState value)?  $default,){
final _that = this;
switch (_that) {
case _ExamReadinessState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ExamReadiness> entries,  ExamReadinessStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamReadinessState() when $default != null:
return $default(_that.entries,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ExamReadiness> entries,  ExamReadinessStatus status)  $default,) {final _that = this;
switch (_that) {
case _ExamReadinessState():
return $default(_that.entries,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ExamReadiness> entries,  ExamReadinessStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ExamReadinessState() when $default != null:
return $default(_that.entries,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ExamReadinessState extends ExamReadinessState {
  const _ExamReadinessState({final  List<ExamReadiness> entries = const <ExamReadiness>[], this.status = ExamReadinessStatus.initial}): _entries = entries,super._();


 final  List<ExamReadiness> _entries;
@override@JsonKey() List<ExamReadiness> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  ExamReadinessStatus status;

/// Create a copy of ExamReadinessState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamReadinessStateCopyWith<_ExamReadinessState> get copyWith => __$ExamReadinessStateCopyWithImpl<_ExamReadinessState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamReadinessState&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),status);

@override
String toString() {
  return 'ExamReadinessState(entries: $entries, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ExamReadinessStateCopyWith<$Res> implements $ExamReadinessStateCopyWith<$Res> {
  factory _$ExamReadinessStateCopyWith(_ExamReadinessState value, $Res Function(_ExamReadinessState) _then) = __$ExamReadinessStateCopyWithImpl;
@override @useResult
$Res call({
 List<ExamReadiness> entries, ExamReadinessStatus status
});




}
/// @nodoc
class __$ExamReadinessStateCopyWithImpl<$Res>
    implements _$ExamReadinessStateCopyWith<$Res> {
  __$ExamReadinessStateCopyWithImpl(this._self, this._then);

  final _ExamReadinessState _self;
  final $Res Function(_ExamReadinessState) _then;

/// Create a copy of ExamReadinessState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? status = null,}) {
  return _then(_ExamReadinessState(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<ExamReadiness>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExamReadinessStatus,
  ));
}


}

// dart format on
