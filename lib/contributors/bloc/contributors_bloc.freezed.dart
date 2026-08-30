// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contributors_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContributorsState {

 ContributorsResponse get contributors; ContributorsStatus get status;
/// Create a copy of ContributorsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContributorsStateCopyWith<ContributorsState> get copyWith => _$ContributorsStateCopyWithImpl<ContributorsState>(this as ContributorsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContributorsState&&(identical(other.contributors, contributors) || other.contributors == contributors)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,contributors,status);

@override
String toString() {
  return 'ContributorsState(contributors: $contributors, status: $status)';
}


}

/// @nodoc
abstract mixin class $ContributorsStateCopyWith<$Res>  {
  factory $ContributorsStateCopyWith(ContributorsState value, $Res Function(ContributorsState) _then) = _$ContributorsStateCopyWithImpl;
@useResult
$Res call({
 ContributorsResponse contributors, ContributorsStatus status
});


$ContributorsResponseCopyWith<$Res> get contributors;

}
/// @nodoc
class _$ContributorsStateCopyWithImpl<$Res>
    implements $ContributorsStateCopyWith<$Res> {
  _$ContributorsStateCopyWithImpl(this._self, this._then);

  final ContributorsState _self;
  final $Res Function(ContributorsState) _then;

/// Create a copy of ContributorsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contributors = null,Object? status = null,}) {
  return _then(_self.copyWith(
contributors: null == contributors ? _self.contributors : contributors // ignore: cast_nullable_to_non_nullable
as ContributorsResponse,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContributorsStatus,
  ));
}
/// Create a copy of ContributorsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContributorsResponseCopyWith<$Res> get contributors {

  return $ContributorsResponseCopyWith<$Res>(_self.contributors, (value) {
    return _then(_self.copyWith(contributors: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContributorsState].
extension ContributorsStatePatterns on ContributorsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContributorsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContributorsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContributorsState value)  $default,){
final _that = this;
switch (_that) {
case _ContributorsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContributorsState value)?  $default,){
final _that = this;
switch (_that) {
case _ContributorsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContributorsResponse contributors,  ContributorsStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContributorsState() when $default != null:
return $default(_that.contributors,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContributorsResponse contributors,  ContributorsStatus status)  $default,) {final _that = this;
switch (_that) {
case _ContributorsState():
return $default(_that.contributors,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContributorsResponse contributors,  ContributorsStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ContributorsState() when $default != null:
return $default(_that.contributors,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ContributorsState extends ContributorsState {
  const _ContributorsState({this.contributors = const ContributorsResponse(contributors: []), this.status = ContributorsStatus.initial}): super._();


@override@JsonKey() final  ContributorsResponse contributors;
@override@JsonKey() final  ContributorsStatus status;

/// Create a copy of ContributorsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContributorsStateCopyWith<_ContributorsState> get copyWith => __$ContributorsStateCopyWithImpl<_ContributorsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContributorsState&&(identical(other.contributors, contributors) || other.contributors == contributors)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,contributors,status);

@override
String toString() {
  return 'ContributorsState(contributors: $contributors, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ContributorsStateCopyWith<$Res> implements $ContributorsStateCopyWith<$Res> {
  factory _$ContributorsStateCopyWith(_ContributorsState value, $Res Function(_ContributorsState) _then) = __$ContributorsStateCopyWithImpl;
@override @useResult
$Res call({
 ContributorsResponse contributors, ContributorsStatus status
});


@override $ContributorsResponseCopyWith<$Res> get contributors;

}
/// @nodoc
class __$ContributorsStateCopyWithImpl<$Res>
    implements _$ContributorsStateCopyWith<$Res> {
  __$ContributorsStateCopyWithImpl(this._self, this._then);

  final _ContributorsState _self;
  final $Res Function(_ContributorsState) _then;

/// Create a copy of ContributorsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contributors = null,Object? status = null,}) {
  return _then(_ContributorsState(
contributors: null == contributors ? _self.contributors : contributors // ignore: cast_nullable_to_non_nullable
as ContributorsResponse,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContributorsStatus,
  ));
}

/// Create a copy of ContributorsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContributorsResponseCopyWith<$Res> get contributors {

  return $ContributorsResponseCopyWith<$Res>(_self.contributors, (value) {
    return _then(_self.copyWith(contributors: value));
  });
}
}

// dart format on
