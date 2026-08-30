// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lost_found_delete_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LostFoundDeleteResult {

 List<String> get failedCleanupPaths;
/// Create a copy of LostFoundDeleteResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LostFoundDeleteResultCopyWith<LostFoundDeleteResult> get copyWith => _$LostFoundDeleteResultCopyWithImpl<LostFoundDeleteResult>(this as LostFoundDeleteResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LostFoundDeleteResult&&const DeepCollectionEquality().equals(other.failedCleanupPaths, failedCleanupPaths));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(failedCleanupPaths));

@override
String toString() {
  return 'LostFoundDeleteResult(failedCleanupPaths: $failedCleanupPaths)';
}


}

/// @nodoc
abstract mixin class $LostFoundDeleteResultCopyWith<$Res>  {
  factory $LostFoundDeleteResultCopyWith(LostFoundDeleteResult value, $Res Function(LostFoundDeleteResult) _then) = _$LostFoundDeleteResultCopyWithImpl;
@useResult
$Res call({
 List<String> failedCleanupPaths
});




}
/// @nodoc
class _$LostFoundDeleteResultCopyWithImpl<$Res>
    implements $LostFoundDeleteResultCopyWith<$Res> {
  _$LostFoundDeleteResultCopyWithImpl(this._self, this._then);

  final LostFoundDeleteResult _self;
  final $Res Function(LostFoundDeleteResult) _then;

/// Create a copy of LostFoundDeleteResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? failedCleanupPaths = null,}) {
  return _then(_self.copyWith(
failedCleanupPaths: null == failedCleanupPaths ? _self.failedCleanupPaths : failedCleanupPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LostFoundDeleteResult].
extension LostFoundDeleteResultPatterns on LostFoundDeleteResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LostFoundDeleteResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LostFoundDeleteResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LostFoundDeleteResult value)  $default,){
final _that = this;
switch (_that) {
case _LostFoundDeleteResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LostFoundDeleteResult value)?  $default,){
final _that = this;
switch (_that) {
case _LostFoundDeleteResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> failedCleanupPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LostFoundDeleteResult() when $default != null:
return $default(_that.failedCleanupPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> failedCleanupPaths)  $default,) {final _that = this;
switch (_that) {
case _LostFoundDeleteResult():
return $default(_that.failedCleanupPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> failedCleanupPaths)?  $default,) {final _that = this;
switch (_that) {
case _LostFoundDeleteResult() when $default != null:
return $default(_that.failedCleanupPaths);case _:
  return null;

}
}

}

/// @nodoc


class _LostFoundDeleteResult extends LostFoundDeleteResult {
  const _LostFoundDeleteResult({final  List<String> failedCleanupPaths = const <String>[]}): _failedCleanupPaths = failedCleanupPaths,super._();


 final  List<String> _failedCleanupPaths;
@override@JsonKey() List<String> get failedCleanupPaths {
  if (_failedCleanupPaths is EqualUnmodifiableListView) return _failedCleanupPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedCleanupPaths);
}


/// Create a copy of LostFoundDeleteResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LostFoundDeleteResultCopyWith<_LostFoundDeleteResult> get copyWith => __$LostFoundDeleteResultCopyWithImpl<_LostFoundDeleteResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LostFoundDeleteResult&&const DeepCollectionEquality().equals(other._failedCleanupPaths, _failedCleanupPaths));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_failedCleanupPaths));

@override
String toString() {
  return 'LostFoundDeleteResult(failedCleanupPaths: $failedCleanupPaths)';
}


}

/// @nodoc
abstract mixin class _$LostFoundDeleteResultCopyWith<$Res> implements $LostFoundDeleteResultCopyWith<$Res> {
  factory _$LostFoundDeleteResultCopyWith(_LostFoundDeleteResult value, $Res Function(_LostFoundDeleteResult) _then) = __$LostFoundDeleteResultCopyWithImpl;
@override @useResult
$Res call({
 List<String> failedCleanupPaths
});




}
/// @nodoc
class __$LostFoundDeleteResultCopyWithImpl<$Res>
    implements _$LostFoundDeleteResultCopyWith<$Res> {
  __$LostFoundDeleteResultCopyWithImpl(this._self, this._then);

  final _LostFoundDeleteResult _self;
  final $Res Function(_LostFoundDeleteResult) _then;

/// Create a copy of LostFoundDeleteResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failedCleanupPaths = null,}) {
  return _then(_LostFoundDeleteResult(
failedCleanupPaths: null == failedCleanupPaths ? _self._failedCleanupPaths : failedCleanupPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
