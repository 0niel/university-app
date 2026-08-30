// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ads_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdsState {

 bool get showAds;
/// Create a copy of AdsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdsStateCopyWith<AdsState> get copyWith => _$AdsStateCopyWithImpl<AdsState>(this as AdsState, _$identity);

  /// Serializes this AdsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdsState&&(identical(other.showAds, showAds) || other.showAds == showAds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,showAds);

@override
String toString() {
  return 'AdsState(showAds: $showAds)';
}


}

/// @nodoc
abstract mixin class $AdsStateCopyWith<$Res>  {
  factory $AdsStateCopyWith(AdsState value, $Res Function(AdsState) _then) = _$AdsStateCopyWithImpl;
@useResult
$Res call({
 bool showAds
});




}
/// @nodoc
class _$AdsStateCopyWithImpl<$Res>
    implements $AdsStateCopyWith<$Res> {
  _$AdsStateCopyWithImpl(this._self, this._then);

  final AdsState _self;
  final $Res Function(AdsState) _then;

/// Create a copy of AdsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showAds = null,}) {
  return _then(_self.copyWith(
showAds: null == showAds ? _self.showAds : showAds // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdsState].
extension AdsStatePatterns on AdsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdsState value)  $default,){
final _that = this;
switch (_that) {
case _AdsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdsState value)?  $default,){
final _that = this;
switch (_that) {
case _AdsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool showAds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdsState() when $default != null:
return $default(_that.showAds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool showAds)  $default,) {final _that = this;
switch (_that) {
case _AdsState():
return $default(_that.showAds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool showAds)?  $default,) {final _that = this;
switch (_that) {
case _AdsState() when $default != null:
return $default(_that.showAds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdsState implements AdsState {
  const _AdsState({this.showAds = true});
  factory _AdsState.fromJson(Map<String, dynamic> json) => _$AdsStateFromJson(json);

@override@JsonKey() final  bool showAds;

/// Create a copy of AdsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdsStateCopyWith<_AdsState> get copyWith => __$AdsStateCopyWithImpl<_AdsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdsStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdsState&&(identical(other.showAds, showAds) || other.showAds == showAds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,showAds);

@override
String toString() {
  return 'AdsState(showAds: $showAds)';
}


}

/// @nodoc
abstract mixin class _$AdsStateCopyWith<$Res> implements $AdsStateCopyWith<$Res> {
  factory _$AdsStateCopyWith(_AdsState value, $Res Function(_AdsState) _then) = __$AdsStateCopyWithImpl;
@override @useResult
$Res call({
 bool showAds
});




}
/// @nodoc
class __$AdsStateCopyWithImpl<$Res>
    implements _$AdsStateCopyWith<$Res> {
  __$AdsStateCopyWithImpl(this._self, this._then);

  final _AdsState _self;
  final $Res Function(_AdsState) _then;

/// Create a copy of AdsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showAds = null,}) {
  return _then(_AdsState(
showAds: null == showAds ? _self.showAds : showAds // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
