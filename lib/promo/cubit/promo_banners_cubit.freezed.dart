// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_banners_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PromoBannersState {

 List<PromoBanner> get banners; bool get loaded; bool get isLoading;
/// Create a copy of PromoBannersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoBannersStateCopyWith<PromoBannersState> get copyWith => _$PromoBannersStateCopyWithImpl<PromoBannersState>(this as PromoBannersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoBannersState&&const DeepCollectionEquality().equals(other.banners, banners)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(banners),loaded,isLoading);

@override
String toString() {
  return 'PromoBannersState(banners: $banners, loaded: $loaded, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $PromoBannersStateCopyWith<$Res>  {
  factory $PromoBannersStateCopyWith(PromoBannersState value, $Res Function(PromoBannersState) _then) = _$PromoBannersStateCopyWithImpl;
@useResult
$Res call({
 List<PromoBanner> banners, bool loaded, bool isLoading
});




}
/// @nodoc
class _$PromoBannersStateCopyWithImpl<$Res>
    implements $PromoBannersStateCopyWith<$Res> {
  _$PromoBannersStateCopyWithImpl(this._self, this._then);

  final PromoBannersState _self;
  final $Res Function(PromoBannersState) _then;

/// Create a copy of PromoBannersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? banners = null,Object? loaded = null,Object? isLoading = null,}) {
  return _then(_self.copyWith(
banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<PromoBanner>,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoBannersState].
extension PromoBannersStatePatterns on PromoBannersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoBannersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoBannersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoBannersState value)  $default,){
final _that = this;
switch (_that) {
case _PromoBannersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoBannersState value)?  $default,){
final _that = this;
switch (_that) {
case _PromoBannersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PromoBanner> banners,  bool loaded,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoBannersState() when $default != null:
return $default(_that.banners,_that.loaded,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PromoBanner> banners,  bool loaded,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _PromoBannersState():
return $default(_that.banners,_that.loaded,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PromoBanner> banners,  bool loaded,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _PromoBannersState() when $default != null:
return $default(_that.banners,_that.loaded,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _PromoBannersState implements PromoBannersState {
  const _PromoBannersState({final  List<PromoBanner> banners = const <PromoBanner>[], this.loaded = false, this.isLoading = false}): _banners = banners;
  

 final  List<PromoBanner> _banners;
@override@JsonKey() List<PromoBanner> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}

@override@JsonKey() final  bool loaded;
@override@JsonKey() final  bool isLoading;

/// Create a copy of PromoBannersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoBannersStateCopyWith<_PromoBannersState> get copyWith => __$PromoBannersStateCopyWithImpl<_PromoBannersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoBannersState&&const DeepCollectionEquality().equals(other._banners, _banners)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_banners),loaded,isLoading);

@override
String toString() {
  return 'PromoBannersState(banners: $banners, loaded: $loaded, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$PromoBannersStateCopyWith<$Res> implements $PromoBannersStateCopyWith<$Res> {
  factory _$PromoBannersStateCopyWith(_PromoBannersState value, $Res Function(_PromoBannersState) _then) = __$PromoBannersStateCopyWithImpl;
@override @useResult
$Res call({
 List<PromoBanner> banners, bool loaded, bool isLoading
});




}
/// @nodoc
class __$PromoBannersStateCopyWithImpl<$Res>
    implements _$PromoBannersStateCopyWith<$Res> {
  __$PromoBannersStateCopyWithImpl(this._self, this._then);

  final _PromoBannersState _self;
  final $Res Function(_PromoBannersState) _then;

/// Create a copy of PromoBannersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? banners = null,Object? loaded = null,Object? isLoading = null,}) {
  return _then(_PromoBannersState(
banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<PromoBanner>,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
